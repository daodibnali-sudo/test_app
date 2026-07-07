import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chelnok_boxing_timer/core/monetization/subscription_provider.dart';
import 'package:chelnok_boxing_timer/features/timer/widgets/timer_settings_sheet.dart';
import 'package:chelnok_boxing_timer/router/open_timer.dart';
import 'package:chelnok_boxing_timer/shared/theme/app_colors.dart';
import 'package:chelnok_boxing_timer/shared/theme/app_fonts.dart';

class MyAppBar extends ConsumerWidget implements PreferredSizeWidget {
  const MyAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isPro = ref.watch(
      subscriptionProvider.select((subscription) => subscription.isPro),
    );

    return AppBar(
      backgroundColor: AppColors.blackBg,
      leadingWidth: isPro ? 96 : null,
      leading: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            onPressed: () => _showHomeMenu(context),
            icon: Icon(Icons.menu, color: AppColors.textPrimary),
          ),
          if (isPro) const _ProBadge(),
        ],
      ),

      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(0),
        child: Divider(height: 0, thickness: 0, color: AppColors.borderSoft),
      ),
    );
  }

  void _showHomeMenu(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.blackSurface,
      showDragHandle: true,
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(8, 0, 8, 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _MenuTile(
                  icon: Icons.add,
                  title: 'Set a new timer',
                  iconColor: AppColors.textPrimary,
                  textColor: AppColors.textPrimary,
                  backgroundColor: Colors.transparent,
                  onTap: () {
                    Navigator.pop(sheetContext);
                    openTimerSetPage(context);
                  },
                ),
                _MenuTile(
                  icon: Icons.playlist_add,
                  title: 'Preset set',
                  iconColor: AppColors.textPrimary,
                  textColor: AppColors.textPrimary,
                  backgroundColor: Colors.transparent,
                  onTap: () {
                    Navigator.pop(sheetContext);
                    openPresetBuilderPage(context);
                  },
                ),
                _MenuTile(
                  icon: Icons.settings,
                  title: 'Settings',
                  iconColor: AppColors.textPrimary,
                  textColor: AppColors.textPrimary,

                  onTap: () {
                    Navigator.pop(sheetContext);
                    showTimerSettingsSheet(context);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _ProBadge extends StatelessWidget {
  const _ProBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 19,
      padding: const EdgeInsets.symmetric(horizontal: 6),
      decoration: BoxDecoration(
        color: AppColors.cyanLight,
        borderRadius: BorderRadius.circular(4),
      ),
      alignment: Alignment.center,
      child: Text(
        'PRO',
        style: AppTextStyles.label.copyWith(
          color: AppColors.blackBg,
          fontSize: 9,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

class _MenuTile extends StatelessWidget {
  const _MenuTile({
    required this.icon,
    required this.title,
    required this.onTap,
    this.iconColor,
    this.textColor,
    this.backgroundColor,
  });

  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final Color? iconColor;
  final Color? textColor;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      tileColor: backgroundColor,
      leading: Icon(icon, color: iconColor ?? AppColors.cyanLight),
      title: Text(
        title,
        style: AppTextStyles.title.copyWith(
          color: textColor ?? AppColors.textPrimary,
        ),
      ),
      onTap: onTap,
    );
  }
}
