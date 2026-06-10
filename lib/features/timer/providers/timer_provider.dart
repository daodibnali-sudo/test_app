import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:test_app/features/timer/logic/timer_state.dart';

final timerProvider = NotifierProvider<TimerNotifier, TimerState>(
  TimerNotifier.new,
);

//How to make it t

class TimerNotifier extends Notifier<TimerState> {
  Timer? _timer;
  DateTime? _lastTick;

  @override
  TimerState build() {
    ref.onDispose(() {
      _timer?.cancel();
    });

    return TimerState.initial();
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
    final newSeconds = state.workMs + increment;

    state = state.copyWith(
      workMs: newSeconds,
      remainingMs: state.isWork ? newSeconds : state.remainingMs,
    );
  }

  void subtractWorkTime() {
    if (state.workMs <= 10000) return;

    final decrement = state.workMs <= 60000 ? 10000 : 30000;
    final newSeconds = state.workMs - decrement;

    state = state.copyWith(
      workMs: newSeconds,
      remainingMs: state.isWork ? newSeconds : state.remainingMs,
    );
  }

  void addRestTime() {
    final increment = state.restMs < 60000 ? 10000 : 30000;
    final newSeconds = state.restMs + increment;

    state = state.copyWith(
      restMs: newSeconds,
      remainingMs: !state.isWork ? newSeconds : state.remainingMs,
    );
  }

  void subtractRestTime() {
    if (state.restMs <= 10000) return;

    final decrement = state.restMs <= 60000 ? 10000 : 30000;
    final newSeconds = state.restMs - decrement;

    state = state.copyWith(
      restMs: newSeconds,
      remainingMs: !state.isWork ? newSeconds : state.remainingMs,
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

    _timer = Timer.periodic(const Duration(milliseconds: 50), (_) {
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

    state = state.copyWith(
      remainingMs: state.workMs,
      currentRound: 1,
      isRunning: false,
      isWork: true,
    );
  }

  void skip() {
    if (state.isWork) {
      state = state.copyWith(
        isWork: false,
        remainingMs: state.restMs,
      );
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
    if (state.isWork) {
      state = state.copyWith(
        isWork: false,
        remainingMs: state.restMs,
      );
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
}
