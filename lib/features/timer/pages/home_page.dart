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
              Text('Hey, $userName 🥊🔥', style: AppTextStyles.heading),
              Text(
                'Ready to push your limits today?',
                style: AppTextStyles.label,
              ),
              const SizedBox(height: 20),
              Text('Quick Settings workouts:', style: AppTextStyles.title),
              const SizedBox(height: 12),
              SizedBox(
                height: 110,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    _quickWorkoutCard(
                      icon: Icons.sports_martial_arts_outlined,
                      title: 'Boxing',
                      subtitle: '3 x 3 min',
                    ),
                    _quickWorkoutCard(
                      icon: Icons.fitness_center,
                      title: 'Strength',
                      subtitle: '5 rounds',
                    ),
                    _quickWorkoutCard(
                      icon: Icons.flash_on,
                      title: 'HIIT',
                      subtitle: '12 min',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              _setNewTimerButton(),
            ], //children
          ),
        ),
      ),
    );
  }

  Widget _quickWorkoutCard({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Container(
      width: 145,
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.blackSurface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.cyanDeep.withValues(alpha: 0.35)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(icon, color: AppColors.cyanLight, size: 26),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: AppTextStyles.title),
              const SizedBox(height: 4),
              Text(subtitle, style: AppTextStyles.label),
            ],
          ),
        ],
      ),
    );
  }

  Widget _setNewTimerButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton.icon(
        onPressed: () {},
        icon: const Icon(Icons.add),
        label: const Text('Set new timer', style: AppTextStyles.title,),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.blackSurface,
          foregroundColor: AppColors.cyanLight,
          side: BorderSide(color: AppColors.cyanDeep, width: 1.2),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          textStyle: AppTextStyles.heading,
        ),
      ),
    );
  }
}
