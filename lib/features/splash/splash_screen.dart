import 'package:flutter/material.dart';

import 'package:findit/core/theme/app_colors.dart';
import 'package:findit/features/auth/auth_gate.dart';
import 'package:findit/features/onboarding/onboarding_screen.dart';
import 'package:findit/features/onboarding/onboarding_state.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 1400), () {
      if (!mounted) return;
      // Captured now: the onboarding moves on after this splash screen is gone.
      final navigator = Navigator.of(context);
      // First visit on this device: the intro slides, then login.
      final next = onboarding.seen
          ? const AuthGate()
          : OnboardingScreen(
              onDone: () => navigator.pushReplacement(MaterialPageRoute(builder: (_) => const AuthGate())),
            );
      navigator.pushReplacement(MaterialPageRoute(builder: (_) => next));
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: AppColors.navy,
        body: Center(
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Icon(Icons.search, color: AppColors.onNavy, size: 64),
            const SizedBox(height: 12),
            Text('FindIt', style: TextStyle(color: AppColors.onNavy, fontSize: 32, fontWeight: FontWeight.w800)),
            const SizedBox(height: 4),
            Text('University Lost & Found', style: TextStyle(color: AppColors.onNavy.withValues(alpha: .75))),
          ]),
        ),
      );
}
