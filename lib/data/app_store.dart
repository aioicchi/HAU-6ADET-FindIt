import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'mock_data.dart';
import 'models/models.dart';

/// App state, saved on this device (browser storage on the web) after every
/// change. Swap the internals for an API/Firebase later without touching the screens.
class AppStore extends ChangeNotifier {
  static const _storageKey = 'findit_data_v1';

  AppUser? user;

  final List<AppUser> _accounts = [MockData.demoUser()];
  final Map<String, String> _passwords = {MockData.demoEmail: MockData.demoPassword};
  final List<Item> items = MockData.items();
  final List<AppNotification> notifications = MockData.notifications();
  final Map<String, List<Message>> _threads = {};

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
    _threads.clear();
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
    notifyListeners();
  }

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
    thread(item.id).add(Message(text: text, fromMe: true, time: DateTime.now()));
    item.inquiries++;
    notifyListeners();
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
