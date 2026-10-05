import 'package:flutter/foundation.dart';

import 'mock_data.dart';
import 'models/models.dart';

/// In-memory app state. Swap the internals for an API/Firebase later
/// without touching the screens.
class AppStore extends ChangeNotifier {
  AppUser? user;

  final List<AppUser> _accounts = [MockData.demoUser()];
  final Map<String, String> _passwords = {MockData.demoEmail: MockData.demoPassword};
  final List<Item> items = MockData.items();
  final List<AppNotification> notifications = MockData.notifications();
  final Map<String, List<Message>> _threads = {};

  void changed() => notifyListeners();

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
