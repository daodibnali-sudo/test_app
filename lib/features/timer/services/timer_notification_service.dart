import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:chelnok_boxing_timer/features/timer/formatters/timer_formatter.dart';
import 'package:chelnok_boxing_timer/features/timer/logic/timer_state.dart';

class TimerNotificationService {
  TimerNotificationService._();

  static final TimerNotificationService instance = TimerNotificationService._();

  static const pauseResumeActionId = 'timer_pause_resume';
  static const skipActionId = 'timer_skip';

  static const _notificationId = 1001;
  static const _channelId = 'active_timer_v2';
  static const _channelName = 'Active timer';
  static const _channelDescription = 'Shows the active boxing timer progress.';

  final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  bool _initialized = false;
  int? _lastShownSecond;
  String? _lastShownPhase;
  bool? _lastShownRunning;
  _PendingNotificationUpdate? _pendingUpdate;
  bool _syncInProgress = false;
  int _sessionCounter = 0;
  int? _activeSessionId;
  VoidCallback? _onPauseResume;
  VoidCallback? _onSkip;

  int beginSession() {
    _activeSessionId = ++_sessionCounter;
    _pendingUpdate = null;
    _lastShownSecond = null;
    _lastShownPhase = null;
    _lastShownRunning = null;
    return _activeSessionId!;
  }

  Future<void> endSession(int sessionId) async {
    if (_activeSessionId == sessionId) {
      _activeSessionId = null;
    }

    _pendingUpdate = null;
    await cancel();
  }

  void registerActions({VoidCallback? onPauseResume, VoidCallback? onSkip}) {
    _onPauseResume = onPauseResume;
    _onSkip = onSkip;
  }

  Future<void> initialize() async {
    if (_initialized || !Platform.isAndroid) return;

    try {
      const androidSettings = AndroidInitializationSettings(
        '@mipmap/ic_launcher',
      );
      const settings = InitializationSettings(android: androidSettings);

      await _notifications.initialize(
        settings: settings,
        onDidReceiveNotificationResponse: _handleNotificationResponse,
      );

      final android = _notifications
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >();

      await android?.requestNotificationsPermission();

      _initialized = true;
    } catch (error, stackTrace) {
      FlutterError.reportError(
        FlutterErrorDetails(
          exception: error,
          stack: stackTrace,
          library: 'timer notifications',
          context: ErrorDescription('initializing timer notification'),
        ),
      );
    }
  }

  Future<void> sync(TimerState timer, {required int sessionId}) async {
    if (_activeSessionId != sessionId) return;

    _pendingUpdate = _PendingNotificationUpdate(
      timer: timer,
      sessionId: sessionId,
    );
    if (_syncInProgress) return;

    _syncInProgress = true;

    try {
      while (_pendingUpdate != null) {
        final nextUpdate = _pendingUpdate;
        _pendingUpdate = null;

        if (nextUpdate != null) {
          await _showLatest(nextUpdate.timer, nextUpdate.sessionId);
        }
      }
    } finally {
      _syncInProgress = false;
    }
  }

  Future<void> _showLatest(TimerState timer, int sessionId) async {
    if (!Platform.isAndroid) return;
    if (_activeSessionId != sessionId) return;

    if (timer.isFinished || _isResetToStart(timer)) {
      await cancel();
      return;
    }

    await initialize();
    if (_activeSessionId != sessionId) return;
    if (!_initialized) return;

    final remainingSecond = (timer.remainingMs / 1000).ceil().clamp(0, 999999);
    final phaseName = timer.currentPhaseName;
    final shouldSkipUpdate =
        _lastShownSecond == remainingSecond &&
        _lastShownPhase == phaseName &&
        _lastShownRunning == timer.isRunning;

    if (shouldSkipUpdate) return;

    _lastShownSecond = remainingSecond;
    _lastShownPhase = phaseName;
    _lastShownRunning = timer.isRunning;

    final totalMs = timer.currentPhaseTotalMs;
    final elapsedMs = (totalMs - timer.remainingMs).clamp(0, totalMs);

    final progress = totalMs <= 0 ? 0 : (elapsedMs * 1000 ~/ totalMs);
    if (_activeSessionId != sessionId) return;

    await _notifications.show(
      id: _notificationId,
      title: 'Chelnok Boxing Timer',
      body: _notificationBody(timer, remainingSecond),
      notificationDetails: NotificationDetails(
        android: _androidDetails(
          progress: progress,
          body: _notificationBody(timer, remainingSecond),
        ),
      ),
    );
  }

  void _handleNotificationResponse(NotificationResponse response) {
    switch (response.actionId) {
      case pauseResumeActionId:
        _onPauseResume?.call();
        return;
      case skipActionId:
        _onSkip?.call();
        return;
    }
  }

  String _notificationBody(TimerState timer, int remainingSecond) {
    final remainingText = formatTime(remainingSecond * 1000);
    final phaseText = timer.isCustomWorkout
        ? timer.currentPhaseName
        : '${timer.currentPhaseName} - Round ${timer.currentRound}/${timer.rounds}';

    if (timer.isRunning) {
      return '$phaseText \u2022 $remainingText remaining';
    }

    return '$phaseText \u2022 Paused at $remainingText';
  }

  bool _isResetToStart(TimerState timer) {
    return !timer.isRunning &&
        timer.isPreparation &&
        timer.remainingMs == timer.preparationMs &&
        timer.currentRound == 1 &&
        timer.currentBlockIndex == 0;
  }

  AndroidNotificationDetails _androidDetails({
    required int progress,
    required String body,
  }) {
    return AndroidNotificationDetails(
      _channelId,
      _channelName,
      channelDescription: _channelDescription,
      importance: Importance.high,
      priority: Priority.max,
      ongoing: true,
      autoCancel: false,
      onlyAlertOnce: true,
      silent: true,
      playSound: false,
      enableVibration: false,
      showWhen: false,
      showProgress: true,
      maxProgress: 1000,
      progress: progress,
      category: AndroidNotificationCategory.alarm,
      // Android and OEM skins such as Xiaomi/HyperOS can still collapse
      // lock-screen actions; apps can request prominence but cannot force
      // action buttons to be visible in every collapsed notification layout.
      styleInformation: BigTextStyleInformation(body),
      visibility: NotificationVisibility.public,
      actions: <AndroidNotificationAction>[
        AndroidNotificationAction(
          pauseResumeActionId,
          _lastShownRunning == true ? 'Pause' : 'Resume',
          showsUserInterface: true,
          cancelNotification: false,
        ),
        const AndroidNotificationAction(
          skipActionId,
          'Skip',
          showsUserInterface: true,
          cancelNotification: false,
        ),
      ],
    );
  }

  Future<void> cancel() async {
    _pendingUpdate = null;

    if (!Platform.isAndroid) return;

    _lastShownSecond = null;
    _lastShownPhase = null;
    _lastShownRunning = null;

    if (!_initialized) return;

    await _notifications.cancel(id: _notificationId);
  }
}

class _PendingNotificationUpdate {
  const _PendingNotificationUpdate({
    required this.timer,
    required this.sessionId,
  });

  final TimerState timer;
  final int sessionId;
}
