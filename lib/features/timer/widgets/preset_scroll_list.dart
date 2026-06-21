import 'package:flutter/material.dart';
import 'package:chelnok_boxing_timer/features/timer/data/timer_presets.dart';
import 'package:chelnok_boxing_timer/features/timer/models/timer_quick_preset.dart';
import 'package:chelnok_boxing_timer/shared/theme/app_colors.dart';
import 'package:chelnok_boxing_timer/shared/theme/app_fonts.dart';
import 'package:chelnok_boxing_timer/widgets/scroll_cards.dart';

class PresetScrollList extends StatelessWidget {
  const PresetScrollList({
    super.key,
    required this.selectedPreset,
    required this.onPresetTap,
    this.onBuiltInPresetLongPress,
    this.onExtraPresetLongPress,
    this.extraPresets = const [],
    this.height = 112,
  });

  final TimerPreset? selectedPreset;
  final ValueChanged<TimerPreset> onPresetTap;
  final ValueChanged<TimerPreset>? onBuiltInPresetLongPress;
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
            onLongPress: extraIndex >= 0
                ? onExtraPresetLongPress == null
                      ? null
                      : () => onExtraPresetLongPress!(extraIndex)
                : onBuiltInPresetLongPress == null
                ? null
                : () => onBuiltInPresetLongPress!(preset),
            backgroundColor: AppColors.blackSurface,
            borderColor: selected ? AppColors.cyanLight : AppColors.borderSoft,
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
