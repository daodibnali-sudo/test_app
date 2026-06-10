import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:test_app/features/timer/data/timer_preset_storage.dart';
import 'package:test_app/features/timer/logic/timer_state.dart';
import 'package:test_app/features/timer/models/timer_custom_preset.dart';
import 'package:test_app/features/timer/models/timer_quick_preset.dart';

final timerProvider = NotifierProvider<TimerNotifier, TimerState>(
  TimerNotifier.new,
);

class TimerNotifier extends Notifier<TimerState> {
  final TimerPresetStorage _storage = const TimerPresetStorage();
  Timer? _timer;
  DateTime? _lastTick;

  @override
  TimerState build() {
    ref.onDispose(() {
      _timer?.cancel();
    });

    _loadSavedPresets();

    return TimerState.initial();
  }

  Future<void> _loadSavedPresets() async {
    final timerPresets = await _storage.loadTimerPresets();
    final customPresets = await _storage.loadCustomPresets();

    state = state.copyWith(
      savedTimerPresets: timerPresets,
      customPresets: customPresets,
      isLoadingPresets: false,
    );
  }

  void toggleTenSecAnnouncement(bool value) {
    state = state.copyWith(tenSecAnnouncement: value);
  }

  void toggleThirtySecAnnouncement(bool value) {
    state = state.copyWith(thirtySecAnnouncement: value);
  }

  void toggleMinuteAnnouncement(bool value) {
    state = state.copyWith(minuteAnnouncement: value);
  }

  void addWorkTime() {
    final increment = state.workMs < 60000 ? 10000 : 30000;
    final newMs = state.workMs + increment;

    state = state.copyWith(
      workMs: newMs,
      remainingMs: state.isWork && !state.isPreparation
          ? newMs
          : state.remainingMs,
    );
  }

  void subtractWorkTime() {
    if (state.workMs <= 10000) return;

    final decrement = state.workMs <= 60000 ? 10000 : 30000;
    final newMs = state.workMs - decrement;

    state = state.copyWith(
      workMs: newMs,
      remainingMs: state.isWork && !state.isPreparation
          ? newMs
          : state.remainingMs,
    );
  }

  void addRestTime() {
    final increment = state.restMs < 60000 ? 10000 : 30000;
    final newMs = state.restMs + increment;

    state = state.copyWith(
      restMs: newMs,
      remainingMs: !state.isWork && !state.isPreparation
          ? newMs
          : state.remainingMs,
    );
  }

  void subtractRestTime() {
    if (state.restMs <= 10000) return;

    final decrement = state.restMs <= 60000 ? 10000 : 30000;
    final newMs = state.restMs - decrement;

    state = state.copyWith(
      restMs: newMs,
      remainingMs: !state.isWork && !state.isPreparation
          ? newMs
          : state.remainingMs,
    );
  }

  void addPreparationTime() {
    final increment = state.preparationMs < 60000 ? 10000 : 30000;
    final newMs = state.preparationMs + increment;

    state = state.copyWith(
      preparationMs: newMs,
      remainingMs: state.isPreparation ? newMs : state.remainingMs,
    );
  }

  void subtractPreparationTime() {
    if (state.preparationMs <= 0) return;

    final decrement = state.preparationMs <= 60000 ? 10000 : 30000;
    final newMs = (state.preparationMs - decrement).clamp(0, 5999999);

    state = state.copyWith(
      preparationMs: newMs,
      remainingMs: state.isPreparation ? newMs : state.remainingMs,
    );
  }

  void addRound() {
    state = state.copyWith(rounds: state.rounds + 1);
  }

  void subtractRound() {
    state = state.copyWith(rounds: (state.rounds - 1).clamp(1, 99));
  }

  void start() {
    if (state.isRunning) return;

    _lastTick = DateTime.now();
    state = state.copyWith(isRunning: true);

    _timer = Timer.periodic(const Duration(milliseconds: 100), (_) {
      tick();
    });
  }

