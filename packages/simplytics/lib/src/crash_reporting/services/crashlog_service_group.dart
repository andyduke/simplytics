import 'package:simplytics/src/crash_reporting/crashlog_interface.dart';

/// A class that allows you to use several error monitoring services at the same time.
///
/// Example:
/// ```dart
/// Simplytics.setup(
///   crashlogService: SimplyticsCrashlogServiceGroup([
///     SimplyticsDebugCrashlogService(),
///     CustomCrashReportingService(),
///   ]),
/// );
/// ```
class SimplyticsCrashlogServiceGroup extends SimplyticsCrashlogInterface {
  /// List of service classes to which all calls to this group will be propagated.
  final List<SimplyticsCrashlogInterface> services;

  /// Creates an error monitoring service group,
  /// all calls to this group will be propagated to all specified service classes.
  SimplyticsCrashlogServiceGroup(this.services);

  @override
  Future<void> log(String message) {
    return Future.wait(services.map((s) => s.log(message)));
  }

  @override
  Future<void> recordError(exception, StackTrace? stackTrace, {reason, bool fatal = false}) {
    return Future.wait(services.map((s) => s.recordError(exception, stackTrace, reason: reason, fatal: fatal)));
  }

  @override
  Future<void> setCustomKey(String key, Object value) {
    return Future.wait(services.map((s) => s.setCustomKey(key, value)));
  }

  @override
  Future<void> setUserId(String id) {
    return Future.wait(services.map((s) => s.setUserId(id)));
  }

  @override
  bool get isEnabled => services.any((s) => s.isEnabled);

  @override
  Future<void> setEnabled(bool enabled) => Future.wait(services.map((s) => s.setEnabled(enabled)));
}
