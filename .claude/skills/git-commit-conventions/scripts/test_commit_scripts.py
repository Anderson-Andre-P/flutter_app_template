"""Tests for check_commit_msg.py and verify_before_commit.py."""
import json
import os
import subprocess
import sys
import tempfile
import unittest

HERE = os.path.dirname(os.path.abspath(__file__))
CHECK = os.path.join(HERE, "check_commit_msg.py")
VERIFY = os.path.join(HERE, "verify_before_commit.py")


def check(message=None, file_text=None, config=None):
    """Run check_commit_msg.py; returns (exit code, stdout)."""
    args = [sys.executable, CHECK]
    tmp = []
    if config is not None:
        f = tempfile.NamedTemporaryFile("w", suffix=".json", delete=False)
        json.dump(config, f)
        f.close()
        tmp.append(f.name)
        args += ["--config", f.name]
    if file_text is not None:
        m = tempfile.NamedTemporaryFile("w", suffix=".txt", delete=False)
        m.write(file_text)
        m.close()
        tmp.append(m.name)
        args += [m.name]
    else:
        args += ["-m", message]
    try:
        r = subprocess.run(args, capture_output=True, text=True, cwd=tempfile.gettempdir())
        return r.returncode, r.stdout
    finally:
        for t in tmp:
            os.unlink(t)


GOOD = [
    "feat(auth): adiciona o login",
    "fix(splash): trata timestamp nulo na verificação de sessão",
    "docs(refactor): registra gap na modelagem do outbox",
    "chore(deps): adiciona get_it",
    "refactor(core): extrai o outbox para core/sync",
    "feat(service_orders): migra a tela",
    "fix(a.b/c-d): escopo com símbolos permitidos",
    "Merge branch 'x' into y",
    "feat(auth): linha de assunto\n\ncorpo explicando o porquê",
]
BAD = {
    "adiciona o login": "does not match",
    "feat: sem escopo": "does not match",
    "feat(auth) sem dois pontos": "does not match",
    "Feat(auth): maiúscula no tipo": "does not match",
    "feat(auth):sem espaço": "does not match",
    "wip(auth): tipo inválido": "does not match",
    "feat(auth): ": "does not match",
    "feat(auth, home): dois escopos": "one scope",
    "feat(auth+home): dois escopos": "one scope",
    "feat(auth): ok\n\nCo-Authored-By: Alguém <a@b.c>": "forbidden trailer",
    "feat(auth): ok\n\nco-authored-by: alguém": "forbidden trailer",
    "feat(auth): ok\n\nGenerated with Tool": "forbidden trailer",
    "feat(auth): ok\ncorpo sem linha em branco": "blank line",
}


class CheckCommitMsgTest(unittest.TestCase):
    def test_good_messages_pass(self):
        for msg in GOOD:
            with self.subTest(msg=msg):
                code, out = check(msg)
                self.assertEqual(code, 0, out)

    def test_bad_messages_fail_with_the_right_reason(self):
        for msg, reason in BAD.items():
            with self.subTest(msg=msg):
                code, out = check(msg)
                self.assertEqual(code, 1, out)
                self.assertIn(reason, out)

    def test_message_file_is_read_and_git_comment_lines_are_ignored(self):
        code, out = check(file_text="feat(auth): ok\n# Please enter the commit message\n# Co-Authored-By: in a comment\n")
        self.assertEqual(code, 0, out)

    def test_trailer_in_a_message_file_is_caught(self):
        code, out = check(file_text="feat(auth): ok\n\nGenerated with X\n")
        self.assertEqual(code, 1)

    def test_types_come_from_config(self):
        code, _ = check("wip(auth): custom type", config={"types": ["wip", "feat"]})
        self.assertEqual(code, 0)
        code, _ = check("fix(auth): not in this config", config={"types": ["wip", "feat"]})
        self.assertEqual(code, 1)

    def test_forbidden_trailers_come_from_config(self):
        code, _ = check("feat(a): ok\n\nSigned-off-by: x", config={"forbiddenTrailers": ["Signed-off-by"]})
        self.assertEqual(code, 1)
        code, _ = check("feat(a): ok\n\nCo-Authored-By: x", config={"forbiddenTrailers": []})
        self.assertEqual(code, 0)

    def test_max_subject_length_is_optional(self):
        long = "feat(a): " + "x" * 100
        self.assertEqual(check(long)[0], 0)
        code, out = check(long, config={"maxSubjectLength": 72})
        self.assertEqual(code, 1)
        self.assertIn("longer than 72", out)

    def test_no_message_is_a_usage_error(self):
        r = subprocess.run([sys.executable, CHECK], capture_output=True, text=True)
        self.assertEqual(r.returncode, 2)


