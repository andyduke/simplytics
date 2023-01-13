import 'package:simplytics/src/analytics/analytics_interface.dart';
import 'package:simplytics/src/analytics/services/default_analytics_service.dart';
import 'package:simplytics/src/crash_reporting/crashlog_interface.dart';
import 'package:simplytics/src/crash_reporting/services/default_crash_reporting_service.dart';

abstract class Simplytics {
  static SimplyticsAnalyticsInterface get analytics => _analytics;
  static SimplyticsAnalyticsInterface _analytics = SimplyticsDefaultAnalyticsService();

  static SimplyticsCrashlogInterface get crashlog => _crashlog;
  static SimplyticsCrashlogInterface _crashlog = SimplyticsDefaultCrashlogService();

  static void setup({
    SimplyticsAnalyticsInterface? analyticsService,
    SimplyticsCrashlogInterface? crashlogService,
  }) {
    if (analyticsService != null) {
      _analytics = analyticsService;
    }
    if (crashlogService != null) {
      _crashlog = crashlogService;
    }
  }
}
