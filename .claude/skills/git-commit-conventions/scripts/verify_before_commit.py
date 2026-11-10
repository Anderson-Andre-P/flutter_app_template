#!/usr/bin/env python3
"""Run the project's pre-commit checks and report PASS/FAIL from each command's real exit code.

Usage: python3 verify_before_commit.py [--config file.json] [--only analyze|test]... [--skip analyze|test]...

Commands come from the config keys `analyze` and `test` (strings). Never pipe a check into `tail`/`grep`
yourself: a pipe returns the last command's status and hides a failure. This script reads the exit
code of the check, prints one line per check, and on failure the last 15 lines of its output.
Exit 0 all passed, 1 any failed, 2 usage error. Standard library only.
"""
import argparse
import json
import os
import shlex
import subprocess
import sys

CONFIG_NAME = os.path.join(".claude", "skill-config", "git-commit-conventions.json")
CHECKS = ["analyze", "test"]


def find_config(start):
    d = os.path.abspath(start)
    while True:
        candidate = os.path.join(d, CONFIG_NAME)
        if os.path.isfile(candidate):
            return candidate
        parent = os.path.dirname(d)
        if parent == d:
            return None
        d = parent


def main(argv):
    ap = argparse.ArgumentParser(description=__doc__.split("\n")[0])
    ap.add_argument("--config")
    ap.add_argument("--only", action="append", default=[], choices=CHECKS)
    ap.add_argument("--skip", action="append", default=[], choices=CHECKS)
    args = ap.parse_args(argv)

    path = args.config or find_config(os.getcwd())
    if not path:
        print("no config found (.claude/skill-config/git-commit-conventions.json); pass --config")
        return 2
    try:
        with open(path, encoding="utf-8") as f:
            cfg = json.load(f)
    except (OSError, ValueError) as e:
        print(f"config error: {e}")
        return 2

    failed = False
    for name in CHECKS:
        if (args.only and name not in args.only) or name in args.skip:
            continue
        command = cfg.get(name)
        if not command:
            print(f"SKIP {name} (not configured)")
            continue
        try:
            r = subprocess.run(shlex.split(command), capture_output=True, text=True)
            output, code = (r.stdout + r.stderr), r.returncode
        except OSError as e:
            output, code = str(e), 127
        if code == 0:
            print(f"PASS {name}")
        else:
            failed = True
            print(f"FAIL {name} (exit {code})")
            for line in output.rstrip().split("\n")[-15:]:
                print(f"  {line}")
    return 1 if failed else 0


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))
