import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

abstract final class AppColors {
  static const black = Color(0xFF090B0F);
  static const surface = Color(0xFF12161D);
  static const card = Color(0xFF1A1F27);

  static const text = Color(0xFFF5F7FA);
  static const textSub = Color(0xFF8E96A3);
  static const textDisabled = Color(0xFF5B6573);

  static const primary = Color(0xFF00D9FF);
  static const primaryDark = Color(0xFF0097B8);

  static const success = Color(0xFF22C55E);
  static const warning = Color(0xFFFACC15);
  static const error = Color(0xFFFF5C5C);
  static const accent = Color(0xFF6E4CFF);
}

abstract final class AppFonts {
  static const inter = 'Inter';
  static const alata = 'Alata';
}

abstract final class AppTextStyles {
  static const timer = TextStyle(
    fontFamily: AppFonts.alata,
    fontSize: 72,
    fontWeight: FontWeight.w400,
    letterSpacing: -2,
    color: AppColors.primary,
  );

  static const heading = TextStyle(
    fontFamily: AppFonts.alata,
    fontSize: 30,
    fontWeight: FontWeight.w400,
    color: AppColors.text,
  );

  static const title = TextStyle(
    fontFamily: AppFonts.inter,
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppColors.text,
  );

  static const body = TextStyle(
    fontFamily: AppFonts.inter,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.textSub,
  );

  static const label = TextStyle(
    fontFamily: AppFonts.inter,
    fontSize: 13,
    fontWeight: FontWeight.w500,
    color: AppColors.textSub,
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: AppColors.black,
        fontFamily: AppFonts.inter,
      ),
      home: const DesignTestPage(),
    );
  }
}

class DesignTestPage extends StatelessWidget {
  const DesignTestPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: const [
            Text('CHELNOCK', style: AppTextStyles.heading),
            SizedBox(height: 4),
            Text('Color + font test screen', style: AppTextStyles.body),

            SizedBox(height: 28),

            TimerPreview(),

            SizedBox(height: 28),

            SectionTitle('Colors'),
            SizedBox(height: 12),
            ColorGrid(),

            SizedBox(height: 28),

            SectionTitle('Typography'),
            SizedBox(height: 12),
            TypographyCard(),

            SizedBox(height: 28),

            SectionTitle('Buttons'),
            SizedBox(height: 12),
            ButtonPreview(),

            SizedBox(height: 28),

            SectionTitle('Cards'),
            SizedBox(height: 12),
            CardPreview(),
          ],
        ),
      ),
    );
  }
}

class TimerPreview extends StatelessWidget {
  const TimerPreview({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: AppColors.card),
      ),
      child: Column(
        children: [
          const Text('ROUND 3', style: AppTextStyles.label),
          const SizedBox(height: 10),
          const Text('02:45', style: AppTextStyles.timer),
          const Text('WORK', style: AppTextStyles.title),
          const SizedBox(height: 24),
          SizedBox(
            height: 120,
            width: 120,
            child: Stack(
              alignment: Alignment.center,
              children: const [
                CircularProgressIndicator(
                  value: 0.62,
                  strokeWidth: 10,
                  backgroundColor: AppColors.card,
                  valueColor: AlwaysStoppedAnimation(AppColors.primary),
                  strokeCap: StrokeCap.round,
                ),
                Text('62%', style: AppTextStyles.title),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ColorGrid extends StatelessWidget {
  const ColorGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: const [
        ColorBox('Black', AppColors.black),
        ColorBox('Surface', AppColors.surface),
        ColorBox('Card', AppColors.card),
        ColorBox('Text', AppColors.text),
        ColorBox('Text Sub', AppColors.textSub),
        ColorBox('Disabled', AppColors.textDisabled),
        ColorBox('Primary', AppColors.primary),
        ColorBox('Primary Dark', AppColors.primaryDark),
        ColorBox('Success', AppColors.success),
        ColorBox('Warning', AppColors.warning),
        ColorBox('Error', AppColors.error),
        ColorBox('Accent', AppColors.accent),
      ],
    );
  }
}

class ColorBox extends StatelessWidget {
  final String name;
  final Color color;

  const ColorBox(this.name, this.color, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 105,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.card),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 58,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.card),
            ),
          ),
          const SizedBox(height: 8),
          Text(name, style: AppTextStyles.label),
        ],
      ),
    );
  }
}

class TypographyCard extends StatelessWidget {
  const TypographyCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(22),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Alata Heading', style: AppTextStyles.heading),
          SizedBox(height: 8),
          Text('Inter Title 20 SemiBold', style: AppTextStyles.title),
          SizedBox(height: 8),
          Text(
            'Inter body text. Use this for normal UI descriptions and settings.',
            style: AppTextStyles.body,
          ),
          SizedBox(height: 8),
          Text('Inter label 13 Medium', style: AppTextStyles.label),
        ],
      ),
    );
  }
}

class ButtonPreview extends StatelessWidget {
  const ButtonPreview({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FilledButton(
          style: FilledButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.black,
            minimumSize: const Size(double.infinity, 54),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          onPressed: () {},
          child: const Text('START WORKOUT'),
        ),
        const SizedBox(height: 12),
        OutlinedButton(
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.primary,
            side: const BorderSide(color: AppColors.primary),
            minimumSize: const Size(double.infinity, 54),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          onPressed: () {},
          child: const Text('EDIT SESSION'),
        ),
      ],
    );
  }
}

class CardPreview extends StatelessWidget {
  const CardPreview({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        WorkoutCard(
          title: 'Boxing HIIT',
          subtitle: '6 rounds · 02:45 work',
          color: AppColors.primary,
        ),
        SizedBox(height: 12),
        WorkoutCard(
          title: 'Shadow Boxing',
          subtitle: '8 rounds · 01:00 rest',
          color: AppColors.accent,
        ),
        SizedBox(height: 12),
        WorkoutCard(
          title: 'Delete / Error State',
          subtitle: 'Danger color test',
          color: AppColors.error,
        ),
      ],
    );
  }
}

class WorkoutCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final Color color;

  const WorkoutCard({
    required this.title,
    required this.subtitle,
    required this.color,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.card),
      ),
      child: Row(
        children: [
          Icon(Icons.flash_on, color: color, size: 30),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTextStyles.title),
                const SizedBox(height: 4),
                Text(subtitle, style: AppTextStyles.body),
              ],
            ),
          ),
          Icon(Icons.chevron_right, color: color),
        ],
      ),
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String text;

  const SectionTitle(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(text, style: AppTextStyles.title);
  }
}