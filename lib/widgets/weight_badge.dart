import 'package:flutter/material.dart';
import 'package:chelnok_boxing_timer/features/timer/pages/home_page.dart';
import 'package:chelnok_boxing_timer/shared/theme/app_colors.dart';
import 'package:chelnok_boxing_timer/shared/theme/app_fonts.dart';
//import 'package:chelnok_boxing_timer/test.dart';

Widget weightBadge() {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(8),
      border: Border.all(color: AppColors.cyanLight.withAlpha(200)),
    ),
    child: Text('$userWeight kg', style: AppTextStyles.label),
  );
}
