import 'package:simplytics/simplytics.dart';

class SimplyticsDefaultAnalyticsService extends SimplyticsAnalyticsInterface {
  @override
  Future<void> logEvent({required String name, Map<String, Object?>? parameters}) async {}

  @override
  Future<void> resetAnalyticsData() async {}

  @override
  Future<void> routeStart({required String name, String? screenClassOverride}) async {}

  @override
  Future<void> routeEnd({required String name}) async {}

  @override
  Future<void> setUserId(String? id) async {}

  @override
  Future<void> setUserProperty({required String name, required String? value}) async {}
}
