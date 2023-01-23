import 'package:simplytics/simplytics.dart';
import 'dart:developer' as developer;

class CustomCrashReportingService extends SimplyticsCrashlogInterface {
  bool _enabled = true;

  @override
  Future<void> log(String message) async {
    if (_enabled) {
      developer.log(
        '•• $message',
        name: 'Custom Crash',
        level: 2,
      );
    }
  }

  @override
  Future<void> recordError(exception, StackTrace? stackTrace, {reason, bool fatal = false}) async {
    if (_enabled) {
      developer.log(
        '•• ${fatal ? 'Fatal ' : ''}Error${(reason != null) ? ': $reason' : ''}',
        error: exception,
        stackTrace: stackTrace,
        name: 'Custom Crash',
        level: 99,
      );
    }
  }

  @override
  Future<void> setCustomKey(String key, Object value) async {
    if (_enabled) {
      developer.log(
        '•• Set Custom Key: $key="$value"',
        name: 'Custom Crash',
        level: 2,
      );
    }
  }

  @override
  Future<void> setUserId(String id) async {
    if (_enabled) {
      developer.log(
        '•• Set User Id: "$id"',
        name: 'Custom Crash',
        level: 2,
      );
    }
  }

  @override
  bool get isEnabled => _enabled;

  @override
  Future<void> setEnabled(bool enabled) async => _enabled = enabled;
}
