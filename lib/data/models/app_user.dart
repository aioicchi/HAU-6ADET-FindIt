class AppUser {
  AppUser({
    required this.id,
    required this.name,
    required this.email,
    this.studentId = '',
    this.phone = '',
  });

  final String id;
  final String email;
  String name;
  String studentId;
  String phone;

  String get initials => name.trim().split(RegExp(r'\s+')).take(2).map((p) => p[0].toUpperCase()).join();
}
