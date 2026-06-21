import 'package:flutter/material.dart';
import 'package:chelnok_boxing_timer/shared/theme/app_colors.dart';

abstract final class AppFonts {
  static const String inter = 'Inter';
  static const String alata = 'Alata';
}

abstract final class AppTextStyles {
  static TextStyle get timer => const TextStyle(
    fontFamily: AppFonts.alata,
    fontSize: 72,
    fontWeight: FontWeight.w400,
    letterSpacing: -2,
  );

  static TextStyle get heading => TextStyle(
    color: AppColors.textPrimary,
    fontFamily: AppFonts.alata,
    fontSize: 28,
    fontWeight: FontWeight.w400,
  );

  static TextStyle get title => TextStyle(
    color: AppColors.textSecondary,
    fontFamily: AppFonts.inter,
    fontSize: 14,
    fontWeight: FontWeight.w600,
  );

  static TextStyle get body => const TextStyle(
    fontFamily: AppFonts.inter,
    fontSize: 16,
    fontWeight: FontWeight.w400,
  );

  static TextStyle get label => TextStyle(
    color: AppColors.textSecondary,
    fontFamily: AppFonts.alata,
    fontSize: 13,
    fontWeight: FontWeight.w500,
  );
}
