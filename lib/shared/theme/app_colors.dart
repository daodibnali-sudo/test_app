import 'package:flutter/material.dart';

class AppColors {
  const AppColors._();

  static bool _isLight = false;

  static bool get isLight => _isLight;

  static void setThemeMode(ThemeMode mode) {
    _isLight = mode == ThemeMode.light;
  }

  // Brand
  static Color get cyanLight =>
      _isLight ? const Color(0xFF00BCD4) : const Color(0xFF00D9FF);

  static Color get cyanDeep =>
      _isLight ? const Color(0xFF0097A7) : const Color(0xFF0097B8);

  static const lagoon = Color(0xFF0047FF);

  // Background + surfaces
  static Color get blackBg =>
      _isLight ? const Color(0xFFF6F8FB) : const Color(0xFF090B0F);

  static Color get blackSurface =>
      _isLight ? const Color(0xFFFFFFFF) : const Color(0xFF12161D);

  static Color get surfaceSoft =>
      _isLight ? const Color(0xFFEEF3F7) : const Color(0xFF1A1F27);

  // Use this for borders/dividers in light mode, and raised surfaces in dark mode.
  static Color get blackShadow =>
      _isLight ? const Color(0xFFEEF3F7) : const Color(0xFF1A1F27);

  // Optional stronger card shadow color
  static Color get cardShadow =>
      _isLight ? const Color(0x140F172A) : const Color(0x66000000);

  static List<BoxShadow> get cardShadows => _isLight
      ? [
          BoxShadow(
            color: cardShadow,
            blurRadius: 16,
            spreadRadius: 0,
            offset: const Offset(0, 8),
          ),
        ]
      : const [];

  // Text
  static Color get textPrimary =>
      _isLight ? const Color(0xFF111827) : const Color(0xFFF5F7FA);

  static Color get textSecondary =>
      _isLight ? const Color(0xFF6B7280) : const Color(0xFF8E96A3);

  static Color get textDisabled =>
      _isLight ? const Color(0xFF9CA3AF) : const Color(0xFF5B6573);

  // Light theme helpers
  static Color get border =>
      _isLight ? const Color(0xFFD8DEE6) : const Color(0xFF2A3340);

  static Color get borderSoft =>
      _isLight ? const Color(0xFFE8EDF3) : const Color(0xFF2A3340);

  static Color get lightBorder =>
      _isLight ? const Color(0xFFE5E7EB) : const Color(0xFF2A3340);

  static Color get softIconBg =>
      _isLight ? const Color(0xFFF1F5F9) : const Color(0xFF202632);

  static Color get primaryActionSurface =>
      _isLight ? const Color(0xFFF9FEFF) : blackSurface;

  static Color get controlBorder => _isLight ? border : textPrimary;

  // Premium colors
  static const premiumPrimary = Color(0xFF6E4CFF);
  static const premiumSecondary = Color(0xFF8A5CFF);

  // States
  static const success = Color(0xFF22C55E);
  static const warning = Color(0xFFFACC15);
  static const error = Color(0xFFFF5C5C);
}
