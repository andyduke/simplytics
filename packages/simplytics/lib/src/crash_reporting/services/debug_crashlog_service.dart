import 'package:flutter/foundation.dart';
import 'package:simplytics/simplytics.dart';
import 'dart:developer' as developer;

/// Error monitoring service for debugging, outputs all events to the system log, if [enabled].
///
/// Enabled by default for debug mode ([kDebugMode]).
class SimplyticsDebugCrashlogService extends SimplyticsCrashlogInterface {
  bool _enabled = false;

  /// Creates an error monitoring service object for debugging,
  /// outputs all events to the system log, if [enabled].
  ///
  /// Enabled by default for debug mode ([kDebugMode]).
  SimplyticsDebugCrashlogService([this._enabled = kDebugMode]);

  static const _serviceName = 'Crashlog';

  @override
  Future<void> log(String message) async {
    if (_enabled) {
      developer.log(
        '• $message',
        name: _serviceName,
        level: 2,
      );
    }
  }

  @override
  Future<void> recordError(exception, StackTrace? stackTrace,
      {reason, bool fatal = false}) async {
    if (_enabled) {
      developer.log(
        '• ${fatal ? 'Fatal ' : ''}Error${(reason != null) ? ': $reason' : ''}',
        error: exception,
        stackTrace: stackTrace,
        name: _serviceName,
        level: 99,
      );
    }
  }

  @override
  Future<void> setCustomKey(String key, Object value) async {
    if (_enabled) {
      developer.log(
        '• Set Custom Key: $key="$value"',
        name: _serviceName,
        level: 2,
      );
    }
  }

  @override
  Future<void> setUserId(String id) async {
    if (_enabled) {
      developer.log(
        '• Set User Id: "$id"',
        name: _serviceName,
        level: 2,
      );
    }
  }

  /// If true, output all events to the system log.
  @override
  bool get isEnabled => _enabled;

  @override
  Future<void> setEnabled(bool enabled) async => _enabled = enabled;
}
