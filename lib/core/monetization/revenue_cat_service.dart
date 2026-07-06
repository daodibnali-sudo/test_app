import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:purchases_ui_flutter/purchases_ui_flutter.dart';

import 'package:chelnok_boxing_timer/core/monetization/revenue_cat_config.dart';

class RevenueCatService {
  RevenueCatService._();

  static final RevenueCatService instance = RevenueCatService._();

  Future<void>? _initializeFuture;

  bool get _isSupportedPlatform =>
      defaultTargetPlatform == TargetPlatform.android ||
      defaultTargetPlatform == TargetPlatform.iOS;

  Future<void> initialize() {
    if (!_isSupportedPlatform) return Future.value();
    return _initializeFuture ??= _configure();
  }

  Future<void> _configure() async {
    try {
      if (await Purchases.isConfigured) return;

      await Purchases.setLogLevel(kDebugMode ? LogLevel.debug : LogLevel.warn);
      await Purchases.configure(
        PurchasesConfiguration(RevenueCatConfig.apiKey),
      );
    } catch (error, stackTrace) {
      _initializeFuture = null;
      FlutterError.reportError(
        FlutterErrorDetails(
          exception: error,
          stack: stackTrace,
          library: 'revenue_cat',
          context: ErrorDescription('configuring RevenueCat'),
        ),
      );
      rethrow;
    }
  }

  Future<CustomerInfo?> getCustomerInfo() async {
    if (!_isSupportedPlatform) return null;
    await initialize();
    return Purchases.getCustomerInfo();
  }

  Future<Offerings?> getOfferings() async {
    if (!_isSupportedPlatform) return null;
    await initialize();
    return Purchases.getOfferings();
  }

  Future<bool> isProActive() async {
    final customerInfo = await getCustomerInfo();
    return isProCustomer(customerInfo);
  }

  bool isProCustomer(CustomerInfo? customerInfo) {
    return customerInfo?.entitlements.active.containsKey(
          RevenueCatConfig.proEntitlementId,
        ) ??
        false;
  }

  Future<CustomerInfo?> purchasePackage(Package package) async {
    if (!_isSupportedPlatform) return null;
    await initialize();

    try {
      final result = await Purchases.purchase(PurchaseParams.package(package));
      return result.customerInfo;
    } on PlatformException catch (error) {
      final errorCode = PurchasesErrorHelper.getErrorCode(error);
      if (errorCode == PurchasesErrorCode.purchaseCancelledError) {
        return null;
      }
      rethrow;
    }
  }

  Future<CustomerInfo?> restorePurchases() async {
    if (!_isSupportedPlatform) return null;
    await initialize();
    return Purchases.restorePurchases();
  }

  Future<bool> presentProPaywall() async {
    if (!_isSupportedPlatform) return false;
    await initialize();

    final result = await RevenueCatUI.presentPaywallIfNeeded(
      RevenueCatConfig.proEntitlementId,
      displayCloseButton: true,
    );

    return switch (result) {
      PaywallResult.notPresented ||
      PaywallResult.purchased ||
      PaywallResult.restored => true,
      PaywallResult.cancelled || PaywallResult.error => false,
    };
  }

  Future<void> presentCustomerCenter() async {
    if (!_isSupportedPlatform) return;
    await initialize();
    await RevenueCatUI.presentCustomerCenter();
  }
}
