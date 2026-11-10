#!/usr/bin/env bash
# Format check + static analysis. Fails on any unformatted file or issue.
set -euo pipefail
cd "$(dirname "$0")/.."

dart format --output=none --set-exit-if-changed lib test tool
flutter analyze
