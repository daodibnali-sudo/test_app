
import 'package:flutter/material.dart';
import 'package:test_app/features/timer/pages/home_page.dart';
import 'package:test_app/shared/theme/app_colors.dart';
import 'package:test_app/shared/theme/app_fonts.dart';
//import 'package:test_app/test.dart';

Widget weightBadge() {
  return Container(
    padding: const EdgeInsets.symmetric(
      horizontal: 12,
      vertical: 8,
    ),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(8),
      border: Border.all(
        color: AppColors.cyanDeep.withAlpha(150),
      ),
    ),
    child: Text('$userWeight kg', 
    style: AppTextStyles.label,
    ),
  );
}