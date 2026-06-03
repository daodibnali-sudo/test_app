import 'package:flutter/material.dart';
import 'package:test_app/shared/theme/app_colors.dart';

class TimerAppBar extends StatelessWidget implements PreferredSizeWidget {
  const TimerAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.blackBg,
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: const Icon(
          Icons.arrow_back_ios_new_outlined,
          color: AppColors.textPrimary,
        ),
      ),
      actions: [
        IconButton(
          onPressed: () {},
          icon: Icon(Icons.settings, color: AppColors.textPrimary),
        ),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Divider(
          height: 1,
          thickness: 1,
          color: AppColors.cyanDeep.withValues(alpha: 0.45),
        ),
      ),
    );
  }
}
