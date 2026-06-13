import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:chelnok_boxing_timer/core/ads/ad_ids.dart';

class InterstitialAdService {
  InterstitialAdService._();

  static final InterstitialAdService instance = InterstitialAdService._();

  InterstitialAd? _interstitialAd;
  bool _isLoading = false;

  String? get _adUnitId {
    if (Platform.isAndroid) return AdIds.androidInterstitial;
    return null;
  }

  void loadInterstitialAd() {
    final adUnitId = _adUnitId;
    if (adUnitId == null || _isLoading || _interstitialAd != null) return;

    _isLoading = true;

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
