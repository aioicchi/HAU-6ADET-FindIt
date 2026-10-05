import 'package:flutter/material.dart';

import 'core/theme/app_theme.dart';
import 'features/splash/splash_screen.dart';
import 'shared/widgets/phone_frame.dart';

class FindItApp extends StatelessWidget {
  const FindItApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'FindIt',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        builder: (context, child) => PhoneFrame(child: child!),
        home: const SplashScreen(),
      );
}
