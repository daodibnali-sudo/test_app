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
  bool _stopCalled = false;

  late final void Function() _stopRun;

  @override
  void initState() {
    super.initState();

    final timerNotifier = ref.read(timerProvider.notifier);
    _stopRun = timerNotifier.stopRun;
  }

  void _leaveRunPage() {
    _stopRunOnce();

    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    }
  }

  void _stopRunOnce() {
    if (_stopCalled) return;

    _stopCalled = true;
    _stopRun();
  }

  @override
  void dispose() {
    _stopRunOnce();
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
        if (_autoPopped ||
            _stopCalled ||
            !next.isFinished ||
            next.finishRemainingMs > 0) {
          return;
        }

        _autoPopped = true;

        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted || _stopCalled || !Navigator.canPop(context)) return;

          _stopRunOnce();
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
        if (didPop) _stopRunOnce();
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
              _RunActions(onDone: _leaveRunPage),
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

        return (
          name: timer.isFinished ? 'WORKOUT COMPLETE' : timer.currentPhaseName,
          color: color,
        );
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
    return Consumer(
      builder: (context, ref, child) {
        final isFinished = ref.watch(
          timerProvider.select((timer) => timer.isFinished),
        );

        return Column(
          children: [
            const Stack(
              alignment: Alignment.center,
              children: [_ProgressRing(), _TimerText()],
            ),
            const SizedBox(height: 12),
            if (isFinished)
              const _FinishedSummaryCard()
            else
              const _ProgressLabel(),
          ],
        );
      },
    );
  }
}

class _FinishedSummaryCard extends ConsumerWidget {
  const _FinishedSummaryCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summary = ref.watch(
      timerProvider.select(
        (timer) => (
          totalWork: formatTime(timer.totalWorkMs),
          totalTime: formatTime(timer.totalMs),
        ),
      ),
    );

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.blackSurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.cyanDeep.withAlpha(110)),
      ),
      child: Row(
        children: [
          Expanded(
            child: _SummaryMetric(
              label: 'TOTAL WORK',
              value: summary.totalWork,
            ),
          ),
          Container(
            width: 1,
            height: 38,
            color: AppColors.textDisabled.withAlpha(90),
          ),
          Expanded(
            child: _SummaryMetric(
              label: 'TOTAL TIME',
              value: summary.totalTime,
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryMetric extends StatelessWidget {
  const _SummaryMetric({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.label.copyWith(
            color: AppColors.textSecondary,
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.heading.copyWith(
            color: AppColors.textPrimary,
            fontSize: 24,
          ),
        ),
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
              ? timer.currentPhaseTotalMs
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
        if (timer.isFinished) {
          return (isFinished: true, displayMs: 0);
        }

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
          ? Icon(
              Icons.check_rounded,
              key: const ValueKey('finished'),
              color: AppColors.success,
              size: 86,
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
                'Total work: ${formatTime(timer.totalWorkMs)}\n'
                'Total time: ${formatTime(timer.totalMs)}',
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
  const _RunActions({required this.onDone});

  final VoidCallback onDone;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final timer = ref.watch(
      timerProvider.select(
        (timer) => (isRunning: timer.isRunning, isFinished: timer.isFinished),
      ),
    );

    if (timer.isFinished) {
      return AppButton(
        text: 'DONE',
        leading: const Icon(Icons.check_rounded),
        backgroundColor: AppColors.cyanLight,
        iconColor: AppColors.blackBg,
        textStyle: const TextStyle(
          color: AppColors.blackBg,
          fontWeight: FontWeight.w700,
          fontSize: 16,
        ),
        onPressed: onDone,
      );
    }

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
