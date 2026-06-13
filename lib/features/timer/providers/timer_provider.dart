import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chelnok_boxing_timer/features/timer/data/timer_preset_storage.dart';
import 'package:chelnok_boxing_timer/features/timer/logic/timer_state.dart';
import 'package:chelnok_boxing_timer/features/timer/models/timer_custom_preset.dart';
import 'package:chelnok_boxing_timer/features/timer/models/timer_quick_preset.dart';
import 'package:chelnok_boxing_timer/features/timer/services/timer_haptic_service.dart';
import 'package:chelnok_boxing_timer/features/timer/services/timer_sound_services.dart';

final timerProvider = NotifierProvider<TimerNotifier, TimerState>(
  TimerNotifier.new,
);

class TimerNotifier extends Notifier<TimerState> {
  final TimerPresetStorage _storage = const TimerPresetStorage();
  final TimerSoundService _sounds = TimerSoundService();
  final TimerHapticService _haptics = TimerHapticService();

  Timer? _timer;
  DateTime? _lastTick;

  int? _lastCountdownBeepSecond;
  int _runGeneration = 0;
  bool _isDisposed = false;
  bool _startAnnouncementPlayed = false;
  bool _finishSequenceStarted = false;
  int _phaseGeneration = 0;
  bool _minuteAnnouncementFired = false;
  bool _thirtySecAnnouncementFired = false;
  bool _tenSecAnnouncementFired = false;

  @override
  TimerState build() {
    ref.onDispose(() {
      _isDisposed = true;
      _cancelRunCallbacks();
      unawaited(_sounds.dispose());
      unawaited(_haptics.dispose());
    });

    _loadSavedPresets();

    return TimerState.initial();
  }

  Future<void> _loadSavedPresets() async {
    final timerPresets = await _storage.loadTimerPresets();
    final customPresets = await _storage.loadCustomPresets();

    if (_isDisposed) return;

    state = state.copyWith(
      savedTimerPresets: timerPresets,
      customPresets: customPresets,
      isLoadingPresets: false,
    );
  }

  // ---------------------------------------------------------------------------
  // TIMER SOUND LOGIC
  // ---------------------------------------------------------------------------

  void _resetCountdownBeep() {
    _lastCountdownBeepSecond = null;
  }

  bool _isCurrentRun(int generation) {
    return !_isDisposed && generation == _runGeneration;
  }

  int _newRunGeneration() {
    _runGeneration++;
    _phaseGeneration++;
    _startAnnouncementPlayed = false;
    _finishSequenceStarted = false;
    _resetTimedAnnouncements();
    return _runGeneration;
  }

  void _cancelRunCallbacks() {
    _runGeneration++;
    _phaseGeneration++;
    _timer?.cancel();
    _timer = null;
    _lastTick = null;
    _resetCountdownBeep();
    _resetTimedAnnouncements();
    _startAnnouncementPlayed = false;
    _finishSequenceStarted = false;
    unawaited(_haptics.stopAllHaptics());
  }

  void _beginPhaseTracking() {
    _phaseGeneration++;
    _resetCountdownBeep();
    _resetTimedAnnouncements();
  }

  void _playPhaseBell() {
    if (!state.allowSound) return;
    unawaited(_sounds.playBellRestarting());
  }

  void _announcePreparationStart(int generation) {
    if (!state.isPreparation || _startAnnouncementPlayed) return;

    _startAnnouncementPlayed = true;

    unawaited(
      _sounds.speak('Get ready').then((_) {
        if (!_isCurrentRun(generation)) return;
      }),
    );
  }

  void _vibrate() {
    if (!state.allowVibration) return;
    unawaited(HapticFeedback.selectionClick());
  }

  void _resetTimedAnnouncements() {
    _minuteAnnouncementFired = false;
    _thirtySecAnnouncementFired = false;
    _tenSecAnnouncementFired = false;
  }

  bool _canPlayTimedAnnouncements() {
    return state.allowSound &&
        state.isRunning &&
        !state.isPreparation &&
        !state.isFinished;
  }

