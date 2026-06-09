import 'package:flutter/material.dart';
import 'package:test_app/features/timer/widgets/timer_display.dart';
import 'package:test_app/shared/theme/app_colors.dart';

class TimerProgressCircle extends StatelessWidget {
  const TimerProgressCircle({
    super.key,
    required this.remainingSeconds,
    required this.totalSeconds,
    required this.color,
    this.size = 260,
    this.strokeWidth = 10,
  });

  final int remainingSeconds;
  final int totalSeconds;
  final Color color;
  final double size;
  final double strokeWidth;

  @override
  Widget build(BuildContext context) {
    final progress = totalSeconds == 0
        ? 0.0
        : remainingSeconds / totalSeconds;

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CircularProgressIndicator(
            value: progress,
            strokeWidth: strokeWidth,
            strokeCap: StrokeCap.round,
            backgroundColor: AppColors.blackSurface,
            color: color,
          ),
          TimerDisplay(seconds: remainingSeconds),
        ],
      ),
    );
  }
}