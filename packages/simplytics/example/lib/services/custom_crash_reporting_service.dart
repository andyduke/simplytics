import 'package:simplytics/simplytics.dart';
import 'dart:developer' as developer;

class CustomCrashReportingService extends SimplyticsCrashlogInterface {
  @override
  Future<void> log(String message) async {
    developer.log(
      '•• $message',
      name: 'Custom Crash',
      level: 2,
    );
  }

  @override
  Future<void> recordError(exception, StackTrace? stackTrace, {reason, bool fatal = false}) async {
    developer.log(
      '•• ${fatal ? 'Fatal ' : ''}Error${(reason != null) ? ': $reason' : ''}',
      error: exception,
      stackTrace: stackTrace,
      name: 'Custom Crash',
      level: 99,
    );
  }

  @override
  Future<void> setCustomKey(String key, Object value) async {
    developer.log(
      '•• Set Custom Key: $key="$value"',
      name: 'Custom Crash',
      level: 2,
    );
  }

  @override
  Future<void> setUserId(String identifier) async {
    developer.log(
      '•• Set User Id: "$identifier"',
      name: 'Custom Crash',
      level: 2,
    );
  }
}
