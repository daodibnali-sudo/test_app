import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:chelnok_boxing_timer/features/settings/logic/app_settings_state.dart';
import 'package:chelnok_boxing_timer/features/settings/models/app_language.dart';

final appSettingsProvider =
    NotifierProvider<AppSettingsNotifier, AppSettingsState>(
      AppSettingsNotifier.new,
    );

class AppSettingsNotifier extends Notifier<AppSettingsState> {
  static const _themeKey = 'selectedThemeMode';
  static const _languageKey = 'selectedLanguageCode';

  @override
  AppSettingsState build() {
    unawaited(_load());
    return AppSettingsState.initial();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final themeName = prefs.getString(_themeKey);
    final languageCode = prefs.getString(_languageKey);

    state = state.copyWith(
      themeMode: themeName == ThemeMode.light.name
          ? ThemeMode.light
          : ThemeMode.dark,
      language: AppLanguage.fromCode(languageCode),
      isLoading: false,
    );
  }

  Future<void> setThemeMode(ThemeMode themeMode) async {
    state = state.copyWith(themeMode: themeMode);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_themeKey, themeMode.name);
  }

  Future<void> setLanguage(AppLanguage language) async {
    state = state.copyWith(language: language);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_languageKey, language.code);
  }
}
