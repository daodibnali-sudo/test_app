class TimerState {
  final int workSeconds;
  final int restSeconds;
  final int remainingSeconds;
  final int rounds;
  final int currentRound;
  final bool isRunning;
  final bool isWork;
  final bool tenSecAnnouncement;
  final bool thirtySecAnnouncement;
  final bool minuteAnnouncement;

  int get totalSeconds => (workSeconds + restSeconds) * rounds;

  const TimerState({
    required this.workSeconds,
    required this.restSeconds,
    required this.remainingSeconds,
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
      workSeconds: 180,
      restSeconds: 60,
      remainingSeconds: 180,
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
    int? workSeconds,
    int? restSeconds,
    int? remainingSeconds,
    int? rounds,
    int? currentRound,
    bool? isRunning,
    bool? isWork,
    bool? tenSecAnnouncement,
    bool? thirtySecAnnouncement,
    bool? minuteAnnouncement,
  }) {
    return TimerState(
      workSeconds: workSeconds ?? this.workSeconds,
      restSeconds: restSeconds ?? this.restSeconds,
      remainingSeconds: remainingSeconds ?? this.remainingSeconds,
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
