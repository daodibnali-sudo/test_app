import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:test_app/features/legal/data/legal_documents.dart';
import 'package:test_app/features/legal/pages/legal_document_page.dart';
import 'package:test_app/features/timer/providers/timer_provider.dart';
import 'package:test_app/shared/theme/app_colors.dart';
import 'package:test_app/shared/theme/app_fonts.dart';
import 'package:test_app/widgets/switch.dart';

Future<void> showTimerSettingsSheet(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    backgroundColor: AppColors.blackSurface,
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
    final notifier = ref.read(timerProvider.notifier);

    return SafeArea(
      child: SingleChildScrollView(
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
            const SizedBox(height: 14),
            Divider(
              height: 1,
              thickness: 1,
              color: AppColors.cyanDeep.withAlpha(120),
            ),
            const SizedBox(height: 16),
            Text(
              'LEGAL',
              style: AppTextStyles.title.copyWith(
                color: AppColors.textSecondary,
                letterSpacing: 0.8,
              ),
            ),
            const SizedBox(height: 8),
            _LegalNavigationRow(
              icon: Icons.privacy_tip_outlined,
              title: 'Privacy Policy',
              onTap: () => _openDocument(
                context,
                LegalDocumentPage(
                  title: 'Privacy Policy',
                  subtitle: 'Effective date: June 12, 2026',
                  sections: privacyPolicySections,
                  externalUrl: privacyPolicyUrl,
                ),
              ),
            ),
            _LegalNavigationRow(
              icon: Icons.description_outlined,
              title: 'Terms of Use',
              onTap: () => _openDocument(
                context,
                LegalDocumentPage(
                  title: 'Terms of Use',
                  subtitle: 'Effective date: June 12, 2026',
                  sections: termsOfUseSections,
                  externalUrl: termsOfUseUrl,
                ),
              ),
            ),
            _LegalNavigationRow(
              icon: Icons.info_outline,
              title: 'About Chelnok',
              onTap: () => _openDocument(
                context,
                const LegalDocumentPage(
                  title: 'About Chelnok',
                  subtitle: 'Built for the rounds that matter.',
                  sections: aboutChelnokSections,
                  showContactButton: true,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openDocument(BuildContext sheetContext, Widget page) {
    Navigator.pop(sheetContext);
    Navigator.of(rootContext).push(
      PageRouteBuilder<void>(
        transitionDuration: const Duration(milliseconds: 260),
        reverseTransitionDuration: const Duration(milliseconds: 200),
        pageBuilder: (_, animation, secondaryAnimation) => page,
        transitionsBuilder: (_, animation, secondaryAnimation, child) {
          final curvedAnimation = CurvedAnimation(
            parent: animation,
            curve: Curves.easeOutCubic,
            reverseCurve: Curves.easeInCubic,
          );

          return FadeTransition(
            opacity: curvedAnimation,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0.08, 0),
                end: Offset.zero,
              ).animate(curvedAnimation),
              child: child,
            ),
          );
        },
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
                const Icon(Icons.chevron_right, color: AppColors.textSecondary),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