  void pause() {
    tick();
    _timer?.cancel();
    _lastTick = null;
    state = state.copyWith(isRunning: false);
  }

  void reset() {
    _timer?.cancel();
    _lastTick = null;

    if (state.isCustomWorkout) {
      state = state.copyWith(
        remainingMs: state.preparationMs,
        currentBlockIndex: 0,
        isRunning: false,
        isPreparation: true,
      );
      return;
    }

    state = state.copyWith(
      remainingMs: state.preparationMs,
      currentRound: 1,
      isRunning: false,
      isWork: true,
      isPreparation: true,
    );
  }

  void skip() {
    if (state.isCustomWorkout) {
      if (state.isPreparation) {
        state = state.copyWith(
          isPreparation: false,
          remainingMs: state.customBlocks.isEmpty
              ? 0
              : state.customBlocks.first.durationMs,
        );
        return;
      }

      _moveToNextCustomBlock();
      return;
    }

    if (state.isPreparation) {
      state = state.copyWith(
        isWork: true,
        isPreparation: false,
        remainingMs: state.workMs,
      );
    } else if (state.isWork) {
      state = state.copyWith(isWork: false, remainingMs: state.restMs);
    } else {
      if (state.currentRound >= state.rounds) {
        _timer?.cancel();
        _lastTick = null;
        state = state.copyWith(isRunning: false, remainingMs: 0);
        return;
      }

      state = state.copyWith(
        isWork: true,
        currentRound: state.currentRound + 1,
        remainingMs: state.workMs,
      );
    }

    if (state.isRunning) {
      _lastTick = DateTime.now();
    }
  }

  void tick() {
    if (!state.isRunning) return;

    final now = DateTime.now();
    final lastTick = _lastTick ?? now;
    final elapsedMs = now.difference(lastTick).inMilliseconds;
    _lastTick = now;

    if (elapsedMs <= 0) return;

    if (state.remainingMs > elapsedMs) {
      state = state.copyWith(remainingMs: state.remainingMs - elapsedMs);
      return;
    }

    _handleRoundEnd();
  }

  void _handleRoundEnd() {
    if (state.isPreparation) {
      if (state.isCustomWorkout) {
        state = state.copyWith(
          isPreparation: false,
          remainingMs: state.customBlocks.isEmpty
              ? 0
              : state.customBlocks.first.durationMs,
        );
      } else {
        state = state.copyWith(
          isWork: true,
          isPreparation: false,
          remainingMs: state.workMs,
        );
      }
      return;
    }

    if (state.isCustomWorkout) {
      _moveToNextCustomBlock();
      return;
    }

    if (state.isWork) {
      state = state.copyWith(isWork: false, remainingMs: state.restMs);
      return;
    }

    if (state.currentRound >= state.rounds) {
      _timer?.cancel();
      _lastTick = null;
      state = state.copyWith(isRunning: false, remainingMs: 0);
      return;
    }

    state = state.copyWith(
      isWork: true,
      currentRound: state.currentRound + 1,
      remainingMs: state.workMs,
    );
  }

  void applyPreset(TimerPreset preset) {
    _timer?.cancel();
    _lastTick = null;

    state = state.copyWith(
      workMs: preset.workMs,
      restMs: preset.restMs,
      rounds: preset.rounds,
      preparationMs: preset.preparationMs,
      remainingMs: preset.preparationMs,
      currentRound: 1,
      currentBlockIndex: 0,
      isRunning: false,
      isWork: true,
      isPreparation: true,
      isCustomWorkout: false,
      customBlocks: const [],
      selectedPreset: preset,
      clearSelectedCustomPreset: true,
    );
  }

  void prepareManualTimer() {
    _timer?.cancel();
    _lastTick = null;

    state = state.copyWith(
      remainingMs: state.preparationMs,
      currentRound: 1,
      currentBlockIndex: 0,
      isRunning: false,
      isWork: true,
      isPreparation: true,
      isCustomWorkout: false,
      customBlocks: const [],
      clearSelectedPreset: true,
      clearSelectedCustomPreset: true,
    );
  }

