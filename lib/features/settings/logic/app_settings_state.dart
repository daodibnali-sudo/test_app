import 'package:flutter/material.dart';
import 'package:chelnok_boxing_timer/features/settings/models/app_language.dart';

class AppSettingsState {
  const AppSettingsState({
    required this.themeMode,
    required this.language,
    required this.isLoading,
  });

  factory AppSettingsState.initial() {
    return const AppSettingsState(
      themeMode: ThemeMode.dark,
      language: AppLanguage.english,
      isLoading: true,
    );
  }

  final ThemeMode themeMode;
  final AppLanguage language;
  final bool isLoading;

  AppSettingsState copyWith({
    ThemeMode? themeMode,
    AppLanguage? language,
    bool? isLoading,
  }) {
    return AppSettingsState(
      themeMode: themeMode ?? this.themeMode,
      language: language ?? this.language,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
