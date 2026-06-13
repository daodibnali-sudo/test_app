import 'package:flutter/material.dart';
import 'package:chelnok_boxing_timer/features/timer/widgets/timer_settings_sheet.dart';
import 'package:chelnok_boxing_timer/router/open_timer.dart';
import 'package:chelnok_boxing_timer/shared/theme/app_colors.dart';
import 'package:chelnok_boxing_timer/shared/theme/app_fonts.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MyAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.blackBg,
      leading: IconButton(
        onPressed: () => _showHomeMenu(context),
        icon: Icon(Icons.menu, color: AppColors.textPrimary),
      ),
      
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(0),
        child: Divider(
          height: 0,
          thickness: 0,
          color: AppColors.textDisabled.withAlpha(200),
        ),
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
                  onTap: () {
                    Navigator.pop(sheetContext);
                    openTimerSetPage(context);
                  },
                ),
                _MenuTile(
                  icon: Icons.playlist_add,
                  title: 'Preset set',
                  onTap: () {
                    Navigator.pop(sheetContext);
                    openPresetBuilderPage(context);
                  },
                ),
                _MenuTile(
                  icon: Icons.settings,
                  title: 'Settings',
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

class _MenuTile extends StatelessWidget {
  const _MenuTile({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: AppColors.cyanLight),
      title: Text(
        title,
        style: AppTextStyles.title.copyWith(color: AppColors.textPrimary),
      ),
      onTap: onTap,
    );
  }
}