  void _playTimedAnnouncementsForCrossing({
    required int previousRemainingMs,
    required int currentRemainingMs,
  }) {
    if (!_canPlayTimedAnnouncements()) return;

    _playThresholdAnnouncementIfNeeded(
      thresholdMs: 60000,
      previousRemainingMs: previousRemainingMs,
      currentRemainingMs: currentRemainingMs,
    );
    _playThresholdAnnouncementIfNeeded(
      thresholdMs: 30000,
      previousRemainingMs: previousRemainingMs,
      currentRemainingMs: currentRemainingMs,
    );
    _playThresholdAnnouncementIfNeeded(
      thresholdMs: 10000,
      previousRemainingMs: previousRemainingMs,
      currentRemainingMs: currentRemainingMs,
    );
  }

  void _playInitialTimedAnnouncementIfNeeded({bool delayForBell = false}) {
    if (!_canPlayTimedAnnouncements()) return;

    final remainingMs = state.remainingMs;
    final phaseGeneration = _phaseGeneration;
    final runGeneration = _runGeneration;
    final delay = delayForBell
        ? const Duration(milliseconds: 750)
        : Duration.zero;

    if (remainingMs != 60000 && remainingMs != 30000 && remainingMs != 10000) {
      return;
    }

    unawaited(
      Future<void>.delayed(delay).then((_) {
        if (!_isCurrentRun(runGeneration) ||
            phaseGeneration != _phaseGeneration ||
            !_canPlayTimedAnnouncements()) {
          return;
        }

        _playThresholdAnnouncementIfNeeded(
          thresholdMs: remainingMs,
          previousRemainingMs: remainingMs + 1,
          currentRemainingMs: remainingMs,
        );
      }),
    );
  }

  void _playThresholdAnnouncementIfNeeded({
    required int thresholdMs,
    required int previousRemainingMs,
    required int currentRemainingMs,
  }) {
    if (!_phaseCanReachThreshold(thresholdMs)) return;
    if (previousRemainingMs <= thresholdMs ||
        currentRemainingMs > thresholdMs) {
      return;
    }

    switch (thresholdMs) {
      case 60000:
        if (_minuteAnnouncementFired || !state.minuteAnnouncement) return;
        _minuteAnnouncementFired = true;
        unawaited(_sounds.playTimedBeepAnnouncement('Minute left'));
        return;
      case 30000:
        if (_thirtySecAnnouncementFired || !state.thirtySecAnnouncement) {
          return;
        }
        _thirtySecAnnouncementFired = true;
        unawaited(_sounds.playTimedBeepAnnouncement('Thirty seconds left'));
        return;
      case 10000:
        if (_tenSecAnnouncementFired || !state.tenSecAnnouncement) return;
        _tenSecAnnouncementFired = true;
        unawaited(_sounds.playKnockAnnouncement());
        return;
    }
  }

  void _playCountdownBeepIfNeeded(int remainingMs) {
    if (!state.allowSound) return;

    final secondsLeft = (remainingMs / 1000).ceil();

    final isCountdownSecond = secondsLeft >= 1 && secondsLeft <= 5;
    final alreadyPlayed = secondsLeft == _lastCountdownBeepSecond;

    if (!isCountdownSecond || alreadyPlayed) return;

    _lastCountdownBeepSecond = secondsLeft;

    unawaited(_sounds.playCountdownBeep());
  }

  // ---------------------------------------------------------------------------
  // ANNOUNCEMENT SETTINGS
  // ---------------------------------------------------------------------------

  void toggleTenSecAnnouncement(bool value) {
    state = state.copyWith(tenSecAnnouncement: value);
  }

  void toggleThirtySecAnnouncement(bool value) {
    state = state.copyWith(thirtySecAnnouncement: value);
  }

  void toggleMinuteAnnouncement(bool value) {
    if (value && !_canEnableMinuteAnnouncementForSettings()) return;

    state = state.copyWith(minuteAnnouncement: value);
  }

  void toggleSound(bool value) {
    state = state.copyWith(allowSound: value);
  }

  void toggleVibration(bool value) {
    state = state.copyWith(allowVibration: value);
  }

  bool _canEnableMinuteAnnouncementForSettings({int? workMs, int? restMs}) {
    return (workMs ?? state.workMs) > 60000 || (restMs ?? state.restMs) > 60000;
  }

  bool _minuteAnnouncementAfterDurationChange({
    required int workMs,
    required int restMs,
  }) {
    if (!_canEnableMinuteAnnouncementForSettings(
      workMs: workMs,
      restMs: restMs,
    )) {
      return false;
    }

    return state.minuteAnnouncement;
  }

