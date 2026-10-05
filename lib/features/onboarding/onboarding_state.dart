import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Remembers, on this device, whether the intro slides were already shown.
class OnboardingState {
  static const _storageKey = 'findit_onboarded';

  /// True until [load] says otherwise, so screens built without loading
  /// (like tests) go straight to login.
  bool seen = true;
  SharedPreferences? _prefs;

  Future<void> load() async {
    try {
      final prefs = _prefs = await SharedPreferences.getInstance();
      seen = prefs.getBool(_storageKey) ?? false;
    } catch (e) {
      debugPrint('FindIt: could not load onboarding flag. $e');
    }
  }

  void markSeen() {
    seen = true;
    _prefs?.setBool(_storageKey, true);
  }
}

final onboarding = OnboardingState();
