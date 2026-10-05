import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Remembers whether the user picked System, Light or Dark, on this device.
class ThemeController extends ChangeNotifier {
  static const _storageKey = 'findit_theme';

  ThemeMode mode = ThemeMode.system;
  SharedPreferences? _prefs;

  Future<void> load() async {
    try {
      final prefs = _prefs = await SharedPreferences.getInstance();
      final saved = prefs.getString(_storageKey);
      if (saved != null) mode = ThemeMode.values.byName(saved);
    } catch (e) {
      debugPrint('FindIt: could not load theme setting. $e');
    }
  }

  void setMode(ThemeMode value) {
    if (value == mode) return;
    mode = value;
    notifyListeners();
    _prefs?.setString(_storageKey, value.name);
  }

  /// Whether night mode should be on, given the phone/computer setting.
  bool isDarkFor(Brightness platform) => switch (mode) {
        ThemeMode.dark => true,
        ThemeMode.light => false,
        ThemeMode.system => platform == Brightness.dark,
      };

  String get label => switch (mode) {
        ThemeMode.system => 'System',
        ThemeMode.light => 'Light',
        ThemeMode.dark => 'Dark',
      };
}

final themeController = ThemeController();
