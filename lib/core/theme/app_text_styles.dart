import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Getters, not constants, so they follow day/night mode.
class AppTextStyles {
  AppTextStyles._();

  static TextStyle get mono => TextStyle(fontFamily: 'monospace', fontSize: 11, color: AppColors.muted);
  static TextStyle get label => TextStyle(fontSize: 10, fontWeight: FontWeight.w700, letterSpacing: .6, color: AppColors.label);
  static const sectionTitle = TextStyle(fontSize: 15, fontWeight: FontWeight.w700);
  static TextStyle get caption => TextStyle(fontSize: 11, color: AppColors.muted);
  static TextStyle get error => TextStyle(color: AppColors.lost, fontSize: 12);
}
