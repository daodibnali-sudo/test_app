enum AppLanguage {
  english('en', 'English', 'en-US'),
  russian('ru', 'Русский', 'ru-RU'),
  czech('cs', 'Čeština', 'cs-CZ');

  const AppLanguage(this.code, this.label, this.ttsLanguageCode);

  final String code;
  final String label;
  final String ttsLanguageCode;

  static AppLanguage fromCode(String? code) {
    return AppLanguage.values.firstWhere(
      (language) => language.code == code,
      orElse: () => AppLanguage.english,
    );
  }
}
