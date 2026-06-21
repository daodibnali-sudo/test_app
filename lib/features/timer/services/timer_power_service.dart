import 'package:flutter/services.dart';

class TimerPowerService {
  const TimerPowerService._();

  static const MethodChannel _channel = MethodChannel('chelnok_timer/power');

  static Future<void> acquireRunWakeLock() async {
    try {
      await _channel.invokeMethod<void>('acquireRunWakeLock');
    } on PlatformException {
      // Best-effort Android reliability helper; the timer must still run if
      // the native wake lock is unavailable on another platform or device.
    }
  }

  static Future<void> releaseRunWakeLock() async {
    try {
      await _channel.invokeMethod<void>('releaseRunWakeLock');
    } on PlatformException {
      // See acquireRunWakeLock.
    }
  }
}
