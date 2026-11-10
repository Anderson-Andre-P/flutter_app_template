#!/usr/bin/env bash
# Claude Code PreToolUse hook (matcher: Bash). The AI may open a pull request only INTO an allowed
# base branch (a pre-production branch); never into production. Blocks:
#   - `gh pr create` without an explicit --base/-B, or with a base that is not allowed (the default
#     base is the repository's default branch, usually production);
#   - `gh pr create` whose head (--head/-H, or the current branch) is a protected production branch;
#   - `gh pr edit` that retargets a PR to a base that is not allowed;
#   - `gh api` calls that create or change pull requests;
#   - `glab mr create`.
# Needs: bash, jq, grep. Edit `allowed_bases` / `protected_heads` to match `prAllowedBases` / `prProtectedHeads` in the skill config.
set -euo pipefail

allowed_bases='homolog'                          # space-separated
protected_heads='main master production prod'    # a PR may not start from these

input="$(cat)"
cwd="$(printf '%s' "$input" | jq -r '.cwd // empty')"
command="$(printf '%s' "$input" | jq -r '.tool_input.command // empty')"
start='(^|[;&|] *)'

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

base_of() {  # prints the value of --base / -B, empty if absent
  printf '%s' "$command" | grep -oE '(--base|-B)[= ]+[^ ]+' | head -n1 \
    | sed -E 's/^(--base|-B)[= ]+//' | tr -d "\"'" || true
}

head_of() {  # --head/-H value (owner: prefix stripped), else the current branch; empty if unknown
  local h
  h="$(printf '%s' "$command" | grep -oE '(--head|-H)[= ]+[^ ]+' | head -n1 | sed -E 's/^(--head|-H)[= ]+//' | tr -d "\"'")" || true
  if [ -z "$h" ]; then
    h="$(git -C "${cwd:-.}" branch --show-current 2>/dev/null)" || h=""
  fi
  printf '%s' "${h##*:}"
}

is_protected_head() {
  local b="$1" p
  for p in $protected_heads; do [ "$b" = "$p" ] && return 0; done
  return 1
}

is_allowed() {
  local b="$1" a
  for a in $allowed_bases; do [ "$b" = "$a" ] && return 0; done
  return 1
}

if printf '%s' "$command" | grep -qE "${start}gh +pr +create\b"; then
  base="$(base_of)"
  if [ -z "$base" ]; then
    deny "Blocked: gh pr create needs an explicit '--base <branch>'. Without it the PR targets the default (production) branch. Allowed base: ${allowed_bases}."
  fi
  is_allowed "$base" || deny "Blocked: PRs may only target [${allowed_bases}], not '${base}'. Production branches are promoted by the human owner."
  head="$(head_of)"
  if [ -z "$head" ]; then
    deny "Blocked: cannot tell which branch this PR starts from. Pass '--head <branch>' or run it from the working branch."
  fi
  if is_protected_head "$head"; then
    deny "Blocked: a PR may not start from the production branch '${head}'. Open it from a working branch."
  fi
fi

if printf '%s' "$command" | grep -qE "${start}gh +pr +edit\b"; then
  base="$(base_of)"
  if [ -n "$base" ] && ! is_allowed "$base"; then
    deny "Blocked: a PR may only be retargeted to [${allowed_bases}], not '${base}'."
  fi
fi

if printf '%s' "$command" | grep -qE "${start}gh +api\b" && printf '%s' "$command" | grep -qE '/pulls'; then
  if printf '%s' "$command" | grep -qE '(-X|--method)[= ]*(POST|PATCH|PUT)|(^| )(-f|-F|--field|--raw-field|--input)\b'; then
    deny "Blocked: creating or changing pull requests through 'gh api' bypasses the base-branch check. Use 'gh pr create --base ${allowed_bases%% *}'."
  fi
fi

if printf '%s' "$command" | grep -qE "${start}glab +mr +(create|update)\b"; then
  deny "Blocked: merge requests are not part of this project's flow (GitHub pull requests into [${allowed_bases}] only)."
fi

exit 0
