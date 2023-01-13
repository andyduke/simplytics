import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:simplytics/simplytics.dart';

class SimplyticsFirebaseCrashlogService extends SimplyticsCrashlogInterface {
  final FirebaseCrashlytics crashlytics;

  SimplyticsFirebaseCrashlogService(this.crashlytics);

  @override
  Future<void> log(String message) {
    return crashlytics.log(message);
  }

  @override
  Future<void> recordError(exception, StackTrace? stackTrace, {reason, bool fatal = false}) {
    return crashlytics.recordError(exception, stackTrace, reason: reason, fatal: fatal);
  }

  @override
  Future<void> setCustomKey(String key, Object value) {
    return crashlytics.setCustomKey(key, value);
  }

  @override
  Future<void> setUserId(String identifier) {
    return crashlytics.setUserIdentifier(identifier);
  }
}