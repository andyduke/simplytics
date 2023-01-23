import 'package:simplytics/src/analytics/analytics_event.dart';

/// Exposes all analytic methods for implementation.
abstract class SimplyticsAnalyticsInterface {
  /// Log an event with the specified event [name] and [parameters] to the analytics service.
  Future<void> logEvent({
    required String name,
    Map<String, Object?>? parameters,
  });

  /// Log an [event] class to the analytics service.
  ///
  /// This makes it possible to use typed events, for example:
  /// ```dart
  /// Simplytics.analytics.log(PostScoreEvent(score: 777, level: 5, character: 'Dash'));
  /// ```
  /// See also:
  /// * [SimplyticsEvent] - an interface that allows you to create typed analytics events.
  Future<void> log(SimplyticsEvent event) {
    final eventData = event.getEventData(this);
    return logEvent(name: eventData.name, parameters: eventData.parameters);
  }

  /// Log this event when the user starts viewing the application screen [name] (and possibly [screenClassOverride]).
  Future<void> routeStart({
    required String name,
    String? screenClassOverride,
  });

  /// Log this event when the user ends viewing the [name] application screen.
  Future<void> routeEnd({
    required String name,
  });

  /// Sets a user [id] to associate with all app events.
  Future<void> setUserId(String? id);

  /// Sets the user property named [name] to the given [value].
  Future<void> setUserProperty({
    required String name,
    required String? value,
  });

  /// Resets all current analytics data.
  Future<void> resetAnalyticsData();

  /// Whether the analytics service collects events.
  /// If false, no events is sent to the service.
  ///
  /// See [setEnabled] to toggle the value.
  bool get isEnabled;

  /// Enables/disables automatic event collection using this service class.
  Future<void> setEnabled(bool enabled);
}
