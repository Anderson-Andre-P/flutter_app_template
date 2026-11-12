// Reads the event stream produced by
// `flutter test --file-reporter json:<path>` and prints an end-of-run
// summary: one pass/fail/skip table per feature group (with a subtotal),
// an OVERALL table, the list of failures (file:line + first error line),
// and the 10 slowest tests.
//
// Pure parsing/formatting lives in [summarize] so it can be unit-tested
// (test/tool/test_summary_test.dart); `main` only does file IO, colour
// resolution and the exit code.
//
// Usage: dart run tool/test_summary.dart [--color=auto|always|never] <events.json>

import 'dart:convert';
import 'dart:io';

Future<void> main(List<String> args) async {
  String? colorMode;
  final paths = <String>[];
  for (final arg in args) {
    if (arg == '--color' || arg == '--colour') {
      colorMode = 'always';
    } else if (arg == '--no-color' || arg == '--no-colour') {
      colorMode = 'never';
    } else if (arg.startsWith('--color=') || arg.startsWith('--colour=')) {
      colorMode = arg.split('=').last;
    } else {
      paths.add(arg);
    }
  }

  if (paths.isEmpty) {
    stderr.writeln(
      'usage: dart run tool/test_summary.dart [--color=auto|always|never] '
      '<events.json> [more events.json ...]',
    );
    exitCode = 2;
    return;
  }

  final reports = <List<String>>[];
  for (final path in paths) {
    final file = File(path);
    if (!file.existsSync()) {
      stderr.writeln('test_summary: file not found: $path');
      exitCode = 2;
      return;
    }
    reports.add(await file.readAsLines());
  }

  final result = summarize(
    reports.length == 1 ? reports.single : mergeReports(reports),
    color: _resolveColor(colorMode),
  );
  stdout.writeln(result.report);
  exitCode = result.ok ? 0 : 1;
}

bool _resolveColor(String? mode) {
  switch (mode) {
    case 'always':
      return true;
    case 'never':
      return false;
    default: // 'auto' or unset
      if ((Platform.environment['NO_COLOR'] ?? '').isNotEmpty) return false;
      return stdout.hasTerminal;
  }
}

/// Outcome of [summarize]: the rendered [report] and whether the run is
/// green ([ok] — every test passed and the stream completed).
class TestSummary {
  const TestSummary({required this.report, required this.ok});

  final String report;
  final bool ok;
}

/// Merges several reporter event streams (one per `flutter test` run, each with
/// ids starting from 0) into one: ids are offset per report so they cannot
/// collide, and the per-report `done` events are replaced by a single one that
/// is only emitted if EVERY report finished (success only if all succeeded).
List<String> mergeReports(List<List<String>> reports) {
  const idKeys = {'id', 'testID', 'suiteID', 'parentID'};
  const idListKeys = {'groupIDs'};
  Object? shift(Object? node, int offset) {
    if (node is Map<String, dynamic>) {
      return {
        for (final e in node.entries)
          e.key: idKeys.contains(e.key) && e.value is int
              ? (e.value as int) + offset
              : idListKeys.contains(e.key) && e.value is List
              ? [for (final v in e.value as List) v is int ? v + offset : v]
              : shift(e.value, offset),
      };
    }
    if (node is List) return [for (final v in node) shift(v, offset)];
    return node;
  }

  final merged = <String>[];
  var allDone = true;
  var allSucceeded = true;
  for (var i = 0; i < reports.length; i++) {
    var done = false;
    for (final line in reports[i]) {
      final trimmed = line.trim();
      if (trimmed.isEmpty) continue;
      final Object? decoded;
      try {
        decoded = jsonDecode(trimmed);
      } on FormatException {
        continue;
      }
      if (decoded is! Map<String, dynamic>) continue;
      if (decoded['type'] == 'done') {
        done = true;
        if (decoded['success'] != true) allSucceeded = false;
        continue;
      }
      merged.add(jsonEncode(shift(decoded, i * 1000000)));
    }
    if (!done) allDone = false;
  }
  if (allDone) {
    merged.add(jsonEncode({'type': 'done', 'success': allSucceeded}));
  }
  return merged;
}

