import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:test_app/features/timer/providers/timer_provider.dart';
import 'package:test_app/shared/theme/app_colors.dart';
import 'package:test_app/shared/theme/app_fonts.dart';
import 'package:test_app/widgets/switch.dart';

Future<void> showTimerSettingsSheet(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    backgroundColor: AppColors.blackSurface,
    showDragHandle: true,
    builder: (_) => const _TimerSettingsSheet(),
  );
}

class _TimerSettingsSheet extends ConsumerWidget {
  const _TimerSettingsSheet();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(
      timerProvider.select(
        (timer) => (
          allowSound: timer.allowSound,
          allowVibration: timer.allowVibration,
        ),
      ),
    );
    final notifier = ref.read(timerProvider.notifier);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Settings',
              style: AppTextStyles.heading.copyWith(fontSize: 26),
            ),
            const SizedBox(height: 10),
            _SettingSwitchRow(
              label: 'Allow sound',
              value: settings.allowSound,
              onChanged: notifier.toggleSound,
            ),
            _SettingSwitchRow(
              label: 'Allow vibrations',
              value: settings.allowVibration,
              onChanged: notifier.toggleVibration,
            ),
          ],
        ),
      ),
    );
  }
}

class _SettingSwitchRow extends StatelessWidget {
  const _SettingSwitchRow({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Text(
            label,
            style: AppTextStyles.heading.copyWith(
              color: AppColors.textPrimary,
              fontSize: 18,
            ),
          ),
          const Spacer(),
          ChelnockSwitch(value: value, onChanged: onChanged),
        ],
      ),
    );
  }
}
