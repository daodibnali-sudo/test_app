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
import 'package:test_app/widgets/outlined_section.dart';
import 'package:test_app/widgets/weight_badge.dart';

final double userWeight = 66.4;
final String userName = 'David';

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
              Align(alignment: Alignment.topRight, child: weightBadge()),

              Text('Hey, $userName 🥊🔥', style: AppTextStyles.heading),
              Text(
                'Ready to push your limits today?',
                style: AppTextStyles.label,
              ),

              const SizedBox(height: 20),

              Row(
                children: [
                  Icon(
                    Icons.flash_on,
                    color: AppColors.cyanLight.withAlpha(200),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      'Quick Settings workouts:',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.title.copyWith(
                        color: AppColors.cyanLight.withAlpha(200),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              OutlinedSection(
                child: PresetScrollList(
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
              ),

              const SizedBox(height: 12),

              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Custom workouts',
                      style: AppTextStyles.title.copyWith(
                        color: AppColors.cyanLight.withAlpha(200),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 8),

              OutlinedSection(
                child: CustomPresetScrollList(
                  presets: timer.customPresets,
                  selectedPreset: timer.selectedCustomPreset,
                  onPresetTap: (preset) async {
                    timerNotifier.startCustomPreset(preset);
                    timerNotifier.start();
                    await openTimerRunPage(context);
                    timerNotifier.clearPresetSelection();
                  },
                ),
              ),

              const SizedBox(height: 12),

              AppButton(
                iconColor: AppColors.blackBg,
                height: 64,
                radius: 16,
                backgroundColor: AppColors.cyanLight,
                text: '+ Create Workout',
                textColor: AppColors.blackBg,
                leading: const Icon(Icons.playlist_add),
                onPressed: () => openPresetBuilderPage(context),
              ),

              const SizedBox(height: 12),

              AppButton(
                iconColor: AppColors.cyanDeep,
                height: 100,
                radius: 16,
                borderWidth: 2,
                backgroundColor: AppColors.blackSurface,
                borderColor: AppColors.cyanDeep.withAlpha(200),
                filled: false,
                text: 'Set new timer',
                textColor: AppColors.cyanLight.withAlpha(200),
                leading: const Icon(Icons.add),
                onPressed: () => openTimerSetPage(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
