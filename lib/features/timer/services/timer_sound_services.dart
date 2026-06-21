import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_tts/flutter_tts.dart';

class TimerSoundService {
  TimerSoundService() {
    _ready = _configureAudio();
  }

  final AudioPlayer _bellPlayer = AudioPlayer();
  final AudioPlayer _finishPlayer = AudioPlayer();
  final AudioPlayer _announcementPlayer = AudioPlayer();
  final AudioPlayer _beepPlayer = AudioPlayer();
  final FlutterTts _tts = FlutterTts();

  late final Future<void> _ready;

  static final AudioContext _timerAudioContext = AudioContext(
    android: const AudioContextAndroid(
      stayAwake: true,
      contentType: AndroidContentType.sonification,
      usageType: AndroidUsageType.alarm,
      audioFocus: AndroidAudioFocus.gainTransientMayDuck,
    ),
    iOS: AudioContextIOS(category: AVAudioSessionCategory.playback),
  );

  static final AssetSource _bellTwiceSource = AssetSource(
    'sounds/bell_twice.mp3',
  );
  static final AssetSource _bellThreeTimesSource = AssetSource(
    'sounds/bell_three_times.mp3',
  );
  static final AssetSource _beepSource = AssetSource('sounds/beep.mp3');
  static final AssetSource _knockSource = AssetSource('sounds/knock.mp3');

  int _generation = 0;
  int _announcementGeneration = 0;
  bool _isDisposed = false;
  String _ttsLanguage = 'en-US';

  bool _isCurrent(int generation) {
    return !_isDisposed && generation == _generation;
  }

  Future<void> playBellRestarting({String? announcement}) async {
    final generation = ++_generation;
    ++_announcementGeneration;

    await _ready;
    await _stopPlayersAndTts();
    if (!_isCurrent(generation)) return;

    final completed = _bellPlayer.onPlayerComplete.first;
    await _bellPlayer.play(_bellTwiceSource);

    if (announcement == null || announcement.isEmpty) return;

    await Future.any([
      completed,
      Future<void>.delayed(const Duration(milliseconds: 750)),
      _waitForCancellation(generation),
    ]);

    if (!_isCurrent(generation)) return;

    await _speakNow(announcement);
  }

  Future<void> playFinishThreeBells() async {
    final generation = ++_generation;
    ++_announcementGeneration;

    await _ready;
    await _stopPlayersAndTts();
    if (!_isCurrent(generation)) return;

    final completed = _finishPlayer.onPlayerComplete.first;
    await _finishPlayer.play(_bellThreeTimesSource);

    await Future.any([completed, _waitForCancellation(generation)]);
  }

  Future<void> speak(String text) async {
    final generation = ++_generation;
    ++_announcementGeneration;

    await _ready;
    await _stopPlayersAndTts();
    if (!_isCurrent(generation)) return;

    await _speakNow(text);
  }

  Future<void> stopAllAudio() async {
    ++_generation;
    ++_announcementGeneration;
    await _stopPlayersAndTts();
  }

  Future<void> setLanguage(String languageCode) async {
    await _ready;
    if (_isDisposed || _ttsLanguage == languageCode) return;

    final nextLanguage = await _availableTtsLanguage(languageCode);
    _ttsLanguage = nextLanguage;

    try {
      await _tts.setLanguage(nextLanguage);
    } catch (_) {
      _ttsLanguage = 'en-US';
      await _tts.setLanguage(_ttsLanguage);
    }
  }

  Future<void> playTimedBeepAnnouncement(String text) async {
    final generation = ++_announcementGeneration;

    await _ready;
    await _announcementPlayer.stop();
    if (!_isCurrentAnnouncement(generation)) return;

    final completed = _announcementPlayer.onPlayerComplete.first;
    await _announcementPlayer.play(_beepSource);

    await Future.any([
      completed,
      Future<void>.delayed(const Duration(milliseconds: 260)),
      _waitForAnnouncementCancellation(generation),
    ]);

    if (!_isCurrentAnnouncement(generation)) return;

    await _speakNow(text);
  }

  Future<void> playKnockAnnouncement() async {
    final generation = ++_announcementGeneration;

    await _ready;
    await _announcementPlayer.stop();
    if (!_isCurrentAnnouncement(generation)) return;

    await _announcementPlayer.play(_knockSource);
  }

  Future<void> playCountdownBeep() async {
    if (_isDisposed) return;

    await _ready;
    await _beepPlayer.stop();
    if (_isDisposed) return;

    await _beepPlayer.play(_beepSource);
  }

  Future<void> _configureAudio() async {
    await Future.wait([
      _configurePlayer(_bellPlayer, _bellTwiceSource),
      _configurePlayer(_finishPlayer, _bellThreeTimesSource),
      _configurePlayer(_announcementPlayer, _beepSource),
      _configurePlayer(_beepPlayer, _beepSource),
    ]);
    await _tts.awaitSpeakCompletion(false);
    await _tts.setQueueMode(0);
    await _tts.setLanguage(_ttsLanguage);
  }

  Future<String> _availableTtsLanguage(String languageCode) async {
    try {
      final isAvailable = await _tts.isLanguageAvailable(languageCode);
      if (isAvailable == true) return languageCode;
    } catch (_) {
      // Fall through to the stable English default if the platform cannot
      // report language availability.
    }

    return 'en-US';
  }

  Future<void> _configurePlayer(AudioPlayer player, AssetSource source) async {
    await player.setAudioContext(_timerAudioContext);
    await player.setReleaseMode(ReleaseMode.stop);
    await player.setSource(source);
  }

  Future<void> _speakNow(String text) async {
    await _tts.stop();
    if (_isDisposed) return;

    await _tts.speak(text, focus: true);
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
