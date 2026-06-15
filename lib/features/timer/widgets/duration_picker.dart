import 'package:flutter/material.dart';
import 'package:chelnok_boxing_timer/shared/theme/app_colors.dart';
import 'package:chelnok_boxing_timer/shared/theme/app_fonts.dart';

class DurationPicker extends StatelessWidget {
  const DurationPicker({
    super.key,
    required this.minutes,
    required this.seconds,
    required this.onMinutesChanged,
    required this.onSecondsChanged,
  });

  final int minutes;
  final int seconds;
  final ValueChanged<int> onMinutesChanged;
  final ValueChanged<int> onSecondsChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _NumberPickerColumn(
            label: 'Minutes',
            value: minutes,
            onMinus: () => onMinutesChanged((minutes - 1).clamp(0, 99)),
            onPlus: () => onMinutesChanged((minutes + 1).clamp(0, 99)),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _NumberPickerColumn(
            label: 'Seconds',
            value: seconds,
            onMinus: () => onSecondsChanged((seconds - 5).clamp(0, 55)),
            onPlus: () => onSecondsChanged((seconds + 5).clamp(0, 55)),
          ),
        ),
      ],
    );
  }
}

class _NumberPickerColumn extends StatelessWidget {
  const _NumberPickerColumn({
    required this.label,
    required this.value,
    required this.onMinus,
    required this.onPlus,
  });

  final String label;
  final int value;
  final VoidCallback onMinus;
  final VoidCallback onPlus;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.cyanDeep.withAlpha(120)),
      ),
      child: Column(
        children: [
          IconButton(
            onPressed: onPlus,
            iconSize: 40,
            icon: const Icon(Icons.add),
            color: AppColors.cyanLight,
            highlightColor: AppColors.cyanLight.withAlpha(100),
            
          ),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 140),
            child: Text(
              value.toString().padLeft(2, '0'),
              key: ValueKey(value),
              style: AppTextStyles.heading.copyWith(
                color: AppColors.textPrimary,
                fontSize: 30,
              ),
            ),
          ),
          Text(label, style: AppTextStyles.label),
          IconButton(
            iconSize: 40,
            onPressed: onMinus,
            icon: const Icon(Icons.remove),
            color: AppColors.textPrimary,
            highlightColor: AppColors.error.withAlpha(100),
          ),
        ],
      ),
    );
  }
}
