import 'package:flutter/material.dart';
import 'package:chelnok_boxing_timer/shared/theme/app_colors.dart';

class OutlinedSection extends StatelessWidget {
  const OutlinedSection({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.blackSurface,
        border: Border.all(
          color: AppColors.isLight
              ? AppColors.borderSoft
              : AppColors.textPrimary.withAlpha(150),
          width: AppColors.isLight ? 1 : 2,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppColors.cardShadows,
      ),
      child: child,
    );
  }
}
