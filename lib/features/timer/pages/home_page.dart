import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:test_app/features/timer/providers/timer_provider.dart';
import 'package:test_app/features/timer/widgets/custom_preset_scroll_list.dart';
import 'package:test_app/features/timer/widgets/preset_scroll_list.dart';
import 'package:test_app/router/open_timer.dart';

import 'package:test_app/widgets/button.dart';
import 'package:test_app/shared/theme/app_colors.dart';
import 'package:test_app/shared/theme/app_fonts.dart';
import 'package:test_app/widgets/app_bar.dart';
//import 'package:test_app/widgets/outlined_section.dart';
//import 'package:test_app/widgets/weight_badge.dart';

final double userWeight = 0;
final String userName = 'Boxer';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final timer = ref.watch(
      timerProvider.select(
        (timer) => (
          selectedPreset: timer.selectedPreset,
          selectedCustomPreset: timer.selectedCustomPreset,
          savedTimerPresets: timer.savedTimerPresets,
          customPresets: timer.customPresets,
        ),
      ),
    );
    final timerNotifier = ref.read(timerProvider.notifier);

    return Scaffold(
      backgroundColor: AppColors.blackBg,
      appBar: MyAppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 21, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //Align(alignment: Alignment.topRight, child: weightBadge()),

              Text('Hey, $userName 🥊🔥', style: AppTextStyles.heading),
              Text(
                'Ready to push your limits today?',
                style: AppTextStyles.label,
              ),

              const SizedBox(height: 15),

              PreferredSize(
                preferredSize: const Size.fromHeight(0),
                child: Divider(
                  height: 0,
                  thickness: 0,
                  color: AppColors.textDisabled.withAlpha(200),
                ),
              ),

              const SizedBox(height: 15),

              Row(
                children: [
                  Icon(
                    Icons.flash_on,
                    color: AppColors.textPrimary.withAlpha(200),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      'Quick Settings workouts:',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.title.copyWith(
                        color: AppColors.textPrimary.withAlpha(200),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              PresetScrollList(
                selectedPreset: timer.selectedPreset,
                extraPresets: timer.savedTimerPresets,
                onPresetTap: (preset) async {
                  timerNotifier.applyPreset(preset);
                  timerNotifier.start();
                  await openTimerRunPage(context);
                  timerNotifier.clearPresetSelection();
                },
                onExtraPresetLongPress: (index) {
                  HapticFeedback.selectionClick();
                  final preset = timer.savedTimerPresets[index];
                  timerNotifier.applyPreset(preset);
                  openTimerSetPage(context, editingTimerPresetIndex: index);
                },
              ),

              const SizedBox(height: 12),

              AppButton(
                iconColor: AppColors.blackSurface,
                height: 100,
                radius: 16,
                borderWidth: 2,
                backgroundColor: AppColors.blackSurface,
                borderColor: AppColors.cyanDeep.withAlpha(150),
                filled: true,
                subtitle: 'Set a new',
                text: 'Workout timer',
                subtitleOnTop: true,
                textAlign: TextAlign.start,
                contentAlignment: MainAxisAlignment.start,
                textSize: 30,
                subtitleGap: 0,
                textStyle: TextStyle(
                  fontFamily: 'alata', color: AppColors.textPrimary.withAlpha(230), fontSize: 30
                ),

                subtitleStyle: AppTextStyles.label.copyWith(
                  color: AppColors.textSecondary,
                  fontSize: 15
                ),
                iconBackgroundColor: AppColors.textDisabled.withAlpha(50),
                
                leading: const Icon(Icons.add, color: AppColors.textPrimary,),
                iconSize: 45,
                onPressed: () => openTimerSetPage(context),
                
              ),

                            const SizedBox(height: 12),

                            PreferredSize(
                preferredSize: const Size.fromHeight(0),
                child: Divider(
                  height: 0,
                  thickness: 0,
                  color: AppColors.textDisabled.withAlpha(200),
                ),
              ),

              const SizedBox(height: 15),


              Row(
                children: [
                  Icon(
                    Icons.timer,
                    color: AppColors.textPrimary.withAlpha(200),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      'Custom presets',
                      style: AppTextStyles.title.copyWith(
                        color: AppColors.textPrimary.withAlpha(200),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 8),

              CustomPresetScrollList(
                presets: timer.customPresets,
                selectedPreset: timer.selectedCustomPreset,
                onPresetTap: (preset) async {
                  timerNotifier.startCustomPreset(preset);
                  timerNotifier.start();
                  await openTimerRunPage(context);
                  timerNotifier.clearPresetSelection();
                },
              ),

              const SizedBox(height: 12),

              AppButton(
                iconColor: AppColors.textPrimary,
                borderColor: AppColors.cyanDeep.withAlpha(150),
                height: 64,
                iconBackgroundColor: AppColors.textDisabled.withAlpha(50),
                textAlign: TextAlign.start,
                
                radius: 16,
                backgroundColor: AppColors.blackSurface,
                text: 'Create Workout',
                textColor: AppColors.textPrimary,
                leading: const Icon(Icons.playlist_add),
                onPressed: () => openPresetBuilderPage(context),
              ),

              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}
