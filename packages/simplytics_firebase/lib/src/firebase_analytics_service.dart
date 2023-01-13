import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:simplytics/simplytics.dart';

class SimplyticsFirebaseAnalyticsService implements SimplyticsAnalyticsInterface {
  final FirebaseAnalytics analytics;

  SimplyticsFirebaseAnalyticsService(this.analytics);

  @override
  Future<void> logEvent({required String name, Map<String, Object?>? parameters}) {
    return analytics.logEvent(name: name, parameters: parameters);
  }

  @override
  Future<void> resetAnalyticsData() {
    return analytics.resetAnalyticsData();
  }

  @override
  Future<void> setCurrentScreen({required String name, String? screenClassOverride}) {
    return analytics.setCurrentScreen(screenName: name, screenClassOverride: screenClassOverride ?? 'Flutter');
  }

  @override
  Future<void> setUserId(String? id) {
    return analytics.setUserId(id: id);
  }

  @override
  Future<void> setUserProperty({required String name, required String? value}) {
    return analytics.setUserProperty(name: name, value: value);
  }
}
