import 'package:flutter/material.dart';
import 'package:chelnok_boxing_timer/shared/theme/app_colors.dart';
import 'package:chelnok_boxing_timer/shared/theme/app_fonts.dart';
import 'package:chelnok_boxing_timer/widgets/scroll_cards.dart';

class WorkoutCard extends StatelessWidget {
  const WorkoutCard({
    super.key,
    required this.backgroundColor,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.titleStyle,
    this.subtitleStyle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  final Color? backgroundColor;
  final TextStyle? titleStyle;
  final TextStyle? subtitleStyle;

  @override
  Widget build(BuildContext context) {
    return ScrollCard(
      icon: icon,
      title: title,
      subtitle: subtitle,
      titleStyle: AppTextStyles.body.copyWith(
        color: AppColors.cyanLight,
        fontFamily: 'Alata',
      ),
      subtitleStyle: AppTextStyles.label,
      backgroundColor: backgroundColor,
      borderColor: AppColors.cyanDeep.withAlpha(200),
      iconColor: AppColors.cyanLight,
      radius: 8,
    );
  }
}
