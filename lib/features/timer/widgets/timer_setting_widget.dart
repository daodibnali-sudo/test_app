import 'package:flutter/material.dart';
import 'package:test_app/shared/theme/app_colors.dart';
import 'package:test_app/shared/theme/app_fonts.dart';

class TimeSettingRow extends StatelessWidget {
  const TimeSettingRow({
    super.key,
    required this.value,
    required this.label,
    required this.onMinus,
    required this.onPlus,
  });

  final String value;
  final String label;
  final VoidCallback onMinus;
  final VoidCallback onPlus;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 165,
              child: Text(
                value,
                style: AppTextStyles.heading.copyWith(
                  color: AppColors.textPrimary,
                  fontSize: 60,
                  fontFeatures: const [FontFeature.tabularFigures()],
                ),
              ),
            ),
            Text(
              label,
              style: AppTextStyles.title.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),

        const Spacer(),

        IconButton(
          onPressed: onMinus,
          highlightColor: AppColors.error,
          icon: const Icon(
            Icons.remove,
            color: AppColors.textPrimary,
            size: 45,
          ),
        ),
        IconButton(
          
          onPressed: onPlus,
          highlightColor: AppColors.cyanLight,
          icon: const Icon(Icons.add, color: AppColors.textPrimary, size: 45),
        ),
      ],
    );
  }
}
