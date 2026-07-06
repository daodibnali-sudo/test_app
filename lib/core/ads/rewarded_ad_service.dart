import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'package:chelnok_boxing_timer/core/ads/ad_ids.dart';

class RewardedAdService {
  RewardedAdService._();

  static final RewardedAdService instance = RewardedAdService._();

  RewardedAd? _rewardedAd;
  Future<RewardedAd?>? _loadFuture;
  bool _isInitialized = false;

  String? get _adUnitId {
    if (Platform.isAndroid) return AdIds.androidRewarded;
    return null;
  }

  Future<void> initialize() async {
    if (_isInitialized || _adUnitId == null) return;

    try {
      await MobileAds.instance.initialize();
      _isInitialized = true;
      unawaited(loadRewardedAd());
    } catch (error, stackTrace) {
      FlutterError.reportError(
        FlutterErrorDetails(
          exception: error,
          stack: stackTrace,
          library: 'ads',
          context: ErrorDescription('initializing rewarded ads'),
        ),
      );
    }
  }

  Future<RewardedAd?> loadRewardedAd() {
    final adUnitId = _adUnitId;
    if (adUnitId == null) return Future.value(null);
    if (_rewardedAd != null) return Future.value(_rewardedAd);
    final loadFuture = _loadFuture;
    if (loadFuture != null) return loadFuture;

    final completer = Completer<RewardedAd?>();
    _loadFuture = completer.future;

    RewardedAd.load(
      adUnitId: adUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          _rewardedAd = ad;
          _loadFuture = null;
          if (!completer.isCompleted) completer.complete(ad);
        },
        onAdFailedToLoad: (error) {
          _rewardedAd = null;
          _loadFuture = null;
          if (!completer.isCompleted) completer.complete(null);
        },
      ),
    ).catchError((Object error, StackTrace stackTrace) {
      _rewardedAd = null;
      _loadFuture = null;
      if (!completer.isCompleted) completer.complete(null);
      FlutterError.reportError(
        FlutterErrorDetails(
          exception: error,
          stack: stackTrace,
          library: 'ads',
          context: ErrorDescription('loading rewarded ad'),
        ),
      );
    });

    return completer.future.timeout(
      const Duration(seconds: 15),
      onTimeout: () {
        _loadFuture = null;
        return null;
      },
    );
  }

  Future<bool> showRewardedAd() async {
    if (_adUnitId == null) return false;

    await initialize();
    final ad = _rewardedAd ?? await loadRewardedAd();
    if (ad == null) return false;

    _rewardedAd = null;
    final completer = Completer<bool>();
    var earnedReward = false;

    void complete(bool value) {
      if (!completer.isCompleted) completer.complete(value);
    }

    ad.fullScreenContentCallback = FullScreenContentCallback<RewardedAd>(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        unawaited(loadRewardedAd());
        complete(earnedReward);
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        ad.dispose();
        unawaited(loadRewardedAd());
        complete(false);
      },
    );

    try {
      await ad.show(
        onUserEarnedReward: (_, _) {
          earnedReward = true;
        },
      );
    } catch (error, stackTrace) {
      ad.dispose();
      unawaited(loadRewardedAd());
      complete(false);
      FlutterError.reportError(
        FlutterErrorDetails(
          exception: error,
          stack: stackTrace,
          library: 'ads',
          context: ErrorDescription('showing rewarded ad'),
        ),
      );
    }

    return completer.future.timeout(
      const Duration(minutes: 2),
      onTimeout: () => earnedReward,
    );
  }

  void dispose() {
    _rewardedAd?.dispose();
    _rewardedAd = null;
    _loadFuture = null;
  }
}
