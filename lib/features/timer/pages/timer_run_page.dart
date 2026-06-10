import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:test_app/features/timer/logic/timer_run_controller.dart';
import 'package:test_app/features/timer/providers/timer_provider.dart';
import 'package:test_app/features/timer/widgets/app_bar_timer.dart';
import 'package:test_app/features/timer/widgets/chelnok_progress_bar.dart';
import 'package:test_app/features/timer/widgets/timer_display.dart';
import 'package:test_app/shared/theme/app_colors.dart';
import 'package:test_app/shared/theme/app_fonts.dart';
import 'package:test_app/widgets/button.dart';

class TimerRunPage extends ConsumerWidget {
  const TimerRunPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appBarTitle = ref.watch(
      timerProvider.select(
        (timer) =>
            timer.selectedCustomPreset?.name ??
            timer.selectedPreset?.title ??
            '',
      ),
    );

    return Scaffold(
      extendBody: true,
      backgroundColor: AppColors.blackBg,
      appBar: TimerAppBar(title: appBarTitle),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            const SizedBox(height: 40),
            const _PhaseTitle(),
            const SizedBox(height: 24),
            const _ProgressSection(),
            const Spacer(),
            const _RunActions(),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}

class _PhaseTitle extends ConsumerWidget {
  const _PhaseTitle();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final phase = ref.watch(
      timerProvider.select((timer) {
        final color = timer.isPreparation
            ? AppColors.textSecondary
            : timer.isWork || timer.isCustomWorkout
            ? AppColors.cyanLight
            : AppColors.success;

        return (name: timer.currentPhaseName, color: color);
      }),
    );

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 180),
      child: Text(
        phase.name,
        key: ValueKey(phase.name),
        textAlign: TextAlign.center,
        style: AppTextStyles.heading.copyWith(color: phase.color),
      ),
    );
  }
}

class _ProgressSection extends StatelessWidget {
  const _ProgressSection();

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [_ProgressRing(), _TimerText()],
        ),
        SizedBox(height: 12),
        _ProgressLabel(),
      ],
    );
  }
}

class _ProgressRing extends ConsumerWidget {
  const _ProgressRing();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ring = ref.watch(
      timerProvider.select((timer) {
        final color = timer.isPreparation
            ? AppColors.textSecondary
            : timer.isWork || timer.isCustomWorkout
            ? AppColors.cyanLight
            : AppColors.success;

        return (
          remainingMs: timer.remainingMs,
          totalMs: timer.currentPhaseTotalMs,
          color: color,
        );
      }),
    );

    return ChelnokProgressBar(
      remainingMs: ring.remainingMs,
      totalMs: ring.totalMs,
      progressColor: ring.color,
    );
  }
}

class _TimerText extends ConsumerWidget {
  const _TimerText();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final displayMs = ref.watch(
      timerProvider.select((timer) => (timer.remainingMs ~/ 1000) * 1000),
    );

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 140),
      switchInCurve: Curves.easeOutCubic,
      switchOutCurve: Curves.easeInCubic,
      child: TimerDisplay(key: ValueKey(displayMs), seconds: displayMs),
    );
  }
}

class _ProgressLabel extends ConsumerWidget {
  const _ProgressLabel();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final label = ref.watch(
      timerProvider.select((timer) {
        return timer.isCustomWorkout
            ? 'Block ${timer.currentBlockIndex + 1} / ${timer.customBlocks.length}'
            : 'Round ${timer.currentRound} / ${timer.rounds}';
      }),
    );

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 180),
      child: Text(
        label,
        key: ValueKey(label),
        style: AppTextStyles.title.copyWith(color: AppColors.textSecondary),
      ),
    );
  }
}

class _RunActions extends ConsumerWidget {
  const _RunActions();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isRunning = ref.watch(
      timerProvider.select((timer) => timer.isRunning),
    );
    final controller = TimerRunController(ref);

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 160),
      child: Row(
        key: ValueKey(isRunning),
        children: [
          Expanded(
            child: AppButton(
              text: isRunning ? 'PAUSE' : 'START',
              leading: Icon(isRunning ? Icons.pause : Icons.play_arrow),
              backgroundColor: isRunning ? AppColors.error : AppColors.success,
              iconSize: 35,
              textStyle: const TextStyle(
                color: AppColors.blackBg,
                fontWeight: FontWeight.w700,
                fontSize: 16,
              ),
              onPressed: controller.startPause,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: AppButton(
              borderColor: AppColors.cyanLight,
              text: isRunning ? 'SKIP' : 'RESET',
              textColor: AppColors.cyanLight,
              leading: isRunning
                  ? const Icon(Icons.skip_next)
                  : const Icon(Icons.restart_alt),
              filled: true,
              iconSize: 32,
              iconColor: AppColors.cyanLight,
              backgroundColor: AppColors.blackSurface,
              onPressed: isRunning ? controller.skip : controller.reset,
            ),
          ),
        ],
      ),
    );
  }
}
