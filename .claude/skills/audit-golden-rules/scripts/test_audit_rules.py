"""Tests for audit_rules.py against the fixtures in assets/fixtures/.

The `violations` and `lookalike` fixtures carry their own
`.claude/skill-config/audit-golden-rules.json`, so these tests also cover config auto-discovery.
"""
import json
import os
import subprocess
import sys
import tempfile
import unittest

HERE = os.path.dirname(os.path.abspath(__file__))
SCRIPT = os.path.join(HERE, "audit_rules.py")
FIXTURES = os.path.join(HERE, "..", "assets", "fixtures")


def run(case, *extra):
    root = os.path.join(FIXTURES, case, "lib")
    r = subprocess.run([sys.executable, SCRIPT, "--root", root, *extra], capture_output=True, text=True)
    return r.returncode, r.stdout


def findings(out):
    """`path:line: rule` for each finding (the hint after ' — ' is not asserted)."""
    return sorted(line.split(" — ")[0] for line in out.splitlines() if " — " in line)


def with_config(cfg, fn):
    with tempfile.NamedTemporaryFile("w", suffix=".json", delete=False) as f:
        json.dump(cfg, f)
    try:
        return fn(f.name)
    finally:
        os.unlink(f.name)


EXPECTED = sorted(
    [
        "features/a/presentation/bloc/counter_cubit.dart:2: no-cubit",
        "features/a/presentation/bloc/counter_cubit.dart:3: no-cubit",
        "features/a/data/models/gen.dart:1: no-json-codegen",
        "features/a/data/models/gen.dart:2: no-json-codegen",
        "features/a/data/models/gen.dart:4: no-json-codegen",
        "features/a/data/models/gen.dart:6: no-json-codegen",
        "features/a/data/models/other.g.dart:1: no-json-codegen",
        "features/a/application/notifier.dart:1: no-provider-changenotifier",
        "features/a/application/notifier.dart:3: no-provider-changenotifier",
        "features/a/data/legacy.dart:1: no-forbidden-import",
        "features/a/presentation/screens/strings.dart:4: no-literal-user-strings",
        "features/a/presentation/screens/strings.dart:8: no-literal-user-strings",
        "features/a/presentation/screens/strings.dart:9: no-literal-user-strings",
        "features/a/presentation/widgets/colours.dart:3: no-colour-literals",
        "features/a/presentation/widgets/colours.dart:6: no-colour-literals",
        "features/a/presentation/widgets/colours.dart:7: no-colour-literals",
        "features/a/presentation/widgets/spacing.dart:3: no-spacing-literals",
        "features/a/presentation/widgets/spacing.dart:6: no-spacing-literals",
        "features/a/presentation/widgets/radius.dart:3: no-radius-literals",
        "features/a/presentation/widgets/radius.dart:5: no-radius-literals",
        "features/a/domain/entities/refuel.dart:2: decimal-fields-not-double",
        "features/a/domain/entities/refuel.dart:4: decimal-fields-not-double",
    ]
)


