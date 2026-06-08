import 'package:flutter/material.dart';
import 'package:test_app/shared/theme/app_colors.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MyAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.blackBg,
      leading: IconButton(
        onPressed: () {},
        icon: Icon(Icons.menu, color: AppColors.textPrimary),
      ),
      actions: [
        IconButton(
          onPressed: () {},
          icon: Icon(
            Icons.notifications_outlined,
            color: AppColors.textPrimary,
          ),
        ),
        IconButton(
          onPressed: () {},
          icon: Icon(
            Icons.account_circle_outlined,
            color: AppColors.textPrimary,
          ),
        ),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Divider(
          height: 2,
          thickness: 2,
          color: AppColors.cyanLight.withAlpha(200),
        ),
      ),
    );
  }
}
