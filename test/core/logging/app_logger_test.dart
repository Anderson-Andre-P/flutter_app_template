import 'package:flutter_app_template/core/logging/app_logger.dart';
import 'package:flutter_app_template/core/logging/debug_app_logger.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:logger/logger.dart';

class _MemoryOutput extends LogOutput {
  final lines = <String>[];

  @override
  void output(OutputEvent event) => lines.addAll(event.lines);
}

void main() {
  test('writes one tagged line per level', () {
    final out = _MemoryOutput();
    final logger = DebugAppLogger.withOutput(out, level: Level.all)
      ..debug('d')
      ..info('i')
      ..success('s')
      ..warning('w')
      ..error('e');
    expect(logger, isA<AppLogger>());
    final text = out.lines.join('\n');
    for (final tag in [
      '[DEBUG] d',
      '[INFO] i',
      '[SUCCESS] s',
      '[WARN] w',
      '[ERROR] e',
    ]) {
      expect(text, contains(tag));
    }
  });

  test('includes the error when one is given', () {
    final out = _MemoryOutput();
    DebugAppLogger.withOutput(
      out,
      level: Level.all,
    ).error('falhou', error: StateError('boom'));
    expect(out.lines.join('\n'), contains('boom'));
  });
}
