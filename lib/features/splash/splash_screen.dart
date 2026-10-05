import 'package:flutter/material.dart';

import 'package:findit/core/theme/app_colors.dart';
import 'package:findit/features/auth/auth_gate.dart';

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
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const AuthGate()));
    });
  }

  @override
  Widget build(BuildContext context) => const Scaffold(
        backgroundColor: AppColors.navy,
        body: Center(
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Icon(Icons.search, color: Colors.white, size: 64),
            SizedBox(height: 12),
            Text('FindIt', style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.w800)),
            SizedBox(height: 4),
            Text('University Lost & Found', style: TextStyle(color: Colors.white70)),
          ]),
        ),
      );
}
