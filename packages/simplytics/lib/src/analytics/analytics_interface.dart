/// Exposes all analytic methods for implementation.
abstract class SimplyticsAnalyticsInterface {
  /// Logs an event by [name] and possible [parameters].
  Future<void> logEvent({
    required String name,
    Map<String, Object?>? parameters,
  });

  /// Sets the user [id] of the current user that's logged in.
  Future<void> setUserId(String? id);

  /// Sets the new screen route to [name] and possible [screenClassOverride].
  Future<void> routeStart({
    required String name,
    String? screenClassOverride,
  });

  /// Ends the screen route for route [name].
  Future<void> routeEnd({
    required String name,
  });

  /// Sets a user property by [name] and [value].
  Future<void> setUserProperty({
    required String name,
    required String? value,
  });

  /// Resets all current analytics data.
  Future<void> resetAnalyticsData();
}
