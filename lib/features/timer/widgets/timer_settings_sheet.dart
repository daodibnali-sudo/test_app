import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chelnok_boxing_timer/features/legal/data/legal_documents.dart';
import 'package:chelnok_boxing_timer/features/settings/localization/app_strings.dart';
import 'package:chelnok_boxing_timer/features/settings/models/app_language.dart';
import 'package:chelnok_boxing_timer/features/settings/providers/app_settings_provider.dart';
import 'package:chelnok_boxing_timer/features/timer/providers/timer_provider.dart';
import 'package:chelnok_boxing_timer/shared/theme/app_colors.dart';
import 'package:chelnok_boxing_timer/shared/theme/app_fonts.dart';
import 'package:chelnok_boxing_timer/widgets/switch.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> showTimerSettingsSheet(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    backgroundColor: Colors.transparent,
    showDragHandle: true,
    builder: (sheetContext) => _TimerSettingsSheet(rootContext: context),
  );
}

class _TimerSettingsSheet extends ConsumerWidget {
  const _TimerSettingsSheet({required this.rootContext});

  final BuildContext rootContext;

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
    final appSettings = ref.watch(appSettingsProvider);
    AppColors.setThemeMode(appSettings.themeMode);

    final appSettingsNotifier = ref.read(appSettingsProvider.notifier);
    final strings = ref.watch(appStringsProvider);
    final notifier = ref.read(timerProvider.notifier);

    return Material(
      color: AppColors.blackSurface,
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                strings.text('settings'),
                style: AppTextStyles.heading.copyWith(fontSize: 26),
              ),
              const SizedBox(height: 10),
              _SettingsSectionLabel(label: strings.text('theme')),
              const SizedBox(height: 8),
              _ChoiceRow<ThemeMode>(
                value: appSettings.themeMode,
                options: [
                  _ChoiceOption(
                    value: ThemeMode.dark,
                    label: strings.text('dark'),
                  ),
                  _ChoiceOption(
                    value: ThemeMode.light,
                    label: strings.text('light'),
                  ),
                ],
                onChanged: appSettingsNotifier.setThemeMode,
              ),
              const SizedBox(height: 14),
              _SettingsSectionLabel(label: strings.text('language')),
              const SizedBox(height: 8),
              _ChoiceRow<AppLanguage>(
                value: appSettings.language,
                options: AppLanguage.values
                    .map(
                      (language) =>
                          _ChoiceOption(value: language, label: language.label),
                    )
                    .toList(),
                onChanged: appSettingsNotifier.setLanguage,
              ),
              const SizedBox(height: 14),
              _SettingSwitchRow(
                label: strings.text('allowSound'),
                value: settings.allowSound,
                onChanged: notifier.toggleSound,
              ),
              _SettingSwitchRow(
                label: strings.text('allowVibrations'),
                value: settings.allowVibration,
                onChanged: notifier.toggleVibration,
              ),
              const SizedBox(height: 14),
              Divider(height: 1, thickness: 1, color: AppColors.borderSoft),
              const SizedBox(height: 16),
              Text(
                strings.text('legal'),
                style: AppTextStyles.title.copyWith(
                  color: AppColors.textSecondary,
                  letterSpacing: 0.8,
                ),
              ),
              const SizedBox(height: 8),
              _LegalNavigationRow(
                icon: Icons.privacy_tip_outlined,
                title: 'Privacy Policy',
                onTap: () => _openExternalUrl(context, privacyPolicyUrl),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _openExternalUrl(BuildContext sheetContext, String url) async {
    Navigator.pop(sheetContext);

    final uri = Uri.tryParse(url);
    if (uri == null || !await canLaunchUrl(uri)) return;

    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

}

class _SettingsSectionLabel extends StatelessWidget {
  const _SettingsSectionLabel({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: AppTextStyles.title.copyWith(
        color: AppColors.textSecondary,
        letterSpacing: 0.8,
      ),
    );
  }
}

class _ChoiceOption<T> {
  const _ChoiceOption({required this.value, required this.label});

  final T value;
  final String label;
}

class _ChoiceRow<T> extends StatelessWidget {
  const _ChoiceRow({
    required this.value,
    required this.options,
    required this.onChanged,
  });

  final T value;
  final List<_ChoiceOption<T>> options;
  final ValueChanged<T> onChanged;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final option in options)
          ChoiceChip(
            label: Text(option.label),
            selected: option.value == value,
            onSelected: (_) => onChanged(option.value),
            selectedColor: AppColors.cyanDeep.withAlpha(170),
            backgroundColor: AppColors.blackBg.withAlpha(120),
            labelStyle: AppTextStyles.title.copyWith(
              color: AppColors.textPrimary,
              fontSize: 14,
            ),
            side: BorderSide(color: AppColors.borderSoft),
          ),
      ],
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

class _LegalNavigationRow extends StatelessWidget {
  const _LegalNavigationRow({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Material(
        color: AppColors.blackBg.withAlpha(90),
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            child: Row(
              children: [
                Icon(icon, color: AppColors.cyanLight, size: 22),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: AppTextStyles.title.copyWith(
                      color: AppColors.textPrimary,
                      fontSize: 15,
                    ),
                  ),
                ),
                Icon(Icons.chevron_right, color: AppColors.textSecondary),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
