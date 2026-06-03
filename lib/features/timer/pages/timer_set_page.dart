import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:test_app/features/timer/formatters/timer_formatter.dart';
import 'package:test_app/features/timer/pages/timer_run_page.dart';
import 'package:test_app/features/timer/providers/timer_provider.dart';
import 'package:test_app/shared/theme/app_colors.dart';
import 'package:test_app/shared/theme/app_fonts.dart';
import 'package:test_app/widgets/app_bar_timer.dart';
import 'package:test_app/widgets/timer_setting_widget.dart';
//import 'package:test_app/features/timer/providers/timer_provider.dart';

class TimerSetPage extends ConsumerWidget {
  const TimerSetPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final timer = ref.watch(timerProvider);
    final timerNotifier = ref.read(timerProvider.notifier);
    return Scaffold(
      backgroundColor: AppColors.blackBg,
      appBar: TimerAppBar(),

      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(left: 25, right: 10),
          child: Column(
            children: [
              Text('Set new timer', style: AppTextStyles.heading),
              SizedBox(height: 20),
              TimeSettingRow(
                value: formatTime(timer.workSeconds),
                label: 'Work',
                onMinus: timerNotifier.subtractWorkTime,
                onPlus: timerNotifier.addWorkTime,
              ),
              TimeSettingRow(
                value: formatTime(timer.restSeconds),
                label: 'Rest',
                onMinus: timerNotifier.subtractRestTime,
                onPlus: timerNotifier.addRestTime,
              ),
              TimeSettingRow(
                value: timer.rounds.toString(),
                label: 'Rounds',
                onMinus: timerNotifier.subtractRound,
                onPlus: timerNotifier.addRound,
              ),
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  backgroundColor: AppColors.blackSurface,
                  foregroundColor: AppColors.textPrimary,
                  side: const BorderSide(color: AppColors.cyanDeep, width: 2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 16,
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const TimerRunPage()),
                  );
                },
                child: Text('START'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
