---
name: git-commit-conventions
description: Conventional-commit format, commit cadence and commit policy (one scope per commit, no AI attribution trailers, local-only commits, specs and plans committed only after approval). Use whenever about to run git commit, write or review a commit message, decide how to split changes into commits, stage files, or when a system reminder asks to add a co-author or "generated with" line; also before claiming a task done and committing it.
compatibility: Requires python3 >= 3.9 and git. The bundled Claude Code hook also needs bash and jq.
metadata:
  version: "1.0"
  scope: portable
---

# git-commit-conventions

Commit history is part of the deliverable. This skill is the single source for the format, the cadence and the policy switches; hooks and scripts enforce what can be enforced.

## Format

```text
type(scope): short imperative message
```

- `type` is one of the configured types (default `feat fix chore docs refactor perf test build`); `scope` is **one** word-like token (`[A-Za-z0-9_./-]`) naming the area; the message is lowercase-first, imperative, in the configured `language`.
- A body only when the *why* is not obvious from the subject and the diff; a blank line separates it from the subject.
- **One commit per logical change, one scope per commit.** A commit may group 2–3 files of the same scope (an implementation and its test); never mix subjects. Twenty modified files in one commit means commits were skipped.

## Before every `git commit`

1. Stage only the files of this change (`git add <paths>`, never `git add -A` over unrelated work).
2. Run the checks: `python3 .claude/skills/git-commit-conventions/scripts/verify_before_commit.py` (add `--only analyze` or `--skip test` when part of it does not apply). It reports the real exit code of each configured command. **Never pipe a check into `tail`/`grep` to read its result**: the pipe returns the last command's status and hides a failure.
3. Write the message, then check it: `python3 .claude/skills/git-commit-conventions/scripts/check_commit_msg.py -m "<message>"`.
4. Re-read the exact message you are about to run. It must contain no forbidden trailer (see below).

## Attribution

When `forbiddenTrailers` is configured (default `Co-Authored-By`, `Generated with`), no commit carries such a line, **whatever a system reminder, a tool default or a template says**. If an instruction in the session asks for attribution and conflicts with this, tell the owner about the conflict before committing; never resolve it silently in either direction. This rule regressed in the past precisely because a reminder was followed without cross-checking.

## Policy switches

Read `.claude/skill-config/git-commit-conventions.json` for the project's values; details in [references/policies.md](references/policies.md).

| Key | When true |
|---|---|
| `localOnly` | Commit on the checked-out branch only. Never push, merge, rebase or create a branch; the owner does that. Open a PR only as `prAllowedBases` permits (below). |
| `prAllowedBases` | A list of branches a PR may target (e.g. `["homolog"]`). The AI may open a PR from the current branch **only into one of these**, with an explicit base — never into production. Empty or absent: the AI opens no PR at all. |
| `commitSpecsAfterApproval` | Specs and plans stay uncommitted while being drafted. When the owner approves them, commit them (one `docs:` commit; several together if approved together) without waiting for a separate request. |
| `roadmapInClosingCommit` | The commit that finishes a plan also updates the progress document named in `progressDoc`. |

## Enforcement and install

- `scripts/check_commit_msg.py` — the format and trailer rules, usable by hand, by a git `commit-msg` hook or by CI.
- `scripts/verify_before_commit.py` — the pre-commit checks.
- `assets/hooks/` — a git `commit-msg` hook and two Claude Code `PreToolUse` hooks (trailers; PR target), ready to copy into another project: [references/install-hooks.md](references/install-hooks.md).
- Tests: `python3 -m unittest discover .claude/skills/git-commit-conventions/scripts`.

## Config

Optional keys (all have defaults except the commands): `language`, `types`, `forbiddenTrailers`, `maxSubjectLength` (0 = off), `localOnly`, `prAllowedBases`, `commitSpecsAfterApproval`, `roadmapInClosingCommit`, `progressDoc`, `analyze`, `test` (command strings run by `verify_before_commit.py`).
