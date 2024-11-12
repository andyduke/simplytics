/// Exposes all error monitoring methods for implementation.
abstract class SimplyticsCrashlogInterface {
  /// Logs an error [Exception] and a possible [stackTrace].
  Future<void> recordError(
    dynamic exception,
    StackTrace? stackTrace, {
    dynamic reason,
    Iterable<Object> information = const [],
    bool fatal = false,
  });

  /// Logs a fatal error [Exception] and a possible [stackTrace].
  Future<void> recordFatalError(
    dynamic exception,
    StackTrace? stackTrace, {
    dynamic reason,
    Iterable<Object> information = const [],
  }) =>
      recordError(
        exception,
        stackTrace,
        reason: reason,
        information: information,
        fatal: true,
      );

  /// Logs a [message].
  /// Typically, this message is sent with the following error report.
  Future<void> log(String message);

  /// Sets a user [id] to associate with all error reports.
  Future<void> setUserId(String id);

  /// Sets a custom key for the user that usually persists through the apps lifecycle.
  Future<void> setCustomKey(String key, Object value);

  /// Whether the error monitoring service collects reports.
  /// If false, no crash reporting data is sent to the service.
  ///
  /// See [setEnabled] to toggle the value.
  bool get isEnabled;

  /// Enables/disables automatic data collection using this service class.
  Future<void> setEnabled(bool enabled);
}
