"""Tests for run_tests_checked.sh using a fake `flutter` so the exit code is under control."""
import os
import stat
import subprocess
import tempfile
import unittest

HERE = os.path.dirname(os.path.abspath(__file__))
SCRIPT = os.path.join(HERE, "run_tests_checked.sh")


def run(fake_body, *args):
    with tempfile.TemporaryDirectory() as d:
        fake = os.path.join(d, "flutter")
        with open(fake, "w") as f:
            f.write("#!/usr/bin/env bash\n" + fake_body + "\n")
        os.chmod(fake, os.stat(fake).st_mode | stat.S_IEXEC)
        env = dict(os.environ, FLUTTER_BIN=fake)
        r = subprocess.run(["bash", SCRIPT, *args], capture_output=True, text=True, env=env)
        return r.returncode, r.stdout


class RunTestsCheckedTest(unittest.TestCase):
    def test_pass_prints_one_verdict_and_exits_zero(self):
        code, out = run('echo "00:01 +12: All tests passed!"; exit 0')
        self.assertEqual(code, 0)
        self.assertEqual(out.strip().splitlines(), ["All tests passed"])

    def test_failure_exits_with_the_real_code_and_says_so(self):
        code, out = run('echo "00:01 +3 -2: Some tests failed."; exit 1')
        self.assertEqual(code, 1)
        self.assertIn("Some tests failed (exit 1)", out)
        self.assertNotIn("All tests passed", out)

    def test_output_that_looks_like_success_does_not_fool_it(self):
        code, out = run('echo "All tests passed!"; exit 1')
        self.assertEqual(code, 1)
        self.assertIn("Some tests failed (exit 1)", out)

    def test_failure_shows_the_tail_of_the_output(self):
        code, out = run('for i in $(seq 1 60); do echo "line $i"; done; exit 2')
        self.assertEqual(code, 2)
        self.assertIn("line 60", out)
        self.assertNotIn("line 1\n", out)

    def test_arguments_are_passed_through(self):
        code, out = run('echo "args: $@"; exit 1', "test/a_test.dart")
        self.assertIn("-r compact", out)
        self.assertIn("test/a_test.dart", out)


if __name__ == "__main__":
    unittest.main()
