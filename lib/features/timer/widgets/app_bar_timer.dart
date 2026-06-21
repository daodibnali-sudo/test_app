import 'package:flutter/material.dart';
import 'package:chelnok_boxing_timer/shared/theme/app_colors.dart';
import 'package:chelnok_boxing_timer/shared/theme/app_fonts.dart';
import 'package:chelnok_boxing_timer/features/timer/widgets/timer_settings_sheet.dart';

class TimerAppBar extends StatelessWidget implements PreferredSizeWidget {
  const TimerAppBar({super.key, this.title = '', this.onBack});

  final String title;
  final VoidCallback? onBack;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.blackBg,
      leading: IconButton(
        onPressed: onBack ?? () => Navigator.pop(context),
        icon: Icon(
          Icons.arrow_back_ios_new_outlined,
          color: AppColors.textPrimary,
        ),
      ),
      title: title.isEmpty
          ? null
          : Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.heading.copyWith(fontSize: 24),
            ),
      actions: [
        IconButton(
          onPressed: () => showTimerSettingsSheet(context),
          icon: Icon(Icons.settings, color: AppColors.textPrimary),
        ),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Divider(
          height: 1,
          thickness: 1,
          color: AppColors.textPrimary.withAlpha(200),
        ),
      ),
    );
  }
}
