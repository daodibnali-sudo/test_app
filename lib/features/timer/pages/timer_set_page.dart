import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:test_app/features/timer/formatters/timer_formatter.dart';
import 'package:test_app/features/timer/pages/timer_run_page.dart';
import 'package:test_app/features/timer/providers/timer_provider.dart';
import 'package:test_app/shared/theme/app_colors.dart';
import 'package:test_app/shared/theme/app_fonts.dart';
import 'package:test_app/features/timer/widgets/announcement_row.dart';
import 'package:test_app/features/timer/widgets/app_bar_timer.dart';
import 'package:test_app/widgets/outlined_section.dart';
import 'package:test_app/widgets/button.dart';
import 'package:test_app/features/timer/widgets/timer_setting_widget.dart';

class TimerSetPage extends ConsumerWidget {
  const TimerSetPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final timer = ref.watch(timerProvider);
    final timerNotifier = ref.read(timerProvider.notifier);

    void openTimerRunPage() {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const TimerRunPage()),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.blackBg,
      appBar: TimerAppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(15, 0, 15, 20),
          child: Column(
            children: [
              const SizedBox(height: 16),

              Text(
                'Total Workout Time: ${formatTime(timer.totalSeconds)}',
                style: AppTextStyles.heading.copyWith(
                  fontSize: 25,
                  color: AppColors.textSecondary,
                ),
              ),

              const SizedBox(height: 15),

              OutlinedSection(
                child: Column(
                  children: [
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
                  ],
                ),
              ),

              const SizedBox(height: 14),

              OutlinedSection(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Announcements:',
                      style: AppTextStyles.body.copyWith(
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 10),
                    AnnouncementRow(
                      label: '10s Left',
                      value: timer.tenSecAnnouncement,
                      onChanged: timerNotifier.toggleTenSecAnnouncement,
                    ),
                    AnnouncementRow(
                      label: '30s Left',
                      value: timer.thirtySecAnnouncement,
                      onChanged: timerNotifier.toggleThirtySecAnnouncement,
                    ),
                    AnnouncementRow(
                      label: 'Minute left',
                      value: timer.minuteAnnouncement,
                      onChanged: timerNotifier.toggleMinuteAnnouncement,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 10),

              Row(
  children: [
    Expanded(
      child: AppButton(
        text: 'START',
        onPressed: openTimerRunPage,
      ),
    ),

    const SizedBox(width: 10),

    Expanded(
      child: AppButton(
        text: 'SAVE',
        filled: false,
        onPressed: () {},
      ),
    ),
  ],
)
            ],
          ),
        ),
      ),
    );
  }
}