/// Parses [lines] (one JSON reporter event each) into a printable summary.
///
/// [rootDir] is stripped from absolute test paths so tables show
/// repo-relative files; defaults to the current working directory.
/// [color] adds ANSI colour to the output.
TestSummary summarize(
  List<String> lines, {
  String? rootDir,
  bool color = false,
}) {
  final root = rootDir ?? Directory.current.path;
  final suitePaths = <int, String>{};
  final tests = <int, _TestRecord>{};
  bool? runSucceeded;

  for (final line in lines) {
    final trimmed = line.trim();
    if (trimmed.isEmpty) continue;

    final Object? decoded;
    try {
      decoded = jsonDecode(trimmed);
    } on FormatException {
      continue;
    }
    if (decoded is! Map<String, dynamic>) continue;

    switch (decoded['type']) {
      case 'suite':
        final suite = decoded['suite'] as Map<String, dynamic>?;
        if (suite != null) {
          suitePaths[suite['id'] as int] = (suite['path'] as String?) ?? '';
        }
      case 'testStart':
        final test = decoded['test'] as Map<String, dynamic>?;
        if (test == null) break;
        var url = (test['root_url'] ?? test['url']) as String?;
        var line = (test['root_line'] ?? test['line']) as int?;
        // `testWidgets` reports Flutter's own wrapper (a `package:` URL) as the
        // source; the suite path is then the real test file (line unknown).
        if (url == null || url.startsWith('package:')) {
          final suitePath = suitePaths[test['suiteID']];
          if (suitePath != null && suitePath.isNotEmpty) {
            url = suitePath;
            line = null;
          }
        }
        tests[test['id'] as int] = _TestRecord(
          name: (test['name'] as String?) ?? '',
          file: url == null ? null : _relativePath(url, root),
          line: line,
          startMs: (decoded['time'] as int?) ?? 0,
        );
      case 'error':
        final record = tests[decoded['testID'] as int?];
        if (record != null && record.firstErrorLine == null) {
          final raw = (decoded['error'] as String?) ?? '';
          record.firstErrorLine = raw.split('\n').first.trimRight();
        }
      case 'testDone':
        final record = tests[decoded['testID'] as int?];
        if (record == null) break;
        record.endMs = (decoded['time'] as int?) ?? record.startMs;
        record.result = (decoded['result'] as String?) ?? 'success';
        record.skipped = (decoded['skipped'] as bool?) ?? false;
        record.hidden = (decoded['hidden'] as bool?) ?? false;
      case 'done':
        runSucceeded = (decoded['success'] as bool?) ?? false;
    }
  }

  final reported = tests.values
      .where(
        (t) => !t.hidden && t.file != null && !t.name.startsWith('loading '),
      )
      .toList();

  final report = _render(
    reported,
    runSucceeded: runSucceeded,
    ansi: _Ansi(color),
  );
  final ok = runSucceeded == true && reported.every((t) => !t.failed);
  return TestSummary(report: report, ok: ok);
}

