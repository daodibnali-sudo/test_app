# Google Play Store Submission Checklist

## Overview
This app is now prepared for initial Google Play Store submission. The following steps outline how to complete the review process and enable monetization features.

---

## ✅ What Has Been Fixed

### 1. **Version Updated**
- Changed from `0.1.1+4` → `1.0.0+1`
- File: `pubspec.yaml`

### 2. **App Description Improved**
- Updated with professional feature list and benefit-focused description
- File: `README.md`

### 3. **Legal Documents Created**
- **Privacy Policy**: `lib/features/legal/data/privacy_policy.dart`
- **Terms of Service**: `lib/features/legal/data/terms_of_service.dart`
- Both documents cover:
  - Data collection practices
  - Third-party services (Google Mobile Ads)
  - User rights and responsibilities
  - Limitation of liability

### 4. **App Display Name**
- Verified: Android shows "Chelnok Boxing Timer"
- File: `android/app/src/main/AndroidManifest.xml`

### 5. **Ads Disabled (Temporarily)**
- Test ad IDs removed to prevent Play Store rejection
- All ad initialization commented out in `main.dart`
- Preset access gate allows free access without rewarded ads
- Files modified:
  - `lib/main.dart`
  - `lib/core/ads/ad_ids.dart` (marked with warnings)
  - `lib/features/timer/pages/timer_run_page.dart`
  - `lib/core/monetization/preset_access_gate.dart`

### 6. **AdMob Configuration Files Created**
- `lib/core/ads/ad_configuration.dart` - Explains what needs to be done
- Ready for production ad unit IDs

---

## 🔴 Critical: Before Publishing

### Step 1: Register for Google AdMob
1. Go to https://admob.google.com/
2. Sign in with your Google account
3. Click "Sign up for AdMob"
4. Follow the registration process
5. Accept the policies

### Step 2: Add Your App to AdMob
1. In AdMob console, click "Apps" → "Add app"
2. Select Android
3. Choose "Create a new app"
4. Enter app name: "Chelnok Boxing Timer"
5. Accept policies
6. You'll receive an **AdMob Application ID**

### Step 3: Create Ad Units
1. Go to "Ad units" section
2. Create an **Interstitial Ad Unit**
   - Give it a name, e.g., "Interstitial - Workout End"
   - Note the **Ad Unit ID** (looks like: `ca-app-pub-xxxxxxxxxxxxxxxx/yyyyyyyyyyyy`)
3. Create a **Rewarded Ad Unit**
   - Give it a name, e.g., "Rewarded - Custom Presets"
   - Note the **Ad Unit ID**

### Step 4: Update App with Production Ad IDs
Replace the test IDs in your app:

**File: `lib/core/ads/ad_ids.dart`**
```dart
class AdIds {
  const AdIds._();

  // Replace these with your REAL ad unit IDs from AdMob
  static const androidInterstitial = 'ca-app-pub-YOUR_ID_HERE/1234567890';
  static const androidRewarded = 'ca-app-pub-YOUR_ID_HERE/0987654321';
  static const iosInterstitial = null; // Leave null if not publishing on iOS
}
```

### Step 5: Update AndroidManifest.xml with AdMob App ID
**File: `android/app/src/main/AndroidManifest.xml`**

Find this section and add back the AdMob Application ID:
```xml
<meta-data
    android:name="com.google.android.gms.ads.APPLICATION_ID"
    android:value="ca-app-pub-xxxxxxxxxxxxxxxx~zzzzzzzzzz" />
```

### Step 6: Re-enable Ads in Code
**File: `lib/main.dart`**
```dart
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  
  // Re-enable these:
  unawaited(InterstitialAdService.instance.initialize());
  unawaited(RewardedAdService.instance.initialize());
  
  // ... rest of code
}
```

Also re-enable disposal:
```dart
@override
void dispose() {
  InterstitialAdService.instance.dispose();
  RewardedAdService.instance.dispose();
  super.dispose();
}
```

### Step 7: Re-enable Monetization Features
**File: `lib/core/monetization/preset_access_gate.dart`**

Uncomment the original rewarded ad logic (currently commented out starting at line ~20)

**File: `lib/features/timer/pages/timer_run_page.dart`**

Re-enable the interstitial ad call:
```dart
InterstitialAdService.instance.showInterstitialAd(
  onComplete: _openTimerSetPage,
);
```

---

## 📋 Google Play Store Submission Steps

### 1. Set Up Google Play Developer Account
- Go to https://play.google.com/console
- Register with Google account (requires $25 one-time fee)
- Complete developer profile and merchant setup

### 2. Create New App Listing
- Click "Create app"
- Enter app name: "Chelnok Boxing Timer"
- Select language and category
- Follow setup wizard

### 3. Fill in App Details
- **App name**: Chelnok Boxing Timer
- **Short description**: A professional boxing timer for fighters with customizable rounds, sound announcements, and workout tracking.
- **Full description**: Use content from `README.md`
- **Category**: Sports (Boxing)
- **Content rating**: Complete the questionnaire
  - Indicate no mature content, violence, etc.
- **Privacy policy**: https://sites.google.com/view/chelnok-studios/privacy-policy
- **Terms of service**: https://sites.google.com/view/chelnok-studios/terms-of-service (or create URL)

### 4. Add Store Listing Assets
- **App icon**: Design a professional 512x512 icon
- **Feature graphic**: 1024x500 banner image
- **Screenshots**: Upload 2-5 Android screenshots showing:
  - Timer setup screen
  - Timer running
  - Settings/presets
  - History view
- **Video preview**: Optional 15-30 second demo (recommended)

### 5. Build and Upload APK/AAB
- Build release build:
  ```bash
  flutter build appbundle --release
  ```
- Or for APK:
  ```bash
  flutter build apk --release
  ```
- Upload to Play Console under "Releases" → "Production"

### 6. Pricing and Distribution
- Select "Free" (or add pricing)
- Choose countries for distribution
- Set content rating (already completed)

### 7. Review and Publish
- Review all details
- Click "Send to review"
- Google will review within 24-48 hours
- Once approved, app appears in Play Store

---

## 🛠 Testing Before Submission

### Local Testing
```bash
# Install debug APK on device
flutter run

# Test all features:
# - Timer creation with various durations
# - Round transitions
# - Sound announcements
# - Vibration feedback
# - Settings changes
# - Theme switching
# - Language switching
```

### Test on Multiple Devices
- Test on Android 6.0+ devices if possible
- Different screen sizes (phone, tablet)
- Portrait mode (as configured)

---

## ⚠️ Important Reminders

1. **Never use test ad IDs in production** - Always use your real AdMob ad unit IDs
2. **Keep privacy policy accessible** - Link must work in Settings
3. **Test all features** - Ensure no crashes during usage
4. **Check permissions** - Users must be able to grant/revoke:
   - Vibrate
   - Post notifications
5. **Keep assets professional** - App icons and screenshots matter for conversions

---

## 📞 Support

If you encounter issues:

1. **AdMob Integration**: https://developers.google.com/admob/flutter/start
2. **Google Play Developer Help**: https://support.google.com/googleplay/android-developer
3. **Flutter Deployment**: https://flutter.dev/docs/deployment/android

---

## 🎯 Next Steps

1. ✅ Create AdMob account
2. ✅ Get production ad unit IDs
3. ✅ Update app code with real IDs
4. ✅ Build release APK/AAB
5. ✅ Create Google Play developer account
6. ✅ Upload to Play Console
7. ✅ Submit for review
8. ✅ Monitor review status
9. ✅ Address any feedback
10. ✅ Publish to Play Store

---

Version: 1.0.0
Last Updated: July 2026
