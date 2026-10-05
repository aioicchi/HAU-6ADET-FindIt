import 'models/models.dart';

/// Demo content so the app is usable without a backend.
class MockData {
  MockData._();

  static const demoEmail = 'student@hau.edu.ph';
  static const demoPassword = 'password';

  static AppUser demoUser() => AppUser(
        id: 'u1',
        name: 'Hayward Flor',
        email: demoEmail,
        studentId: '2023-00123',
        phone: '0917 123 4567',
      );

  static List<Item> items() {
    final now = DateTime.now();
    return [
      Item(
        id: '1',
        name: 'Student ID',
        description: 'Holy Angel University student ID card, blue with a red lanyard.',
        status: ItemStatus.lost,
        location: 'IH-GYM (Gymnasium)',
        date: now.subtract(const Duration(hours: 2)),
        contact: demoEmail,
        ownerId: 'u1',
        tags: ['ID CARD', 'DOCUMENTS'],
        hasPhoto: true,
        inquiries: 2,
        note: 'Pending claim inquiries',
      ),
      Item(
        id: '2',
        name: 'Aquaflask Tumbler',
        description: 'Navy blue 40oz Aquaflask with a small dent near the bottom.',
        status: ItemStatus.found,
        location: 'SJH (St. Joseph Hall)',
        date: now.subtract(const Duration(days: 1)),
        contact: demoEmail,
        ownerId: 'u1',
        tags: ['TUMBLER'],
        hasPhoto: true,
        note: 'Currently at lost and found section',
      ),
      Item(
        id: '3',
        name: 'Student ID',
        description: "Found a Holy Angel University student ID card near the cafeteria. Name on the card is Hayward Flor. It's in a clear plastic holder with a red lanyard.",
        status: ItemStatus.found,
        location: 'University Library',
        date: DateTime(2026, 1, 30),
        contact: 'library@hau.edu.ph',
        ownerId: 'u2',
        tags: ['ID CARD', 'DOCUMENTS'],
      ),
      Item(
        id: '4',
        name: 'Umbrella',
        description: 'Compact black folding umbrella left on a bench.',
        status: ItemStatus.found,
        location: 'PGN (Pangilinan Hall)',
        date: now.subtract(const Duration(days: 2)),
        contact: 'security@hau.edu.ph',
        ownerId: 'u2',
        tags: ['UMBRELLA'],
        hasPhoto: true,
      ),
      Item(
        id: '5',
        name: 'House Keys',
        description: 'Set of 3 keys with a green keychain.',
        status: ItemStatus.lost,
        location: 'Canteen',
        date: now.subtract(const Duration(days: 3)),
        contact: '0918 555 0102',
        ownerId: 'u3',
        tags: ['KEYS'],
      ),
    ];
  }

  static List<AppNotification> notifications() {
    final now = DateTime.now();
    return [
      AppNotification(title: 'Possible match', body: 'A found item may match your lost Student ID.', time: now.subtract(const Duration(hours: 1)), itemId: '3'),
      AppNotification(title: 'New inquiry', body: 'Someone inquired about your Aquaflask Tumbler.', time: now.subtract(const Duration(hours: 5)), itemId: '2'),
      AppNotification(title: 'Welcome to FindIt', body: 'Report lost or found items across campus.', time: now.subtract(const Duration(days: 2))),
    ];
  }
}
