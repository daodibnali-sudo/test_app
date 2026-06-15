import 'dart:async';

import 'package:chelnok_vibrate/chelnok_vibrate.dart';
import 'package:flutter/services.dart';

class TimerHapticService {
  static const List<int> _victoryPattern = [0, 120, 120, 120, 160, 600];

  int _generation = 0;
  bool _isDisposed = false;

  Future<void> playWorkoutCompleteHaptics() async {
    final generation = ++_generation;

    if (_isDisposed) return;

    final canUseCustomPattern = await _canUseCustomPattern();
    if (!_isCurrent(generation)) return;

    if (canUseCustomPattern) {
      await _playNativePattern(generation);
    } else {
      await _fallbackPattern(generation);
    }
  }

  Future<void> stopAllHaptics() async {
    ++_generation;

    try {
      await ChelnokVibrate.cancel();
    } on PlatformException {
      // The fallback Flutter haptics cannot be cancelled mid-impact.
    } on MissingPluginException {
      // A hot restart/full rebuild may be needed after adding the plugin.
    }
  }

  Future<void> dispose() async {
    _isDisposed = true;
    await stopAllHaptics();
  }

  bool _isCurrent(int generation) {
    return !_isDisposed && generation == _generation;
  }

  Future<bool> _canUseCustomPattern() async {
    try {
      return await ChelnokVibrate.hasVibrator();
    } on PlatformException {
      return false;
    } on MissingPluginException {
      return false;
    }
  }

  Future<void> _pause(int generation, int durationMs) async {
    if (!_isCurrent(generation)) return;

    await Future<void>.delayed(Duration(milliseconds: durationMs));
  }

  Future<void> _playNativePattern(int generation) async {
    if (!_isCurrent(generation)) return;

    try {
      await ChelnokVibrate.vibratePattern(
        _victoryPattern.map((ms) => Duration(milliseconds: ms)).toList(),
      );
      await _pause(
        generation,
        _victoryPattern.fold<int>(0, (total, ms) => total + ms),
      );
    } on PlatformException {
      await _fallbackPattern(generation);
    } on MissingPluginException {
      await _fallbackPattern(generation);
    }
  }

  Future<void> _fallbackPattern(int generation) async {
    if (!_isCurrent(generation)) return;

    await HapticFeedback.mediumImpact();
    await _pause(generation, 120);
    if (!_isCurrent(generation)) return;

    await HapticFeedback.mediumImpact();
    await _pause(generation, 160);
    if (!_isCurrent(generation)) return;

    await HapticFeedback.heavyImpact();
  }
}
