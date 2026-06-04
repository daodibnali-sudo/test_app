import 'package:flutter/material.dart';
import 'package:test_app/shared/theme/app_colors.dart';

class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.filled = true,
  });

  final String text;
  final VoidCallback onPressed;
  final bool filled;

  static const _textStyle = TextStyle(
    fontFamily: 'alata',
    fontWeight: FontWeight.bold,
    fontSize: 15,
  );

  @override
  Widget build(BuildContext context) {
    if (filled) {
      return FilledButton(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.cyanLight,
          foregroundColor: AppColors.blackShadow,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
        onPressed: onPressed,
        child: Text(text, style: _textStyle),
      );
    }

    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        backgroundColor: AppColors.blackSurface,
        foregroundColor: AppColors.textPrimary,
        side: const BorderSide(
          color: AppColors.cyanDeep,
          width: 2,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.symmetric(vertical: 16),
      ),
      onPressed: onPressed,
      child: Text(text, style: _textStyle),
    );
  }
}