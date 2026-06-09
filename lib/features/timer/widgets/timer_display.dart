import 'package:flutter/material.dart';
import 'package:test_app/features/timer/formatters/timer_formatter.dart';
import 'package:test_app/shared/theme/app_colors.dart';
import 'package:test_app/shared/theme/app_fonts.dart';

class TimerDisplay extends StatelessWidget {
  const TimerDisplay({super.key, required this.seconds});

  final int seconds;

  @override
  Widget build(BuildContext context) {
    return Text(
      formatTime(seconds),
      textAlign: TextAlign.center,
      style: AppTextStyles.timer.copyWith(
        color: AppColors.textPrimary,
        fontSize: 60,
        fontFeatures: const [FontFeature.tabularFigures()],
      ),
    );
  }
}
