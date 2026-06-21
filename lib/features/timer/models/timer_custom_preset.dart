import 'package:chelnok_boxing_timer/features/timer/models/timer_block.dart';

class TimerCustomPreset {
  const TimerCustomPreset({
    required this.name,
    required this.blocks,
    this.preparationMs = 10000,
    this.sets = 1,
  });

  final String name;
  final List<TimerBlock> blocks;
  final int preparationMs;
  final int sets;

  factory TimerCustomPreset.fromJson(Map<String, dynamic> json) {
    final blockJson = json['blocks'] as List<dynamic>? ?? const [];

    return TimerCustomPreset(
      name: json['name'] as String? ?? 'Custom preset',
      preparationMs: json['preparationMs'] as int? ?? 10000,
      sets: (json['sets'] as int? ?? 1).clamp(1, 99),
      blocks: blockJson
          .whereType<Map<String, dynamic>>()
          .map(TimerBlock.fromJson)
          .toList(),
    );
  }

  int get totalMs {
    return preparationMs +
        (blocks.fold(0, (total, block) => total + block.durationMs) * sets);
  }

  String get subtitle {
    final blockLabel = blocks.length == 1 ? 'block' : 'blocks';
    final setLabel = sets == 1 ? 'set' : 'sets';
    final setSuffix = sets > 1 ? ' x $sets $setLabel' : '';
    final workDurations = blocks
        .where((block) => !block.name.toLowerCase().contains('rest'))
        .map((block) => block.durationMs)
        .toSet();
    final restDurations = blocks
        .where((block) => block.name.toLowerCase().contains('rest'))
        .map((block) => block.durationMs)
        .toSet();

    if (workDurations.length == 1 && restDurations.length == 1) {
      return '${_formatMs(workDurations.single)} / '
          '${_formatMs(restDurations.single)} - '
          '${blocks.length} $blockLabel$setSuffix';
    }

    return '${blocks.length} $blockLabel$setSuffix - Mixed';
  }

  String _formatMs(int durationMs) {
    final minutes = durationMs ~/ 60000;
    final seconds = durationMs % 60000 ~/ 1000;

    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'preparationMs': preparationMs,
      'sets': sets,
      'blocks': blocks.map((block) => block.toJson()).toList(),
    };
  }
}
