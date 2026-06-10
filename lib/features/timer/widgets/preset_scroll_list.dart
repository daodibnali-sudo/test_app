import 'package:flutter/material.dart';
import 'package:test_app/features/timer/data/timer_presets.dart';
import 'package:test_app/features/timer/models/timer_quick_preset.dart';
import 'package:test_app/shared/theme/app_colors.dart';
import 'package:test_app/shared/theme/app_fonts.dart';
import 'package:test_app/widgets/scroll_cards.dart';

class PresetScrollList extends StatelessWidget {
  const PresetScrollList({
    super.key,
    required this.selectedPreset,
    required this.onPresetTap,
    this.onExtraPresetLongPress,
    this.extraPresets = const [],
    this.height = 112,
  });

  final TimerPreset? selectedPreset;
  final ValueChanged<TimerPreset> onPresetTap;
  final ValueChanged<int>? onExtraPresetLongPress;
  final List<TimerPreset> extraPresets;
  final double height;

  bool _isSelected(TimerPreset preset) {
    if (selectedPreset == null) return false;

    return selectedPreset!.workMs == preset.workMs &&
        selectedPreset!.restMs == preset.restMs &&
        selectedPreset!.rounds == preset.rounds &&
        selectedPreset!.preparationMs == preset.preparationMs;
  }

  @override
  Widget build(BuildContext context) {
    final presets = [...timerPresets, ...extraPresets];

    return SizedBox(
      height: height,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: presets.length,
        itemBuilder: (context, index) {
          final preset = presets[index];
          final extraIndex = index - timerPresets.length;
          final selected = _isSelected(preset);

          return ScrollCard(
            icon: preset.icon,
            title: preset.title,
            subtitle: preset.subtitle,
            height: height,
            isSelected: selected,
            onTap: () => onPresetTap(preset),
            onLongPress: extraIndex >= 0 && onExtraPresetLongPress != null
                ? () => onExtraPresetLongPress!(extraIndex)
                : null,
            backgroundColor: AppColors.blackSurface,
            borderColor: selected
                ? AppColors.cyanLight
                : AppColors.cyanDeep.withAlpha(120),
            iconColor: selected ? AppColors.cyanLight : AppColors.textSecondary,
            titleStyle: AppTextStyles.body.copyWith(
              color: selected ? AppColors.cyanLight : AppColors.textPrimary,
              fontSize: 14,
            ),
            subtitleStyle: AppTextStyles.label.copyWith(
              color: AppColors.textSecondary,
              fontSize: 12,
            ),
          );
        },
      ),
    );
  }
}
