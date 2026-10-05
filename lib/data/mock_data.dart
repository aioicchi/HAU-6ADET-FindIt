import 'models/models.dart';

/// Demo content so the app is usable without a backend.
class MockData {
  MockData._();

  static const demoEmail = 'student@hau.edu.ph';
  static const demoPassword = 'password';

  static AppUser demoUser() => AppUser(
        id: 'u1',
        // Obviously fake details: this repo is public.
        name: 'Juan Dela Cruz',
        email: demoEmail,
        studentId: '0000-00000',
        phone: '0900 000 0000',
      );

  static List<Item> items() {
    final now = DateTime.now();
    return [
      Item(
        id: '1',
        name: 'Student ID',
        description: 'Blue student ID card with a photo and barcode. School year 2024/2025.',
        status: ItemStatus.lost,
        location: 'IH-GYM (Gymnasium)',
        date: now.subtract(const Duration(hours: 2)),
        contact: demoEmail,
        ownerId: 'u1',
        tags: ['ID CARD', 'DOCUMENTS'],
        hasPhoto: true,
        photoAsset: 'assets/images/student_id.jpg',
        inquiries: 2,
        note: 'Pending claim inquiries',
      ),
      Item(
        id: '2',
        name: 'Aquaflask Tumbler',
        description: 'Moss green 32oz Aquaflask with a black spout lid and carry loop. Found with its box.',
        status: ItemStatus.found,
        location: 'SJH (St. Joseph Hall)',
        date: now.subtract(const Duration(days: 1)),
        contact: demoEmail,
        ownerId: 'u1',
        tags: ['TUMBLER'],
        hasPhoto: true,
        photoAsset: 'assets/images/tumbler.jpg',
        note: 'Currently at lost and found section',
      ),
      Item(
        id: '3',
        name: 'Student ID',
        description: 'Found an ID card left on a bookshelf in the library. White card with a photo and barcode. Name on the card is Wes Lee Coyote.',
        status: ItemStatus.found,
        location: 'University Library',
        date: DateTime(2026, 1, 30),
        contact: 'library@hau.edu.ph',
        ownerId: 'u2',
        tags: ['ID CARD', 'DOCUMENTS'],
        hasPhoto: true,
        photoAsset: 'assets/images/student_id_found.jpg',
      ),
      Item(
        id: '4',
        name: 'Umbrella',
        description: 'Red paper umbrella with white flowers painted on it, left on a bench.',
        status: ItemStatus.found,
        location: 'PGN (Pangilinan Hall)',
        date: now.subtract(const Duration(days: 2)),
        contact: 'security@hau.edu.ph',
        ownerId: 'u2',
        tags: ['UMBRELLA'],
        hasPhoto: true,
        photoAsset: 'assets/images/umbrella.jpg',
      ),
      Item(
        id: '5',
        name: 'House Keys',
        description: 'Loose set of brass and silver house keys. Two have round paper tags labelled "Carport".',
        status: ItemStatus.lost,
        location: 'Canteen',
        date: now.subtract(const Duration(days: 3)),
        contact: '0918 555 0102',
        ownerId: 'u3',
        tags: ['KEYS'],
        hasPhoto: true,
        photoAsset: 'assets/images/keys.jpg',
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
