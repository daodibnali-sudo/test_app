import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:test_app/features/timer/logic/timer_run_controller.dart';
import 'package:test_app/features/timer/providers/timer_provider.dart';
import 'package:test_app/shared/theme/app_colors.dart';
import 'package:test_app/shared/theme/app_fonts.dart';
import 'package:test_app/features/timer/widgets/app_bar_timer.dart';
import 'package:test_app/widgets/button.dart';
import 'package:test_app/features/timer/widgets/chelnok_progress_bar.dart';

class TimerRunPage extends ConsumerWidget {
  const TimerRunPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    
    final timer = ref.watch(timerProvider);
    final controller = TimerRunController(ref);
    final totalSeconds = timer.isWork ? timer.workSeconds : timer.restSeconds;
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
            ChelnokProgressBar(
              remainingSeconds: timer.remainingSeconds,
              totalSeconds: totalSeconds,
              progressColor: timer.isWork ? AppColors.cyanLight : AppColors.success,
),
            const SizedBox(height: 12),
            Text(
              'Round ${timer.currentRound} / ${timer.rounds}',
              style: AppTextStyles.title.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const Spacer(),

            Row(
              children: [
                Expanded(
                  child: AppButton(
                    text: timer.isRunning ? 'PAUSE' : 'START',
                    leading: Icon(
                      timer.isRunning ? Icons.pause : Icons.play_arrow,
                    ),
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
                        ? Icon(Icons.skip_next)
                        : Icon(Icons.restart_alt),

                    filled: true,

                    iconSize: 32,
                    iconColor: AppColors.cyanLight,
                    backgroundColor: AppColors.blackSurface,
                    onPressed: timer.isRunning
                        ? controller.skip
                        : controller.reset,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}
