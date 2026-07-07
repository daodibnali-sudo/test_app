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
  static const int maxFreeCustomPresets = 1;
  static const String _rewardedStartsKey = 'rewarded_preset_starts';

  static Future<bool> requestPresetStart(BuildContext context) async {
    // Android only - not publishing on other platforms
    // if (!Platform.isAndroid) return true;

    if (await _isProActive()) return true;

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

  static Future<CustomPresetSaveAccess> requestCustomPresetSave(
    BuildContext context, {
    required int existingCustomPresetCount,
  }) async {
    if (await _isProActive()) return const CustomPresetSaveAccess.allowed();

    if (existingCustomPresetCount >= maxFreeCustomPresets) {
      if (!context.mounted) return const CustomPresetSaveAccess.denied();
      final upgraded = await _showCustomPresetUpgradeSheet(context);
      return CustomPresetSaveAccess(allowed: upgraded);
    }

    if (!context.mounted) return const CustomPresetSaveAccess.denied();
    final acceptedAd = await _showCustomPresetRewardPrompt(context);
    if (acceptedAd != true || !context.mounted) {
      return const CustomPresetSaveAccess.denied();
    }

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Loading rewarded ad...')));

    final earnedReward = await RewardedAdService.instance.showRewardedAd();
    if (!context.mounted) return const CustomPresetSaveAccess.denied();

    if (!earnedReward) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Watch the full ad to save this preset.'),
        ),
      );
      return const CustomPresetSaveAccess.denied();
    }

    return const CustomPresetSaveAccess(allowed: true, watchedAd: true);
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

  static Future<bool?> _showCustomPresetRewardPrompt(BuildContext context) {
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
                  'Save custom preset',
                  style: AppTextStyles.title.copyWith(
                    color: AppColors.textPrimary,
                    fontSize: 22,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Watch one rewarded ad to save your first custom preset. '
                  'Chelnok Pro unlocks unlimited custom presets.',
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

  static Future<bool> _showCustomPresetUpgradeSheet(BuildContext context) async {
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
                  'Unlimited custom presets',
                  style: AppTextStyles.title.copyWith(
                    color: AppColors.textPrimary,
                    fontSize: 22,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Free users can save 1 custom preset after watching an ad. '
                  'Upgrade to Chelnok Pro to save more custom presets.',
                  style: AppTextStyles.label.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 18),
                AppButton(
                  text: 'Upgrade to Chelnok Pro',
                  leading: const Icon(Icons.workspace_premium_outlined),
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
        return _presentPaywall(context);
      case _UpgradeAction.restore:
        return _restorePurchases(context);
      case null:
        return false;
    }
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
                  'You used your 2 rewarded ad starts. Upgrade to Chelnok Pro '
                  'for yearly or lifetime access.',
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
        return _presentPaywall(context);
      case _UpgradeAction.restore:
        return _restorePurchases(context);
      case null:
        return false;
    }
  }

  static Future<bool> _isProActive() async {
    try {
      return await RevenueCatService.instance.isProActive();
    } catch (_) {
      return false;
    }
  }

  static Future<bool> _presentPaywall(BuildContext context) async {
    try {
      return await RevenueCatService.instance.presentProPaywall();
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Unable to open Pro upgrade.')),
        );
      }
      return false;
    }
  }

  static Future<bool> _restorePurchases(BuildContext context) async {
    try {
      final customerInfo = await RevenueCatService.instance.restorePurchases();
      final isPro = RevenueCatService.instance.isProCustomer(customerInfo);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              isPro ? 'Chelnok Pro restored.' : 'No active Pro purchase found.',
            ),
          ),
        );
      }
      return isPro;
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Unable to restore purchases.')),
        );
      }
      return false;
    }
  }
}

class CustomPresetSaveAccess {
  const CustomPresetSaveAccess({
    required this.allowed,
    this.watchedAd = false,
  });

  const CustomPresetSaveAccess.allowed()
    : allowed = true,
      watchedAd = false;

  const CustomPresetSaveAccess.denied()
    : allowed = false,
      watchedAd = false;

  final bool allowed;
  final bool watchedAd;
}

enum _UpgradeAction { paywall, restore }
