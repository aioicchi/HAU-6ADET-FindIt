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
        inquiries: 1,
        note: 'Currently at lost and found section',
        claimAt: 'Lost & Found Office, SJH Ground Floor',
        verifyQuestion: "What color is it, and what's special about the lid?",
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
        claimAt: 'University Library front desk',
        verifyQuestion: 'What name is printed on the card?',
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
        claimAt: 'Security Office, PGN Hall',
        verifyQuestion: 'What color is it, and is there any design on it?',
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

  /// Inquiries other students already sent about the demo user's reports.
  static Map<String, List<Message>> threads() {
    final now = DateTime.now();
    return {
      '1': [
        Message(
          text: 'Hi! I think I saw a blue ID on the bleachers at the gym this morning. Is it yours?',
          fromMe: false,
          sender: 'Ana R.',
          time: now.subtract(const Duration(minutes: 90)),
        ),
        Message(
          text: 'Good afternoon, a student ID was turned in to the Security Office. Please drop by with another valid ID.',
          fromMe: false,
          sender: 'Security Office',
          time: now.subtract(const Duration(minutes: 40)),
        ),
      ],
      '2': [
        Message(
          text: 'Hello, I lost a green Aquaflask in SJH yesterday. Does yours have a scratch near the lid?',
          fromMe: false,
          sender: 'Mark T.',
          time: now.subtract(const Duration(hours: 5)),
        ),
      ],
    };
  }

  /// A claim waiting for the demo user to approve or reject.
  static List<Claim> claims() => [
        Claim(
          id: 'c1',
          itemId: '2',
          claimant: 'Mark T.',
          answer: "It's moss green with a black spout lid. I also lost the box with it.",
          time: DateTime.now().subtract(const Duration(hours: 4)),
          fromMe: false,
        ),
      ];

  static List<AppNotification> notifications() {
    final now = DateTime.now();
    return [
      AppNotification(title: 'Possible match', body: 'A found item may match your lost Student ID.', time: now.subtract(const Duration(hours: 1)), itemId: '3'),
      AppNotification(title: 'New claim', body: 'Mark T. says your found Aquaflask Tumbler is theirs. Review the claim.', time: now.subtract(const Duration(hours: 4)), itemId: '2'),
      AppNotification(title: 'New inquiry', body: 'Someone inquired about your Aquaflask Tumbler.', time: now.subtract(const Duration(hours: 5)), itemId: '2'),
      AppNotification(title: 'Welcome to FindIt', body: 'Report lost or found items across campus.', time: now.subtract(const Duration(days: 2))),
    ];
  }
}
