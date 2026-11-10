#!/usr/bin/env bash
# Runs the app. Reads optional config from .env.json (see .env.example.json).
# Extra arguments go straight to `flutter run` (e.g. -d <device>).
set -euo pipefail
cd "$(dirname "$0")/.."

args=()
if [[ -f .env.json ]]; then
  args+=(--dart-define-from-file=.env.json)
fi
exec flutter run "${args[@]}" "$@"
