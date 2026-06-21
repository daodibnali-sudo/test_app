import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chelnok_boxing_timer/features/settings/localization/app_strings.dart';
import 'package:chelnok_boxing_timer/features/settings/providers/app_settings_provider.dart';
import 'package:chelnok_boxing_timer/features/timer/data/timer_presets.dart';
import 'package:chelnok_boxing_timer/features/timer/models/timer_custom_preset.dart';
import 'package:chelnok_boxing_timer/features/timer/models/timer_quick_preset.dart';
import 'package:chelnok_boxing_timer/features/timer/providers/timer_provider.dart';
import 'package:chelnok_boxing_timer/features/timer/widgets/app_bar_timer.dart';
import 'package:chelnok_boxing_timer/features/timer/widgets/preset_actions_sheet.dart';
import 'package:chelnok_boxing_timer/router/open_timer.dart';
import 'package:chelnok_boxing_timer/shared/theme/app_colors.dart';
import 'package:chelnok_boxing_timer/shared/theme/app_fonts.dart';
import 'package:chelnok_boxing_timer/widgets/button.dart';
import 'package:chelnok_boxing_timer/widgets/scroll_cards.dart';

enum PresetListType { defaultPresets, customPresets }

class PresetListPage extends ConsumerWidget {
  const PresetListPage({super.key, required this.type});

  final PresetListType type;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(
      appSettingsProvider.select((settings) => settings.themeMode),
    );
    AppColors.setThemeMode(themeMode);
    final strings = ref.watch(appStringsProvider);
    final title = switch (type) {
      PresetListType.defaultPresets => strings.text('quickSettingsWorkouts'),
      PresetListType.customPresets => strings.text('customPresetsTitle'),
    };

    return Scaffold(
      backgroundColor: AppColors.blackBg,
      appBar: TimerAppBar(title: title),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(21, 16, 21, 20),
          child: type == PresetListType.defaultPresets
              ? const _DefaultPresetList()
              : const _CustomPresetList(),
        ),
      ),
    );
  }
}

class _DefaultPresetList extends ConsumerWidget {
  const _DefaultPresetList();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final timer = ref.watch(
      timerProvider.select(
        (timer) => (
          selectedPreset: timer.selectedPreset,
          savedPresets: timer.savedTimerPresets,
        ),
      ),
    );
    final allPresets = [...timerPresets, ...timer.savedPresets];

    return ListView.separated(
      itemCount: allPresets.length,
      separatorBuilder: (_, _) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final preset = allPresets[index];
        final savedIndex = index - timerPresets.length;
        final isBuiltIn = savedIndex < 0;

        return _QuickPresetListCard(
          preset: preset,
          isSelected: _isSameTimerPreset(timer.selectedPreset, preset),
          onTap: () => _startQuickPreset(context, ref, preset),
          onLongPress: () {
            HapticFeedback.selectionClick();
            _showQuickPresetActions(
              context: context,
              ref: ref,
              preset: preset,
              savedIndex: isBuiltIn ? null : savedIndex,
            );
          },
        );
      },
    );
  }
}

class _CustomPresetList extends ConsumerWidget {
  const _CustomPresetList();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final timer = ref.watch(
      timerProvider.select(
        (timer) => (
          selectedPreset: timer.selectedCustomPreset,
          presets: timer.customPresets,
        ),
      ),
    );

    if (timer.presets.isEmpty) {
      return const _EmptyCustomPresetState();
    }

    return ListView.separated(
      itemCount: timer.presets.length,
      separatorBuilder: (_, _) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final preset = timer.presets[index];

        return _CustomPresetListCard(
          preset: preset,
          isSelected: identical(timer.selectedPreset, preset),
          onTap: () => _startCustomPreset(context, ref, preset),
          onLongPress: () {
            HapticFeedback.selectionClick();
            _showCustomPresetActions(
              context: context,
              ref: ref,
              preset: preset,
              index: index,
            );
          },
        );
      },
    );
  }
}

class _EmptyCustomPresetState extends ConsumerWidget {
  const _EmptyCustomPresetState();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final strings = ref.watch(appStringsProvider);

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            strings.text('noCustomPresetsYet'),
            textAlign: TextAlign.center,
            style: AppTextStyles.heading.copyWith(fontSize: 24),
          ),
          const SizedBox(height: 8),
          Text(
            strings.text('createFirstPreset'),
            textAlign: TextAlign.center,
            style: AppTextStyles.label.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 18),
          AppButton(
            text: strings.text('createPreset'),
            leading: const Icon(Icons.playlist_add),
            backgroundColor: AppColors.cyanLight,
            iconColor: AppColors.blackBg,
            textStyle: TextStyle(
              color: AppColors.blackBg,
              fontWeight: FontWeight.w700,
              fontSize: 16,
            ),
            onPressed: () => openPresetBuilderPage(context),
          ),
        ],
      ),
    );
  }
}

class _QuickPresetListCard extends StatelessWidget {
  const _QuickPresetListCard({
    required this.preset,
    required this.isSelected,
    required this.onTap,
    required this.onLongPress,
  });

