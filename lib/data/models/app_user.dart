class AppUser {
  AppUser({
    required this.id,
    required this.name,
    required this.email,
    this.studentId = '',
    this.phone = '',
  });

  factory AppUser.fromJson(Map<String, dynamic> j) => AppUser(
        id: j['id'] as String,
        name: j['name'] as String,
        email: j['email'] as String,
        studentId: j['studentId'] as String? ?? '',
        phone: j['phone'] as String? ?? '',
      );

  final String id;
  final String email;
  String name;
  String studentId;
  String phone;

  String get initials => name.trim().split(RegExp(r'\s+')).take(2).map((p) => p[0].toUpperCase()).join();

  Map<String, dynamic> toJson() => {'id': id, 'name': name, 'email': email, 'studentId': studentId, 'phone': phone};
}
