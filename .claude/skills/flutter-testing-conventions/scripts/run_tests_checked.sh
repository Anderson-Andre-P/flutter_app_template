#!/usr/bin/env bash
# Run `flutter test -r compact [args]` and report the verdict from its REAL exit code.
#
#   bash run_tests_checked.sh                       # whole suite
#   bash run_tests_checked.sh test/path/a_test.dart # one file
#
# Why: `flutter test | tail` returns tail's status and hides a failing suite. This prints exactly
# one verdict line ("All tests passed" or "Some tests failed (exit N)") and exits with flutter's
# own status; on failure it first shows the last 40 lines of output. FLUTTER_BIN overrides the binary.
set -uo pipefail

out="$(mktemp)"
trap 'rm -f "$out"' EXIT

"${FLUTTER_BIN:-flutter}" test -r compact "$@" >"$out" 2>&1
code=$?

if [ "$code" -eq 0 ]; then
  echo "All tests passed"
else
  tail -n 40 "$out"
  echo "Some tests failed (exit $code)"
fi
exit "$code"