  final TimerPreset preset;
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  @override
  Widget build(BuildContext context) {
    return ScrollCard(
      icon: preset.icon,
      title: preset.title,
      subtitle: preset.subtitle,
      width: double.infinity,
      height: 104,
      margin: EdgeInsets.zero,
      isSelected: isSelected,
      onTap: onTap,
      onLongPress: onLongPress,
      backgroundColor: AppColors.blackSurface,
      borderColor: isSelected ? AppColors.cyanLight : AppColors.borderSoft,
      iconColor: isSelected ? AppColors.cyanLight : AppColors.textSecondary,
      titleStyle: AppTextStyles.body.copyWith(
        color: isSelected ? AppColors.cyanLight : AppColors.textPrimary,
        fontSize: 15,
      ),
      subtitleStyle: AppTextStyles.label.copyWith(
        color: AppColors.textSecondary,
        fontSize: 12,
      ),
    );
  }
}

class _CustomPresetListCard extends StatelessWidget {
  const _CustomPresetListCard({
    required this.preset,
    required this.isSelected,
    required this.onTap,
    required this.onLongPress,
  });

  final TimerCustomPreset preset;
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  @override
  Widget build(BuildContext context) {
    return ScrollCard(
      icon: Icons.playlist_play,
      title: preset.name,
      subtitle: preset.subtitle,
      width: double.infinity,
      height: 104,
      margin: EdgeInsets.zero,
      isSelected: isSelected,
      onTap: onTap,
      onLongPress: onLongPress,
      backgroundColor: AppColors.blackSurface,
      borderColor: isSelected ? AppColors.cyanLight : AppColors.borderSoft,
      iconColor: AppColors.textSecondary,
      titleStyle: AppTextStyles.body.copyWith(
        color: AppColors.textPrimary,
        fontSize: 15,
      ),
      subtitleStyle: AppTextStyles.label.copyWith(
        color: AppColors.textSecondary,
        fontSize: 12,
      ),
    );
  }
}

Future<void> _startQuickPreset(
  BuildContext context,
  WidgetRef ref,
  TimerPreset preset,
) async {
  final notifier = ref.read(timerProvider.notifier);
  notifier
    ..applyPreset(preset)
    ..start();
  await openTimerRunPage(context);
  notifier.clearPresetSelection();
}

Future<void> _startCustomPreset(
  BuildContext context,
  WidgetRef ref,
  TimerCustomPreset preset,
) async {
  final notifier = ref.read(timerProvider.notifier);
  notifier
    ..startCustomPreset(preset)
    ..start();
  await openTimerRunPage(context);
  notifier.clearPresetSelection();
}

void _showQuickPresetActions({
  required BuildContext context,
  required WidgetRef ref,
  required TimerPreset preset,
  required int? savedIndex,
}) {
  showPresetActions(
    context: context,
    title: preset.title,
    editLabel: savedIndex == null
        ? ref.read(appStringsProvider).text('editAsCopy')
        : ref.read(appStringsProvider).text('edit'),
    removeLabel: ref.read(appStringsProvider).text('remove'),
    cancelLabel: ref.read(appStringsProvider).text('cancel'),
    onEdit: () {
      final notifier = ref.read(timerProvider.notifier);

      notifier.applyPreset(preset);
      openTimerSetPage(context, editingTimerPresetIndex: savedIndex);
    },
    onRemove: savedIndex == null
        ? null
        : () async {
            final strings = ref.read(appStringsProvider);
            final shouldRemove = await showRemovePresetConfirmation(
              context,
              title: strings.text('removePresetQuestion'),
              message: strings.text('actionCannotBeUndone'),
              cancelLabel: strings.text('cancel'),
              removeLabel: strings.text('remove'),
            );
            if (!shouldRemove || !context.mounted) return;

            ref.read(timerProvider.notifier).removeTimerPreset(savedIndex);
          },
  );
}

void _showCustomPresetActions({
  required BuildContext context,
  required WidgetRef ref,
  required TimerCustomPreset preset,
  required int index,
}) {
  showPresetActions(
    context: context,
    title: preset.name,
    editLabel: ref.read(appStringsProvider).text('edit'),
    removeLabel: ref.read(appStringsProvider).text('remove'),
    cancelLabel: ref.read(appStringsProvider).text('cancel'),
    onEdit: () =>
        openPresetBuilderPage(context, editingCustomPresetIndex: index),
    onRemove: () async {
      final strings = ref.read(appStringsProvider);
      final shouldRemove = await showRemovePresetConfirmation(
        context,
        title: strings.text('removePresetQuestion'),
        message: strings.text('actionCannotBeUndone'),
        cancelLabel: strings.text('cancel'),
        removeLabel: strings.text('remove'),
      );
      if (!shouldRemove || !context.mounted) return;

      ref.read(timerProvider.notifier).removeCustomPreset(index);
    },
  );
}

bool _isSameTimerPreset(TimerPreset? first, TimerPreset second) {
  if (first == null) return false;

  return first.title == second.title &&
      first.workMs == second.workMs &&
      first.restMs == second.restMs &&
      first.rounds == second.rounds &&
      first.preparationMs == second.preparationMs;
}
