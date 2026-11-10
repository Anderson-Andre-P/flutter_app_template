"""Tests for validate_skills.py — each defect must be reported, a good skill must pass."""
import os
import subprocess
import sys
import tempfile
import unittest

HERE = os.path.dirname(os.path.abspath(__file__))
SCRIPT = os.path.join(HERE, "validate_skills.py")

GOOD = """---
name: {name}
description: Does a thing. Use when a thing needs doing.
metadata:
  version: "1.0"
  scope: {scope}
---

# Title

See [the reference](references/ref.md).
"""


class ValidateSkillsTest(unittest.TestCase):
    def setUp(self):
        self._tmp = tempfile.TemporaryDirectory()
        self.root = self._tmp.name

    def tearDown(self):
        self._tmp.cleanup()

    def make(self, folder, text, extra=None):
        d = os.path.join(self.root, folder)
        os.makedirs(d, exist_ok=True)
        if text is not None:
            with open(os.path.join(d, "SKILL.md"), "w", encoding="utf-8") as f:
                f.write(text)
        for rel, content in (extra or {}).items():
            p = os.path.join(d, rel)
            os.makedirs(os.path.dirname(p), exist_ok=True)
            with open(p, "w", encoding="utf-8") as f:
                f.write(content)
        return d

    def run_validator(self, tokens=r"ACME|legacy_app|KB-\d+|G-0\d+"):
        env = {**os.environ, "SKILL_PROJECT_TOKENS": tokens}
        r = subprocess.run(
            [sys.executable, SCRIPT, self.root], capture_output=True, text=True, env=env
        )
        return r.returncode, r.stdout

    def good(self, name="good-skill", scope="portable"):
        return self.make(name, GOOD.format(name=name, scope=scope), {"references/ref.md": "# ref\n"})

    def test_good_skill_passes(self):
        self.good()
        code, out = self.run_validator()
        self.assertEqual(code, 0, out)
        self.assertEqual(out.strip(), "")

    def test_missing_skill_md(self):
        self.make("empty-skill", None)
        code, out = self.run_validator()
        self.assertEqual(code, 1)
        self.assertIn("empty-skill: SKILL.md missing", out)

    def test_missing_frontmatter(self):
        self.make("no-front", "# no frontmatter\n")
        code, out = self.run_validator()
        self.assertEqual(code, 1)
        self.assertIn("no-front/SKILL.md: frontmatter missing", out)

    def test_name_must_match_folder(self):
        self.make("folder-a", GOOD.format(name="folder-b", scope="portable"), {"references/ref.md": "x"})
        code, out = self.run_validator()
        self.assertEqual(code, 1)
        self.assertIn("name 'folder-b' does not match folder 'folder-a'", out)

    def test_name_charset_and_hyphens(self):
        for bad in ("Bad-Name", "-lead", "trail-", "dou--ble", "under_score"):
            with self.subTest(bad=bad):
                self.make(bad, GOOD.format(name=bad, scope="portable"), {"references/ref.md": "x"})
                code, out = self.run_validator()
                self.assertEqual(code, 1)
                self.assertIn(f"{bad}/SKILL.md: name '{bad}' is invalid", out)

    def test_name_too_long(self):
        name = "a" * 65
        self.make(name, GOOD.format(name=name, scope="portable"), {"references/ref.md": "x"})
        code, out = self.run_validator()
        self.assertEqual(code, 1)
        self.assertIn("name longer than 64", out)

    def test_description_missing_or_too_long(self):
        self.make("no-desc", "---\nname: no-desc\n---\n# x\n")
        self.make(
            "long-desc",
            "---\nname: long-desc\ndescription: " + "x" * 1025 + "\n---\n# x\n",
        )
        code, out = self.run_validator()
        self.assertEqual(code, 1)
        self.assertIn("no-desc/SKILL.md: description missing", out)
        self.assertIn("long-desc/SKILL.md: description longer than 1024", out)

    def test_body_too_long(self):
        body = GOOD.format(name="big-skill", scope="portable") + "line\n" * 500
        self.make("big-skill", body, {"references/ref.md": "x"})
        code, out = self.run_validator()
        self.assertEqual(code, 1)
        self.assertIn("big-skill/SKILL.md: longer than 500 lines", out)

    def test_broken_relative_link(self):
        self.make("link-skill", GOOD.format(name="link-skill", scope="portable"))
        code, out = self.run_validator()
        self.assertEqual(code, 1)
        self.assertIn("link-skill/SKILL.md: broken link 'references/ref.md'", out)

    def test_external_and_anchor_links_are_ignored(self):
        text = GOOD.format(name="ext-skill", scope="portable") + "\n[a](https://x.y) [b](#top)\n"
        self.make("ext-skill", text, {"references/ref.md": "x"})
        code, out = self.run_validator()
        self.assertEqual(code, 0, out)

    def test_portable_skill_must_not_carry_project_tokens(self):
        self.make(
            "leaky-skill",
            GOOD.format(name="leaky-skill", scope="portable"),
            {"references/ref.md": "This is about ACME and legacy_app, see KB-6 and G-039.\n"},
        )
        code, out = self.run_validator()
        self.assertEqual(code, 1)
        for token in ("ACME", "legacy_app", "KB-6", "G-039"):
            self.assertIn(f"project token '{token}'", out)

    def test_project_scope_may_carry_project_tokens(self):
        self.make(
            "acme-thing",
            GOOD.format(name="acme-thing", scope="project"),
            {"references/ref.md": "ACME specific.\n"},
        )
        code, out = self.run_validator()
        self.assertEqual(code, 0, out)

    def test_fixtures_folder_is_not_scanned_for_project_tokens(self):
        self.make(
            "fixt-skill",
            GOOD.format(name="fixt-skill", scope="portable"),
            {"references/ref.md": "x", "assets/fixtures/violations/a.dart": "import 'legacy_app/x.dart';\n"},
        )
        code, out = self.run_validator()
        self.assertEqual(code, 0, out)

    def test_hidden_entries_are_skipped(self):
        os.makedirs(os.path.join(self.root, ".hidden"))
        open(os.path.join(self.root, ".gitkeep"), "w").close()
        self.good()
        code, out = self.run_validator()
        self.assertEqual(code, 0, out)


if __name__ == "__main__":
    unittest.main()