String _render(
  List<_TestRecord> tests, {
  required bool? runSucceeded,
  required _Ansi ansi,
}) {
  final buffer = StringBuffer();

  // Group -> file -> tally
  final groups = <String, Map<String, _Tally>>{};
  for (final t in tests) {
    final byFile = groups.putIfAbsent(_groupOf(t.file!), () => {});
    byFile.putIfAbsent(t.file!, _Tally.new).add(t);
  }

  final groupNames = groups.keys.toList()..sort();
  final overall = <String, _Tally>{};

  for (final groupName in groupNames) {
    final byFile = groups[groupName]!;
    final files = byFile.keys.toList()..sort();
    final groupTally = _Tally();
    for (final t in byFile.values) {
      groupTally.merge(t);
    }
    overall[groupName] = groupTally;

    final heading = _pretty(groupName).toUpperCase();
    final bar = '═' * 6;
    buffer.writeln();
    buffer.writeln(
      groupTally.failed > 0
          ? ansi.redBold('$bar  $heading  $bar')
          : ansi.bold('$bar  $heading  $bar'),
    );

    final labels = {for (final f in files) f: _fileLabel(f, groupName)};
    final labelWidth = [
      'File',
      'subtotal',
      ...labels.values,
    ].map((s) => s.length).reduce((a, b) => a > b ? a : b);

    buffer.writeln(
      ansi.dim(_row(labelWidth, 'File', '✓', '✗', 'skip', 'time')),
    );
    for (final file in files) {
      final tally = byFile[file]!;
      final label = labels[file]!;
      buffer.writeln(
        _dataRow(
          ansi,
          labelWidth,
          tally.failed > 0 ? ansi.redBold(label.padRight(labelWidth)) : null,
          label,
          tally,
        ),
      );
    }
    buffer.writeln(
      _dataRow(
        ansi,
        labelWidth,
        ansi.bold('subtotal'.padRight(labelWidth)),
        'subtotal',
        groupTally,
      ),
    );
  }

  // ── OVERALL ───────────────────────────────────────────────────────
  final total = _Tally();
  for (final t in overall.values) {
    total.merge(t);
  }
  final overallLabelWidth = [
    'Group',
    'TOTAL',
    ...groupNames.map(_pretty),
  ].map((s) => s.length).reduce((a, b) => a > b ? a : b);

  buffer.writeln();
  buffer.writeln(ansi.bold('${'═' * 9}  OVERALL  ${'═' * 9}'));
  buffer.writeln(
    ansi.dim(_row(overallLabelWidth, 'Group', '✓', '✗', 'skip', 'time')),
  );
  for (final groupName in groupNames) {
    final tally = overall[groupName]!;
    buffer.writeln(
      _dataRow(
        ansi,
        overallLabelWidth,
        tally.failed > 0
            ? ansi.redBold(_pretty(groupName).padRight(overallLabelWidth))
            : null,
        _pretty(groupName),
        tally,
      ),
    );
  }
  buffer.writeln(
    _dataRow(
      ansi,
      overallLabelWidth,
      ansi.bold('TOTAL'.padRight(overallLabelWidth)),
      'TOTAL',
      total,
    ),
  );

  if (runSucceeded == null) {
    buffer.writeln();
    buffer.writeln(
      ansi.redBold(
        "⚠️  the run did not finish (no 'done' event) — "
        'results above may be partial',
      ),
    );
  }

  // ── FAILURES ──────────────────────────────────────────────────────
  final failures = tests.where((t) => t.failed).toList()
    ..sort((a, b) => a.location.compareTo(b.location));
  if (failures.isNotEmpty) {
    buffer.writeln();
    buffer.writeln(ansi.redBold('FAILURES (${failures.length})'));
    for (final f in failures) {
      buffer.writeln('  ${ansi.red(f.location)}  ${f.name}');
      if (f.firstErrorLine != null && f.firstErrorLine!.isNotEmpty) {
        buffer.writeln(ansi.dim('      ${f.firstErrorLine}'));
      }
    }
  }

  // ── SLOWEST ───────────────────────────────────────────────────────
  if (tests.isNotEmpty) {
    final slowest = tests.toList()
      ..sort((a, b) => b.durationMs.compareTo(a.durationMs));
    buffer.writeln();
    buffer.writeln(ansi.bold('SLOWEST 10 TESTS'));
    for (final t in slowest.take(10)) {
      buffer.writeln(
        '  ${ansi.dim(_formatDuration(t.durationMs).padLeft(8))}  '
        '${t.file}  ${t.name}',
      );
    }
  }

  return buffer.toString();
}

/// Bucket a repo-relative test path into a feature group.
String _groupOf(String path) {
  final feature = RegExp(r'(?:^|/)test/features/([^/]+)/').firstMatch(path);
  if (feature != null) return feature.group(1)!;

  // integration_test/<area>/<flow>_test.dart -> <area>
  final area = RegExp(r'(?:^|/)integration_test/([^/]+)/').firstMatch(path);
  if (area != null) return area.group(1)!;

  final flow = RegExp(r'(?:^|/)integration_test/([^/]+)_flow_test\.dart$')
      .firstMatch(path);
  if (flow != null) return flow.group(1)!;

  final testSub = RegExp(r'(?:^|/)test/([^/]+)/').firstMatch(path);
  if (testSub != null) return testSub.group(1)!;

  if (path.contains('integration_test/')) return 'integration_test';

  final first = path.split('/').first;
  return first.isEmpty ? 'other' : first;
}

/// Per-file table label: the path with the group's own directory stripped
/// (it's already in the section heading). `test/features/map/…/x_test.dart`
/// -> `…/x_test.dart`; `integration_test/map_flow_test.dart` -> `map_flow_test.dart`.
/// The full path is kept in FAILURES/SLOWEST for click-to-open.
String _fileLabel(String path, String group) {
  for (final prefix in [
    'test/features/$group/',
    'integration_test/$group/',
    'integration_test/',
    'test/$group/',
  ]) {
    final at = path.indexOf(prefix);
    if (at != -1) return path.substring(at + prefix.length);
  }
  return path;
}

