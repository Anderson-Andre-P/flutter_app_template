#!/usr/bin/env python3
"""Validate Agent Skills (agentskills.io/specification) in a directory.

Usage: python3 tool/validate_skills.py [skills_dir]   (default: .claude/skills)

Prints `path: problem` per defect and exits 1 if any; silent and 0 when clean.
Standard library only.
"""
import json
import os
import re
import sys

NAME_RE = re.compile(r"^[a-z0-9]+(-[a-z0-9]+)*$")
LINK_RE = re.compile(r"\]\(([^)\s]+)\)")
# Tokens a portable skill must not carry (project facts live in docs/ and config).
# They are project data, so they come from config, never from this file:
#   env SKILL_PROJECT_TOKENS="ACME|KB-\\d+"  (wins), or
#   .claude/skill-config/validate-skills.json  {"projectTokens": ["ACME", "KB-\\d+"]}
CONFIG_PATH = os.path.join(".claude", "skill-config", "validate-skills.json")


def load_project_tokens():
    pattern = os.environ.get("SKILL_PROJECT_TOKENS")
    if pattern is None and os.path.isfile(CONFIG_PATH):
        with open(CONFIG_PATH, encoding="utf-8") as f:
            tokens = json.load(f).get("projectTokens", [])
        pattern = "|".join(tokens)
    return re.compile(rf"\b({pattern})\b") if pattern else None


PROJECT_TOKENS = load_project_tokens()
TEXT_EXTS = {".md", ".json", ".py", ".sh", ".txt", ".yaml", ".yml", ".dart"}
MAX_BODY_LINES = 500


def parse_frontmatter(text):
    """Return (fields, nested) or None. `nested` maps a parent key to its indented children."""
    lines = text.split("\n")
    if not lines or lines[0].strip() != "---":
        return None
    try:
        end = lines[1:].index("---") + 1
    except ValueError:
        return None
    fields, nested, parent = {}, {}, None
    i = 1
    while i < end:
        line = lines[i]
        m = re.match(r"^([A-Za-z0-9_-]+):\s*(.*)$", line)
        if m and not line.startswith((" ", "\t")):
            key, val = m.group(1), m.group(2).strip()
            if val in (">", "|", ">-", "|-"):
                block = []
                while i + 1 < end and (lines[i + 1].startswith((" ", "\t")) or not lines[i + 1].strip()):
                    i += 1
                    block.append(lines[i].strip())
                val = " ".join(b for b in block if b)
            fields[key] = val.strip("\"'")
            parent = key if val == "" else None
        elif parent and line.startswith((" ", "\t")):
            m2 = re.match(r"^\s+([A-Za-z0-9_-]+):\s*(.*)$", line)
            if m2:
                nested.setdefault(parent, {})[m2.group(1)] = m2.group(2).strip().strip("\"'")
        i += 1
    return fields, nested


def check_skill(skills_dir, folder, report):
    base = os.path.join(skills_dir, folder)
    skill_md = os.path.join(base, "SKILL.md")
    if not os.path.isfile(skill_md):
        report(f"{folder}: SKILL.md missing")
        return
    rel = f"{folder}/SKILL.md"
    with open(skill_md, encoding="utf-8") as f:
        text = f.read()

    parsed = parse_frontmatter(text)
    if parsed is None:
        report(f"{rel}: frontmatter missing")
        return
    fields, nested = parsed

    name = fields.get("name", "")
    if not name:
        report(f"{rel}: name missing")
    else:
        if len(name) > 64:
            report(f"{rel}: name longer than 64 characters")
        if not NAME_RE.match(name):
            report(f"{rel}: name '{name}' is invalid (lowercase letters, digits, single hyphens, no leading/trailing hyphen)")
        if name != folder:
            report(f"{rel}: name '{name}' does not match folder '{folder}'")

    desc = fields.get("description", "")
    if not desc:
        report(f"{rel}: description missing")
    elif len(desc) > 1024:
        report(f"{rel}: description longer than 1024 characters")

    if len(fields.get("compatibility", "")) > 500:
        report(f"{rel}: compatibility longer than 500 characters")

    if text.count("\n") + 1 > MAX_BODY_LINES:
        report(f"{rel}: longer than {MAX_BODY_LINES} lines (move detail to references/)")

    for target in LINK_RE.findall(text):
        if re.match(r"^(https?:|mailto:|#)", target):
            continue
        path = target.split("#", 1)[0]
        if path and not os.path.exists(os.path.join(base, path)):
            report(f"{rel}: broken link '{target}'")

    if nested.get("metadata", {}).get("scope") == "portable":
        check_portable(base, folder, report)


def check_portable(base, folder, report):
    if PROJECT_TOKENS is None:
        return
    for dirpath, dirnames, filenames in os.walk(base):
        rel_dir = os.path.relpath(dirpath, base)
        if rel_dir.replace(os.sep, "/").startswith("assets/fixtures"):
            dirnames[:] = []
            continue
        for fn in sorted(filenames):
            if os.path.splitext(fn)[1] not in TEXT_EXTS:
                continue
            path = os.path.join(dirpath, fn)
            shown = f"{folder}/{os.path.relpath(path, base)}".replace(os.sep, "/")
            with open(path, encoding="utf-8", errors="replace") as f:
                for n, line in enumerate(f, 1):
                    for m in PROJECT_TOKENS.finditer(line):
                        report(f"{shown}:{n}: project token '{m.group(1)}' in a portable skill")


def main(argv):
    skills_dir = argv[1] if len(argv) > 1 else os.path.join(".claude", "skills")
    if not os.path.isdir(skills_dir):
        print(f"{skills_dir}: not a directory")
        return 2
    problems = []
    for folder in sorted(os.listdir(skills_dir)):
        if folder.startswith(".") or not os.path.isdir(os.path.join(skills_dir, folder)):
            continue
        check_skill(skills_dir, folder, problems.append)
    for p in problems:
        print(p)
    return 1 if problems else 0


if __name__ == "__main__":
    sys.exit(main(sys.argv))
