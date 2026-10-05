import 'package:flutter/material.dart';

/// The app's colors. Each one comes from the light or the night palette,
/// depending on [dark], which [ThemeController] sets.
class AppColors {
  AppColors._();

  /// True while night mode is on. Change it through [ThemeController], which
  /// also redraws every screen.
  static bool dark = false;

  static _Palette get _p => dark ? _night : _day;

  /// Brand color: buttons, selected states, icons and titles.
  static Color get navy => _p.navy;
  static Color get background => _p.background;

  /// Cards, inputs, app bar and other raised areas.
  static Color get surface => _p.surface;
  static Color get line => _p.line;
  static Color get text => _p.text;
  static Color get muted => _p.muted;
  static Color get hint => _p.hint;
  static Color get label => _p.label;
  static Color get lost => _p.lost;
  static Color get found => _p.found;
  static Color get photoBg => _p.photoBg;
  static Color get banner => _p.banner;
  static Color get chip => _p.chip;

  static const _day = _Palette(
    navy: Color(0xFF1E2A45),
    background: Color(0xFFF2F3F5),
    surface: Colors.white,
    line: Color(0xFFD0D3D9),
    text: Color(0xDD000000),
    muted: Color(0xFF6B7280),
    hint: Color(0xFF9CA3AF),
    label: Color(0xFF4B5563),
    lost: Color(0xFFC0392B),
    found: Color(0xFF1E8E5A),
    photoBg: Color(0xFFDDE6EE),
    banner: Color(0xFFE8EBF2),
    chip: Color(0xFFE5E7EB),
  );

  static const _night = _Palette(
    navy: Color(0xFF5B7BC0),
    background: Color(0xFF121417),
    surface: Color(0xFF1C1F24),
    line: Color(0xFF33373F),
    text: Color(0xFFE5E7EB),
    muted: Color(0xFF9CA3AF),
    hint: Color(0xFF6B7280),
    label: Color(0xFFB4BAC4),
    lost: Color(0xFFEF6B5E),
    found: Color(0xFF3DBE7F),
    photoBg: Color(0xFF27303B),
    banner: Color(0xFF232833),
    chip: Color(0xFF2A2E35),
  );
}

class _Palette {
  const _Palette({
    required this.navy,
    required this.background,
    required this.surface,
    required this.line,
    required this.text,
    required this.muted,
    required this.hint,
    required this.label,
    required this.lost,
    required this.found,
    required this.photoBg,
    required this.banner,
    required this.chip,
  });

  final Color navy;
  final Color background;
  final Color surface;
  final Color line;
  final Color text;
  final Color muted;
  final Color hint;
  final Color label;
  final Color lost;
  final Color found;
  final Color photoBg;
  final Color banner;
  final Color chip;
}
