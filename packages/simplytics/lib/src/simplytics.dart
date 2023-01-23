import 'package:simplytics/src/analytics/analytics_interface.dart';
import 'package:simplytics/src/analytics/services/default_analytics_service.dart';
import 'package:simplytics/src/crash_reporting/crashlog_interface.dart';
import 'package:simplytics/src/crash_reporting/services/default_crash_reporting_service.dart';

/// The main Simplytics class that allows you to configure analytics and
/// error monitoring services and gives access to them through properties.
///
/// Before use, you must configure using the setup method:
/// ```dart
/// Simplytics.setup(
///   analyticsService: YourAnalyticsService(),
///   crashlogService: YourCrashReportingService(),
/// );
/// ```
/// After that, you can use it anywhere in your code:
/// ```dart
/// // Analytics
/// Simplytics.analytics.logEvent(name: 'your_event');
///
/// // Error reporting
/// Simplytics.crashlog.recordError('Some error', StackTrace.current);
/// ```
///
/// See also:
/// * [Simplytics.setup] - to set up analytics and error monitoring services;
/// * [Simplytics.analytics] - analytics service instance;
/// * [Simplytics.crashlog] - error monitoring service instance.
abstract class Simplytics {
  /// A reference to an instance of an analytics object that gives access to methods for
  /// sending events, setting a user id, etc.
  ///
  /// Gives easy access to the configured analytics service class:
  /// ```dart
  /// Simplytics.analytics.logEvent(name: 'your_event');
  /// ```
  static SimplyticsAnalyticsInterface get analytics => _analytics;
  static SimplyticsAnalyticsInterface _analytics =
      SimplyticsDefaultAnalyticsService();

  /// A reference to an instance of the error monitoring object, giving access to methods for
  /// sending error reports, etc.
  ///
  /// Gives easy access to the configured error monitoring service class:
  /// ```dart
  /// Simplytics.crashlog.recordError('Some error', StackTrace.current);
  /// ```
  static SimplyticsCrashlogInterface get crashlog => _crashlog;
  static SimplyticsCrashlogInterface _crashlog =
      SimplyticsDefaultCrashlogService();

  /// Set up analytics and error monitoring object instances.
  /// Must be called before sending events to analytics and error reporting.
  ///
  /// You can set up only one service, for example only the error monitoring service,
  /// if you do not need analytics.
  ///
  /// It is possible to configure several services of the same type at once
  /// using a group class, for example:
  /// ```dart
  /// Simplytics.setup(
  ///   crashlogService: SimplyticsCrashlogServiceGroup([
  ///     SimplyticsDebugCrashlogService(),
  ///     CustomCrashReportingService(),
  ///   ]),
  /// );
  /// ```
  /// See also:
  /// * [SimplyticsAnalyticsServiceGroup] - for grouping analytics services;
  /// * [SimplyticsCrashlogServiceGroup] - for grouping error monitoring services.
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
