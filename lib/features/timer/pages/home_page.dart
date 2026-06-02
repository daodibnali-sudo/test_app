import 'package:flutter/material.dart';
import 'package:test_app/shared/theme/app_colors.dart';
import 'package:test_app/shared/theme/app_fonts.dart';
import 'package:test_app/widgets/weight_badge.dart';
//import 'timer_set_page.dart';

final double userWeight = 66.4;
final String userName = 'David';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.blackBg,
      appBar: AppBar(
        backgroundColor: AppColors.blackBg,
        title: Row(
          children: [
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.menu, color: AppColors.textPrimary),
            ),
            const Spacer(),
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
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Divider(
            height: 1,
            thickness: 1,
            color: AppColors.cyanDeep.withValues(alpha: 0.45),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          color: AppColors.blackBg,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(alignment: Alignment.topRight, child: weightBadge()),
              const SizedBox(height: 12),
              Text('Hey, $userName 🥊🔥', style: AppTextStyles.heading),
            ],
          ),
        ),
      ),
    );
  }
}
