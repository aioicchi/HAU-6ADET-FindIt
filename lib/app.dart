import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'core/theme/app_colors.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_controller.dart';
import 'features/splash/splash_screen.dart';
import 'shared/widgets/phone_frame.dart';

class FindItApp extends StatefulWidget {
  const FindItApp({super.key});

  @override
  State<FindItApp> createState() => _FindItAppState();
}

class _FindItAppState extends State<FindItApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    _syncPalette();
    themeController.addListener(_onThemeChanged);
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    themeController.removeListener(_onThemeChanged);
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  /// The phone/computer switched between light and dark.
  @override
  void didChangePlatformBrightness() => _onThemeChanged();

  void _onThemeChanged() {
    if (!_syncPalette()) return;
    // Colors are read straight from AppColors, so every screen (including
    // const widgets and pages further back) must build again. Their state is kept.
    void markDirty(Element e) {
      e.markNeedsBuild();
      e.visitChildren(markDirty);
    }

    (context as Element).visitChildren(markDirty);
    setState(() {});
  }

  /// Points AppColors at the right palette. Returns true if it changed.
  bool _syncPalette() {
    final platform = WidgetsBinding.instance.platformDispatcher.platformBrightness;
    final dark = themeController.isDarkFor(platform);
    if (dark == AppColors.dark) return false;
    AppColors.dark = dark;
    return true;
  }

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'FindIt',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.current,
        // Switch instantly so the theme and AppColors never disagree mid-animation.
        themeAnimationDuration: Duration.zero,
        // Let a mouse drag lists like a finger, so the phone-framed site on a
        // laptop scrolls and pulls to refresh the same way a phone does.
        scrollBehavior: const MaterialScrollBehavior().copyWith(dragDevices: PointerDeviceKind.values.toSet()),
        builder: (context, child) => PhoneFrame(child: child!),
        home: const SplashScreen(),
      );
}