  void addCustomPreset(TimerCustomPreset preset) {
    final presets = [...state.customPresets, preset];
    state = state.copyWith(customPresets: presets);
    unawaited(_storage.saveCustomPresets(presets));
  }

  void addTimerPreset(TimerPreset preset) {
    if (hasTimerPresetName(preset.title)) return;

    final presets = [...state.savedTimerPresets, preset];
    state = state.copyWith(savedTimerPresets: presets);
    unawaited(_storage.saveTimerPresets(presets));
  }

  void updateTimerPreset(int index, TimerPreset preset) {
    if (index < 0 || index >= state.savedTimerPresets.length) return;

    final presets = [...state.savedTimerPresets];
    presets[index] = preset;

    state = state.copyWith(savedTimerPresets: presets, selectedPreset: preset);
    unawaited(_storage.saveTimerPresets(presets));
  }

  void clearPresetSelection() {
    state = state.copyWith(
      clearSelectedPreset: true,
      clearSelectedCustomPreset: true,
    );
  }

  TimerPreset buildCurrentTimerPreset({String? title}) {
    final presetTitle = title ?? nextTimerPresetName();

    return TimerPreset(
      title: presetTitle,
      subtitle:
          '${_formatMs(state.workMs)} / ${_formatMs(state.restMs)} - ${state.rounds} rounds',
      icon: Icons.timer,
      workMs: state.workMs,
      restMs: state.restMs,
      rounds: state.rounds,
      preparationMs: state.preparationMs,
    );
  }

  String nextCustomPresetName() {
    return _nextPresetName(
      prefix: 'Custom preset',
      existingNames: state.customPresets.map((preset) => preset.name),
    );
  }

  String nextTimerPresetName() {
    return _nextPresetName(
      prefix: 'Timer preset',
      existingNames: state.savedTimerPresets.map((preset) => preset.title),
    );
  }

  bool hasCustomPresetName(String name) {
    return state.customPresets.any(
      (preset) => preset.name.toLowerCase() == name.toLowerCase(),
    );
  }

  bool hasTimerPresetName(String name) {
    return state.savedTimerPresets.any(
      (preset) => preset.title.toLowerCase() == name.toLowerCase(),
    );
  }

  void startCustomPreset(TimerCustomPreset preset) {
    _timer?.cancel();
    _lastTick = null;

    final blocks = List.of(preset.blocks);

    state = state.copyWith(
      selectedCustomPreset: preset,
      clearSelectedPreset: true,
      customBlocks: blocks,
      currentBlockIndex: 0,
      preparationMs: preset.preparationMs,
      remainingMs: preset.preparationMs,
      currentRound: 1,
      isRunning: false,
      isWork: true,
      isPreparation: true,
      isCustomWorkout: true,
    );
  }

  void _moveToNextCustomBlock() {
    final nextIndex = state.currentBlockIndex + 1;

    if (nextIndex >= state.customBlocks.length) {
      _timer?.cancel();
      _lastTick = null;
      state = state.copyWith(isRunning: false, remainingMs: 0);
      return;
    }

    state = state.copyWith(
      currentBlockIndex: nextIndex,
      remainingMs: state.customBlocks[nextIndex].durationMs,
    );

    if (state.isRunning) {
      _lastTick = DateTime.now();
    }
  }

  String _nextPresetName({
    required String prefix,
    required Iterable<String> existingNames,
  }) {
    final normalizedNames = existingNames
        .map((name) => name.toLowerCase())
        .toSet();

    for (var index = 1; index <= 99999999; index++) {
      final name = '$prefix #$index';
      if (!normalizedNames.contains(name.toLowerCase())) {
        return name;
      }
    }

    return '$prefix #99999999';
  }

  String _formatMs(int ms) {
    final minutes = ms ~/ 60000;
    final seconds = ms % 60000 ~/ 1000;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }
}
