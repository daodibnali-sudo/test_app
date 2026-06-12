import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:test_app/features/timer/pages/preset_list_page.dart';
import 'package:test_app/features/timer/providers/timer_provider.dart';
import 'package:test_app/features/timer/widgets/preset_actions_sheet.dart';
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

              PresetSectionHeader(
                icon: Icons.flash_on,
                title: 'Quick Settings workouts:',
                onSeeAll: () => openPresetListPage(
                  context,
                  type: PresetListType.defaultPresets,
                ),
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
                onBuiltInPresetLongPress: (preset) {
                  HapticFeedback.selectionClick();
                  showPresetActions(
                    context: context,
                    title: preset.title,
                    editLabel: 'EDIT AS COPY',
                    onEdit: () {
                      timerNotifier.applyPreset(preset);
                      openTimerSetPage(context);
                    },
                  );
                },
                onExtraPresetLongPress: (index) {
                  HapticFeedback.selectionClick();
                  final preset = timer.savedTimerPresets[index];
                  showPresetActions(
                    context: context,
                    title: preset.title,
                    editLabel: 'EDIT',
                    onEdit: () {
                      timerNotifier.applyPreset(preset);
                      openTimerSetPage(context, editingTimerPresetIndex: index);
                    },
                    onRemove: () async {
                      final shouldRemove = await showRemovePresetConfirmation(
                        context,
                      );
                      if (!shouldRemove || !context.mounted) return;

                      timerNotifier.removeTimerPreset(index);
                    },
                  );
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
                  fontFamily: 'alata',
                  color: AppColors.textPrimary.withAlpha(230),
                  fontSize: 30,
                ),

                subtitleStyle: AppTextStyles.label.copyWith(
                  color: AppColors.textSecondary,
                  fontSize: 15,
                ),
                iconBackgroundColor: AppColors.textDisabled.withAlpha(50),

                leading: const Icon(Icons.add, color: AppColors.textPrimary),
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

              PresetSectionHeader(
                icon: Icons.timer,
                title: 'Custom presets',
                onSeeAll: () => openPresetListPage(
                  context,
                  type: PresetListType.customPresets,
                ),
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
                onPresetLongPress: (index) {
                  HapticFeedback.selectionClick();
                  final preset = timer.customPresets[index];
                  showPresetActions(
                    context: context,
                    title: preset.name,
                    editLabel: 'EDIT',
                    onEdit: () => openPresetBuilderPage(
                      context,
                      editingCustomPresetIndex: index,
                    ),
                    onRemove: () async {
                      final shouldRemove = await showRemovePresetConfirmation(
                        context,
                      );
                      if (!shouldRemove || !context.mounted) return;

                      timerNotifier.removeCustomPreset(index);
                    },
                  );
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

class PresetSectionHeader extends StatelessWidget {
  const PresetSectionHeader({
    super.key,
    required this.icon,
    required this.title,
    required this.onSeeAll,
  });

  final IconData icon;
  final String title;
  final VoidCallback onSeeAll;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: AppColors.textPrimary.withAlpha(200)),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.title.copyWith(
              color: AppColors.textPrimary.withAlpha(200),
            ),
          ),
        ),
        TextButton(
          onPressed: onSeeAll,
          child: Text(
            'SEE ALL',
            style: AppTextStyles.title.copyWith(color: AppColors.cyanLight),
          ),
        ),
      ],
    );
  }
}
