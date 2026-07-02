import 'package:flutter/material.dart';

class AppColors {
  static const background = Color(0xFF0B0B0D);
  static const surface = Color(0xFF17171A);
  static const surfaceRaised = Color(0xFF1F1F23);
  static const accent = Color(0xFFE8342B);
  static const accentSoft = Color(0xFFFF6A3D);
  static const textPrimary = Color(0xFFF5F5F5);
  static const textSecondary = Color(0xFF9A9AA2);
  static const divider = Color(0xFF2A2A2E);
}

class AppTheme {
  static ThemeData dark() {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.background,
      primaryColor: AppColors.accent,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.accent,
        secondary: AppColors.accentSoft,
        surface: AppColors.surface,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: AppColors.textPrimary,
          fontSize: 24,
          fontWeight: FontWeight.w900,
          letterSpacing: 1.2,
        ),
      ),
      textTheme: const TextTheme(
        titleLarge: TextStyle(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w900,
          letterSpacing: 0.5,
        ),
        titleMedium: TextStyle(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w700,
        ),
        bodyMedium: TextStyle(color: AppColors.textSecondary),
      ),
      iconTheme: const IconThemeData(color: AppColors.textPrimary),
      dividerColor: AppColors.divider,
      splashColor: AppColors.accent.withOpacity(0.15),
      highlightColor: Colors.transparent,
    );
  }
}
