import 'package:flutter/material.dart';

import 'app.dart';
import 'core/theme/theme_controller.dart';
import 'data/app_store.dart';
import 'features/onboarding/onboarding_state.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Future.wait([store.load(), themeController.load()]);
  showIntroOnLaunch = true; // The intro slides come up every time the app opens.
  runApp(const FindItApp());
}
