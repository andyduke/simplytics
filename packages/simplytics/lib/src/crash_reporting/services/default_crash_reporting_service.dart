import 'package:simplytics/simplytics.dart';

/// The default error monitoring service (used if no other is installed via [Simplytics.setup])
/// is just a stub that does nothing.
class SimplyticsDefaultCrashlogService extends SimplyticsCrashlogInterface {
  bool _enabled = false;

  @override
  Future<void> log(String message) async {}

  @override
  Future<void> recordError(exception, StackTrace? stackTrace,
      {reason, bool fatal = false}) async {}

  @override
  Future<void> setCustomKey(String key, Object value) async {}

  @override
  Future<void> setUserId(String id) async {}

  @override
  bool get isEnabled => _enabled;

  @override
  Future<void> setEnabled(bool enabled) async => _enabled = enabled;
}
