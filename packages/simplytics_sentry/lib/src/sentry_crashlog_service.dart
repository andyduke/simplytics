import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:simplytics/simplytics.dart';

/// Implementation of the Sentry crash reporting service for Simplytics.
///
/// Used when configuring Simplytics:
/// ```dart
/// // Initialize Sentry
/// Simplytics.setup(
///   crashlogService: SimplyticsSentryCrashlogService(),
/// );
/// ```
class SimplyticsSentryCrashlogService extends SimplyticsCrashlogInterface {
  static const bool defaultEnabled = true;

  // static String userIdPropertyName = 'User ID';

  bool _enabled = defaultEnabled;

  final Map<String, dynamic> _userProperties = {};
  String? _userId;

  // String? _message;

  SimplyticsSentryCrashlogService({
    bool enabled = defaultEnabled,
  }) : _enabled = enabled;

  @override
  Future<void> log(String message) async {
    if (!_enabled) return;

    // _message = message;

    await Sentry.captureMessage(message);
  }

  @override
  Future<void> recordError(exception, StackTrace? stackTrace, {reason, bool fatal = false}) async {
    if (!_enabled) return;

    /*
    String error = '$exception'.replaceAll('\n', ' ');

    // Add the Error object type as a prefix if it doesn't already have one.
    if (exception is Error) {
      final prefix = '${exception.runtimeType}: ';
      final prefixPattern = RegExp('^${RegExp.escape(prefix)}');
      if (!prefixPattern.hasMatch(error)) {
        error = '$prefix$error';
      }
    }

    // Pass user properties as segmentation parameters.
    final segmentation = _userProperties.map((key, value) => MapEntry<String, Object>(key, value));

    await Sentry.logExceptionManual(
      '$error\n$stackTrace',
      fatal, // Doesn't work on iOS; on Android the value is inverted.
      stacktrace: StackTrace.empty,
      segmentation: segmentation,
    );
    */

    // await Sentry.configureScope((scope) => scope.setTag('user.pk', 'ABC'));

    await Sentry.captureException(
      exception,
      stackTrace: stackTrace,
      /*
      withScope: (scope) {
        // scope.setTag('app.user_id', 'User ABC');
        // // scope.level = SentryLevel.warning;
        // scope.setExtra('extra1', 'BCD');
        // scope.setUser(SentryUser(id: 'AA', name: 'AAAA bbbb'));

        if (_userProperties.isNotEmpty) {
          scope.setContexts('User Properties', _userProperties);
        } else {
          scope.removeContexts('User Properties');
        }

        if (_userId != null) {
          scope.setUser(SentryUser(id: _userId));
          scope.setTag('session.user_id', _userId!);
        } else {
          scope.setUser(null);
          scope.removeTag('session.user_id');
        }
      },
      */
      // hint: Hint.withMap({
      //   'custom_prop1': 'Test 1',
      // }),
      // hint: Hint.withMap({
      //   ..._userProperties.map((key, value) => MapEntry<String, Object>(key, value)),
      //   // if (_message != null) 'message': _message!,
      // }),
    );

    // _message = null;
  }

  @override
  Future<void> setCustomKey(String key, Object value) async {
    if (!_enabled) return;

    if (value != '') {
      _userProperties[key] = value;
    } else {
      _userProperties.remove(key);
    }

    /*
    final scope = Sentry.currentHub.scope;
    if (_userProperties.isNotEmpty) {
      scope.setContexts('User Properties', _userProperties);
    } else {
      scope.removeContexts('User Properties');
    }
    */

    await Sentry.configureScope((scope) {
      if (_userProperties.isNotEmpty) {
        scope.setContexts('User Properties', _userProperties);
      } else {
        scope.removeContexts('User Properties');
      }
    });

    // await Sentry.configureScope((scope) => scope.setContexts(key, value));
  }

  @override
  Future<void> setUserId(String id) async {
    if (!_enabled) return;

    // if (id.isNotEmpty) {
    //   _userProperties[userIdPropertyName] = id;
    // } else {
    //   _userProperties.remove(userIdPropertyName);
    // }

    // await Sentry.configureScope((scope) => scope.setUser(SentryUser(id: id)));

    _userId = id.isNotEmpty ? id : null;

    /*
    final scope = Sentry.currentHub.scope;
    if (_userId != null) {
      scope.setUser(SentryUser(id: _userId));
      scope.setTag('session.user_id', _userId!);
    } else {
      scope.setUser(null);
      scope.removeTag('session.user_id');
    }
    */

    await Sentry.configureScope((scope) {
      if (_userId != null) {
        scope.setUser(SentryUser(id: _userId));
        scope.setTag('session.user_id', _userId!);
      } else {
        scope.setUser(null);
        scope.removeTag('session.user_id');
      }
    });
  }

  @override
  bool get isEnabled => _enabled;

  @override
  Future<void> setEnabled(bool enabled) async => _enabled = enabled;
}
