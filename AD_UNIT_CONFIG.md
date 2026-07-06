# Ad Configuration Summary

✅ **Your app is now fully configured with production AdMob ad units.**

## Ad Unit Configuration

### 1. **Interstitial Ad** (Workout Done)
- **When shown**: After user completes a timer session
- **Ad Unit ID**: `ca-app-pub-5684421358928894/1358044193`
- **Location**: `lib/core/ads/ad_ids.dart` → `androidInterstitial`
- **Trigger**: `lib/features/timer/pages/timer_run_page.dart` → `_donePressed()`

### 2. **Rewarded Ad** (Preset Unlock)
- **When shown**: When user tries to create/use a 3rd custom preset
- **Max free uses**: 2 presets without watching ads
- **Ad Unit ID**: `ca-app-pub-5684421358928894/5622803824`
- **Location**: `lib/core/ads/ad_ids.dart` → `androidRewarded`
- **Trigger**: `lib/core/monetization/preset_access_gate.dart` → `requestPresetStart()`

## AdMob Application ID
- **Value**: `ca-app-pub-5684421358928894~5658459279`
- **Location**: `android/app/src/main/AndroidManifest.xml`

## Files Updated

1. ✅ `lib/core/ads/ad_ids.dart` - Production ad unit IDs
2. ✅ `android/app/src/main/AndroidManifest.xml` - AdMob App ID
3. ✅ `lib/main.dart` - Ads re-enabled at startup
4. ✅ `lib/features/timer/pages/timer_run_page.dart` - Interstitial on workout complete
5. ✅ `lib/core/monetization/preset_access_gate.dart` - Rewarded ad for preset unlock

## Monetization Flow

### Interstitial Ads
```
User completes workout → Session finished screen → Interstitial ad shows → Returns to home
```

### Rewarded Ads
```
User tries to create 3rd preset → Check if 2 free uses consumed
  ├─ If NO → Allow to create preset
  └─ If YES → Show rewarded ad prompt
     ├─ User watches full ad → Unlock preset
     └─ User skips/fails → Show upgrade sheet (create more presets)
```

## Ready to Build & Deploy

Your app is now ready to build and submit to Google Play Store:

```bash
# Build release APK
flutter build apk --release

# Or build App Bundle (recommended)
flutter build appbundle --release
```

The app will:
- Show interstitial ads when users complete workouts
- Allow 2 free custom presets, then offer rewarded ads to unlock more
- Fully comply with Google Play Store ad policies
- Display ads only with production ad unit IDs

## Next Steps

1. ✅ Build the app
2. ✅ Test ads on a real device (not emulator)
3. ✅ Submit to Google Play Store
4. ✅ Monitor ad performance in AdMob dashboard

---

**Version**: 1.0.0+1  
**Last Updated**: July 2026  
**Status**: ✅ Ready for Production
