import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:test_app/features/timer/formatters/timer_formatter.dart';
import 'package:test_app/features/timer/providers/timer_provider.dart';
import 'package:test_app/router/open_timer.dart';
import 'package:test_app/shared/theme/app_colors.dart';
import 'package:test_app/shared/theme/app_fonts.dart';
import 'package:test_app/features/timer/widgets/announcement_row.dart';
import 'package:test_app/features/timer/widgets/app_bar_timer.dart';
import 'package:test_app/widgets/outlined_section.dart';
import 'package:test_app/widgets/button.dart';
import 'package:test_app/features/timer/widgets/timer_setting_widget.dart';

class TimerSetPage extends ConsumerWidget {
  const TimerSetPage({super.key, this.editingTimerPresetIndex});

  final int? editingTimerPresetIndex;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final timer = ref.watch(
      timerProvider.select(
        (timer) => (
          workMs: timer.workMs,
          restMs: timer.restMs,
          preparationMs: timer.preparationMs,
          rounds: timer.rounds,
          tenSecAnnouncement: timer.tenSecAnnouncement,
          thirtySecAnnouncement: timer.thirtySecAnnouncement,
          minuteAnnouncement: timer.minuteAnnouncement,
          savedTimerPresets: timer.savedTimerPresets,
        ),
      ),
    );
    final timerNotifier = ref.read(timerProvider.notifier);
    final totalMs =
        timer.preparationMs +
        (timer.workMs * timer.rounds) +
        (timer.restMs * (timer.rounds - 1));
    final editingPreset = editingTimerPresetIndex == null
        ? null
        : timer.savedTimerPresets[editingTimerPresetIndex!];

    return Scaffold(
      backgroundColor: AppColors.blackBg,
      appBar: TimerAppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(15, 0, 15, 20),
          child: Column(
            children: [
              const SizedBox(height: 15),
              OutlinedSection(
                child: Column(
                  children: [
                    TimeSettingRow(
                      value: formatTime(timer.preparationMs),
                      label: 'Preparation',
                      onMinus: timerNotifier.subtractPreparationTime,
                      onPlus: timerNotifier.addPreparationTime,
                    ),
                    TimeSettingRow(
                      value: formatTime(timer.workMs),
                      label: 'Work',
                      onMinus: timerNotifier.subtractWorkTime,
                      onPlus: timerNotifier.addWorkTime,
                    ),
                    TimeSettingRow(
                      value: formatTime(timer.restMs),
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
                    Text(
                      'Total Workout Time: ${formatTime(totalMs)}',
                      style: AppTextStyles.heading.copyWith(
                        fontSize: 24,
                        color: AppColors.textDisabled,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 10),

              //const SizedBox(height: 10),
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
                    const SizedBox(height: 5),
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
                      backgroundColor: AppColors.cyanLight,
                      text: 'START',
                      leading: Icon(Icons.play_circle_fill),
                      textColor: AppColors.blackSurface,
                      onPressed: () {
                        timerNotifier.prepareManualTimer();
                        timerNotifier.start();
                        openTimerRunPage(context);
                      },
                    ),
                  ),

                  const SizedBox(width: 10),

                  Expanded(
                    child: AppButton(
                      borderColor: AppColors.cyanLight,
                      text: editingPreset == null ? 'SAVE' : 'UPDATE',
                      textColor: AppColors.cyanLight,
                      leading: Icon(Icons.save),
                      iconColor: AppColors.cyanLight,
                      filled: false,
                      onPressed: () {
                        final preset = timerNotifier.buildCurrentTimerPreset(
                          title: editingPreset?.title,
                        );

                        if (editingTimerPresetIndex == null) {
                          timerNotifier.addTimerPreset(preset);
                        } else {
                          timerNotifier.updateTimerPreset(
                            editingTimerPresetIndex!,
                            preset,
                          );
                        }

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              editingPreset == null
                                  ? '${preset.title} saved'
                                  : '${preset.title} updated',
                            ),
                            backgroundColor: AppColors.blackSurface,
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
