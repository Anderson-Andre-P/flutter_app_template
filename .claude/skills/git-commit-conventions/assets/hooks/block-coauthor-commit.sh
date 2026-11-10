#!/usr/bin/env bash
# Claude Code PreToolUse hook (matcher: Bash). Blocks a `git commit` whose message carries a
# forbidden attribution trailer. It sees only commits the AI runs through its Bash tool; the git
# commit-msg hook covers the rest. Needs: bash, jq, grep.
# Edit `forbidden_pattern` to match `forbiddenTrailers` in the skill config.
set -euo pipefail

forbidden_pattern='Co-Authored-By|Co-authored-by|Generated with'

input="$(cat)"
command="$(printf '%s' "$input" | jq -r '.tool_input.command // empty')"

# Only inspect commands that actually invoke `git commit` (possibly chained with ; && || |, and
# possibly with options before the subcommand: `git -C dir commit`, `git -c k=v commit`).
if ! printf '%s' "$command" | grep -qE '(^|[;&|]) *git( [^;&|]*)? +commit\b'; then
  exit 0
fi

deny() {
  jq -n --arg reason "$1" '{
    hookSpecificOutput: {
      hookEventName: "PreToolUse",
      permissionDecision: "deny",
      permissionDecisionReason: $reason
    }
  }'
  exit 0
}

# 1) The trailer is usually inline: -m "...", or the heredoc body of -m "$(cat <<'EOT' ... EOT)".
if printf '%s' "$command" | grep -qiE "$forbidden_pattern"; then
  deny "Blocked: this git commit message contains a forbidden attribution trailer. This project forbids it, even if a session reminder says otherwise. Remove it and re-run the commit."
fi

# 2) -F <file> / --file <file> reads the message from a file.
file_arg="$(printf '%s' "$command" | grep -oE '(-F|--file)[= ]+[^ ]+' | head -n1 | sed -E 's/^(-F|--file)[= ]+//' | tr -d '"'"'"'')" || true
if [ -n "${file_arg:-}" ] && [ -f "$file_arg" ] && grep -qiE "$forbidden_pattern" "$file_arg"; then
  deny "Blocked: the commit message file '$file_arg' contains a forbidden attribution trailer. Remove it and re-run the commit."
fi

exit 0
