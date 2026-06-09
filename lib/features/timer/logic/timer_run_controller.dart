import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:test_app/features/timer/providers/timer_provider.dart';

class TimerRunController {
  TimerRunController(this.ref);

  final WidgetRef ref;

  void startPause() {
    final timer = ref.read(timerProvider);
    final notifier = ref.read(timerProvider.notifier);

    if (timer.isRunning) {
      notifier.pause();
    } else {
      notifier.start();
    }
  }

  void reset() {
    ref.read(timerProvider.notifier).reset();
  }

  void skip() {
    ref.read(timerProvider.notifier).skip();
  }
}
