import 'package:simplytics/simplytics.dart';

/// The default analytics service (used if no other is installed via [Simplytics.setup])
/// is just a stub that does nothing.
class SimplyticsDefaultAnalyticsService extends SimplyticsAnalyticsInterface {
  bool _enabled = false;

  @override
  Future<void> logEvent(
      {required String name, Map<String, Object?>? parameters}) async {}

  @override
  Future<void> resetAnalyticsData() async {}

  @override
  Future<void> routeStart(
      {required String name, String? screenClassOverride}) async {}

  @override
  Future<void> routeEnd({required String name}) async {}

  @override
  Future<void> setUserId(String? id) async {}

  @override
  Future<void> setUserProperty(
      {required String name, required String? value}) async {}

  @override
  bool get isEnabled => _enabled;

  @override
  Future<void> setEnabled(bool enabled) async => _enabled = enabled;
}
