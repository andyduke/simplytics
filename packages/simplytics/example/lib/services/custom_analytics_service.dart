import 'package:simplytics/simplytics.dart';
import 'dart:developer' as developer;

class CustomAnalyticsService extends SimplyticsAnalyticsInterface {
  bool _enabled = true;

  @override
  Future<void> logEvent(
      {required String name, Map<String, Object?>? parameters}) async {
    if (_enabled) {
      developer.log(
        '•• Event: $name${(parameters != null) ? ': $parameters' : ''}',
        name: 'Custom Analytics',
        level: 1,
      );
    }
  }

  @override
  Future<void> resetAnalyticsData() async {
    // Do nothing
  }

  @override
  Future<void> routeStart(
      {required String name, String? screenClassOverride}) async {
    if (_enabled) {
      developer.log(
        '•• Current Screen: $name${(screenClassOverride != null) ? ' ($screenClassOverride)' : ''}',
        name: 'Custom Analytics',
        level: 1,
      );
    }
  }

  @override
  Future<void> routeEnd({required String name}) async {}

  @override
  Future<void> setUserId(String? id) async {
    if (_enabled) {
      developer.log(
        '•• Set User Id: "$id"',
        name: 'Custom Analytics',
        level: 1,
      );
    }
  }

  @override
  Future<void> setUserProperty(
      {required String name, required String? value}) async {
    if (_enabled) {
      developer.log(
        '•• Set User Property: $name="$value"',
        name: 'Custom Analytics',
      );
    }
  }

  @override
  bool get isEnabled => _enabled;

  @override
  Future<void> setEnabled(bool enabled) async => _enabled = enabled;
}
