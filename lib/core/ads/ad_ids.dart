// Production Ad Unit IDs - Registered with Google AdMob
// Android only - not publishing on iOS
// Interstitial: Shown when workout is completed
// Rewarded: Shown to unlock additional presets (max 2 free uses)

class AdIds {
  const AdIds._();

  // Production Android Ad Unit IDs
  static const androidProductionInterstitial =
      'ca-app-pub-5684421358928894/1358044193';
  static const androidProductionRewarded =
      'ca-app-pub-5684421358928894/5622803824';

  static String get androidInterstitial => androidProductionInterstitial;

  static String get androidRewarded => androidProductionRewarded;
}
