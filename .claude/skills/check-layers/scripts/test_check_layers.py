"""Tests for check_layers.py against the fixtures in assets/fixtures/."""
import json
import os
import subprocess
import sys
import tempfile
import unittest

HERE = os.path.dirname(os.path.abspath(__file__))
SCRIPT = os.path.join(HERE, "check_layers.py")
FIXTURES = os.path.join(HERE, "..", "assets", "fixtures")


def run(case, *extra):
    root = os.path.join(FIXTURES, case, "lib")
    r = subprocess.run(
        [sys.executable, SCRIPT, "--root", root, *extra], capture_output=True, text=True
    )
    return r.returncode, r.stdout


def findings(out):
    """`path:line: rule` for each finding line (the hint after ' — ' is not asserted)."""
    return sorted(line.split(" — ")[0] for line in out.splitlines() if " — " in line)


class CheckLayersTest(unittest.TestCase):
    def test_clean_tree_passes(self):
        code, out = run("clean")
        self.assertEqual(code, 0, out)
        self.assertEqual(out.strip(), "")

    def test_lookalikes_do_not_flag(self):
        code, out = run("lookalike")
        self.assertEqual(code, 0, out)

    def test_each_violation_is_reported_with_its_rule(self):
        code, out = run("violations")
        self.assertEqual(code, 1)
        d = "features/a/domain/entities/"
        self.assertEqual(
            findings(out),
            sorted(
                [
                    "core/bad_core.dart:1: core-imports-features",
                    f"{d}flutter_leak.dart:1: domain-imports",
                    f"{d}data_leak.dart:1: domain-imports",
                    f"{d}other_pkg.dart:1: domain-imports",
                    f"{d}lookalike_pkg.dart:1: domain-imports",
                    f"{d}ui_leak.dart:1: domain-imports",
                    f"{d}impure_core.dart:1: domain-impure-core",
                    f"{d}transitive.dart:1: domain-impure-core",
                    f"{d}plugin_core.dart:1: domain-impure-core",
                    f"{d}cross.dart:1: cross-feature-import",
                    "features/a/data/models/a_model.dart:2: data-imports-presentation",
                    "features/a/presentation/screens/a_screen.dart:2: presentation-imports-data",
                    "features/a/application/a_bloc.dart:1: application-imports-presentation",
                ]
            ),
            out,
        )

    def test_transitive_finding_names_the_chain(self):
        _, out = run("violations")
        line = next(l for l in out.splitlines() if "transitive.dart" in l)
        self.assertIn("core/wrapper/uses_widgets.dart", line)
        self.assertIn("core/widgets/app_button.dart", line)
        self.assertIn("package:flutter", line)

    def test_allow_entry_with_reason_suppresses_one_finding(self):
        cfg = {
            "allow": [
                {
                    "rule": "domain-impure-core",
                    "file": "features/a/domain/entities/impure_core.dart",
                    "import": "core/widgets/app_button.dart",
                    "reason": "fixture: pretend this module is pure",
                }
            ]
        }
        with tempfile.NamedTemporaryFile("w", suffix=".json", delete=False) as f:
            json.dump(cfg, f)
        try:
            _, out = run("violations", "--config", f.name)
        finally:
            os.unlink(f.name)
        self.assertNotIn("impure_core.dart", out)
        self.assertIn("transitive.dart", out)

    def test_allow_entry_with_folder_prefix_covers_every_file_under_it(self):
        cfg = {
            "allow": [
                {
                    "rule": "core-imports-features",
                    "file": "core/",
                    "import": "features/",
                    "reason": "fixture: pretend core/ is a composition root",
                }
            ]
        }
        with tempfile.NamedTemporaryFile("w", suffix=".json", delete=False) as f:
            json.dump(cfg, f)
        try:
            _, out = run("violations", "--config", f.name)
        finally:
            os.unlink(f.name)
        self.assertNotIn("core-imports-features", out)
        self.assertIn("domain-impure-core", out)

    def test_allow_entry_without_reason_is_rejected(self):
        cfg = {"allow": [{"rule": "domain-impure-core", "file": "x", "import": "y"}]}
        with tempfile.NamedTemporaryFile("w", suffix=".json", delete=False) as f:
            json.dump(cfg, f)
        try:
            code, out = run("violations", "--config", f.name)
        finally:
            os.unlink(f.name)
        self.assertEqual(code, 2)
        self.assertIn("reason", out)

    def test_domain_allowed_packages_come_from_config(self):
        with tempfile.NamedTemporaryFile("w", suffix=".json", delete=False) as f:
            json.dump({"domainAllowedPackages": ["equatable", "dio"]}, f)
        try:
            _, out = run("violations", "--config", f.name)
        finally:
            os.unlink(f.name)
        self.assertNotIn("other_pkg.dart", out)

    def test_summary_lists_layers_and_counts(self):
        code, out = run("clean", "--summary")
        self.assertEqual(code, 0)
        for layer in ("domain", "data", "application", "presentation", "core"):
            self.assertRegex(out, rf"(?m)^{layer}\s+\d+\s+0$")

    def test_missing_root_is_an_error(self):
        r = subprocess.run(
            [sys.executable, SCRIPT, "--root", "/nonexistent/lib"], capture_output=True, text=True
        )
        self.assertEqual(r.returncode, 2)


if __name__ == "__main__":
    unittest.main()
