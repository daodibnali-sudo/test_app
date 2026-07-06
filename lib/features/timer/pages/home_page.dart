import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:chelnok_boxing_timer/features/settings/localization/app_strings.dart';
import 'package:chelnok_boxing_timer/features/settings/providers/app_settings_provider.dart';
import 'package:chelnok_boxing_timer/features/timer/pages/preset_list_page.dart';
import 'package:chelnok_boxing_timer/features/timer/providers/timer_provider.dart';
import 'package:chelnok_boxing_timer/features/timer/widgets/preset_actions_sheet.dart';
import 'package:chelnok_boxing_timer/features/timer/widgets/custom_preset_scroll_list.dart';
import 'package:chelnok_boxing_timer/features/timer/widgets/preset_scroll_list.dart';
import 'package:chelnok_boxing_timer/core/monetization/preset_access_gate.dart';
import 'package:chelnok_boxing_timer/router/open_timer.dart';

import 'package:chelnok_boxing_timer/widgets/button.dart';
import 'package:chelnok_boxing_timer/shared/theme/app_colors.dart';
import 'package:chelnok_boxing_timer/shared/theme/app_fonts.dart';
import 'package:chelnok_boxing_timer/widgets/app_bar.dart';
//import 'package:chelnok_boxing_timer/widgets/outlined_section.dart';
//import 'package:chelnok_boxing_timer/widgets/weight_badge.dart';

final double userWeight = 0;
final String userName = 'Boxer';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(
      appSettingsProvider.select((settings) => settings.themeMode),
    );
    AppColors.setThemeMode(themeMode);

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
    final strings = ref.watch(appStringsProvider);

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
              Text(strings.text('greetings'), style: AppTextStyles.heading),
              Text(strings.text('ready'), style: AppTextStyles.label),

              const SizedBox(height: 15),

              PreferredSize(
                preferredSize: const Size.fromHeight(0),
                child: Divider(
                  height: 0,
                  thickness: 0,
                  color: AppColors.borderSoft,
                ),
              ),

              const SizedBox(height: 15),

              PresetSectionHeader(
                icon: Icons.flash_on,
                title: strings.text('quickWorkouts'),
                seeAllLabel: strings.text('seeAll'),
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
                  final canStart = await PresetAccessGate.requestPresetStart(
                    context,
                  );
                  if (!canStart || !context.mounted) return;

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
                iconColor: AppColors.cyanDeep,
                height: 64,
                radius: 16,
                borderWidth: AppColors.isLight ? 1 : 2,
                backgroundColor: AppColors.primaryActionSurface,
                borderColor: AppColors.isLight
                    ? AppColors.borderSoft
                    : AppColors.textPrimary.withAlpha(150),
                filled: true,
                text: strings.text('workoutTimer'),
                subtitleOnTop: true,
                textAlign: TextAlign.start,
                contentAlignment: MainAxisAlignment.start,
                textSize: 20,
                subtitleGap: 0,
                textStyle: TextStyle(
                  fontFamily: 'alata',
                  color: AppColors.textPrimary.withAlpha(230),
                  fontSize: 20,
                ),
                iconBackgroundColor: AppColors.softIconBg,
                leading: Icon(Icons.add, color: AppColors.cyanDeep),
                iconSize: 22,
                onPressed: () => openTimerSetPage(context),
              ),

              const SizedBox(height: 12),

              PreferredSize(
                preferredSize: const Size.fromHeight(0),
                child: Divider(
                  height: 0,
                  thickness: 0,
                  color: AppColors.borderSoft,
                ),
              ),

              const SizedBox(height: 15),

              PresetSectionHeader(
                icon: Icons.timer,
                title: strings.text('customPresets'),
                seeAllLabel: strings.text('seeAll'),
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
                  final canStart = await PresetAccessGate.requestPresetStart(
                    context,
                  );
                  if (!canStart || !context.mounted) return;

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
                textAlign: TextAlign.start,
                contentAlignment: MainAxisAlignment.start,
                iconColor: AppColors.cyanDeep,
                borderColor: AppColors.isLight
                    ? AppColors.borderSoft
                    : AppColors.textPrimary.withAlpha(150),
                height: 64,
                iconBackgroundColor: AppColors.softIconBg,
                borderWidth: AppColors.isLight ? 1 : 2,
                radius: 16,
                backgroundColor: AppColors.primaryActionSurface,
                text: strings.text('createWorkout'),
                textColor: AppColors.textPrimary,
                leading: const Icon(Icons.playlist_add),
                onPressed: () => openPresetBuilderPage(context),
                textStyle: TextStyle(
                  fontFamily: 'alata',
                  color: AppColors.textPrimary.withAlpha(230),
                  fontSize: 20,
                ),
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
    required this.seeAllLabel,
    required this.onSeeAll,
  });

  final IconData icon;
  final String title;
  final String seeAllLabel;
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
            seeAllLabel,
            style: AppTextStyles.title.copyWith(color: AppColors.cyanLight),
          ),
        ),
      ],
    );
  }
}
