import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';

import '../../tool/test_summary.dart';

List<String> _events({required bool secondPasses}) => [
  {
    'type': 'suite',
    'suite': {'id': 0, 'path': '/repo/test/core/a_test.dart'},
  },
  {
    'type': 'testStart',
    'test': {
      'id': 1,
      'name': 'passes',
      'suiteID': 0,
      'groupIDs': <int>[],
      'line': 3,
    },
  },
  {
    'type': 'testDone',
    'testID': 1,
    'result': 'success',
    'hidden': false,
    'skipped': false,
    'time': 5,
  },
  {
    'type': 'testStart',
    'test': {
      'id': 2,
      'name': 'breaks',
      'suiteID': 0,
      'groupIDs': <int>[],
      'line': 9,
    },
  },
  if (!secondPasses)
    {
      'type': 'error',
      'testID': 2,
      'error': 'boom',
      'stackTrace': '',
      'isFailure': true,
    },
  {
    'type': 'testDone',
    'testID': 2,
    'result': secondPasses ? 'success' : 'failure',
    'hidden': false,
    'skipped': false,
    'time': 7,
  },
  {'type': 'done', 'success': secondPasses},
].map(jsonEncode).toList();

void main() {
  test('a failing test makes the summary not ok and names it', () {
    final s = summarize(_events(secondPasses: false), rootDir: '/repo');
    expect(s.ok, isFalse);
    expect(s.report, contains('breaks'));
  });

  test('an all-green run is ok', () {
    expect(summarize(_events(secondPasses: true), rootDir: '/repo').ok, isTrue);
  });
}
