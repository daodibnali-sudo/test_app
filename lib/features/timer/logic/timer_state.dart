class TimerState {
  final int workMs;
  final int restMs;
  final int remainingMs;
  final int rounds;
  final int currentRound;
  final bool isRunning;
  final bool isWork;
  final bool tenSecAnnouncement;
  final bool thirtySecAnnouncement;
  final bool minuteAnnouncement;
  final int preparationMs;

  int get totalMs => (workMs * rounds) + (restMs * (rounds - 1));

  const TimerState({
    required this.workMs,
    required this.restMs,
    required this.preparationMs,
    required this.remainingMs,
    required this.rounds,
    required this.currentRound,
    required this.isRunning,
    required this.isWork,
    required this.tenSecAnnouncement,
    required this.thirtySecAnnouncement,
    required this.minuteAnnouncement,
  });

  factory TimerState.initial() {
    return const TimerState(
      workMs: 180000,
      restMs: 60000,
      preparationMs: 10000,
      remainingMs: 180000,
      rounds: 3,
      currentRound: 1,
      isRunning: false,
      isWork: true,
      tenSecAnnouncement: true,
      thirtySecAnnouncement: true,
      minuteAnnouncement: true,
    );
  }

  TimerState copyWith({
    int? workMs,
    int? restMs,
    int? remainingMs,
    int? preparationMs,
    int? rounds,
    int? currentRound,
    bool? isRunning,
    bool? isWork,
    bool? tenSecAnnouncement,
    bool? thirtySecAnnouncement,
    bool? minuteAnnouncement,
  }) {
    return TimerState(
      workMs: workMs ?? this.workMs,
      restMs: restMs ?? this.restMs,
      remainingMs: remainingMs ?? this.remainingMs,
      preparationMs: preparationMs ?? this.preparationMs,
      rounds: rounds ?? this.rounds,
      currentRound: currentRound ?? this.currentRound,
      isRunning: isRunning ?? this.isRunning,
      isWork: isWork ?? this.isWork,
      tenSecAnnouncement: tenSecAnnouncement ?? this.tenSecAnnouncement,
      thirtySecAnnouncement:
      thirtySecAnnouncement ?? this.thirtySecAnnouncement,
      minuteAnnouncement: minuteAnnouncement ?? this.minuteAnnouncement,
    );
  }
}
