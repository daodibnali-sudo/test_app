import 'package:flutter/material.dart';
import 'package:test_app/features/timer/models/timer_custom_preset.dart';
import 'package:test_app/shared/theme/app_colors.dart';
import 'package:test_app/shared/theme/app_fonts.dart';
import 'package:test_app/widgets/scroll_cards.dart';

class CustomPresetScrollList extends StatelessWidget {
  const CustomPresetScrollList({
    super.key,
    required this.presets,
    required this.selectedPreset,
    required this.onPresetTap,
    this.height = 112,
  });

  final List<TimerCustomPreset> presets;
  final TimerCustomPreset? selectedPreset;
  final ValueChanged<TimerCustomPreset> onPresetTap;
  final double height;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 180),
      switchInCurve: Curves.easeOutCubic,
      switchOutCurve: Curves.easeInCubic,
      child: presets.isEmpty
          ? SizedBox(
              key: const ValueKey('empty-custom-presets'),
              height: 48,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'No custom workouts yet',
                  style: AppTextStyles.label.copyWith(
                    color: AppColors.textDisabled,
                  ),
                ),
              ),
            )
          : SizedBox(
              key: const ValueKey('custom-presets'),
              height: height,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: presets.length,
                itemBuilder: (context, index) {
                  final preset = presets[index];
                  final selected = identical(selectedPreset, preset);

                  return ScrollCard(
                    icon: Icons.playlist_play,
                    title: preset.name,
                    subtitle: preset.subtitle,
                    height: height,
                    isSelected: selected,
                    onTap: () => onPresetTap(preset),
                    backgroundColor: AppColors.blackSurface,
                    borderColor: selected
                        ? AppColors.cyanLight
                        : AppColors.cyanDeep.withAlpha(120),
                    iconColor: selected
                        ? AppColors.cyanLight
                        : AppColors.textSecondary,
                    titleStyle: AppTextStyles.body.copyWith(
                      color: selected
                          ? AppColors.cyanLight
                          : AppColors.textPrimary,
                      fontSize: 14,
                    ),
                    subtitleStyle: AppTextStyles.label.copyWith(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                    ),
                  );
                },
              ),
            ),
    );
  }
}
