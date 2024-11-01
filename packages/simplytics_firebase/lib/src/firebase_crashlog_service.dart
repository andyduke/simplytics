import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:simplytics/simplytics.dart';

/// Implementation of the Firebase Crashlytics service for Simplytics.
///
/// Used when configuring Simplytics:
/// ```dart
/// await Firebase.initializeApp();
/// Simplytics.setup(
///   crashlogService: SimplyticsFirebaseCrashlogService(FirebaseCrashlytics.instance),
/// );
/// ```
class SimplyticsFirebaseCrashlogService extends SimplyticsCrashlogInterface {
  final FirebaseCrashlytics crashlytics;

  SimplyticsFirebaseCrashlogService(this.crashlytics);

  @override
  Future<void> log(String message) {
    return crashlytics.log(message);
  }

  @override
  Future<void> recordError(
    dynamic exception,
    StackTrace? stackTrace, {
    dynamic reason,
    Iterable<Object> information = const [],
    bool fatal = false,
  }) {
    return crashlytics.recordError(
      exception,
      stackTrace,
      reason: reason,
      information: information,
      fatal: fatal,
    );
  }

  @override
  Future<void> setCustomKey(String key, Object value) {
    return crashlytics.setCustomKey(key, value);
  }

  @override
  Future<void> setUserId(String id) {
    return crashlytics.setUserIdentifier(id);
  }

  @override
  bool get isEnabled => crashlytics.isCrashlyticsCollectionEnabled;

  @override
  Future<void> setEnabled(bool enabled) =>
      crashlytics.setCrashlyticsCollectionEnabled(enabled);
}
