import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:chelnok_boxing_timer/core/ads/ad_ids.dart';

class InterstitialAdService {
  InterstitialAdService._();

  static final InterstitialAdService instance = InterstitialAdService._();

  InterstitialAd? _interstitialAd;
  bool _isInitialized = false;
  bool _isLoading = false;

  String? get _adUnitId {
    // Android only - not publishing on iOS
    if (Platform.isAndroid) return AdIds.androidInterstitial;
    return null;
  }

  Future<void> initialize() async {
    if (_isInitialized || _adUnitId == null) return;

    try {
      await MobileAds.instance.initialize();
      _isInitialized = true;
      loadInterstitialAd();
    } catch (error, stackTrace) {
      FlutterError.reportError(
        FlutterErrorDetails(
          exception: error,
          stack: stackTrace,
          library: 'ads',
          context: ErrorDescription('initializing Google Mobile Ads'),
        ),
      );
    }
  }

  void loadInterstitialAd() {
    final adUnitId = _adUnitId;
    if (!_isInitialized ||
        adUnitId == null ||
        _isLoading ||
        _interstitialAd != null) {
      return;
    }

    _isLoading = true;

    try {
      InterstitialAd.load(
        adUnitId: adUnitId,
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (ad) {
            _isLoading = false;
            _interstitialAd = ad;
          },
          onAdFailedToLoad: (_) {
            _isLoading = false;
            _interstitialAd = null;
          },
        ),
      );
    } catch (error, stackTrace) {
      _isLoading = false;
      FlutterError.reportError(
        FlutterErrorDetails(
          exception: error,
          stack: stackTrace,
          library: 'ads',
          context: ErrorDescription('loading an interstitial ad'),
        ),
      );
    }
  }

  void showInterstitialAd({VoidCallback? onComplete}) {
    final ad = _interstitialAd;

    if (ad == null) {
      loadInterstitialAd();
      onComplete?.call();
      return;
    }

    _interstitialAd = null;

    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        loadInterstitialAd();
        onComplete?.call();
      },
      onAdFailedToShowFullScreenContent: (ad, _) {
        ad.dispose();
        loadInterstitialAd();
        onComplete?.call();
      },
    );

    ad.show();
  }

  void dispose() {
    _interstitialAd?.dispose();
    _interstitialAd = null;
    _isLoading = false;
  }
}
