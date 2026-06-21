import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:chelnok_boxing_timer/shared/theme/app_colors.dart';

class ChelnockSwitch extends StatefulWidget {
  const ChelnockSwitch({
    super.key,
    required this.value,
    required this.onChanged,
  });

  final bool value;
  final ValueChanged<bool>? onChanged;

  @override
  State<ChelnockSwitch> createState() => _ChelnockSwitchState();
}

class _ChelnockSwitchState extends State<ChelnockSwitch> {
  static const Duration _moveDuration = Duration(milliseconds: 260);

  bool _isAnimating = false;
  Timer? _resetTimer;

  void _toggle() {
    if (widget.onChanged == null) return;

    _resetTimer?.cancel();

    setState(() => _isAnimating = true);
    widget.onChanged!(!widget.value);

    _resetTimer = Timer(_moveDuration, () {
      if (!mounted) return;
      setState(() => _isAnimating = false);
    });
  }

  @override
  void dispose() {
    _resetTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const double trackWidth = 68;
    const double trackHeight = 30;
    const double thumbWidth = 38;
    const double thumbHeight = 25;
    final isEnabled = widget.onChanged != null;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: isEnabled ? _toggle : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        width: trackWidth,
        height: trackHeight,
        padding: const EdgeInsets.symmetric(vertical: 2.5, horizontal: 2.5),
        decoration: BoxDecoration(
          color: isEnabled && widget.value
              ? AppColors.cyanLight
              : AppColors.blackShadow,
          borderRadius: BorderRadius.circular(999),
          boxShadow: [
            if (isEnabled && widget.value)
              BoxShadow(
                color: AppColors.cyanLight.withValues(alpha: 0.35),
                blurRadius: 16,
                spreadRadius: 1,
              ),
          ],
        ),
        child: AnimatedAlign(
          duration: _moveDuration,
          curve: Curves.easeOutCubic,
          alignment: widget.value
              ? Alignment.centerRight
              : Alignment.centerLeft,
          child: AnimatedScale(
            duration: const Duration(milliseconds: 140),
            curve: Curves.easeOut,
            scale: isEnabled && _isAnimating ? 1.9 : 1,
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 140),
              opacity: isEnabled ? (_isAnimating ? 0.62 : 1) : 0.45,
              child: isEnabled && _isAnimating
                  ? _LiquidGlassThumb(width: thumbWidth, height: thumbHeight)
                  : _DefaultThumb(width: thumbWidth, height: thumbHeight),
            ),
          ),
        ),
      ),
    );
  }
}

class _DefaultThumb extends StatelessWidget {
  const _DefaultThumb({required this.width, required this.height});

  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.white, Colors.white.withValues(alpha: 0.92)],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.16),
            blurRadius: 5,
            offset: const Offset(0, 1.5),
          ),
        ],
      ),
    );
  }
}

class _LiquidGlassThumb extends StatelessWidget {
  const _LiquidGlassThumb({required this.width, required this.height});

  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(999),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          width: width,
          height: height,
          padding: const EdgeInsets.all(1.2),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(999),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white.withValues(alpha: 0.95),
                AppColors.cyanLight.withValues(alpha: 0.70),
                Colors.white.withValues(alpha: 0.25),
                Colors.black.withValues(alpha: 0.10),
              ],
              stops: const [0.00, 0.35, 0.75, 1.00],
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.cyanLight.withValues(alpha: 0.28),
                blurRadius: 16,
                spreadRadius: -1,
              ),
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.15),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(999),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white.withValues(alpha: 0.82),
                  Colors.white.withValues(alpha: 0.34),
                ],
              ),
            ),
            child: Stack(
              children: [
                Positioned(
                  top: 2,
                  left: 5,
                  right: 5,
                  child: Container(
                    height: 7,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(999),
                      gradient: LinearGradient(
                        colors: [
                          Colors.white.withValues(alpha: 0.95),
                          Colors.white.withValues(alpha: 0),
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: -6,
                  top: 4,
                  child: Container(
                    width: 18,
                    height: 18,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.white.withValues(alpha: 0.45),
                          blurRadius: 12,
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  bottom: -3,
                  left: 12,
                  child: Container(
                    width: 20,
                    height: 10,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(999),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.white.withValues(alpha: 0.25),
                          blurRadius: 10,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
