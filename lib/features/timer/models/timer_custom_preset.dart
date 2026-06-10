import 'package:test_app/features/timer/models/timer_block.dart';

class TimerCustomPreset {
  const TimerCustomPreset({
    required this.name,
    required this.blocks,
    this.preparationMs = 10000,
  });

  final String name;
  final List<TimerBlock> blocks;
  final int preparationMs;

  factory TimerCustomPreset.fromJson(Map<String, dynamic> json) {
    final blockJson = json['blocks'] as List<dynamic>? ?? const [];

    return TimerCustomPreset(
      name: json['name'] as String? ?? 'Custom preset',
      preparationMs: json['preparationMs'] as int? ?? 10000,
      blocks: blockJson
          .whereType<Map<String, dynamic>>()
          .map(TimerBlock.fromJson)
          .toList(),
    );
  }

  int get totalMs {
    return preparationMs +
        blocks.fold(0, (total, block) => total + block.durationMs);
  }

  String get subtitle {
    final blockLabel = blocks.length == 1 ? 'block' : 'blocks';
    final minutes = totalMs ~/ 60000;
    final seconds = totalMs % 60000 ~/ 1000;
    final secondsText = seconds.toString().padLeft(2, '0');

    return '${blocks.length} $blockLabel - $minutes:$secondsText';
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'preparationMs': preparationMs,
      'blocks': blocks.map((block) => block.toJson()).toList(),
    };
  }
}
