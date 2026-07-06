// Ad Configuration for Google Play Store Compliance
//
// IMPORTANT: This app is Android-only. Not publishing on iOS.
// All configuration is for Android platform only.
//
// IMPORTANT FOR PRODUCTION SUBMISSION:
// Before submitting to Google Play Store, verify:
//
// 1. Ad Unit IDs are from Google AdMob: https://admob.google.com/
// 2. Production ad unit IDs are correct (not test IDs)
// 3. AndroidManifest.xml has correct AdMob Application ID

class AdConfiguration {
  const AdConfiguration._();

  // PRODUCTION ANDROID AD UNIT IDS
  // Get these from https://admob.google.com/
  static const androidInterstitialAdUnitId =
      'ca-app-pub-5684421358928894/1358044193';
  static const androidRewardedAdUnitId =
      'ca-app-pub-5684421358928894/5622803824';

  /// Returns true if ads are properly configured for production
  static bool get isProductionConfigured =>
      androidInterstitialAdUnitId.isNotEmpty &&
      androidRewardedAdUnitId.isNotEmpty;

  /// Debug message showing current configuration status
  static String getConfigStatus() {
    final configured = isProductionConfigured;
    return configured
        ? 'Ads configured for Android production'
        : 'Ads not configured';
  }
}
