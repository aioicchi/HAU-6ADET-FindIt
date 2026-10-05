class AppNotification {
  AppNotification({
    required this.title,
    required this.body,
    required this.time,
    this.itemId,
    this.read = false,
  });

  final String title;
  final String body;
  final DateTime time;
  final String? itemId;
  bool read;
}
