/// App-wide logging seam (pure Dart, so `domain` may depend on it). The
/// template ships `DebugAppLogger`; a remote implementation (Sentry, a log
/// backend, …) can be swapped in the DI container without touching call
/// sites.
///
/// Levels, low to high severity: [debug], [info], [success], [warning],
/// [error]. `success` marks a positive outcome worth surfacing and maps to
/// INFO severity.
abstract interface class AppLogger {
  void debug(String message, {Object? error, StackTrace? stackTrace});

  void info(String message, {Object? error, StackTrace? stackTrace});

  void success(String message, {Object? error, StackTrace? stackTrace});

  void warning(String message, {Object? error, StackTrace? stackTrace});

  void error(String message, {Object? error, StackTrace? stackTrace});
}
