import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chelnok_boxing_timer/features/settings/models/app_language.dart';
import 'package:chelnok_boxing_timer/features/settings/providers/app_settings_provider.dart';
import 'package:chelnok_boxing_timer/features/timer/logic/timer_state.dart';

final appStringsProvider = Provider<AppStrings>((ref) {
  final language = ref.watch(
    appSettingsProvider.select((settings) => settings.language),
  );
  return AppStrings(language);
});

class AppStrings {
  const AppStrings(this.language);

  final AppLanguage language;

  static const _values = {
    'en': {
      'greetings': 'Hey, Boxer🥊🔥',
      'settings': 'Settings',
      'theme': 'Theme',
      'dark': 'Dark',
      'light': 'Light',
      'language': 'Language',
      'allowSound': 'Allow sound',
      'allowVibrations': 'Allow vibrations',
      'legal': 'LEGAL',
      "ready": "\"Champions aren't made in gyms. Champions are made from something they have deep inside them.\"",
      'quickWorkouts': 'Quick Settings workouts:',
      'customPresets': 'Custom presets',
      'setNew': 'Set a new',
      'workoutTimer': 'Workout timer',
      'createWorkout': 'Create Workout',
      'seeAll': 'SEE ALL',
      'preparation': 'Preparation',
      'work': 'Work',
      'rest': 'Rest',
      'rounds': 'Rounds',
      'totalWorkoutTime': 'Total Workout Time',
      'announcements': 'Announcements:',
      'tenSecondsLeft': '10s left',
      'thirtySecondsLeft': '30s left',
      'minuteLeft': 'minute left',
      'keepScreenAwake': 'Keep Screen Awake',
      'start': 'START',
      'pause': 'PAUSE',
      'resume': 'RESUME',
      'skip': 'SKIP',
      'reset': 'RESET',
      'done': 'DONE',
      'save': 'SAVE',
      'update': 'UPDATE',
      'saved': 'saved',
      'updated': 'updated',
      'workoutComplete': 'WORKOUT COMPLETE',
      'totalWork': 'TOTAL WORK',
      'totalTime': 'TOTAL TIME',
      'block': 'Block',
      'round': 'Round',
      'getReadyTts': 'Get ready',
      'minuteLeftTts': 'Minute left',
      'thirtySecondsLeftTts': 'Thirty seconds left',
      'goodWorkTts': 'Good work',
    },
    'ru': {
      'greetings': 'Здорово, Боксёр 🥊🔥',
      'settings': 'Настройки',
      'theme': 'Тема',
      'dark': 'Темная',
      'light': 'Светлая',
      'language': 'Язык',
      'allowSound': 'Звук',
      'allowVibrations': 'Вибрация',
      'legal': 'ДОКУМЕНТЫ',
      'ready':
          '«Дисциплина — это делать то, что не хочется, так, будто тебе это нравится.»',
      'quickWorkouts': 'Быстрые тренировки:',
      'customPresets': 'Свои пресеты',
      'setNew': '',
      'workoutTimer': 'Новая тренировка',
      'createWorkout': 'Создать тренировку',
      'seeAll': 'ВСЕ',
      'preparation': 'Подготовка',
      'work': 'Работа',
      'rest': 'Отдых',
      'rounds': 'Раунды',
      'totalWorkoutTime': 'Общее время',
      'announcements': 'Оповещения:',
      'tenSecondsLeft': ' осталось 10 сек',
      'thirtySecondsLeft': ' осталось 30 сек',
      'minuteLeft': ' осталось минута',
      'keepScreenAwake': 'Не гасить экран',
      'start': 'СТАРТ',
      'pause': 'ПАУЗА',
      'resume': 'ДАЛЕЕ',
      'skip': 'ДАЛЕЕ',
      'reset': 'СБРОС',
      'done': 'ГОТОВО',
      'save': 'СОХРАНИТЬ',
      'update': 'ОБНОВИТЬ',
      'saved': 'сохранен',
      'updated': 'обновлен',
      'workoutComplete': 'ТРЕНИРОВКА ЗАВЕРШЕНА',
      'totalWork': 'РАБОТА',
      'totalTime': 'ВСЕГО',
      'block': 'Блок',
      'round': 'Раунд',
      'getReadyTts': 'Приготовься',
      'minuteLeftTts': 'Осталась минута',
      'thirtySecondsLeftTts': 'Осталось тридцать секунд',
      'goodWorkTts': 'Хорошая работа',
    },
    'cs': {
      'greetings': 'Čau, Boxere 🥊🔥',
      'settings': 'Nastavení',
      'theme': 'Motiv',
      'dark': 'Tmavý',
      'light': 'Světlý',
      'language': 'Jazyk',
      'allowSound': 'Zvuk',
      'allowVibrations': 'Vibrace',
      'legal': 'PRÁVNÍ INFORMACE',
      'ready':
          '„Disciplína znamená dělat to, co nemáš rád, jako bys to miloval.“',
      'quickWorkouts': 'Rychlé tréninky:',
      'customPresets': 'Vlastní presety',
      'setNew': 'Nastavit nový',
      'workoutTimer': 'Nový trénink',
      'createWorkout': 'Vytvořit preset',
      'seeAll': 'VŠE',
      'preparation': 'Příprava',
      'work': 'Práce',
      'rest': 'Pauza',
      'rounds': 'Kola',
      'totalWorkoutTime': 'Celkový čas',
      'announcements': 'Oznámení:',
      'tenSecondsLeft': '10 s zbývá',
      'thirtySecondsLeft': '30 s zbývá',
      'minuteLeft': 'Minuta zbývá',
      'keepScreenAwake': 'Neuspávat obrazovku',
      'start': 'START',
      'pause': 'PAUZA',
      'resume': 'POKRAČOVAT',
      'skip': 'DALŠÍ',
      'reset': 'RESET',
      'done': 'HOTOVO',
      'save': 'ULOŽIT',
      'update': 'UPRAVIT',
      'saved': 'uloženo',
      'updated': 'upraveno',
      'workoutComplete': 'TRÉNINK DOKONČEN',
      'totalWork': 'PRÁCE',
      'totalTime': 'CELKEM',
      'block': 'Blok',
      'round': 'Kolo',
      'getReadyTts': 'Připrav se',
      'minuteLeftTts': 'Zbývá minuta',
      'thirtySecondsLeftTts': 'Zbývá třicet sekund',
      'goodWorkTts': 'Dobrá práce',
    },
  };

