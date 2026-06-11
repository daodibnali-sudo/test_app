import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:test_app/features/timer/formatters/timer_formatter.dart';
import 'package:test_app/features/timer/logic/timer_run_controller.dart';
import 'package:test_app/features/timer/providers/timer_provider.dart';
import 'package:test_app/features/timer/widgets/app_bar_timer.dart';
import 'package:test_app/features/timer/widgets/chelnok_progress_bar.dart';
import 'package:test_app/features/timer/widgets/timer_display.dart';
import 'package:test_app/shared/theme/app_colors.dart';
import 'package:test_app/shared/theme/app_fonts.dart';
import 'package:test_app/widgets/button.dart';

class TimerRunPage extends ConsumerStatefulWidget {
  const TimerRunPage({super.key});

  @override
  ConsumerState<TimerRunPage> createState() => _TimerRunPageState();
}

class _TimerRunPageState extends ConsumerState<TimerRunPage> {
  bool _autoPopped = false;

  void _leaveRunPage() {
    ref.read(timerProvider.notifier).stopRun();
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    ref.read(timerProvider.notifier).stopRun();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(
      timerProvider.select(
        (timer) => (
          isFinished: timer.isFinished,
          finishRemainingMs: timer.finishRemainingMs,
        ),
      ),
      (_, next) {
        if (_autoPopped || !next.isFinished || next.finishRemainingMs > 0) {
          return;
        }

        _autoPopped = true;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted || !Navigator.canPop(context)) return;
          Navigator.pop(context);
        });
      },
    );

    final appBarTitle = ref.watch(
      timerProvider.select(
        (timer) =>
            timer.selectedCustomPreset?.name ??
            timer.selectedPreset?.title ??
            '',
      ),
    );

    return PopScope(
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) {
          ref.read(timerProvider.notifier).stopRun();
        }
      },
      child: Scaffold(
        extendBody: true,
        backgroundColor: AppColors.blackBg,
        appBar: TimerAppBar(title: appBarTitle, onBack: _leaveRunPage),
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
            : timer.isFinished
            ? AppColors.success
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
            : timer.isFinished
            ? AppColors.success
            : timer.isWork || timer.isCustomWorkout
            ? AppColors.cyanLight
            : AppColors.success;

        return (
          remainingMs: timer.isFinished
              ? timer.finishRemainingMs
              : timer.remainingMs,
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
    final timerText = ref.watch(
      timerProvider.select((timer) {
        if (timer.isFinished) return (isFinished: true, displayMs: 0);
        if (timer.remainingMs <= 0) {
          return (isFinished: false, displayMs: 0);
        }

        return (
          isFinished: false,
          displayMs: ((timer.remainingMs + 999) ~/ 1000) * 1000,
        );
      }),
    );

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 140),
      switchInCurve: Curves.easeOutCubic,
      switchOutCurve: Curves.easeInCubic,
      child: timerText.isFinished
          ? Text(
              '\u{1F4AA}',
              key: const ValueKey('finished'),
              style: AppTextStyles.timer.copyWith(fontSize: 72),
            )
          : TimerDisplay(
              key: ValueKey(timerText.displayMs),
              seconds: timerText.displayMs,
            ),
    );
  }
}

class _ProgressLabel extends ConsumerWidget {
  const _ProgressLabel();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final timer = ref.watch(
      timerProvider.select((timer) {
        if (timer.isFinished) {
          return (
            isFinished: true,
            label:
                'Total work: ${formatTime(timer.totalWorkMs)}\nTotal time: ${formatTime(timer.totalMs)}',
          );
        }

        return (
          isFinished: false,
          label: timer.isCustomWorkout
              ? 'Block ${timer.currentBlockIndex + 1} / ${timer.customBlocks.length}'
              : 'Round ${timer.currentRound} / ${timer.rounds}',
        );
      }),
    );

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 180),
      child: Text(
        timer.label,
        key: ValueKey(timer.label),
        textAlign: TextAlign.center,
        style: AppTextStyles.title.copyWith(
          color: timer.isFinished
              ? AppColors.textPrimary
              : AppColors.textSecondary,
        ),
      ),
    );
  }
}

class _RunActions extends ConsumerWidget {
  const _RunActions();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final timer = ref.watch(
      timerProvider.select(
        (timer) => (isRunning: timer.isRunning, isFinished: timer.isFinished),
      ),
    );
    if (timer.isFinished) return const SizedBox.shrink();

    final controller = TimerRunController(ref);

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 160),
      child: Row(
        key: ValueKey(timer.isRunning),
        children: [
          Expanded(
            child: AppButton(
              text: timer.isRunning ? 'PAUSE' : 'START',
              leading: Icon(timer.isRunning ? Icons.pause : Icons.play_arrow),
              backgroundColor: timer.isRunning
                  ? AppColors.error
                  : AppColors.success,
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
              text: timer.isRunning ? 'SKIP' : 'RESET',
              textColor: AppColors.cyanLight,
              leading: timer.isRunning
                  ? const Icon(Icons.skip_next)
                  : const Icon(Icons.restart_alt),
              filled: true,
              iconSize: 32,
              iconColor: AppColors.cyanLight,
              backgroundColor: AppColors.blackSurface,
              onPressed: timer.isRunning ? controller.skip : controller.reset,
            ),
          ),
        ],
      ),
    );
  }
}
