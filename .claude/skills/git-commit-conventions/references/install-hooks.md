# Installing the commit hooks in another project

Two layers, because they see different commits:

| Layer | Sees | File |
|---|---|---|
| Git `commit-msg` hook | **Every** `git commit` — yours and the AI's | `assets/hooks/commit-msg` |
| Claude Code `PreToolUse` hook | Only commits the AI runs through its Bash tool, and it blocks them before they run | `assets/hooks/block-coauthor-commit.sh` |

## 1. Copy the skill

Copy the whole `git-commit-conventions/` folder to `.claude/skills/` of the other project, then create `.claude/skill-config/git-commit-conventions.json` with that project's values (see the SKILL.md config list).

## 2. Git hook

```bash
mkdir -p .githooks
cp .claude/skills/git-commit-conventions/assets/hooks/commit-msg .githooks/commit-msg
chmod +x .githooks/commit-msg
git config core.hooksPath .githooks          # once per clone; git never installs tracked hooks by itself
```

The hook calls `scripts/check_commit_msg.py`. If the skill lives elsewhere, set `COMMIT_SKILL_DIR`.

## 3. Claude Code hook

```bash
mkdir -p .claude/hooks
cp .claude/skills/git-commit-conventions/assets/hooks/block-coauthor-commit.sh .claude/hooks/
chmod +x .claude/hooks/block-coauthor-commit.sh
```

Register it in `.claude/settings.json`:

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Bash",
        "hooks": [
          {
            "type": "command",
            "command": "bash \"$CLAUDE_PROJECT_DIR/.claude/hooks/block-coauthor-commit.sh\"",
            "statusMessage": "Checking commit message for attribution trailers..."
          }
        ]
      }
    ]
  }
}
```

Edit `forbidden_pattern` at the top of the script so it matches `forbiddenTrailers` in the config. Requires `jq`.

### PR target guard (only if the project lets the AI open pull requests)

```bash
cp .claude/skills/git-commit-conventions/assets/hooks/guard-pr-target.sh .claude/hooks/
chmod +x .claude/hooks/guard-pr-target.sh
```

Add a second entry under `PreToolUse` → `hooks` (same `matcher: "Bash"`) running `bash "$CLAUDE_PROJECT_DIR/.claude/hooks/guard-pr-target.sh"`, set `allowed_bases` at the top of the script to match `prAllowedBases` (and `protected_heads` to your production branch names), and remove any blanket `deny` of `gh pr create` from the permissions (a `deny` always wins over the hook's decision). Keep `gh pr merge` denied.

## 4. Check

```bash
python3 -m unittest discover .claude/skills/git-commit-conventions/scripts
```