  static const _presetValues = {
    'en': {
      'quickSettingsWorkouts': 'Quick Settings Workouts',
      'customPresetsTitle': 'Custom Presets',
      'noCustomPresetsYet': 'NO CUSTOM PRESETS YET',
      'createFirstPreset':
          'Create your first preset to build your own workout.',
      'createPreset': 'CREATE PRESET',
      'edit': 'EDIT',
      'editAsCopy': 'EDIT AS COPY',
      'remove': 'REMOVE',
      'cancel': 'CANCEL',
      'removePresetQuestion': 'Remove preset?',
      'actionCannotBeUndone': 'This action cannot be undone.',
    },
    'ru': {
      'quickSettingsWorkouts': 'Быстрые тренировки',
      'customPresetsTitle': 'Свои пресеты',
      'noCustomPresetsYet': 'СВОИХ ПРЕСЕТОВ ПОКА НЕТ',
      'createFirstPreset': 'Создай первый пресет для своей тренировки.',
      'createPreset': 'СОЗДАТЬ ПРЕСЕТ',
      'edit': 'ИЗМЕНИТЬ',
      'editAsCopy': 'КОПИРОВАТЬ И ИЗМЕНИТЬ',
      'remove': 'УДАЛИТЬ',
      'cancel': 'ОТМЕНА',
      'removePresetQuestion': 'Удалить пресет?',
      'actionCannotBeUndone': 'Это действие нельзя отменить.',
    },
    'cs': {
      'quickSettingsWorkouts': 'Rychlé tréninky',
      'customPresetsTitle': 'Vlastní presety',
      'noCustomPresetsYet': 'ZATÍM ŽÁDNÉ VLASTNÍ PRESETY',
      'createFirstPreset': 'Vytvoř první preset pro vlastní trénink.',
      'createPreset': 'VYTVOŘIT PRESET',
      'edit': 'UPRAVIT',
      'editAsCopy': 'UPRAVIT JAKO KOPII',
      'remove': 'ODSTRANIT',
      'cancel': 'ZRUŠIT',
      'removePresetQuestion': 'Odstranit preset?',
      'actionCannotBeUndone': 'Tuto akci nelze vrátit zpět.',
    },
  };

  String text(String key) {
    return _presetValues[language.code]?[key] ??
        _presetValues['en']?[key] ??
        _values[language.code]?[key] ??
        _values['en']![key] ??
        key;
  }

  String phaseName(TimerState timer) {
    if (timer.isFinished) return text('workoutComplete');
    if (timer.isPreparation) return text('preparation');
    if (timer.isCustomWorkout) {
      final blockName = timer.currentBlock?.name.trim();
      return blockName == null || blockName.isEmpty ? text('work') : blockName;
    }
    return timer.isWork ? text('work') : text('rest');
  }
}
