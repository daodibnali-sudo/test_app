import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_app/features/timer/models/timer_custom_preset.dart';
import 'package:test_app/features/timer/models/timer_quick_preset.dart';

class TimerPresetStorage {
  const TimerPresetStorage();

  static const _timerPresetsKey = 'timer_presets';
  static const _customPresetsKey = 'custom_timer_presets';

  Future<List<TimerPreset>> loadTimerPresets() async {
    final prefs = await _getPrefs();
    if (prefs == null) return const [];

    final rawPresets = prefs.getStringList(_timerPresetsKey) ?? const [];

    return rawPresets
        .map(jsonDecode)
        .whereType<Map<String, dynamic>>()
        .map(TimerPreset.fromJson)
        .toList();
  }

  Future<List<TimerCustomPreset>> loadCustomPresets() async {
    final prefs = await _getPrefs();
    if (prefs == null) return const [];

    final rawPresets = prefs.getStringList(_customPresetsKey) ?? const [];

    return rawPresets
        .map(jsonDecode)
        .whereType<Map<String, dynamic>>()
        .map(TimerCustomPreset.fromJson)
        .toList();
  }

  Future<void> saveTimerPresets(List<TimerPreset> presets) async {
    final prefs = await _getPrefs();
    if (prefs == null) return;

    final rawPresets = presets
        .map((preset) => jsonEncode(preset.toJson()))
        .toList();

    await prefs.setStringList(_timerPresetsKey, rawPresets);
  }

  Future<void> saveCustomPresets(List<TimerCustomPreset> presets) async {
    final prefs = await _getPrefs();
    if (prefs == null) return;

    final rawPresets = presets
        .map((preset) => jsonEncode(preset.toJson()))
        .toList();

    await prefs.setStringList(_customPresetsKey, rawPresets);
  }

  Future<SharedPreferences?> _getPrefs() async {
    try {
      return await SharedPreferences.getInstance();
    } catch (_) {
      return null;
    }
  }
}
