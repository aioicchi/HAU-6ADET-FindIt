import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'mock_data.dart';
import 'models/models.dart';

/// App state, saved on this device (browser storage on the web) after every
/// change. Swap the internals for an API/Firebase later without touching the screens.
class AppStore extends ChangeNotifier {
  // Bump when the demo data changes shape, so old saves don't hide new demo content.
  static const _storageKey = 'findit_data_v2';

  AppUser? user;

  final List<AppUser> _accounts = [MockData.demoUser()];
  final Map<String, String> _passwords = {MockData.demoEmail: MockData.demoPassword};
  final List<Item> items = MockData.items();
  final List<AppNotification> notifications = MockData.notifications();
  final Map<String, List<Message>> _threads = MockData.threads();

  /// Threads waiting for a simulated reply, so only one is queued at a time.
  final Set<String> _pendingReplies = {};

  SharedPreferences? _prefs;
  Future<void> _lastSave = Future.value();

  void changed() => notifyListeners();

  @override
  void notifyListeners() {
    super.notifyListeners();
    _save();
  }

  // ---- Saving ----

  /// Loads saved data, if any. Call once before the app starts.
  Future<void> load() async {
    try {
      final prefs = _prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(_storageKey);
      if (raw == null) return; // First run: keep the demo data.
      _fromJson(jsonDecode(raw) as Map<String, dynamic>);
    } catch (e) {
      debugPrint('FindIt: could not load saved data, starting fresh. $e');
    }
  }

  /// Deletes saved data and goes back to the demo data, signed out.
  Future<void> resetDemoData() async {
    _accounts
      ..clear()
      ..add(MockData.demoUser());
    _passwords
      ..clear()
      ..[MockData.demoEmail] = MockData.demoPassword;
    items
      ..clear()
      ..addAll(MockData.items());
    notifications
      ..clear()
      ..addAll(MockData.notifications());
    _threads
      ..clear()
      ..addAll(MockData.threads());
    _pendingReplies.clear();
    user = null;
    super.notifyListeners();
    await _lastSave;
    await _prefs?.remove(_storageKey);
  }

  void _save() {
    final prefs = _prefs;
    if (prefs == null) return; // Not loaded yet (e.g. in tests).
    // Chain saves so an older one never finishes after a newer one.
    _lastSave = _lastSave.then((_) async {
      try {
        await prefs.setString(_storageKey, jsonEncode(_toJson(withPhotos: true)));
      } catch (_) {
        // Browser storage is small (about 5 MB). If photos don't fit, keep
        // everything else and let the photos live only until the page reloads.
        try {
          await prefs.setString(_storageKey, jsonEncode(_toJson(withPhotos: false)));
        } catch (e) {
          debugPrint('FindIt: could not save data. $e');
        }
      }
    });
  }

  Map<String, dynamic> _toJson({required bool withPhotos}) => {
        'session': user?.email,
        'accounts': [for (final a in _accounts) a.toJson()],
        // Demo only: a real app must never store passwords like this.
        'passwords': _passwords,
        'items': [for (final i in items) i.toJson(withPhoto: withPhotos)],
        'notifications': [for (final n in notifications) n.toJson()],
        'threads': {
          for (final e in _threads.entries) e.key: [for (final m in e.value) m.toJson()],
        },
      };

  void _fromJson(Map<String, dynamic> j) {
    List<Map<String, dynamic>> list(String key) => List<Map<String, dynamic>>.from(j[key] as List);

    _accounts
      ..clear()
      ..addAll(list('accounts').map(AppUser.fromJson));
    _passwords
      ..clear()
      ..addAll(Map<String, String>.from(j['passwords'] as Map));
    items
      ..clear()
      ..addAll(list('items').map(Item.fromJson));
    notifications
      ..clear()
      ..addAll(list('notifications').map(AppNotification.fromJson));
    _threads
      ..clear()
      ..addAll({
        for (final e in (j['threads'] as Map<String, dynamic>).entries)
          e.key: List<Map<String, dynamic>>.from(e.value as List).map(Message.fromJson).toList(),
      });
    final session = j['session'] as String?;
    user = _accounts.where((a) => a.email == session).firstOrNull;
  }

  // ---- Auth ----
  String? login(String email, String password) {
    final e = email.trim().toLowerCase();
    if (_passwords[e] != password) return 'Invalid email or password.';
    user = _accounts.firstWhere((a) => a.email == e);
    notifyListeners();
    return null;
  }

