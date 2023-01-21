import 'package:simplytics/src/analytics/analytics_event.dart';
import 'package:simplytics/src/analytics/analytics_interface.dart';

/// A class that allows you to use multiple analytics services at the same time.
///
/// Example:
/// ```dart
/// Simplytics.setup(
///   analyticsService: SimplyticsAnalyticsServiceGroup([
///     SimplyticsDebugAnalyticsService(),
///     CustomAnalyticsService(),
///   ]),
/// );
/// ```
class SimplyticsAnalyticsServiceGroup extends SimplyticsAnalyticsInterface {
  /// List of service classes to which all calls to this group will be propagated.
  final List<SimplyticsAnalyticsInterface> services;

  /// Creates an analytics service group,
  /// all calls to this group will be propagated to all specified service classes.
  SimplyticsAnalyticsServiceGroup(this.services);

  @override
  Future<void> logEvent({required String name, Map<String, Object?>? parameters}) {
    return Future.wait(services.map((s) => s.logEvent(name: name, parameters: parameters)));
  }

  @override
  Future<void> log(SimplyticsEvent event) {
    return Future.wait(services.map((s) => s.log(event)));
  }

  @override
  Future<void> resetAnalyticsData() {
    return Future.wait(services.map((s) => s.resetAnalyticsData()));
  }

  @override
  Future<void> routeStart({required String name, String? screenClassOverride}) {
    return Future.wait(services.map((s) => s.routeStart(name: name, screenClassOverride: screenClassOverride)));
  }

  @override
  Future<void> routeEnd({required String name}) {
    return Future.wait(services.map((s) => s.routeEnd(name: name)));
  }

  @override
  Future<void> setUserId(String? id) {
    return Future.wait(services.map((s) => s.setUserId(id)));
  }

  @override
  Future<void> setUserProperty({required String name, required String? value}) {
    return Future.wait(services.map((s) => s.setUserProperty(name: name, value: value)));
  }
}
