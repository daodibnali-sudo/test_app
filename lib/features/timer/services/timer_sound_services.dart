import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_tts/flutter_tts.dart';

class TimerSoundService {
  final AudioPlayer _bellPlayer = AudioPlayer();
  final AudioPlayer _finishPlayer = AudioPlayer();
  final AudioPlayer _announcementPlayer = AudioPlayer();
  final AudioPlayer _beepPlayer = AudioPlayer();
  final FlutterTts _tts = FlutterTts();

  int _generation = 0;
  int _announcementGeneration = 0;
  bool _isDisposed = false;

  bool _isCurrent(int generation) {
    return !_isDisposed && generation == _generation;
  }

  Future<void> playBellRestarting() async {
    final generation = ++_generation;
    ++_announcementGeneration;

    await _stopPlayersAndTts();
    if (!_isCurrent(generation)) return;

    await _bellPlayer.play(AssetSource('sounds/bell_twice.mp3'));
  }

  Future<void> playFinishThreeBells() async {
    final generation = ++_generation;
    ++_announcementGeneration;

    await _stopPlayersAndTts();
    if (!_isCurrent(generation)) return;

    final completed = _finishPlayer.onPlayerComplete.first;
    await _finishPlayer.play(AssetSource('sounds/bell_three_times.mp3'));

    await Future.any([completed, _waitForCancellation(generation)]);
  }

  Future<void> speak(String text) async {
    final generation = ++_generation;
    ++_announcementGeneration;

    await _stopPlayersAndTts();
    if (!_isCurrent(generation)) return;

    await _tts.speak(text);
  }

  Future<void> stopAllAudio() async {
    ++_generation;
    ++_announcementGeneration;
    await _stopPlayersAndTts();
  }

  Future<void> playTimedBeepAnnouncement(String text) async {
    final generation = ++_announcementGeneration;

    await _stopAnnouncementAudio();
    if (!_isCurrentAnnouncement(generation)) return;

    final completed = _announcementPlayer.onPlayerComplete.first;
    await _announcementPlayer.play(AssetSource('sounds/beep.mp3'));

    await Future.any([
      completed,
      Future<void>.delayed(const Duration(milliseconds: 260)),
      _waitForAnnouncementCancellation(generation),
    ]);

    if (!_isCurrentAnnouncement(generation)) return;

    await _tts.speak(text);
  }

  Future<void> playKnockAnnouncement() async {
    final generation = ++_announcementGeneration;

    await _stopAnnouncementAudio();
    if (!_isCurrentAnnouncement(generation)) return;

    await _announcementPlayer.play(AssetSource('sounds/knock.mp3'));
  }

  Future<void> playCountdownBeep() async {
    if (_isDisposed) return;

    await _beepPlayer.stop();
    if (_isDisposed) return;

    await _beepPlayer.play(AssetSource('sounds/beep.mp3'));
  }

  Future<void> _waitForCancellation(int generation) {
    final completer = Completer<void>();
    Timer? timer;

    timer = Timer.periodic(const Duration(milliseconds: 50), (_) {
      if (_isCurrent(generation)) return;

      timer?.cancel();
      if (!completer.isCompleted) completer.complete();
    });

    return completer.future.whenComplete(() => timer?.cancel());
  }

  Future<void> _waitForAnnouncementCancellation(int generation) {
    final completer = Completer<void>();
    Timer? timer;

    timer = Timer.periodic(const Duration(milliseconds: 50), (_) {
      if (_isCurrentAnnouncement(generation)) return;

      timer?.cancel();
      if (!completer.isCompleted) completer.complete();
    });

    return completer.future.whenComplete(() => timer?.cancel());
  }

  bool _isCurrentAnnouncement(int generation) {
    return !_isDisposed && generation == _announcementGeneration;
  }

  Future<void> _stopAnnouncementAudio() async {
    await Future.wait([_announcementPlayer.stop(), _tts.stop()]);
  }

  Future<void> _stopPlayersAndTts() async {
    await Future.wait([
      _bellPlayer.stop(),
      _finishPlayer.stop(),
      _announcementPlayer.stop(),
      _beepPlayer.stop(),
      _tts.stop(),
    ]);
  }

  Future<void> dispose() async {
    _isDisposed = true;
    ++_generation;

    await _stopPlayersAndTts();

    await _bellPlayer.dispose();
    await _finishPlayer.dispose();
    await _announcementPlayer.dispose();
    await _beepPlayer.dispose();
  }
}
