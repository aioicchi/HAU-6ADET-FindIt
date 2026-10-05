import 'package:flutter/material.dart';

import 'app.dart';
import 'data/app_store.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await store.load();
  runApp(const FindItApp());
}
