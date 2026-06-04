import 'package:flutter/material.dart';
import 'package:test_app/shared/theme/app_colors.dart';
import 'package:test_app/shared/theme/app_fonts.dart';

Widget scrollCard({
  required IconData icon,
  required String title,
  required String subtitle,
}) {
  return Container(
    width: 145,
    margin: const EdgeInsets.only(right: 12),
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: AppColors.blackSurface,
      borderRadius: BorderRadius.circular(8),
      border: Border.all(color: AppColors.cyanDeep.withValues(alpha: 0.35)),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Icon(icon, color: AppColors.cyanLight, size: 26),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: AppTextStyles.title),
            const SizedBox(height: 4),
            Text(subtitle, style: AppTextStyles.label),
          ],
        ),
      ],
    ),
  );
}
