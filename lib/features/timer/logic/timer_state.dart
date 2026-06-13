import 'package:chelnok_boxing_timer/features/timer/models/timer_block.dart';
import 'package:chelnok_boxing_timer/features/timer/models/timer_custom_preset.dart';
import 'package:chelnok_boxing_timer/features/timer/models/timer_quick_preset.dart';

class TimerState {
  final int workMs;
  final int restMs;
  final int remainingMs;
  final int rounds;
  final int currentRound;
  final bool isRunning;
  final bool isWork;
  final bool isPreparation;
  final bool tenSecAnnouncement;
  final bool thirtySecAnnouncement;
  final bool minuteAnnouncement;
  final int preparationMs;
  final TimerPreset? selectedPreset;
  final TimerCustomPreset? selectedCustomPreset;
  final List<TimerPreset> savedTimerPresets;
  final List<TimerCustomPreset> customPresets;
  final List<TimerBlock> customBlocks;
  final int currentBlockIndex;
  final bool isCustomWorkout;
  final bool isLoadingPresets;
  final bool isFinished;
  final int finishRemainingMs;
  final bool allowSound;
  final bool allowVibration;

  int get totalMs => isCustomWorkout
      ? preparationMs +
            customBlocks.fold(0, (total, block) => total + block.durationMs)
      : preparationMs + (workMs * rounds) + (restMs * (rounds - 1));

  TimerBlock? get currentBlock {
    if (!isCustomWorkout || customBlocks.isEmpty) return null;
    if (currentBlockIndex < 0 || currentBlockIndex >= customBlocks.length) {
      return null;
    }

    return customBlocks[currentBlockIndex];
  }

  int get currentPhaseTotalMs {
    if (isFinished) return 3000;
    if (isPreparation) return preparationMs;
    if (isCustomWorkout) return currentBlock?.durationMs ?? 0;
    return isWork ? workMs : restMs;
  }

  String get currentPhaseName {
    if (isFinished) return 'good work';
    if (isPreparation) return 'Preparation';
    if (isCustomWorkout) return currentBlock?.name ?? 'Finished';
    return isWork ? 'Work' : 'Rest';
  }

  int get totalWorkMs => isCustomWorkout
      ? customBlocks.fold(0, (total, block) => total + block.durationMs)
      : workMs * rounds;

  const TimerState({
    this.selectedPreset,
    this.selectedCustomPreset,
    this.savedTimerPresets = const [],
    this.customPresets = const [],
    this.customBlocks = const [],
    required this.workMs,
    required this.restMs,
    required this.preparationMs,
    required this.remainingMs,
    required this.rounds,
    required this.currentRound,
    required this.isRunning,
    required this.isWork,
    required this.isPreparation,
    required this.currentBlockIndex,
    required this.isCustomWorkout,
    required this.isLoadingPresets,
    required this.tenSecAnnouncement,
    required this.thirtySecAnnouncement,
    required this.minuteAnnouncement,
    required this.isFinished,
    required this.finishRemainingMs,
    required this.allowSound,
    required this.allowVibration,
  });

  factory TimerState.initial() {
    return const TimerState(
      workMs: 180000,
      restMs: 60000,
      preparationMs: 10000,
      remainingMs: 10000,
      rounds: 3,
      currentRound: 1,
      isRunning: false,
      isWork: true,
      isPreparation: true,
      currentBlockIndex: 0,
      isCustomWorkout: false,
      isLoadingPresets: true,
      tenSecAnnouncement: true,
      thirtySecAnnouncement: true,
      minuteAnnouncement: true,
      isFinished: false,
      finishRemainingMs: 3000,
      allowSound: true,
      allowVibration: true,
    );
  }

  TimerState copyWith({
    TimerPreset? selectedPreset,
    TimerCustomPreset? selectedCustomPreset,
    List<TimerPreset>? savedTimerPresets,
    List<TimerCustomPreset>? customPresets,
    List<TimerBlock>? customBlocks,
    int? workMs,
    int? restMs,
    int? remainingMs,
    int? preparationMs,
    int? rounds,
    int? currentRound,
    int? currentBlockIndex,
    bool? isRunning,
    bool? isWork,
    bool? isPreparation,
    bool? isCustomWorkout,
    bool? isLoadingPresets,
    bool? tenSecAnnouncement,
    bool? thirtySecAnnouncement,
    bool? minuteAnnouncement,
    bool? isFinished,
    int? finishRemainingMs,
    bool? allowSound,
    bool? allowVibration,
    bool clearSelectedPreset = false,
    bool clearSelectedCustomPreset = false,
  }) {
    return TimerState(
      selectedPreset: clearSelectedPreset
          ? null
          : selectedPreset ?? this.selectedPreset,
      selectedCustomPreset: clearSelectedCustomPreset
          ? null
          : selectedCustomPreset ?? this.selectedCustomPreset,
      savedTimerPresets: savedTimerPresets ?? this.savedTimerPresets,
      customPresets: customPresets ?? this.customPresets,
      customBlocks: customBlocks ?? this.customBlocks,
      workMs: workMs ?? this.workMs,
      restMs: restMs ?? this.restMs,
      remainingMs: remainingMs ?? this.remainingMs,
      preparationMs: preparationMs ?? this.preparationMs,
      rounds: rounds ?? this.rounds,
      currentRound: currentRound ?? this.currentRound,
      currentBlockIndex: currentBlockIndex ?? this.currentBlockIndex,
      isRunning: isRunning ?? this.isRunning,
      isWork: isWork ?? this.isWork,
      isPreparation: isPreparation ?? this.isPreparation,
      isCustomWorkout: isCustomWorkout ?? this.isCustomWorkout,
      isLoadingPresets: isLoadingPresets ?? this.isLoadingPresets,
      tenSecAnnouncement: tenSecAnnouncement ?? this.tenSecAnnouncement,
      thirtySecAnnouncement:
          thirtySecAnnouncement ?? this.thirtySecAnnouncement,
      minuteAnnouncement: minuteAnnouncement ?? this.minuteAnnouncement,
      isFinished: isFinished ?? this.isFinished,
      finishRemainingMs: finishRemainingMs ?? this.finishRemainingMs,
      allowSound: allowSound ?? this.allowSound,
      allowVibration: allowVibration ?? this.allowVibration,
    );
  }
}
