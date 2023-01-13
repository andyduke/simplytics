import 'package:flutter/foundation.dart';
import 'package:simplytics/simplytics.dart';
import 'dart:developer' as developer;

class SimplyticsDebugAnalyticsService implements SimplyticsAnalyticsInterface {
  final bool enabled;

  SimplyticsDebugAnalyticsService([this.enabled = kDebugMode]);

  static const _serviceName = 'Analytics';

  @override
  Future<void> logEvent({required String name, Map<String, Object?>? parameters}) async {
    if (enabled) {
      developer.log(
        '• Event: $name${(parameters != null) ? ': $parameters' : ''}',
        name: _serviceName,
        level: 1,
      );
    }
  }

  @override
  Future<void> resetAnalyticsData() async {
    // Do nothing
  }

  @override
  Future<void> routeStart({required String name, String? screenClassOverride}) async {
    if (enabled) {
      developer.log(
        '• Enter route: $name${(screenClassOverride != null) ? ' ($screenClassOverride)' : ''}',
        name: _serviceName,
        level: 1,
      );
    }
  }

  @override
  Future<void> routeEnd({required String name}) async {
    if (enabled) {
      developer.log(
        '• Exit route: $name',
        name: _serviceName,
        level: 1,
      );
    }
  }

  @override
  Future<void> setUserId(String? id) async {
    if (enabled) {
      developer.log(
        '• Set User Id: "$id"',
        name: _serviceName,
        level: 1,
      );
    }
  }

  @override
  Future<void> setUserProperty({required String name, required String? value}) async {
    if (enabled) {
      developer.log(
        '• Set User Property: $name="$value"',
        name: _serviceName,
      );
    }
  }
}
