class RevenueCatConfig {
  const RevenueCatConfig._();

  static const apiKey = String.fromEnvironment(
    'REVENUECAT_API_KEY',
    defaultValue: 'goog_zUgKCSPiruwRDINZdOcfWTMCgBx',
  );

  static bool get usesTestStoreApiKey => apiKey.startsWith('test_');

  static const proEntitlementId = 'pro';

  static const lifetimeProductId = 'lifetime';
  static const subscriptionProductId = 'pro_v1:pro-early';
}
