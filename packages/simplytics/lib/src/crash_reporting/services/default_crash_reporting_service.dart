import 'package:simplytics/simplytics.dart';

class SimplyticsDefaultCrashlogService extends SimplyticsCrashlogInterface {
  @override
  Future<void> log(String message) async {}

  @override
  Future<void> recordError(exception, StackTrace? stackTrace, {reason, bool fatal = false}) async {}

  @override
  Future<void> setCustomKey(String key, Object value) async {}

  @override
  Future<void> setUserId(String id) async {}
}
