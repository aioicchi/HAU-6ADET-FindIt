class Validators {
  Validators._();

  static String? required(String? v) => (v == null || v.trim().isEmpty) ? 'Required' : null;

  static String? email(String? v) =>
      RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(v?.trim() ?? '') ? null : 'Enter a valid email';

  static String? password(String? v) => (v == null || v.length < 6) ? 'At least 6 characters' : null;
}
