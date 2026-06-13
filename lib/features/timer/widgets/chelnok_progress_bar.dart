import 'dart:math';

import 'package:flutter/material.dart';
import 'package:chelnok_boxing_timer/shared/theme/app_colors.dart';

class ChelnokProgressBar extends StatelessWidget {
  const ChelnokProgressBar({
    super.key,
    required this.remainingMs,
    required this.totalMs,
    required this.progressColor,
    this.size = 280,
    this.strokeWidth = 14,
    this.trackColor = AppColors.blackSurface,
    this.glassColor = const Color(0x22FFFFFF),
    this.borderColor = const Color(0x33FFFFFF),
    this.borderWidth = 1.2,
  });

  final int remainingMs;
  final int totalMs;
  final Color progressColor;

  final double size;
  final double strokeWidth;
  final Color trackColor;

  final Color glassColor;
  final Color borderColor;
  final double borderWidth;

  @override
  Widget build(BuildContext context) {
    final progress = totalMs == 0
        ? 0.0
        : (remainingMs / totalMs).clamp(0.0, 1.0);

    return TweenAnimationBuilder<double>(
      tween: Tween(end: progress),
      duration: const Duration(milliseconds: 110),
      curve: Curves.linear,
      builder: (context, animatedProgress, child) {
        return SizedBox(
          width: size,
          height: size,
          child: RepaintBoundary(
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: glassColor,
                border: Border.all(color: borderColor, width: borderWidth),
              ),
              child: CustomPaint(
                painter: _ChelnokProgressPainter(
                  progress: animatedProgress,
                  progressColor: progressColor,
                  trackColor: trackColor,
                  strokeWidth: strokeWidth,
                ),
                child: child,
              ),
            ),
          ),
        );
      },
      child: const SizedBox.expand(),
    );
  }
}

class _ChelnokProgressPainter extends CustomPainter {
  const _ChelnokProgressPainter({
    required this.progress,
    required this.progressColor,
    required this.trackColor,
    required this.strokeWidth,
  });

  final double progress;
  final Color progressColor;
  final Color trackColor;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = (size.width - strokeWidth) / 2;

    final rect = Rect.fromCircle(center: center, radius: radius);

    final trackPaint = Paint()
      ..color = trackColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final progressPaint = Paint()
      ..shader = SweepGradient(
        startAngle: -pi / 2,
        endAngle: pi * 1.5,
        colors: [
          progressColor.withAlpha(120),
          progressColor,
          Colors.white.withAlpha(220),
          progressColor,
        ],
      ).createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    const startAngle = -pi / 2;
    final sweepAngle = 2 * pi * progress;

    canvas.drawCircle(center, radius, trackPaint);
    canvas.drawArc(rect, startAngle, sweepAngle, false, progressPaint);

    final highlightPaint = Paint()
      ..color = Colors.white.withAlpha(38)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.4;

    canvas.drawCircle(center, radius - strokeWidth, highlightPaint);
  }

  @override
  bool shouldRepaint(covariant _ChelnokProgressPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.progressColor != progressColor ||
        oldDelegate.trackColor != trackColor ||
        oldDelegate.strokeWidth != strokeWidth;
  }
}
