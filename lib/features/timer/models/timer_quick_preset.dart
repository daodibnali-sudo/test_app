import 'package:flutter/material.dart';

class TimerPreset {
  const TimerPreset({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.workMs,
    required this.restMs,
    required this.rounds,
    this.preparationMs = 10000,
  });

  final String title;
  final String subtitle;
  final IconData icon;

  final int workMs;
  final int restMs;
  final int rounds;
  final int preparationMs;

  factory TimerPreset.fromJson(Map<String, dynamic> json) {
    return TimerPreset(
      title: json['title'] as String? ?? 'Timer preset',
      subtitle: json['subtitle'] as String? ?? '',
      icon: Icons.timer,
      workMs: json['workMs'] as int? ?? 180000,
      restMs: json['restMs'] as int? ?? 60000,
      rounds: json['rounds'] as int? ?? 3,
      preparationMs: json['preparationMs'] as int? ?? 10000,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'subtitle': subtitle,
      'workMs': workMs,
      'restMs': restMs,
      'rounds': rounds,
      'preparationMs': preparationMs,
    };
  }
}