def verify(config, *extra):
    f = tempfile.NamedTemporaryFile("w", suffix=".json", delete=False)
    json.dump(config, f)
    f.close()
    try:
        r = subprocess.run(
            [sys.executable, VERIFY, "--config", f.name, *extra], capture_output=True, text=True
        )
        return r.returncode, r.stdout
    finally:
        os.unlink(f.name)


PY = sys.executable
OK = f"{PY} -c \"print('All tests passed')\""
FAIL_LOOKS_OK = f"{PY} -c \"import sys; print('All tests passed'); sys.exit(1)\""
FAIL = f"{PY} -c \"import sys; print('boom'); sys.exit(3)\""


class VerifyBeforeCommitTest(unittest.TestCase):
    def test_all_pass(self):
        code, out = verify({"analyze": OK, "test": OK})
        self.assertEqual(code, 0, out)
        self.assertIn("PASS analyze", out)
        self.assertIn("PASS test", out)

    def test_exit_code_decides_not_the_output(self):
        code, out = verify({"analyze": OK, "test": FAIL_LOOKS_OK})
        self.assertEqual(code, 1)
        self.assertIn("FAIL test (exit 1)", out)

    def test_failure_shows_the_tail_of_the_output(self):
        code, out = verify({"analyze": FAIL})
        self.assertEqual(code, 1)
        self.assertIn("FAIL analyze (exit 3)", out)
        self.assertIn("boom", out)

    def test_only_and_skip(self):
        code, out = verify({"analyze": FAIL, "test": OK}, "--only", "test")
        self.assertEqual(code, 0, out)
        self.assertNotIn("analyze", out)
        code, out = verify({"analyze": FAIL, "test": OK}, "--skip", "analyze")
        self.assertEqual(code, 0, out)

    def test_missing_command_in_config_is_skipped_with_a_note(self):
        code, out = verify({"analyze": OK})
        self.assertEqual(code, 0, out)
        self.assertIn("SKIP test", out)

    def test_unrunnable_command_is_a_failure(self):
        code, out = verify({"analyze": "definitely-not-a-command-xyz"})
        self.assertEqual(code, 1)
        self.assertIn("FAIL analyze", out)

    def test_missing_config_is_a_usage_error(self):
        r = subprocess.run(
            [sys.executable, VERIFY, "--config", "/nonexistent.json"], capture_output=True, text=True
        )
        self.assertEqual(r.returncode, 2)


HOOKS = os.path.join(HERE, "..", "assets", "hooks")
TRAILER = "Co-Authored-" + "By: someone"  # assembled so this file never trips a literal-text scanner


def hook_decision(command):
    """Feed a PreToolUse payload to the bundled Claude hook; return 'deny' or '' (allowed)."""
    payload = json.dumps({"tool_input": {"command": command}})
    r = subprocess.run(
        ["bash", os.path.join(HOOKS, "block-coauthor-commit.sh")], input=payload, capture_output=True, text=True
    )
    assert r.returncode == 0, r.stderr
    return json.loads(r.stdout)["hookSpecificOutput"]["permissionDecision"] if r.stdout.strip() else ""


_WORK_REPO = tempfile.mkdtemp(prefix="pr-hook-")  # a repo on a working branch, so default-head cases do not depend on this checkout
subprocess.run(["git", "init", "-q", "-b", "feat/work", _WORK_REPO], check=False)


def pr_hook_decision(command, cwd=None):
    payload = json.dumps({"tool_input": {"command": command}, "cwd": cwd or _WORK_REPO})
    r = subprocess.run(
        ["bash", os.path.join(HOOKS, "guard-pr-target.sh")], input=payload, capture_output=True, text=True
    )
    assert r.returncode == 0, r.stderr
    return json.loads(r.stdout)["hookSpecificOutput"]["permissionDecision"] if r.stdout.strip() else ""


