import 'package:simplytics/simplytics.dart';
import 'dart:developer' as developer;

class CustomAnalyticsService extends SimplyticsAnalyticsInterface {
  @override
  Future<void> logEvent({required String name, Map<String, Object?>? parameters}) async {
    developer.log(
      '•• Event: $name${(parameters != null) ? ': $parameters' : ''}',
      name: 'Custom Analytics',
      level: 1,
    );
  }

  @override
  Future<void> resetAnalyticsData() async {
    // Do nothing
  }

  @override
  Future<void> routeStart({required String name, String? screenClassOverride}) async {
    developer.log(
      '•• Current Screen: $name${(screenClassOverride != null) ? ' ($screenClassOverride)' : ''}',
      name: 'Custom Analytics',
      level: 1,
    );
  }

  @override
  Future<void> routeEnd({required String name}) async {}

  @override
  Future<void> setUserId(String? id) async {
    developer.log(
      '•• Set User Id: "$id"',
      name: 'Custom Analytics',
      level: 1,
    );
  }

  @override
  Future<void> setUserProperty({required String name, required String? value}) async {
    developer.log(
      '•• Set User Property: $name="$value"',
      name: 'Custom Analytics',
    );
  }
}
