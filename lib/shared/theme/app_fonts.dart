import 'package:flutter/material.dart';

abstract final class AppFonts {
  static const String inter = 'Inter';
  static const String alata = 'Alata';
}

abstract final class AppTextStyles {
  static const TextStyle timer = TextStyle(
    fontFamily: AppFonts.alata,
    fontSize: 72,
    fontWeight: FontWeight.w400,
    letterSpacing: -2,
  );

  static const TextStyle heading = TextStyle(
    fontFamily: AppFonts.alata,
    fontSize: 28,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle title = TextStyle(
    fontFamily: AppFonts.inter,
    fontSize: 20,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle body = TextStyle(
    fontFamily: AppFonts.inter,
    fontSize: 16,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle label = TextStyle(
    fontFamily: AppFonts.inter,
    fontSize: 13,
    fontWeight: FontWeight.w500,
  );
}