import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

/// App-wide logging seam. The template ships [DebugAppLogger]; a remote
/// implementation (Sentry, a log backend, …) can be swapped in the DI
/// container without touching call sites.
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

/// ANSI colour per level, so the debug console tells severities apart.
const _ansiReset = '\x1B[0m';
const _ansiColors = {
  'DEBUG': '\x1B[38;5;208m',
  'INFO': '\x1B[38;5;141m',
  'SUCCESS': '\x1B[32m',
  'WARN': '\x1B[33m',
  'ERROR': '\x1B[31m',
};

/// One console line and the level tag that picks its colour. The package's
/// `Level` has no "success", so the tag travels with the message and the
/// printer reads it from here.
class _Line {
  const _Line(this.tag, this.text);
  final String tag;
  final String text;
}

/// Renders a [_Line] as `<colour><text><reset>` — the app's own one-line format,
/// not the package's boxed `PrettyPrinter`.
class _LinePrinter extends LogPrinter {
  @override
  List<String> log(LogEvent event) {
    final line = event.message as _Line;
    return ['${_ansiColors[line.tag] ?? ''}${line.text}$_ansiReset'];
  }
}

/// Writes each rendered line with [debugPrint] (throttled, as the console needs).
class _DebugPrintOutput extends LogOutput {
  @override
  void output(OutputEvent event) {
    for (final line in event.lines) {
      debugPrint(line);
    }
  }
}

Logger _buildLogger({LogOutput? output, Level? level}) => Logger(
  filter: ProductionFilter(),
  printer: _LinePrinter(),
  output: output ?? _DebugPrintOutput(),
  level: level ?? (kDebugMode ? Level.all : Level.off),
);

/// Prints to the console in debug builds; silent in profile/release. Built on
/// `package:logger` (filter, printer and output pipeline); the line format is
/// the app's own, unchanged from before the package was adopted.
class DebugAppLogger implements AppLogger {
  const DebugAppLogger() : _logger = null;

  /// Same format over a caller-supplied [output] (tests capture it) and an
  /// optional package filter [level].
  DebugAppLogger.withOutput(LogOutput output, {Level? level})
    : _logger = _buildLogger(output: output, level: level);

  final Logger? _logger;

  static final Logger _console = _buildLogger();

  @override
  void debug(String message, {Object? error, StackTrace? stackTrace}) =>
      _emit(Level.debug, 'DEBUG', message, error, stackTrace);

  @override
  void info(String message, {Object? error, StackTrace? stackTrace}) =>
      _emit(Level.info, 'INFO', message, error, stackTrace);

  @override
  void success(String message, {Object? error, StackTrace? stackTrace}) =>
      _emit(Level.info, 'SUCCESS', message, error, stackTrace);

  @override
  void warning(String message, {Object? error, StackTrace? stackTrace}) =>
      _emit(Level.warning, 'WARN', message, error, stackTrace);

  @override
  void error(String message, {Object? error, StackTrace? stackTrace}) =>
      _emit(Level.error, 'ERROR', message, error, stackTrace);

  void _emit(
    Level level,
    String tag,
    String message,
    Object? error,
    StackTrace? stackTrace,
  ) {
    // Not formatting `error` / `stackTrace` at all outside debug builds, as
    // before (an error whose toString throws must not matter in release).
    if (!kDebugMode) return;
    final logger = _logger ?? _console;
    logger.log(level, _Line(tag, '[$tag] $message'));
    if (error != null) logger.log(level, _Line(tag, '  error: $error'));
    if (stackTrace != null) {
      logger.log(level, _Line(tag, '  stack: $stackTrace'));
    }
  }
}
