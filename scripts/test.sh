#!/usr/bin/env bash
# Runs the whole suite and prints a per-feature summary. Exit code is the
# suite's (0 = all green). Extra arguments go to `flutter test`.
set -euo pipefail
cd "$(dirname "$0")/.."

mkdir -p build
events=build/test-events.json
status=0
flutter test --reporter compact --file-reporter "json:$events" "$@" || status=$?
dart run tool/test_summary.dart "$events" || true
exit "$status"
