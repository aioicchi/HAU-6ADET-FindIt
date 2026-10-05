class Message {
  Message({required this.text, required this.fromMe, required this.time, this.sender});

  factory Message.fromJson(Map<String, dynamic> j) => Message(
        text: j['text'] as String,
        fromMe: j['fromMe'] as bool,
        time: DateTime.parse(j['time'] as String),
        sender: j['sender'] as String?,
      );

  final String text;
  final bool fromMe;
  final DateTime time;

  /// Who sent it, shown above messages that aren't [fromMe].
  final String? sender;

  Map<String, dynamic> toJson() => {'text': text, 'fromMe': fromMe, 'time': time.toIso8601String(), 'sender': sender};
}