class AuditRulesTest(unittest.TestCase):
    def test_lookalikes_do_not_flag(self):
        code, out = run("lookalike")
        self.assertEqual(code, 0, out)
        self.assertEqual(out.strip(), "")

    def test_every_rule_reports_exactly_its_violations(self):
        code, out = run("violations")
        self.assertEqual(code, 1)
        self.assertEqual(findings(out), EXPECTED, out)

    def test_rule_filter_runs_only_that_rule(self):
        _, out = run("violations", "--rule", "no-cubit")
        self.assertEqual({l.split(": ")[1].split(" ")[0] for l in findings(out)}, {"no-cubit"})
        self.assertEqual(len(findings(out)), 2)

    def test_unknown_rule_is_an_error(self):
        code, out = run("violations", "--rule", "no-such-rule")
        self.assertEqual(code, 2)
        self.assertIn("no-such-rule", out)

    def test_disabled_rules_are_skipped(self):
        cfg = {"disabledRules": ["no-spacing-literals", "no-colour-literals"], "decimalFieldNames": ["liters"]}
        _, out = with_config(cfg, lambda p: run("violations", "--config", p))
        self.assertNotIn("no-spacing-literals", out)
        self.assertNotIn("no-colour-literals", out)
        self.assertIn("no-literal-user-strings", out)

    def test_allow_with_contains_suppresses_only_matching_lines(self):
        cfg = {
            "decimalFieldNames": ["liters"],
            "allow": [
                {
                    "rule": "no-colour-literals",
                    "file": "features/a/presentation/widgets/colours.dart",
                    "contains": "Colors.red",
                    "reason": "fixture: brand colour kept from the reference app",
                }
            ],
        }
        _, out = with_config(cfg, lambda p: run("violations", "--config", p))
        self.assertNotIn("colours.dart:3:", out)
        self.assertIn("colours.dart:6:", out)

    def test_allow_with_folder_prefix(self):
        cfg = {
            "allow": [{"rule": "no-spacing-literals", "file": "features/a/presentation/", "reason": "fixture: baseline"}]
        }
        _, out = with_config(cfg, lambda p: run("violations", "--config", p))
        self.assertNotIn("no-spacing-literals", out)

    def test_allow_with_max_count_is_a_ratchet(self):
        entry = {
            "rule": "no-colour-literals",
            "file": "features/a/presentation/widgets/colours.dart",
            "maxCount": 2,
            "reason": "fixture: baseline of existing literals",
        }
        _, out = with_config({"allow": [entry]}, lambda p: run("violations", "--config", p))
        self.assertNotIn("colours.dart:3:", out)  # first two are covered...
        self.assertNotIn("colours.dart:6:", out)
        self.assertIn("colours.dart:7:", out)  # ...the third is new

    def test_suggest_allow_prints_entries_that_make_the_tree_pass(self):
        code, out = run("violations", "--suggest-allow", "--reason", "fixture baseline")
        self.assertEqual(code, 0)
        entries = json.loads(out)
        by_key = {(e["rule"], e["file"]): e for e in entries}
        colours = by_key[("no-colour-literals", "features/a/presentation/widgets/colours.dart")]
        self.assertEqual(colours["maxCount"], 3)
        self.assertEqual(colours["reason"], "fixture baseline")
        cfg = {"allow": entries, "decimalFieldNames": ["liters", "odometer"], "forbiddenImportPrefixes": ["old_app"]}
        code, out = with_config(cfg, lambda p: run("violations", "--config", p))
        self.assertEqual(code, 0, out)

    def test_suggest_allow_requires_a_reason(self):
        code, out = run("violations", "--suggest-allow")
        self.assertEqual(code, 2)
        self.assertIn("--reason", out)

    def test_allow_without_reason_is_rejected(self):
        cfg = {"allow": [{"rule": "no-cubit", "file": "x"}]}
        code, out = with_config(cfg, lambda p: run("violations", "--config", p))
        self.assertEqual(code, 2)
        self.assertIn("reason", out)

    def test_ignore_paths_skip_a_rule_in_a_folder(self):
        cfg = {"ignorePaths": {"no-cubit": ["features/a/presentation/bloc/"]}}
        _, out = with_config(cfg, lambda p: run("violations", "--config", p))
        self.assertNotIn("no-cubit", out)

    def test_summary_counts_per_rule(self):
        _, out = run("violations", "--summary")
        self.assertRegex(out, r"(?m)^no-cubit\s+2$")
        self.assertRegex(out, r"(?m)^no-json-codegen\s+5$")

    def test_missing_root_is_an_error(self):
        r = subprocess.run([sys.executable, SCRIPT, "--root", "/nonexistent/lib"], capture_output=True, text=True)
        self.assertEqual(r.returncode, 2)


if __name__ == "__main__":
    unittest.main()