/// `business_intelligence` -> `Business Intelligence`.
String _pretty(String group) => group
    .split('_')
    .map((w) => w.isEmpty ? w : '${w[0].toUpperCase()}${w.substring(1)}')
    .join(' ');

String _row(
  int labelWidth,
  String label,
  String pass,
  String fail,
  String skip,
  String time,
) =>
    '${label.padRight(labelWidth)}  ${pass.padLeft(4)}  ${fail.padLeft(4)}  '
    '${skip.padLeft(4)}  ${time.padLeft(8)}';

/// A table row whose numeric cells are individually coloured. [coloredLabel]
/// is the pre-coloured label (or null to leave it plain); [plainLabel] is
/// used only to compute padding.
String _dataRow(
  _Ansi ansi,
  int labelWidth,
  String? coloredLabel,
  String plainLabel,
  _Tally tally,
) {
  final label = coloredLabel ?? plainLabel.padRight(labelWidth);
  final pass = tally.passed > 0
      ? ansi.green('${tally.passed}'.padLeft(4))
      : ansi.dim('0'.padLeft(4));
  final fail = tally.failed > 0
      ? ansi.redBold('${tally.failed}'.padLeft(4))
      : ansi.dim('0'.padLeft(4));
  final skip = tally.skipped > 0
      ? ansi.yellow('${tally.skipped}'.padLeft(4))
      : ansi.dim('0'.padLeft(4));
  final time = ansi.dim(_formatDuration(tally.durationMs).padLeft(8));
  return '$label  $pass  $fail  $skip  $time';
}

String _relativePath(String fileUrl, String root) {
  var path = fileUrl;
  try {
    path = Uri.parse(fileUrl).toFilePath();
  } on FormatException {
    // keep the raw string
  } on UnsupportedError {
    // a `package:` URI has no file path — keep the raw string
  }
  final prefix = root.endsWith('/') ? root : '$root/';
  if (path.startsWith(prefix)) return path.substring(prefix.length);

  for (final marker in const ['/integration_test/', '/test/']) {
    final at = path.indexOf(marker);
    if (at != -1) return path.substring(at + 1);
  }
  return path;
}

String _formatDuration(int ms) {
  if (ms < 1000) return '${ms}ms';
  final seconds = ms / 1000;
  if (seconds < 60) return '${seconds.toStringAsFixed(1)}s';
  final minutes = ms ~/ 60000;
  final remainder = (ms % 60000) ~/ 1000;
  return '${minutes}m${remainder.toString().padLeft(2, '0')}s';
}

class _Ansi {
  _Ansi(this.enabled);

  final bool enabled;

  String _wrap(String code, String s) => enabled ? '\x1B[${code}m$s\x1B[0m' : s;

  String green(String s) => _wrap('32', s);
  String red(String s) => _wrap('31', s);
  String redBold(String s) => _wrap('1;31', s);
  String yellow(String s) => _wrap('33', s);
  String dim(String s) => _wrap('2', s);
  String bold(String s) => _wrap('1', s);
}

class _TestRecord {
  _TestRecord({
    required this.name,
    required this.file,
    required this.line,
    required this.startMs,
  });

  final String name;
  final String? file;
  final int? line;
  final int startMs;
  int? endMs;
  String result = 'success';
  bool skipped = false;
  bool hidden = false;
  String? firstErrorLine;

  bool get failed => result == 'failure' || result == 'error';

  int get durationMs {
    final end = endMs ?? startMs;
    return end > startMs ? end - startMs : 0;
  }

  String get location => line == null ? '$file' : '$file:$line';
}

class _Tally {
  int passed = 0;
  int failed = 0;
  int skipped = 0;
  int durationMs = 0;

  void add(_TestRecord t) {
    if (t.skipped) {
      skipped++;
    } else if (t.failed) {
      failed++;
    } else {
      passed++;
    }
    durationMs += t.durationMs;
  }

  void merge(_Tally other) {
    passed += other.passed;
    failed += other.failed;
    skipped += other.skipped;
    durationMs += other.durationMs;
  }
}