  bool _phaseCanReachThreshold(int thresholdMs) {
    if (thresholdMs == 60000) {
      return state.currentPhaseTotalMs > thresholdMs;
    }

    return state.currentPhaseTotalMs >= thresholdMs;
  }

  // ---------------------------------------------------------------------------
  // TIMER SETTINGS
  // ---------------------------------------------------------------------------

  void addWorkTime() {
    final increment = state.workMs < 60000 ? 10000 : 30000;
    final newMs = state.workMs + increment;

    state = state.copyWith(
      workMs: newMs,
      minuteAnnouncement: _minuteAnnouncementAfterDurationChange(
        workMs: newMs,
        restMs: state.restMs,
      ),
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
      minuteAnnouncement: _minuteAnnouncementAfterDurationChange(
        workMs: newMs,
        restMs: state.restMs,
      ),
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
      minuteAnnouncement: _minuteAnnouncementAfterDurationChange(
        workMs: state.workMs,
        restMs: newMs,
      ),
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
      minuteAnnouncement: _minuteAnnouncementAfterDurationChange(
        workMs: state.workMs,
        restMs: newMs,
      ),
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

  // ---------------------------------------------------------------------------
  // TIMER CONTROLS
  // ---------------------------------------------------------------------------

  void start() {
    if (state.isRunning) return;

    final generation = _startAnnouncementPlayed
        ? _runGeneration
        : _newRunGeneration();

    state = state.copyWith(isRunning: true, isFinished: false);

    _announcePreparationStart(generation);
    _vibrate();
    _startTicker();
  }

  void pause() {
    tick();

    _timer?.cancel();
    _timer = null;
    _lastTick = null;

    state = state.copyWith(isRunning: false);
  }

  void reset() {
    _cancelRunCallbacks();
    unawaited(_sounds.stopAllAudio());
    _resetCountdownBeep();
    _vibrate();

    if (state.isCustomWorkout) {
      state = state.copyWith(
        remainingMs: state.preparationMs,
        currentBlockIndex: 0,
        isRunning: false,
        isPreparation: true,
        isFinished: false,
        finishRemainingMs: 3000,
      );

      return;
    }

    state = state.copyWith(
      remainingMs: state.preparationMs,
      currentRound: 1,
      isRunning: false,
      isWork: true,
      isPreparation: true,
      isFinished: false,
      finishRemainingMs: 3000,
    );
  }

  void skip() {
    if (state.isFinished) return;

    _resetCountdownBeep();
    _vibrate();

    if (state.isCustomWorkout) {
      if (state.isPreparation) {
        if (state.customBlocks.isEmpty) {
          _finishWorkout();
          return;
        }

        _beginPhaseTracking();
        state = state.copyWith(
          isPreparation: false,
          remainingMs: state.customBlocks.first.durationMs,
        );

        _restartTickReference();
        _playPhaseBell();
        _playInitialTimedAnnouncementIfNeeded(delayForBell: true);
        return;
      }

      if (_moveToNextCustomBlock()) {
        _playPhaseBell();
        _playInitialTimedAnnouncementIfNeeded(delayForBell: true);
      }
      return;
    }

    if (state.isPreparation) {
      _beginPhaseTracking();
      state = state.copyWith(
        isWork: true,
        isPreparation: false,
        remainingMs: state.workMs,
      );
    } else if (state.isWork) {
      if (state.currentRound >= state.rounds) {
        _finishWorkout();
        return;
      }

      _beginPhaseTracking();
      state = state.copyWith(isWork: false, remainingMs: state.restMs);
    } else {
      if (state.currentRound >= state.rounds) {
        _finishWorkout();
        return;
      }

      _beginPhaseTracking();
      state = state.copyWith(
        isWork: true,
        currentRound: state.currentRound + 1,
        remainingMs: state.workMs,
      );
    }

    _restartTickReference();
    _playPhaseBell();
    _playInitialTimedAnnouncementIfNeeded(delayForBell: true);
  }

  void stopRun() {
    _cancelRunCallbacks();
    unawaited(_sounds.stopAllAudio());

    state = state.copyWith(
      isRunning: false,
      isFinished: false,
      finishRemainingMs: 3000,
    );
  }

  // ---------------------------------------------------------------------------
  // TIMER HEARTBEAT
  // ---------------------------------------------------------------------------

  void tick() {
    if (!state.isRunning) return;

    final now = DateTime.now();
    final lastTick = _lastTick ?? now;
    final elapsedMs = now.difference(lastTick).inMilliseconds;

    _lastTick = now;

    if (elapsedMs <= 0) return;

    if (state.isFinished) {
      final nextMs = state.finishRemainingMs - elapsedMs;

      if (nextMs > 0) {
        state = state.copyWith(finishRemainingMs: nextMs);
        return;
      }

      _timer?.cancel();
      _timer = null;
      _lastTick = null;

      state = state.copyWith(isRunning: false, finishRemainingMs: 0);
      return;
    }

    final nextMs = state.remainingMs - elapsedMs;

    if (nextMs > 0) {
      _playTimedAnnouncementsForCrossing(
        previousRemainingMs: state.remainingMs,
        currentRemainingMs: nextMs,
      );
      _playCountdownBeepIfNeeded(nextMs);

      state = state.copyWith(remainingMs: nextMs);

      return;
    }

    _handleRoundEnd();
  }

  void _handleRoundEnd() {
    _resetCountdownBeep();

    if (state.isPreparation) {
      if (state.isCustomWorkout) {
        if (state.customBlocks.isEmpty) {
          _finishWorkout();
          return;
        }

        _beginPhaseTracking();
        state = state.copyWith(
          isPreparation: false,
          remainingMs: state.customBlocks.first.durationMs,
        );
      } else {
        _beginPhaseTracking();
        state = state.copyWith(
          isWork: true,
          isPreparation: false,
          remainingMs: state.workMs,
        );
      }

      _restartTickReference();
      _playPhaseBell();
      _playInitialTimedAnnouncementIfNeeded(delayForBell: true);
      return;
    }

    if (state.isCustomWorkout) {
      if (_moveToNextCustomBlock()) {
        _playPhaseBell();
        _playInitialTimedAnnouncementIfNeeded(delayForBell: true);
      }
      return;
    }

    if (state.isWork) {
      if (state.currentRound >= state.rounds) {
        _finishWorkout();
        return;
      }

      _beginPhaseTracking();
      state = state.copyWith(isWork: false, remainingMs: state.restMs);

      _restartTickReference();
      _playPhaseBell();
      _playInitialTimedAnnouncementIfNeeded(delayForBell: true);
      return;
    }

    if (state.currentRound >= state.rounds) {
      _finishWorkout();
      return;
    }

    _beginPhaseTracking();
    state = state.copyWith(
      isWork: true,
      currentRound: state.currentRound + 1,
      remainingMs: state.workMs,
    );

    _restartTickReference();
    _playPhaseBell();
    _playInitialTimedAnnouncementIfNeeded(delayForBell: true);
  }

  void _restartTickReference() {
    if (state.isRunning) {
      _lastTick = DateTime.now();
    }
  }

  void _startTicker() {
    _timer?.cancel();
    _lastTick = DateTime.now();
    _timer = Timer.periodic(const Duration(milliseconds: 100), (_) => tick());
  }

  Future<void> _finishWorkout() async {
    if (_finishSequenceStarted) return;

    final generation = _runGeneration;
    _finishSequenceStarted = true;
    _phaseGeneration++;

    _timer?.cancel();
    _timer = null;
    _lastTick = null;
    _resetCountdownBeep();

    state = state.copyWith(
      isRunning: true,
      isFinished: true,
      remainingMs: 0,
      finishRemainingMs: 3000,
    );

    if (state.allowVibration) {
      unawaited(_haptics.playWorkoutCompleteHaptics());
    }

    if (state.allowSound) {
      await _sounds.playFinishThreeBells();
      if (!_isCurrentRun(generation)) return;
    }

    await _sounds.speak('Good work');
    if (!_isCurrentRun(generation)) return;

    _startTicker();
  }

  // ---------------------------------------------------------------------------
  // QUICK PRESETS
  // ---------------------------------------------------------------------------

  void applyPreset(TimerPreset preset) {
    _cancelRunCallbacks();

    state = state.copyWith(
      workMs: preset.workMs,
      restMs: preset.restMs,
      minuteAnnouncement: _minuteAnnouncementAfterDurationChange(
        workMs: preset.workMs,
        restMs: preset.restMs,
      ),
      rounds: preset.rounds,
      preparationMs: preset.preparationMs,
      remainingMs: preset.preparationMs,
      currentRound: 1,
      currentBlockIndex: 0,
      isRunning: false,
      isWork: true,
      isPreparation: true,
      isCustomWorkout: false,
      isFinished: false,
      finishRemainingMs: 3000,
      customBlocks: const [],
      selectedPreset: preset,
      clearSelectedCustomPreset: true,
    );
  }

  void prepareManualTimer() {
    _cancelRunCallbacks();

    state = state.copyWith(
      remainingMs: state.preparationMs,
      currentRound: 1,
      currentBlockIndex: 0,
      isRunning: false,
      isWork: true,
      isPreparation: true,
      isCustomWorkout: false,
      isFinished: false,
      finishRemainingMs: 3000,
      customBlocks: const [],
      clearSelectedPreset: true,
      clearSelectedCustomPreset: true,
    );
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

  void removeTimerPreset(int index) {
    if (index < 0 || index >= state.savedTimerPresets.length) return;

    final removedPreset = state.savedTimerPresets[index];
    final presets = [...state.savedTimerPresets]..removeAt(index);
    final clearSelection = _isSameTimerPreset(
      state.selectedPreset,
      removedPreset,
    );

    state = state.copyWith(
      savedTimerPresets: presets,
      clearSelectedPreset: clearSelection,
    );

    unawaited(_storage.saveTimerPresets(presets));
  }

  // ---------------------------------------------------------------------------
  // CUSTOM PRESETS
  // ---------------------------------------------------------------------------

  void addCustomPreset(TimerCustomPreset preset) {
    final presets = [...state.customPresets, preset];

    state = state.copyWith(customPresets: presets);

    unawaited(_storage.saveCustomPresets(presets));
  }

  void updateCustomPreset(int index, TimerCustomPreset preset) {
    if (index < 0 || index >= state.customPresets.length) return;

    final presets = [...state.customPresets];
    final oldPreset = presets[index];
    final updateSelection = identical(state.selectedCustomPreset, oldPreset);

    presets[index] = preset;

    state = state.copyWith(
      customPresets: presets,
      selectedCustomPreset: updateSelection
          ? preset
          : state.selectedCustomPreset,
    );

    unawaited(_storage.saveCustomPresets(presets));
  }

  void removeCustomPreset(int index) {
    if (index < 0 || index >= state.customPresets.length) return;

    final removedPreset = state.customPresets[index];
    final presets = [...state.customPresets]..removeAt(index);
    final clearSelection = identical(state.selectedCustomPreset, removedPreset);

    state = state.copyWith(
      customPresets: presets,
      clearSelectedCustomPreset: clearSelection,
    );

    unawaited(_storage.saveCustomPresets(presets));
  }

  void startCustomPreset(TimerCustomPreset preset) {
    _cancelRunCallbacks();

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
      isFinished: false,
      finishRemainingMs: 3000,
    );
  }

  bool _moveToNextCustomBlock() {
    final nextIndex = state.currentBlockIndex + 1;

    if (nextIndex >= state.customBlocks.length) {
      _finishWorkout();
      return false;
    }

    _beginPhaseTracking();
    state = state.copyWith(
      currentBlockIndex: nextIndex,
      remainingMs: state.customBlocks[nextIndex].durationMs,
    );

    _restartTickReference();
    return true;
  }

  // ---------------------------------------------------------------------------
  // PRESET HELPERS
  // ---------------------------------------------------------------------------

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

  bool hasCustomPresetName(String name, {int? excludingIndex}) {
    return state.customPresets.indexed.any(
      (entry) =>
          entry.$1 != excludingIndex &&
          entry.$2.name.toLowerCase() == name.toLowerCase(),
    );
  }

  bool hasTimerPresetName(String name) {
    return state.savedTimerPresets.any(
      (preset) => preset.title.toLowerCase() == name.toLowerCase(),
    );
  }

  bool _isSameTimerPreset(TimerPreset? first, TimerPreset second) {
    if (first == null) return false;

    return first.title == second.title &&
        first.workMs == second.workMs &&
        first.restMs == second.restMs &&
        first.rounds == second.rounds &&
        first.preparationMs == second.preparationMs;
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
