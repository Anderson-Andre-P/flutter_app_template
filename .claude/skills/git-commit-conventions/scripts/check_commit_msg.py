#!/usr/bin/env python3
"""Check a commit message against the project's conventions.

Usage: python3 check_commit_msg.py <message-file>
       python3 check_commit_msg.py -m "<message>"   [--config file.json]

Rules: `type(scope): subject` with a type from the config, one scope, a blank line before any body,
and none of the forbidden trailers. Prints `commit-msg: <problem>` per defect; exit 0 ok, 1 invalid,
2 usage error. Standard library only. Config: .claude/skill-config/git-commit-conventions.json
(found by walking up from the current directory) or --config.
"""
import argparse
import json
import os
import re
import sys

DEFAULTS = {
    "types": ["feat", "fix", "chore", "docs", "refactor", "perf", "test", "build"],
    "forbiddenTrailers": ["Co-Authored-By", "Generated with"],
    "maxSubjectLength": 0,
}
CONFIG_NAME = os.path.join(".claude", "skill-config", "git-commit-conventions.json")


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


def load_config(path):
    cfg = dict(DEFAULTS)
    path = path or find_config(os.getcwd())
    if path:
        with open(path, encoding="utf-8") as f:
            cfg.update(json.load(f))
    return cfg


def check(message, cfg):
    lines = [l for l in message.split("\n") if not l.startswith("#")]
    while lines and not lines[-1].strip():
        lines.pop()
    if not lines:
        return ["empty message"]
    subject = lines[0].rstrip()
    if subject.startswith("Merge "):
        return []

    problems = []
    types = "|".join(re.escape(t) for t in cfg["types"])
    m = re.match(rf"^({types})\(([^)]*)\): \S.*$", subject)
    if not m:
        problems.append(
            f"subject does not match 'type(scope): message' with type in [{', '.join(cfg['types'])}] -> {subject!r}"
        )
    else:
        scope = m.group(2)
        if re.search(r"[,+&\s]", scope):
            problems.append(f"one scope per commit; got {scope!r}")
        elif not re.fullmatch(r"[A-Za-z0-9_./-]+", scope):
            problems.append(f"subject does not match 'type(scope): message': invalid scope {scope!r}")
    limit = cfg.get("maxSubjectLength", 0)
    if limit and len(subject) > limit:
        problems.append(f"subject is longer than {limit} characters ({len(subject)})")
    if len(lines) > 1 and lines[1].strip():
        problems.append("a blank line must separate the subject from the body")
    text = "\n".join(lines)
    for trailer in cfg["forbiddenTrailers"]:
        if re.search(re.escape(trailer), text, re.I):
            problems.append(f"forbidden trailer {trailer!r} in the message")
    return problems


def main(argv):
    ap = argparse.ArgumentParser(description=__doc__.split("\n")[0])
    ap.add_argument("file", nargs="?")
    ap.add_argument("-m", dest="message")
    ap.add_argument("--config")
    args = ap.parse_args(argv)
    if args.message is None and not args.file:
        print("give a message file or -m '<message>'")
        return 2
    try:
        cfg = load_config(args.config)
        message = args.message
        if message is None:
            with open(args.file, encoding="utf-8") as f:
                message = f.read()
    except (OSError, ValueError) as e:
        print(f"error: {e}")
        return 2
    problems = check(message, cfg)
    for p in problems:
        print(f"commit-msg: {p}")
    return 1 if problems else 0


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))
