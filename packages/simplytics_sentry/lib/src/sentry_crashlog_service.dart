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
  Future<void> recordError(
    dynamic exception,
    StackTrace? stackTrace, {
    dynamic reason,
    Iterable<Object> information = const [],
    bool fatal = false,
  }) async {
    if (!_enabled) return;

    await Sentry.captureException(
      exception,
      stackTrace: stackTrace,
      withScope: (scope) {
        final List<String> extra = [];

        for (var info in information) {
          switch (info) {
            case SimplyticsErrorTag:
              final tag = info as SimplyticsErrorTag;
              final value = '${tag.value}';
              if (value.isNotEmpty) {
                scope.setTag(tag.name, value);
              }
              break;

            case SimplyticsErrorProperty:
              final prop = info as SimplyticsErrorProperty;
              final value = '${prop.value}';
              if (value.isNotEmpty) {
                scope.setExtra(prop.name, value);
              }
              break;

            default:
              final str = info.toString();
              if (str.isNotEmpty) {
                extra.add(str);
              }
          }

          if (extra.isNotEmpty) {
            scope.setExtra('Information', extra.join('\n\n'));
          }
        }
      },
    );
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
