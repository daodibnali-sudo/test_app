import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chelnok_boxing_timer/features/settings/localization/app_strings.dart';
import 'package:chelnok_boxing_timer/features/settings/providers/app_settings_provider.dart';
import 'package:chelnok_boxing_timer/features/timer/formatters/timer_formatter.dart';
import 'package:chelnok_boxing_timer/features/timer/providers/timer_provider.dart';
import 'package:chelnok_boxing_timer/router/open_timer.dart';
import 'package:chelnok_boxing_timer/shared/theme/app_colors.dart';
import 'package:chelnok_boxing_timer/shared/theme/app_fonts.dart';
import 'package:chelnok_boxing_timer/features/timer/widgets/announcement_row.dart';
import 'package:chelnok_boxing_timer/features/timer/widgets/app_bar_timer.dart';
import 'package:chelnok_boxing_timer/widgets/outlined_section.dart';
import 'package:chelnok_boxing_timer/widgets/button.dart';
import 'package:chelnok_boxing_timer/features/timer/widgets/timer_setting_widget.dart';

class TimerSetPage extends ConsumerWidget {
  const TimerSetPage({super.key, this.editingTimerPresetIndex});

  final int? editingTimerPresetIndex;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(
      appSettingsProvider.select((settings) => settings.themeMode),
    );
    AppColors.setThemeMode(themeMode);

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
          keepScreenAwake: timer.keepScreenAwake,
          canEnableMinuteAnnouncement:
              timer.workMs > 60000 || timer.restMs > 60000,
          savedTimerPresets: timer.savedTimerPresets,
        ),
      ),
    );
    final timerNotifier = ref.read(timerProvider.notifier);
    final strings = ref.watch(appStringsProvider);
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
                      label: strings.text('preparation'),
                      onMinus: timerNotifier.subtractPreparationTime,
                      onPlus: timerNotifier.addPreparationTime,
                    ),
                    TimeSettingRow(
                      value: formatTime(timer.workMs),
                      label: strings.text('work'),
                      onMinus: timerNotifier.subtractWorkTime,
                      onPlus: timerNotifier.addWorkTime,
                    ),
                    TimeSettingRow(
                      value: formatTime(timer.restMs),
                      label: strings.text('rest'),
                      onMinus: timerNotifier.subtractRestTime,
                      onPlus: timerNotifier.addRestTime,
                    ),
                    TimeSettingRow(
                      value: timer.rounds.toString(),
                      label: strings.text('rounds'),
                      onMinus: timerNotifier.subtractRound,
                      onPlus: timerNotifier.addRound,
                    ),
                    Text(
                      '${strings.text('totalWorkoutTime')}: ${formatTime(totalMs)}',
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
                      strings.text('announcements'),
                      style: AppTextStyles.body.copyWith(
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 5),
                    AnnouncementRow(
                      label: strings.text('tenSecondsLeft'),
                      value: timer.tenSecAnnouncement,
                      onChanged: timerNotifier.toggleTenSecAnnouncement,
                    ),
                    AnnouncementRow(
                      label: strings.text('thirtySecondsLeft'),
                      value: timer.thirtySecAnnouncement,
                      onChanged: timerNotifier.toggleThirtySecAnnouncement,
                    ),
                    AnnouncementRow(
                      label: strings.text('minuteLeft'),
                      value: timer.minuteAnnouncement,
                      onChanged: timerNotifier.toggleMinuteAnnouncement,
                      enabled: timer.canEnableMinuteAnnouncement,
                    ),
                    AnnouncementRow(
                      label: strings.text('keepScreenAwake'),
                      value: timer.keepScreenAwake,
                      onChanged: timerNotifier.toggleKeepScreenAwake,
                    ),
                    const SizedBox(height: 8),
                    AppButton(
                      height: 48,
                      text: 'Test voice',
                      leading: const Icon(Icons.record_voice_over),
                      backgroundColor: AppColors.surfaceSoft,
                      borderColor: AppColors.borderSoft,
                      textColor: AppColors.textPrimary,
                      iconColor: AppColors.cyanLight,
                      onPressed: timerNotifier.testVoiceAnnouncement,
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
                      text: strings.text('start'),
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
                      text: editingPreset == null
                          ? strings.text('save')
                          : strings.text('update'),
                      textColor: AppColors.cyanLight,
                      leading: Icon(Icons.save),
                      iconColor: AppColors.cyanLight,
                      filled: false,
                      onPressed: () {
                        final messenger = ScaffoldMessenger.of(context);
                        final navigator = Navigator.of(context);
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

                        navigator.popUntil((route) => route.isFirst);
                        messenger
                          ..clearSnackBars()
                          ..showSnackBar(
                            SnackBar(
                              duration: const Duration(milliseconds: 1300),
                              content: Text(
                                editingPreset == null
                                    ? '${preset.title} ${strings.text('saved')}'
                                    : '${preset.title} ${strings.text('updated')}',
                                style: AppTextStyles.label.copyWith(
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              showCloseIcon: true,
                              closeIconColor: AppColors.error,
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
