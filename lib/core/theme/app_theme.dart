import 'package:flutter/material.dart';

import 'app_colors.dart';

class AppTheme {
  AppTheme._();

  /// The theme for whichever palette [AppColors] is currently using.
  static ThemeData get current {
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(2),
      borderSide: BorderSide(color: AppColors.line),
    );
    final shape = RoundedRectangleBorder(borderRadius: BorderRadius.circular(2));
    final brightness = AppColors.dark ? Brightness.dark : Brightness.light;

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF1E2A45),
        brightness: brightness,
        primary: AppColors.navy,
        onPrimary: Colors.white,
        surface: AppColors.surface,
        onSurface: AppColors.text,
        error: AppColors.lost,
      ),
      scaffoldBackgroundColor: AppColors.background,
      dividerColor: AppColors.line,
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.navy,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(color: AppColors.dark ? AppColors.text : AppColors.navy, fontSize: 16, fontWeight: FontWeight.w700),
        shape: Border(bottom: BorderSide(color: AppColors.line)),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surface,
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        border: border,
        enabledBorder: border,
        focusedBorder: border.copyWith(borderSide: BorderSide(color: AppColors.navy, width: 1.5)),
        hintStyle: TextStyle(color: AppColors.hint, fontSize: 13),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.navy,
          foregroundColor: Colors.white,
          minimumSize: const Size.fromHeight(48),
          shape: shape,
          textStyle: const TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.navy,
          minimumSize: const Size.fromHeight(48),
          side: BorderSide(color: AppColors.navy),
          shape: shape,
        ),
      ),
      bottomSheetTheme: BottomSheetThemeData(backgroundColor: AppColors.surface),
      dialogTheme: DialogThemeData(backgroundColor: AppColors.surface),
      navigationBarTheme: NavigationBarThemeData(backgroundColor: AppColors.surface),
    );
  }
}