@unittest.skipUnless(subprocess.run(["which", "jq"], capture_output=True).returncode == 0, "jq not installed")
class BundledHooksTest(unittest.TestCase):
    def test_claude_hook_blocks_a_trailer_in_the_command(self):
        self.assertEqual(hook_decision(f'git commit -m "feat(a): x\n\n{TRAILER}"'), "deny")
        self.assertEqual(hook_decision('cd x && git commit -m "feat(a): x Generated with Foo"'), "deny")

    def test_claude_hook_blocks_a_trailer_when_git_has_options_before_commit(self):
        self.assertEqual(hook_decision(f'git -c user.name=x commit -m "feat(a): x\n\n{TRAILER}"'), "deny")
        self.assertEqual(hook_decision(f'git -C some/dir commit -m "feat(a): x\n\n{TRAILER}"'), "deny")
        self.assertEqual(hook_decision('git -C some/dir commit -m "feat(a): x"'), "")

    def test_claude_hook_blocks_a_trailer_in_a_message_file(self):
        with tempfile.NamedTemporaryFile("w", suffix=".txt", delete=False) as f:
            f.write(f"feat(a): x\n\n{TRAILER}\n")
        try:
            self.assertEqual(hook_decision(f"git commit -F {f.name}"), "deny")
        finally:
            os.unlink(f.name)

    def test_claude_hook_lets_clean_commits_and_other_commands_through(self):
        self.assertEqual(hook_decision('git commit -m "feat(a): x"'), "")
        self.assertEqual(hook_decision("ls -la"), "")
        self.assertEqual(hook_decision(f'echo "{TRAILER}: only text, no commit"'), "")

    def test_pr_hook_allows_only_the_configured_base(self):
        pr = lambda c: pr_hook_decision(c)
        self.assertEqual(pr("gh pr create --base homolog --title t --body b"), "")
        self.assertEqual(pr("gh pr create -B homolog --fill"), "")
        self.assertEqual(pr("gh pr create --base=homolog --fill"), "")
        self.assertEqual(pr('cd x && gh pr create --base "homolog" --fill'), "")
        for bad in ("main", "master", "production", "release"):
            self.assertEqual(pr(f"gh pr create --base {bad} --fill"), "deny", bad)
        self.assertEqual(pr("gh pr create -B main --fill"), "deny")
        self.assertEqual(pr("gh pr create --base $BASE --fill"), "deny")

    def test_pr_hook_requires_an_explicit_base(self):
        self.assertEqual(pr_hook_decision("gh pr create --fill"), "deny")
        self.assertEqual(pr_hook_decision("gh pr create"), "deny")

    def test_pr_hook_guards_retarget_api_and_glab(self):
        self.assertEqual(pr_hook_decision("gh pr edit 12 --base main"), "deny")
        self.assertEqual(pr_hook_decision("gh pr edit 12 --base homolog"), "")
        self.assertEqual(pr_hook_decision("gh pr edit 12 --title t"), "")
        self.assertEqual(pr_hook_decision("gh api repos/o/r/pulls -f base=main -f head=x"), "deny")
        self.assertEqual(pr_hook_decision("gh api -X POST repos/o/r/pulls"), "deny")
        self.assertEqual(pr_hook_decision("gh api repos/o/r/pulls"), "")
        self.assertEqual(pr_hook_decision("glab mr create --target-branch main"), "deny")

    def test_pr_hook_blocks_a_pr_that_starts_from_production(self):
        for bad in ("main", "master", "production", "someone:main"):
            self.assertEqual(pr_hook_decision(f"gh pr create --base homolog --head {bad} --fill"), "deny", bad)
        self.assertEqual(pr_hook_decision("gh pr create --base homolog -H main --fill"), "deny")
        self.assertEqual(pr_hook_decision("gh pr create --base homolog --head feat/x --fill"), "")
        self.assertEqual(pr_hook_decision("gh pr create --base homolog --head me:feat/x --fill"), "")

    def test_pr_hook_uses_the_current_branch_when_no_head_is_given(self):
        for branch, want in (("main", "deny"), ("master", "deny"), ("feat/x", "")):
            with tempfile.TemporaryDirectory() as d:
                subprocess.run(["git", "init", "-q", "-b", branch, d], check=True)
                self.assertEqual(pr_hook_decision("gh pr create --base homolog --fill", cwd=d), want, branch)

    def test_pr_hook_fails_closed_when_the_head_is_unknown(self):
        with tempfile.TemporaryDirectory() as d:  # not a git repo, no --head
            self.assertEqual(pr_hook_decision("gh pr create --base homolog --fill", cwd=d), "deny")

    def test_pr_hook_ignores_other_commands(self):
        for c in ("gh pr view 3", "gh pr list", "git status", 'echo "gh pr create --base main"'):
            self.assertEqual(pr_hook_decision(c), "", c)

    def test_git_hook_uses_the_script(self):
        skill = os.path.abspath(os.path.join(HERE, ".."))
        env = dict(os.environ, COMMIT_SKILL_DIR=skill)
        for text, expected in (("feat(a): ok\n", 0), ("nonsense\n", 1)):
            with tempfile.NamedTemporaryFile("w", suffix=".txt", delete=False) as f:
                f.write(text)
            try:
                r = subprocess.run(
                    ["bash", os.path.join(HOOKS, "commit-msg"), f.name], env=env, capture_output=True, text=True
                )
                self.assertEqual(r.returncode, expected, r.stdout)
            finally:
                os.unlink(f.name)


if __name__ == "__main__":
    unittest.main()
