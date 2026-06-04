import 'package:flutter/material.dart';
import 'package:test_app/widgets/button.dart';
import 'package:test_app/shared/theme/app_colors.dart';
import 'package:test_app/shared/theme/app_fonts.dart';
import 'package:test_app/widgets/app_bar.dart';
import 'package:test_app/widgets/weight_badge.dart';
import 'timer_set_page.dart';
import 'package:test_app/widgets/scroll_cards.dart';

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
              Text('Quick Settings workouts:', style: AppTextStyles.title),
              const SizedBox(height: 12),
              SizedBox(
                height: 110,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    scrollCard(
                      icon: Icons.sports_martial_arts_outlined,
                      title: 'Boxing',
                      subtitle: '3 x 3 min',
                    ),
                    scrollCard(
                      icon: Icons.fitness_center,
                      title: 'Strength',
                      subtitle: '5 rounds',
                    ),
                    scrollCard(
                      icon: Icons.flash_on,
                      title: 'HIIT',
                      subtitle: '12 min',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              AppButton(text: ('Set new timer'), onPressed: openTimerSetPage, filled: false,)
            ], //children
          ),
        ),
      ),
    );
  }
}
