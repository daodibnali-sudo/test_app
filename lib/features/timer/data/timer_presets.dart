import 'package:flutter/material.dart';
import 'package:chelnok_boxing_timer/features/timer/models/timer_quick_preset.dart';

const timerPresets = [
  TimerPreset(
    title: 'Boxing',
    subtitle: '3:00 / 1:00 - 3 rounds',
    icon: Icons.sports_mma,
    workMs: 180000,
    restMs: 60000,
    preparationMs: 10000,
    rounds: 3,
  ),
  TimerPreset(
    title: 'Amateur',
    subtitle: '2:00 / 1:00 - 3 rounds',
    icon: Icons.timer,
    workMs: 120000,
    restMs: 60000,
    preparationMs: 10000,
    rounds: 3,
  ),
  TimerPreset(
    title: 'HIIT',
    subtitle: '0:30 / 0:15 - 8 rounds',
    icon: Icons.bolt,
    workMs: 30000,
    restMs: 15000,
    preparationMs: 10000,
    rounds: 8,
  ),
];
