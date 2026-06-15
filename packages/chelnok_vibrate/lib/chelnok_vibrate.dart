import 'package:flutter/services.dart';

class ChelnokVibrate {
  static const MethodChannel _channel = MethodChannel(
    'chelnok_vibrate/methods',
  );

  static Future<bool> hasVibrator() async {
    return await _channel.invokeMethod<bool>('hasVibrator') ?? false;
  }

  static Future<void> vibrate(Duration duration) async {
    await _channel.invokeMethod<void>('vibrate', {
      'duration': duration.inMilliseconds,
    });
  }

  static Future<void> vibratePattern(List<Duration> timings) async {
    await _channel.invokeMethod<void>('vibratePattern', {
      'timings': timings.map((duration) => duration.inMilliseconds).toList(),
    });
  }

  static Future<void> cancel() async {
    await _channel.invokeMethod<void>('cancel');
  }
}
