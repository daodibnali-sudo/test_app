import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

import 'package:chelnok_boxing_timer/core/monetization/revenue_cat_config.dart';
import 'package:chelnok_boxing_timer/core/monetization/revenue_cat_service.dart';

final subscriptionProvider =
    NotifierProvider<SubscriptionNotifier, SubscriptionState>(
      SubscriptionNotifier.new,
    );

class SubscriptionState {
  const SubscriptionState({
    this.customerInfo,
    this.offerings,
    this.isLoading = true,
    this.errorMessage,
  });

  final CustomerInfo? customerInfo;
  final Offerings? offerings;
  final bool isLoading;
  final String? errorMessage;

  bool get isPro =>
      customerInfo?.entitlements.active.containsKey(
        RevenueCatConfig.proEntitlementId,
      ) ??
      false;

  SubscriptionState copyWith({
    CustomerInfo? customerInfo,
    Offerings? offerings,
    bool? isLoading,
    String? errorMessage,
    bool clearError = false,
  }) {
    return SubscriptionState(
      customerInfo: customerInfo ?? this.customerInfo,
      offerings: offerings ?? this.offerings,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }
}

class SubscriptionNotifier extends Notifier<SubscriptionState> {
  late final void Function(CustomerInfo) _customerInfoListener;

  @override
  SubscriptionState build() {
    _customerInfoListener = (customerInfo) {
      unawaited(
        Future<void>.microtask(() {
          if (!ref.mounted) return;
          state = state.copyWith(
            customerInfo: customerInfo,
            isLoading: false,
            clearError: true,
          );
        }),
      );
    };
    Purchases.addCustomerInfoUpdateListener(_customerInfoListener);
    ref.onDispose(
      () => Purchases.removeCustomerInfoUpdateListener(_customerInfoListener),
    );

    unawaited(Future<void>.microtask(refresh));
    return const SubscriptionState();
  }

  Future<void> refresh() async {
    if (!ref.mounted) return;
    state = state.copyWith(isLoading: true, clearError: true);

    try {
      final service = RevenueCatService.instance;
      await service.initialize();
      final customerInfo = await service.getCustomerInfo();
      final offerings = await service.getOfferings();

      if (!ref.mounted) return;
      state = state.copyWith(
        customerInfo: customerInfo,
        offerings: offerings,
        isLoading: false,
        clearError: true,
      );
    } on PlatformException catch (error) {
      if (!ref.mounted) return;
      state = state.copyWith(
        isLoading: false,
        errorMessage: error.message ?? 'RevenueCat request failed.',
      );
    } catch (_) {
      if (!ref.mounted) return;
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'RevenueCat is unavailable right now.',
      );
    }
  }

  Future<bool> presentProPaywall() async {
    try {
      final unlocked = await RevenueCatService.instance.presentProPaywall();
      await refresh();
      if (!ref.mounted) return unlocked;
      return unlocked || state.isPro;
    } on PlatformException catch (error) {
      if (!ref.mounted) return false;
      state = state.copyWith(
        isLoading: false,
        errorMessage: error.message ?? 'Unable to show the paywall.',
      );
      return false;
    } catch (_) {
      if (!ref.mounted) return false;
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Unable to show the paywall.',
      );
      return false;
    }
  }

  Future<bool> restorePurchases() async {
    if (!ref.mounted) return false;
    state = state.copyWith(isLoading: true, clearError: true);

    try {
      final customerInfo = await RevenueCatService.instance.restorePurchases();
      if (!ref.mounted) {
        return RevenueCatService.instance.isProCustomer(customerInfo);
      }
      state = state.copyWith(
        customerInfo: customerInfo,
        isLoading: false,
        clearError: true,
      );
      return state.isPro;
    } on PlatformException catch (error) {
      if (!ref.mounted) return false;
      state = state.copyWith(
        isLoading: false,
        errorMessage: error.message ?? 'Unable to restore purchases.',
      );
      return false;
    } catch (_) {
      if (!ref.mounted) return false;
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Unable to restore purchases.',
      );
      return false;
    }
  }

  Future<bool> presentCustomerCenter() async {
    try {
      await RevenueCatService.instance.presentCustomerCenter();
      await refresh();
      return true;
    } on PlatformException catch (error) {
      if (!ref.mounted) return false;
      state = state.copyWith(
        isLoading: false,
        errorMessage: error.message ?? 'Unable to open Customer Center.',
      );
      return false;
    } catch (_) {
      if (!ref.mounted) return false;
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Unable to open Customer Center.',
      );
      return false;
    }
  }
}
