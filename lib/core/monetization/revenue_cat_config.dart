class RevenueCatConfig {
  const RevenueCatConfig._();

  static const apiKey = String.fromEnvironment(
    'REVENUECAT_API_KEY',
    defaultValue: 'test_TrQmGqDrDgOQjzlHabDanzHqJVD',
  );

  static const proEntitlementId = 'chelnok Pro';

  static const lifetimeProductId = 'lifetime';
  static const yearlyProductId = 'yearly';
}
