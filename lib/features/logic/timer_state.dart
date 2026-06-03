class TimerState {
  final int workSeconds;
  final int restSeconds;
  final int remainingSeconds;
  final int rounds;
  final int currentRound;
  final bool isRunning;
  final bool isWork;

  const TimerState({
    required this.workSeconds,
    required this.restSeconds,
    required this.remainingSeconds,
    required this.rounds,
    required this.currentRound,
    required this.isRunning,
    required this.isWork,
  });

  factory TimerState.initial() {
    return const TimerState(
      workSeconds: 180,
      restSeconds: 60,
      remainingSeconds: 180,
      rounds: 3,
      currentRound: 1,
      isRunning: false,
      isWork: true,
    );
  }

  TimerState copyWith({
    int? workSeconds,
    int? restSeconds,
    int? remainingSeconds,
    int? rounds,
    int? currentRound,
    bool? isRunning,
    bool? isWork,
  }) {
    return TimerState(
      workSeconds: workSeconds ?? this.workSeconds,
      restSeconds: restSeconds ?? this.restSeconds,
      remainingSeconds: remainingSeconds ?? this.remainingSeconds,
      rounds: rounds ?? this.rounds,
      currentRound: currentRound ?? this.currentRound,
      isRunning: isRunning ?? this.isRunning,
      isWork: isWork ?? this.isWork,
    );
  }
}
