import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:chelnok_boxing_timer/core/ads/rewarded_ad_service.dart';
import 'package:chelnok_boxing_timer/core/monetization/revenue_cat_service.dart';
import 'package:chelnok_boxing_timer/shared/theme/app_colors.dart';
import 'package:chelnok_boxing_timer/shared/theme/app_fonts.dart';
import 'package:chelnok_boxing_timer/widgets/button.dart';

class PresetAccessGate {
  const PresetAccessGate._();

  static const int maxRewardedPresetStarts = 2;
  static const String _rewardedStartsKey = 'rewarded_preset_starts';

  static Future<bool> requestPresetStart(BuildContext context) async {
    // Android only - not publishing on other platforms
    // if (!Platform.isAndroid) return true;

    if (await RevenueCatService.instance.isProActive()) return true;

    final prefs = await SharedPreferences.getInstance();
    final usedStarts = prefs.getInt(_rewardedStartsKey) ?? 0;

    if (usedStarts >= maxRewardedPresetStarts) {
      if (!context.mounted) return false;
      return _showUpgradeSheet(context);
    }

    if (!context.mounted) return false;
    final acceptedAd = await _showRewardPrompt(
      context,
      remainingStarts: maxRewardedPresetStarts - usedStarts,
    );
    if (acceptedAd != true || !context.mounted) return false;

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Loading rewarded ad...')));

    final earnedReward = await RewardedAdService.instance.showRewardedAd();
    if (!context.mounted) return false;

    if (!earnedReward) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Watch the full ad to start this preset.'),
        ),
      );
      return false;
    }

    await prefs.setInt(_rewardedStartsKey, usedStarts + 1);
    return true;
  }

  static Future<bool?> _showRewardPrompt(
    BuildContext context, {
    required int remainingStarts,
  }) {
    return showModalBottomSheet<bool>(
      context: context,
      backgroundColor: AppColors.blackSurface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(21, 18, 21, 21),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Start preset',
                  style: AppTextStyles.title.copyWith(
                    color: AppColors.textPrimary,
                    fontSize: 22,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Watch one rewarded ad to start this preset. You have '
                  '$remainingStarts free ad start${remainingStarts == 1 ? '' : 's'} left.',
                  style: AppTextStyles.label.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 18),
                AppButton(
                  text: 'Watch ad',
                  leading: const Icon(Icons.play_circle_outline),
                  backgroundColor: AppColors.cyanLight,
                  iconColor: AppColors.blackBg,
                  textColor: AppColors.blackBg,
                  onPressed: () => Navigator.pop(context, true),
                ),
                const SizedBox(height: 10),
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: Text(
                    'Not now',
                    style: TextStyle(color: AppColors.textSecondary),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  static Future<bool> _showUpgradeSheet(BuildContext context) async {
    final selectedAction = await showModalBottomSheet<_UpgradeAction>(
      context: context,
      backgroundColor: AppColors.blackSurface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(21, 18, 21, 21),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Unlock all presets',
                  style: AppTextStyles.title.copyWith(
                    color: AppColors.textPrimary,
                    fontSize: 22,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'You used your 2 rewarded ad starts. Next step is connecting '
                  'Google Play Billing with RevenueCat for yearly or lifetime access.',
                  style: AppTextStyles.label.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 18),
                AppButton(
                  text: 'Upgrade to Chelnok Pro',
                  leading: const Icon(Icons.calendar_month),
                  backgroundColor: AppColors.cyanLight,
                  iconColor: AppColors.blackBg,
                  textColor: AppColors.blackBg,
                  onPressed: () =>
                      Navigator.pop(context, _UpgradeAction.paywall),
                ),
                const SizedBox(height: 10),
                AppButton(
                  text: 'Restore purchases',
                  leading: const Icon(Icons.restore),
                  backgroundColor: AppColors.surfaceSoft,
                  borderColor: AppColors.borderSoft,
                  iconColor: AppColors.textPrimary,
                  textColor: AppColors.textPrimary,
                  onPressed: () =>
                      Navigator.pop(context, _UpgradeAction.restore),
                ),
                const SizedBox(height: 10),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    'Close',
                    style: TextStyle(color: AppColors.textSecondary),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );

    if (!context.mounted) return false;

    switch (selectedAction) {
      case _UpgradeAction.paywall:
        return RevenueCatService.instance.presentProPaywall();
      case _UpgradeAction.restore:
        final customerInfo = await RevenueCatService.instance
            .restorePurchases();
        return RevenueCatService.instance.isProCustomer(customerInfo);
      case null:
        return false;
    }
  }
}

enum _UpgradeAction { paywall, restore }
