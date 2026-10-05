import 'package:flutter/material.dart';

import 'app_colors.dart';

class AppTextStyles {
  AppTextStyles._();

  static const mono = TextStyle(fontFamily: 'monospace', fontSize: 11, color: AppColors.muted);
  static const label = TextStyle(fontSize: 10, fontWeight: FontWeight.w700, letterSpacing: .6, color: Color(0xFF4B5563));
  static const sectionTitle = TextStyle(fontSize: 15, fontWeight: FontWeight.w700);
  static const caption = TextStyle(fontSize: 11, color: AppColors.muted);
  static const error = TextStyle(color: AppColors.lost, fontSize: 12);
}
