import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chelnok_boxing_timer/core/ads/interstitial_ad_service.dart';
import 'package:chelnok_boxing_timer/core/ads/rewarded_ad_service.dart';
import 'package:chelnok_boxing_timer/features/settings/providers/app_settings_provider.dart';
import 'package:chelnok_boxing_timer/features/timer/pages/home_page.dart';
import 'package:chelnok_boxing_timer/features/timer/providers/timer_provider.dart';
import 'package:chelnok_boxing_timer/shared/theme/app_colors.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  unawaited(InterstitialAdService.instance.initialize());
  unawaited(RewardedAdService.instance.initialize());
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: AppColors.blackBg,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: AppColors.blackBg,
      systemNavigationBarDividerColor: AppColors.textPrimary,
      systemNavigationBarIconBrightness: Brightness.light,
      systemNavigationBarContrastEnforced: false,
    ),
  );

  runApp(const ProviderScope(child: MainApp()));
}

class MainApp extends ConsumerStatefulWidget {
  const MainApp({super.key});

  @override
  ConsumerState<MainApp> createState() => _MainAppState();
}

class _MainAppState extends ConsumerState<MainApp> {
  @override
  void dispose() {
    InterstitialAdService.instance.dispose();
    RewardedAdService.instance.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(appSettingsProvider);
    AppColors.setThemeMode(settings.themeMode);

    ref.listen(appSettingsProvider.select((settings) => settings.language), (
      _,
      language,
    ) {
      ref.read(timerProvider.notifier).setLanguage(language);
    });

    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: AppColors.blackBg,
        statusBarIconBrightness: settings.themeMode == ThemeMode.light
            ? Brightness.dark
            : Brightness.light,
        systemNavigationBarColor: AppColors.blackBg,
        systemNavigationBarDividerColor: AppColors.textPrimary,
        systemNavigationBarIconBrightness: settings.themeMode == ThemeMode.light
            ? Brightness.dark
            : Brightness.light,
        systemNavigationBarContrastEnforced: false,
      ),
    );

    return MaterialApp(
      themeMode: settings.themeMode,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        scaffoldBackgroundColor: AppColors.blackBg,
        navigationBarTheme: NavigationBarThemeData(
          backgroundColor: AppColors.blackBg,
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: AppColors.blackBg,
        navigationBarTheme: NavigationBarThemeData(
          backgroundColor: AppColors.blackBg,
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: const AppBootstrapGate(),
    );
  }
}

class AppBootstrapGate extends ConsumerWidget {
  const AppBootstrapGate({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(
      appSettingsProvider.select((settings) => settings.themeMode),
    );
    AppColors.setThemeMode(themeMode);

    final isLoading = ref.watch(
      timerProvider.select((timer) => timer.isLoadingPresets),
    );

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 280),
      switchInCurve: Curves.easeOutCubic,
      switchOutCurve: Curves.easeInCubic,
      child: isLoading ? const _StartupView() : const HomePage(),
    );
  }
}

class _StartupView extends StatelessWidget {
  const _StartupView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.blackBg,
      body: Center(
        child: TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.92, end: 1),
          duration: const Duration(milliseconds: 550),
          curve: Curves.easeOutCubic,
          builder: (context, scale, child) {
            return Transform.scale(scale: scale, child: child);
          },
          child: Image.asset(
            'assets/images/logoPNGthousand.png',
            width: 180,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