  String? register({required String name, required String email, required String studentId, required String password}) {
    final e = email.trim().toLowerCase();
    if (_passwords.containsKey(e)) return 'An account with this email already exists.';
    final u = AppUser(id: 'u${_accounts.length + 1}', name: name.trim(), email: e, studentId: studentId.trim());
    _accounts.add(u);
    _passwords[e] = password;
    user = u;
    notifyListeners();
    return null;
  }

  void logout() {
    user = null;
    notifyListeners();
  }

  void updateProfile({required String name, required String studentId, required String phone}) {
    user!
      ..name = name.trim()
      ..studentId = studentId.trim()
      ..phone = phone.trim();
    notifyListeners();
  }

  // ---- Items ----
  Item? findItem(String id) {
    for (final i in items) {
      if (i.id == id) return i;
    }
    return null;
  }

  List<Item> get myItems => items.where((i) => i.ownerId == user?.id).toList();

  void addItem(Item item) {
    items.insert(0, item);
    // Tell the reporter right away if someone already reported the other side.
    final best = matchesFor(item).firstOrNull;
    if (best != null) {
      notifications.insert(
        0,
        AppNotification(
          title: 'Possible match',
          body: 'A ${best.statusLabel.toLowerCase()} ${best.name} at ${best.location} may match '
              'your ${item.statusLabel.toLowerCase()} ${item.name}.',
          time: DateTime.now(),
          itemId: best.id,
        ),
      );
    }
    notifyListeners();
  }

  /// Open reports on the other side (lost vs found) that look like [item]:
  /// the same category scores 2, each shared word in the name scores 1.
  /// Anything scoring 2 or more counts, best first.
  List<Item> matchesFor(Item item) {
    final words = _nameWords(item.name);
    final scored = <(Item, int)>[];
    for (final other in items) {
      if (other.id == item.id || other.status == item.status || other.resolved) continue;
      var score = _nameWords(other.name).intersection(words).length;
      if (item.category != null && item.category == other.category) score += 2;
      if (score >= 2) scored.add((other, score));
    }
    scored.sort((a, b) => b.$2 != a.$2 ? b.$2.compareTo(a.$2) : b.$1.date.compareTo(a.$1.date));
    return [for (final s in scored) s.$1];
  }

  static Set<String> _nameWords(String name) =>
      name.toLowerCase().split(RegExp('[^a-z0-9]+')).where((w) => w.length >= 3).toSet();

  void deleteItem(String id) {
    items.removeWhere((i) => i.id == id);
    _threads.remove(id);
    notifyListeners();
  }

  void toggleResolved(Item item) {
    item.resolved = !item.resolved;
    notifyListeners();
  }

  // ---- Messages ----
  List<Message> thread(String itemId) => _threads.putIfAbsent(itemId, () => []);

  void sendMessage(Item item, String text) {
    final t = thread(item.id);
    final isMine = item.ownerId == user?.id;
    // Inquiries count people, not messages: only your first message on someone else's report adds one.
    if (!isMine && !t.any((m) => m.fromMe)) item.inquiries++;
    t.add(Message(text: text, fromMe: true, time: DateTime.now()));
    notifyListeners();
    if (!isMine) _queueReply(item);
  }

  /// Demo only: the reporter answers a moment later, following a short script.
  void _queueReply(Item item) {
    final replies = item.isLost
        ? [
            'Hi! Thanks for messaging. Did you find my ${item.name}? Where is it now?',
            "That sounds like mine! Can we meet at ${item.location}? I'm free after class.",
          ]
        : [
            "Hi! Thanks for reaching out. To make sure it's yours, can you describe something only "
                "the owner would know, like a mark, a sticker, or what's inside?",
            'That matches what I found. You can claim it at ${item.claimAt ?? item.location}. '
                'Please bring your school ID.',
          ];
    final sent = thread(item.id).where((m) => !m.fromMe).length;
    if (sent >= replies.length || !_pendingReplies.add(item.id)) return;

    Future.delayed(const Duration(milliseconds: 1500), () {
      _pendingReplies.remove(item.id);
      if (findItem(item.id) == null) return; // Deleted meanwhile.
      final text = replies[sent];
      thread(item.id).add(Message(text: text, fromMe: false, time: DateTime.now(), sender: item.isLost ? 'Owner' : 'Finder'));
      notifications.insert(
        0,
        AppNotification(title: 'New reply', body: '${item.name}: "$text"', time: DateTime.now(), itemId: item.id),
      );
      notifyListeners();
    });
  }

  // ---- Notifications ----
  int get unreadCount => notifications.where((n) => !n.read).length;

  void markRead(AppNotification n) {
    n.read = true;
    notifyListeners();
  }

  void markAllRead() {
    for (final n in notifications) {
      n.read = true;
    }
    notifyListeners();
  }
}

final store = AppStore();
