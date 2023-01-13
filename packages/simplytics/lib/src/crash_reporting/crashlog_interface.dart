/// Exposes all crash reports methods for implementation.
abstract class SimplyticsCrashlogInterface {
  /// Logs an error by dynamic [exception] and possible [stack] and/or [fatal] boolean.
  Future<void> recordError(
    dynamic exception,
    StackTrace? stackTrace, {
    dynamic reason,
    bool fatal = false,
  });

  /// Logs a message by String type [message].
  Future<void> log(String message);

  /// Sets a user identifier that usually persists through the apps lifecycle.
  Future<void> setUserId(String identifier);

  /// Sets a custom key for the user that usually persists through the apps lifecycle.
  Future<void> setCustomKey(String key, Object value);
}
