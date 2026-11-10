# git-commit-conventions — policies

Each policy is a switch in `.claude/skill-config/git-commit-conventions.json`, so a project turns it on or off without editing the skill.

## Cadence

Commit incrementally while working, not at the end: right after each task is done and verified, commit that scope. Do not let changes pile up.

- A task is "done and verified" when the configured `analyze` and `test` checks pass (`verify_before_commit.py`).
- Documentation that belongs to the change (a pointer, an index line) goes in the same commit only when it has the same scope; otherwise it gets its own `docs(...)` commit.
- A fix found while doing something else is its own commit, with its own scope.

## `language`

The subject (and body) is written in this language; the `type` keywords stay as configured. The script cannot check the language — it is a convention the author keeps.

## `localOnly`

On: the AI commits to the current branch and stops. It does not push, merge, rebase, or create branches. Branch creation, pushing and promotion belong to the human owner. Pull requests: see `prAllowedBases`. Destructive history commands (reset, force operations) are outside this skill and need the owner's explicit request.

## `prAllowedBases`

A security rule, not a convenience. The AI may open a pull request **only from the branch it is working on into a branch listed here** (a pre-production branch such as `homolog`), always with an explicit base (`gh pr create --base homolog`). It never opens or retargets a PR into production (`main`, `master`, any release branch); promotion to production is the owner's. Not listed = not allowed, so a new production branch needs no change as a target. The head is checked too: the PR must start from the working branch (`--head`, or the current branch), never from a protected production branch (`protected_heads` in the hook: `main master production prod`); if the head cannot be determined the hook refuses. The AI still does not push: the branch must already be on the remote, put there by the owner. Merging a PR stays the owner's.

Enforced by `assets/hooks/guard-pr-target.sh`, which blocks `gh pr create` without or with a disallowed `--base`/`-B`, `gh pr edit --base` to a disallowed branch, `gh api` calls that create or change pull requests, and `glab mr create/update`. The hook cannot know the host's real default branch, so it requires the explicit base instead of guessing.

## `commitSpecsAfterApproval`

On: while brainstorming and drafting, the specification and plan files stay local and uncommitted. When the owner approves them, commit them straight away as one `docs:` commit (several specs/plans together if they were approved together). A spec or plan moved to an "executed" folder after its execution is committed the same way. Do not commit a draft that has not been approved.

## `roadmapInClosingCommit`

On: the commit that closes a plan also updates the progress document (`progressDoc`) so the plan list and the code agree at every commit.

## Attribution trailers

`forbiddenTrailers` lists strings that must not appear anywhere in a commit message. The scripts and hooks match them case-insensitively. The bundled Claude hook also blocks the command line itself, which means that a shell command quoting such a string next to `git commit` is blocked too — keep test data in files, not in command lines.
