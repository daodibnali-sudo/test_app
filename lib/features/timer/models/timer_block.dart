class TimerBlock {
  const TimerBlock({required this.name, required this.durationMs});

  final String name;
  final int durationMs;

  factory TimerBlock.fromJson(Map<String, dynamic> json) {
    return TimerBlock(
      name: json['name'] as String? ?? 'Block',
      durationMs: json['durationMs'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {'name': name, 'durationMs': durationMs};
  }

  TimerBlock copyWith({String? name, int? durationMs}) {
    return TimerBlock(
      name: name ?? this.name,
      durationMs: durationMs ?? this.durationMs,
    );
  }
}
