import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:test_app/features/logic/timer_state.dart';

final timerProvider = NotifierProvider<TimerNotifier, TimerState>(
  TimerNotifier.new,
);

class TimerNotifier extends Notifier<TimerState> {
  Timer? _timer;

  @override
  TimerState build() {
    ref.onDispose(() {
      _timer?.cancel();
    });

    return TimerState.initial();
  }

  void addWorkTime() {
    final increment = state.workSeconds < 60 ? 10 : 30;
    final newSeconds = state.workSeconds + increment;

    state = state.copyWith(
      workSeconds: newSeconds,
      remainingSeconds: state.isWork ? newSeconds : state.remainingSeconds,
    );
  }

  void subtractWorkTime() {
    if (state.workSeconds <= 10) return;

    final decrement = state.workSeconds <= 60 ? 10 : 30;
    final newSeconds = state.workSeconds - decrement;

    state = state.copyWith(
      workSeconds: newSeconds,
      remainingSeconds: state.isWork ? newSeconds : state.remainingSeconds,
    );
  }

  void addRestTime() {
    final increment = state.restSeconds < 60 ? 10 : 30;
    final newSeconds = state.restSeconds + increment;

    state = state.copyWith(
      restSeconds: newSeconds,
      remainingSeconds: !state.isWork ? newSeconds : state.remainingSeconds,
    );
  }

  void subtractRestTime() {
    if (state.restSeconds <= 10) return;

    final decrement = state.restSeconds <= 60 ? 10 : 30;
    final newSeconds = state.restSeconds - decrement;

    state = state.copyWith(
      restSeconds: newSeconds,
      remainingSeconds: !state.isWork ? newSeconds : state.remainingSeconds,
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

    state = state.copyWith(isRunning: true);

    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      tick();
    });
  }

  void pause() {
    _timer?.cancel();
    state = state.copyWith(isRunning: false);
  }

  void reset() {
    _timer?.cancel();

    state = state.copyWith(
      remainingSeconds: state.workSeconds,
      currentRound: 1,
      isRunning: false,
      isWork: true,
    );
  }

  void tick() {
    if (state.remainingSeconds > 1) {
      state = state.copyWith(remainingSeconds: state.remainingSeconds - 1);
      return;
    }

    _handleRoundEnd();
  }

  void _handleRoundEnd() {
    if (state.isWork) {
      state = state.copyWith(
        isWork: false,
        remainingSeconds: state.restSeconds,
      );
      return;
    }

    if (state.currentRound >= state.rounds) {
      _timer?.cancel();

      state = state.copyWith(isRunning: false, remainingSeconds: 0);
      return;
    }

    state = state.copyWith(
      isWork: true,
      currentRound: state.currentRound + 1,
      remainingSeconds: state.workSeconds,
    );
  }
}
