class AppNotification {
  AppNotification({
    required this.title,
    required this.body,
    required this.time,
    this.itemId,
    this.read = false,
  });

  factory AppNotification.fromJson(Map<String, dynamic> j) => AppNotification(
        title: j['title'] as String,
        body: j['body'] as String,
        time: DateTime.parse(j['time'] as String),
        itemId: j['itemId'] as String?,
        read: j['read'] as bool? ?? false,
      );

  final String title;
  final String body;
  final DateTime time;
  final String? itemId;
  bool read;

  Map<String, dynamic> toJson() => {
        'title': title,
        'body': body,
        'time': time.toIso8601String(),
        'itemId': itemId,
        'read': read,
      };
}
