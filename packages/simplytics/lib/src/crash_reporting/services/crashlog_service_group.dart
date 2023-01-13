import 'package:simplytics/src/crash_reporting/crashlog_interface.dart';

class SimplyticsCrashlogServiceGroup extends SimplyticsCrashlogInterface {
  final List<SimplyticsCrashlogInterface> services;

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
  Future<void> setUserId(String identifier) {
    return Future.wait(services.map((s) => s.setUserId(identifier)));
  }
}
