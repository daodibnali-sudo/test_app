import 'package:flutter/material.dart';
import 'package:test_app/widgets/button.dart';
import 'package:test_app/shared/theme/app_colors.dart';
import 'package:test_app/shared/theme/app_fonts.dart';
import 'package:test_app/widgets/app_bar.dart';
import 'package:test_app/widgets/home_scroll_cards.dart';
import 'package:test_app/widgets/weight_badge.dart';
import 'timer_set_page.dart';

final double userWeight = 66.4;
final String userName = 'David';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    void openTimerSetPage() {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const TimerSetPage()),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.blackBg,
      appBar: MyAppBar(),
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
              Row(
                children: [
                  Icon(
                    Icons.flash_on,
                    color: AppColors.cyanLight.withAlpha(200),
                  ),
                  Text(
                    'Quick Settings workouts:',
                    style: AppTextStyles.title.copyWith(
                      color: AppColors.cyanLight.withAlpha(200),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 110,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    WorkoutCard(
                      backgroundColor: AppColors.blackSurface,
                      icon: Icons.sports_martial_arts_outlined,
                      title: 'Boxing',
                      subtitle: '3 x 3 min',
                    ),
                    WorkoutCard(
                      backgroundColor: AppColors.blackSurface,
                      icon: Icons.fitness_center,
                      titleStyle: TextStyle(color: AppColors.cyanLight),
                      title: 'Strength',
                      subtitle: '5 rounds',
                    ),
                    WorkoutCard(
                      backgroundColor: AppColors.blackSurface,
                      icon: Icons.flash_on,
                      title: 'HIIT',
                      subtitle: '12 min',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              AppButton(
                iconColor: AppColors.cyanDeep,
                height: 100,
                radius: 16,
                borderWidth: 2,
                backgroundColor: AppColors.blackSurface,
                borderColor: AppColors.cyanDeep.withAlpha(200),
                filled: false,
                text: 'Set new timer',

                textColor: AppColors.cyanLight.withAlpha(200),
                leading: Icon(Icons.add),
                onPressed: () {
                  openTimerSetPage();
                },
              ),
            ], //children
          ),
        ),
      ),
    );
  }
}
