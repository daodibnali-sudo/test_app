import 'package:audioplayers/audioplayers.dart';

class TimerSoundService {
  final AudioPlayer _startBellPlayer = AudioPlayer();
  final AudioPlayer _endBellPlayer = AudioPlayer();
  final AudioPlayer _beepPlayer = AudioPlayer();

  Future<void> playStartBell() async {
    await _startBellPlayer.play(
      AssetSource('sounds/bell_twice.mp3'),
    );
  }

  Future<void> playEndBell() async {
    await _endBellPlayer.play(
      AssetSource('sounds/bell_three_times.mp3'),
    );
  }

  Future<void> playCountdownBeep() async {
    await _beepPlayer.stop();

    await _beepPlayer.play(
      AssetSource('sounds/beep.mp3'),
    );
  }

  Future<void> dispose() async {
    await _startBellPlayer.dispose();
    await _endBellPlayer.dispose();
    await _beepPlayer.dispose();
  }
}