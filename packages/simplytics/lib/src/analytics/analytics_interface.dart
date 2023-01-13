/// Exposes all analytic methods for implementation.
abstract class SimplyticsAnalyticsInterface {
  /// Logs an event by [name] and possible [parameters].
  Future<void> logEvent({
    required String name,
    Map<String, Object?>? parameters,
  });

  /// Sets the user [id] of the current user that's logged in.
  Future<void> setUserId(String? id);

  /// Sets the current screen by [name] and possible [screenClassOverride].
  Future<void> setCurrentScreen({
    required String name,
    String? screenClassOverride,
  });

  /// Sets a user property by [name] and [value].
  Future<void> setUserProperty({
    required String name,
    required String? value,
  });

  /// Resets all current analytics data.
  Future<void> resetAnalyticsData();
}