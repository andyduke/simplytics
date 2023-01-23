import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:simplytics/simplytics.dart';

class SimplyticsFirebaseAnalyticsService extends SimplyticsAnalyticsInterface {
  final FirebaseAnalytics analytics;

  SimplyticsFirebaseAnalyticsService(this.analytics);

  bool _enabled = true;

  @override
  Future<void> logEvent({required String name, Map<String, Object?>? parameters}) {
    return analytics.logEvent(name: name, parameters: parameters);
  }

  @override
  Future<void> resetAnalyticsData() {
    return analytics.resetAnalyticsData();
  }

  @override
  Future<void> routeStart({required String name, String? screenClassOverride}) {
    return analytics.setCurrentScreen(screenName: name, screenClassOverride: screenClassOverride ?? 'Flutter');
  }

  @override
  Future<void> routeEnd({required String name}) async {}

  @override
  Future<void> setUserId(String? id) {
    return analytics.setUserId(id: id);
  }

  @override
  Future<void> setUserProperty({required String name, required String? value}) {
    return analytics.setUserProperty(name: name, value: value);
  }

  @override
  bool get isEnabled => _enabled;

  @override
  Future<void> setEnabled(bool enabled) {
    _enabled = enabled;
    return analytics.setAnalyticsCollectionEnabled(enabled);
  }
}
