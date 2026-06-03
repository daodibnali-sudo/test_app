import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:test_app/features/timer/formatters/timer_formatter.dart';
import 'package:test_app/features/timer/providers/timer_provider.dart';
import 'package:test_app/shared/theme/app_colors.dart';
import 'package:test_app/shared/theme/app_fonts.dart';
import 'package:test_app/widgets/app_bar_timer.dart';

class TimerRunPage extends ConsumerWidget {
  const TimerRunPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final timer = ref.watch(timerProvider);
    final timerNotifier = ref.read(timerProvider.notifier);

    return Scaffold(
      extendBody: true,
      backgroundColor: AppColors.blackBg,
      appBar: const TimerAppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            const SizedBox(height: 40),
            Text(
              timer.isWork ? 'Work' : 'Rest',
              style: AppTextStyles.heading.copyWith(
                color: timer.isWork ? AppColors.cyanLight : AppColors.success,
              ),
            ),
            const SizedBox(height: 24),
            _TimerDisplay(seconds: timer.remainingSeconds),
            const SizedBox(height: 12),
            Text(
              'Round ${timer.currentRound} / ${timer.rounds}',
              style: AppTextStyles.title.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const Spacer(),
            _TimerControls(
              isRunning: timer.isRunning,
              onStartPause: timer.isRunning
                  ? timerNotifier.pause
                  : timerNotifier.start,
              onReset: timerNotifier.reset,
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

class _TimerDisplay extends StatelessWidget {
  const _TimerDisplay({required this.seconds});

  final int seconds;

  @override
  Widget build(BuildContext context) {
    return Text(
      formatTime(seconds),
      textAlign: TextAlign.center,
      style: AppTextStyles.timer.copyWith(
        color: AppColors.textPrimary,
        fontSize: 96,
        fontFeatures: const [FontFeature.tabularFigures()],
      ),
    );
  }
}

class _TimerControls extends StatelessWidget {
  const _TimerControls({
    required this.isRunning,
    required this.onStartPause,
    required this.onReset,
  });

  final bool isRunning;
  final VoidCallback onStartPause;
  final VoidCallback onReset;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: onStartPause,
            icon: Icon(isRunning ? Icons.pause : Icons.play_arrow),
            label: Text(isRunning ? 'Pause' : 'Start'),
            style: _buttonStyle(
              isRunning ? AppColors.error : AppColors.success,
            ),
          ),
        ),
        const SizedBox(width: 12),
        IconButton(
          onPressed: onReset,
          icon: const Icon(Icons.restart_alt),
          color: AppColors.textPrimary,
          iconSize: 32,
          style: IconButton.styleFrom(
            backgroundColor: AppColors.blackSurface,
            fixedSize: const Size(56, 56),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ],
    );
  }

  ButtonStyle _buttonStyle(Color color) {
    return ElevatedButton.styleFrom(
      backgroundColor: color,
      foregroundColor: AppColors.textPrimary,
      fixedSize: const Size.fromHeight(56),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      textStyle: AppTextStyles.title.copyWith(
        color: AppColors.textPrimary,
        fontSize: 16,
      ),
    );
  }
}
