#!/usr/bin/env bash
# Builds a release artefact: apk | appbundle | ipa. Reads .env.json if present.
# Extra arguments go straight to `flutter build`.
set -euo pipefail
cd "$(dirname "$0")/.."

target="${1:-}"
case "$target" in
  apk | appbundle | ipa) shift ;;
  *)
    echo "usage: scripts/build.sh <apk|appbundle|ipa> [flutter build args]" >&2
    exit 2
    ;;
esac

args=()
if [[ -f .env.json ]]; then
  args+=(--dart-define-from-file=.env.json)
fi
exec flutter build "$target" --release "${args[@]}" "$@"
