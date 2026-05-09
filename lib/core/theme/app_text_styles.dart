import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTextStyles {
  AppTextStyles._();

  static const String _font = 'Poppins';

  static const TextStyle displayLarge = TextStyle(
    fontFamily: _font, fontSize: 32, fontWeight: FontWeight.w700,
    color: AppColors.textPrimary, letterSpacing: -0.5,
  );
  static const TextStyle displayMedium = TextStyle(
    fontFamily: _font, fontSize: 28, fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );
  static const TextStyle headlineLarge = TextStyle(
    fontFamily: _font, fontSize: 24, fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );
  static const TextStyle headlineMedium = TextStyle(
    fontFamily: _font, fontSize: 20, fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );
  static const TextStyle headlineSmall = TextStyle(
    fontFamily: _font, fontSize: 18, fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );
  static const TextStyle titleLarge = TextStyle(
    fontFamily: _font, fontSize: 16, fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );
  static const TextStyle titleMedium = TextStyle(
    fontFamily: _font, fontSize: 14, fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );
  static const TextStyle titleSmall = TextStyle(
    fontFamily: _font, fontSize: 12, fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );
  static const TextStyle bodyLarge = TextStyle(
    fontFamily: _font, fontSize: 16, fontWeight: FontWeight.w400,
    color: AppColors.textPrimary, height: 1.6,
  );
  static const TextStyle bodyMedium = TextStyle(
    fontFamily: _font, fontSize: 14, fontWeight: FontWeight.w400,
    color: AppColors.textSecondary, height: 1.5,
  );
  static const TextStyle bodySmall = TextStyle(
    fontFamily: _font, fontSize: 12, fontWeight: FontWeight.w400,
    color: AppColors.textTertiary, height: 1.4,
  );
  static const TextStyle labelLarge = TextStyle(
    fontFamily: _font, fontSize: 14, fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
  );
  static const TextStyle labelMedium = TextStyle(
    fontFamily: _font, fontSize: 12, fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
  );
  static const TextStyle labelSmall = TextStyle(
    fontFamily: _font, fontSize: 10, fontWeight: FontWeight.w500,
    color: AppColors.textTertiary, letterSpacing: 0.5,
  );
  static const TextStyle button = TextStyle(
    fontFamily: _font, fontSize: 15, fontWeight: FontWeight.w600,
    letterSpacing: 0.2,
  );
  static const TextStyle caption = TextStyle(
    fontFamily: _font, fontSize: 11, fontWeight: FontWeight.w400,
    color: AppColors.textTertiary,
  );
}
