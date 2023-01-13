import 'package:simplytics/simplytics.dart';

class SimplyticsAnalyticsServiceGroup implements SimplyticsAnalyticsInterface {
  final List<SimplyticsAnalyticsInterface> services;

  SimplyticsAnalyticsServiceGroup(this.services);

  @override
  Future<void> logEvent({required String name, Map<String, Object?>? parameters}) {
    return Future.wait(services.map((s) => s.logEvent(name: name, parameters: parameters)));
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
