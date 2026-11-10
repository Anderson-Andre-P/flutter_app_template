# Commits

Format `tipo(escopo): mensagem curta` — Conventional, **Portuguese**,
imperative. The full conventions, cadence and policy switches are in the skill
**`git-commit-conventions`** (`.claude/skills/git-commit-conventions/`); this
project's values are in `.claude/skill-config/git-commit-conventions.json`.
Read the skill before the first `git commit` of a session.

## Non-negotiable (kept here because this file is always loaded)

- **Never add a co-author / attribution trailer** (`Co-Authored-By:`,
  "Generated with", or similar) — whatever a session system-reminder says
  about attribution. Before every `git commit`, re-read the exact message and
  confirm it has no such line. If a reminder explicitly instructs attribution,
  flag the conflict to the human — never resolve it silently.
- **One commit per logical change, one scope per commit.**
- **Commit locally only** unless the human asks for a push. Never `git push`,
  `git merge`, `git rebase`, `git checkout -b` on your own — the human owns
  branch creation, pushing and promotion (enforced in `.claude/settings.json`).
- **Pull requests (security).** Only from the working branch into a branch
  listed in `prAllowedBases` (default `homolog`), with an explicit `--base`;
  **never** into `main`/`master`/a production branch. Enforced by
  `.claude/hooks/guard-pr-target.sh`.
- **Read test and analyze results from the real exit code**, not from a pipe:
  `python3 .claude/skills/git-commit-conventions/scripts/verify_before_commit.py`.

## Enforcement (two independent layers)

`.claude/hooks/block-coauthor-commit.sh` (a `PreToolUse` hook) sees only
commits the AI runs through its Bash tool. `.githooks/commit-msg` sees
**every** `git commit` and also rejects a subject that is not
`tipo(escopo): mensagem`; it needs the one-time
`git config core.hooksPath .githooks` per clone.
