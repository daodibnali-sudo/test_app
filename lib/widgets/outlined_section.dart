import 'package:flutter/material.dart';
import 'package:test_app/shared/theme/app_colors.dart';

class OutlinedSection extends StatelessWidget {
  const OutlinedSection({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.blackSurface,
        border: Border.all(color: AppColors.cyanLight.withAlpha(150), width: 2),
        borderRadius: BorderRadius.circular(16),
      ),
      child: child,
    );
  }
}