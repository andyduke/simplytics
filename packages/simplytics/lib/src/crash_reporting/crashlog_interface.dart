/// Exposes all error monitoring methods for implementation.
abstract class SimplyticsCrashlogInterface {
  /// Logs an error [Exception] and a possible [stackTrace].
  Future<void> recordError(
    dynamic exception,
    StackTrace? stackTrace, {
    dynamic reason,
    bool fatal = false,
  });

  /// Logs a fatal error [Exception] and a possible [stackTrace].
  Future<void> recordFatalError(
    dynamic exception,
    StackTrace? stackTrace, {
    dynamic reason,
  }) =>
      recordError(exception, stackTrace, reason: reason, fatal: true);

  /// Logs a [message].
  /// Typically, this message is sent with the following error report.
  Future<void> log(String message);

  /// Sets a user [id] to associate with all error reports.
  Future<void> setUserId(String id);

  /// Sets a custom key for the user that usually persists through the apps lifecycle.
  Future<void> setCustomKey(String key, Object value);

  // TODO: enabled property
  // bool get enabled;

  // TODO: enable() method
  // Future<void> enable(bool enabled);
}
