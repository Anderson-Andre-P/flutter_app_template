#!/usr/bin/env python3
"""Audit mechanically checkable architecture rules in a Flutter/Dart `lib/` tree.

Usage: python3 audit_rules.py [--root lib] [--config file.json] [--rule ID]... [--summary]

Prints `path:line: rule — hint` (path relative to --root) per finding; exit 0 clean,
1 findings, 2 usage/config error. Reports only; never edits. Python 3 standard library only.
Rule ids and heuristics: references/rules.md and references/heuristics.md.
"""
import argparse
import bisect
import json
import os
import re
import sys

RULES = [
    "no-cubit",
    "no-json-codegen",
    "no-provider-changenotifier",
    "no-forbidden-import",
    "no-literal-user-strings",
    "no-colour-literals",
    "no-spacing-literals",
    "no-radius-literals",
    "decimal-fields-not-double",
]
DEFAULTS = {
    "disabledRules": [],
    "ignorePaths": {},
    "allow": [],
    "forbiddenImportPrefixes": [],
    "decimalFieldNames": [],
    "allowColors": ["transparent"],
    "presentationPaths": ["core/widgets/"],
    "textParams": [
        "title", "label", "labelText", "hintText", "helperText", "errorText", "tooltip",
        "subtitle", "message", "content", "semanticsLabel", "buttonText", "text",
    ],
}
DIRECTIVE_RE = re.compile(r"^[ \t]*(?:import|export|part)[ \t]+r?(['\"])", re.M)
NUMBER = r"(?<![\w.$])(?:[1-9]\d*(?:\.\d+)?|0\.\d*[1-9]\d*)(?![\w.])"


class ConfigError(Exception):
    pass


def load_config(path):
    cfg = {k: (dict(v) if isinstance(v, dict) else list(v)) for k, v in DEFAULTS.items()}
    if path:
        with open(path, encoding="utf-8") as f:
            cfg.update(json.load(f))
    for i, entry in enumerate(cfg["allow"]):
        for key in ("rule", "file", "reason"):
            if not entry.get(key):
                raise ConfigError(f"allow[{i}] needs '{key}' (every suppression must carry a reason)")
    for i, entry in enumerate(cfg["allow"]):
        if "maxCount" in entry and not (isinstance(entry["maxCount"], int) and entry["maxCount"] >= 1):
            raise ConfigError(f"allow[{i}].maxCount must be an integer >= 1")
    for rule in cfg["disabledRules"]:
        if rule not in RULES:
            raise ConfigError(f"disabledRules: unknown rule '{rule}'")
    return cfg


class Source:
    """A Dart file seen through three views that keep every offset and line number.

    nocomment: comments blanked; code: comments and string contents blanked (quotes kept);
    literals: offset of an opening quote -> raw content of that string.
    """

    def __init__(self, text):
        self.text = text
        n = len(text)
        nc, cd, lits = list(text), list(text), {}

        def blank(arr, a, b):
            for k in range(a, b):
                if arr[k] != "\n":
                    arr[k] = " "

        def string_end(i):
            q = text[i]
            triple = text[i:i + 3] == q * 3
            raw = i > 0 and text[i - 1] == "r" and (i < 2 or not (text[i - 2].isalnum() or text[i - 2] == "_"))
            j = i + 3 if triple else i + 1
            start = j
            while j < n:
                c = text[j]
                if not raw and c == "\\":
                    j += 2
                    continue
                if not raw and c == "$" and text[j + 1:j + 2] == "{":
                    j = skip_interp(j + 2)
                    continue
                if triple:
                    if text[j:j + 3] == q * 3:
                        return j + 3, start, j
                else:
                    if c == q:
                        return j + 1, start, j
                    if c == "\n":
                        return j, start, j
                j += 1
            return n, start, n

        def skip_interp(j):
            depth = 1
            while j < n:
                c = text[j]
                if c in "'\"":
                    j = string_end(j)[0]
                    continue
                if c == "{":
                    depth += 1
                elif c == "}":
                    depth -= 1
                    if depth == 0:
                        return j + 1
                j += 1
            return n

        i = 0
        while i < n:
            c = text[i]
            if text[i:i + 2] == "//":
                j = text.find("\n", i)
                j = n if j < 0 else j
                blank(nc, i, j)
                blank(cd, i, j)
                i = j
            elif text[i:i + 2] == "/*":
                j, depth = i + 2, 1
                while j < n and depth:
                    if text[j:j + 2] == "/*":
                        depth, j = depth + 1, j + 2
                    elif text[j:j + 2] == "*/":
                        depth, j = depth - 1, j + 2
                    else:
                        j += 1
                blank(nc, i, j)
                blank(cd, i, j)
                i = j
            elif c in "'\"":
                end, cs, ce = string_end(i)
                lits[i] = text[cs:ce]
                blank(cd, cs, ce)
                i = end
            else:
                i += 1
        self.nocomment, self.code, self.literals = "".join(nc), "".join(cd), lits
        self._starts = [0] + [m.end() for m in re.finditer("\n", text)]

    def line(self, offset):
        return bisect.bisect_right(self._starts, offset)

    def directives(self):
        """Yield (offset, uri) for import/export/part directives."""
        for m in DIRECTIVE_RE.finditer(self.code):
            q = m.end(1) - 1
            if q in self.literals:
                yield m.start(), self.literals[q]


def balanced(code, open_idx):
    """Return the text between the parenthesis at open_idx and its match."""
    depth = 0
    for k in range(open_idx, len(code)):
        if code[k] == "(":
            depth += 1
        elif code[k] == ")":
            depth -= 1
            if depth == 0:
                return code[open_idx + 1:k]
    return code[open_idx + 1:]


def rule_no_cubit(src, rel, cfg):
    for m in re.finditer(r"\b\w*Cubit\b", src.code):
        yield m.start(), "Cubit is not allowed; every state holder is a Bloc (events in, states out)"
    for off, uri in src.directives():
        if "cubit" in uri.lower():
            yield off, f"import of a Cubit file ({uri}); use a Bloc"


def rule_no_json_codegen(src, rel, cfg):
    if rel.endswith((".g.dart", ".freezed.dart")):
        yield 0, "generated file; fromJson/toJson are hand-written"
    for m in re.finditer(r"@Json(?:Serializable|Key|Converter|Enum|Literal)\b", src.code):
        yield m.start(), "json_serializable annotation; write fromJson/toJson by hand"
    for off, uri in src.directives():
        if "json_annotation" in uri or uri.endswith((".g.dart", ".freezed.dart")):
            yield off, f"code-generation import ({uri}); write fromJson/toJson by hand"


def rule_no_provider(src, rel, cfg):
    for m in re.finditer(r"\bChangeNotifier(?:Provider)?\b|\bProvider\.of\b|\bMultiProvider\b", src.code):
        yield m.start(), "provider/ChangeNotifier is not allowed; use a Bloc"
    for off, uri in src.directives():
        if uri.startswith("package:provider/"):
            yield off, "package:provider is not allowed; use a Bloc"


def rule_forbidden_import(src, rel, cfg):
    for off, uri in src.directives():
        for prefix in cfg["forbiddenImportPrefixes"]:
            if prefix in uri:
                yield off, f"import of a forbidden location ({prefix})"


def rule_user_strings(src, rel, cfg):
    params = "|".join(re.escape(p) for p in cfg["textParams"])
    patterns = [r"\bText\(\s*(?:const\s+)?(['\"])", rf"\b(?:{params})\s*:\s*(?:const\s+)?(['\"])"]
    for pat in patterns:
        for m in re.finditer(pat, src.code):
            lit = src.literals.get(m.start(1), "")
            visible = re.sub(r"\$\{[^}]*\}|\$\w+", "", lit)
            if sum(ch.isalpha() for ch in visible) >= 2:
                yield m.start(1), f"user-facing string literal {lit!r}; move it to the strings constants"


def rule_colours(src, rel, cfg):
    allowed = "|".join(re.escape(c) for c in cfg["allowColors"]) or "(?!)"
    pats = [
        rf"(?<![A-Za-z0-9_])Colors\.(?!(?:{allowed})\b)\w+",
        r"(?<![A-Za-z0-9_])Color\(\s*0x",
        r"(?<![A-Za-z0-9_])Color\.from(?:ARGB|RGBO)\(",
    ]
    for pat in pats:
        for m in re.finditer(pat, src.code):
            yield m.start(), "colour literal; use a theme token"


def rule_spacing(src, rel, cfg):
    for m in re.finditer(r"\bEdgeInsets\.(?:all|symmetric|only|fromLTRB)\(", src.code):
        if re.search(NUMBER, balanced(src.code, m.end() - 1)):
            yield m.start(), "spacing literal in EdgeInsets; use a theme token"
    for m in re.finditer(r"\bSizedBox\(", src.code):
        args = balanced(src.code, m.end() - 1)
        if "child" not in args and re.search(rf"\b(?:width|height)\s*:\s*[^,)]*{NUMBER}", args):
            yield m.start(), "spacing literal in SizedBox; use a theme token"


def rule_radius(src, rel, cfg):
    for m in re.finditer(r"\b(?:Border)?Radius\.circular\(", src.code):
        if re.search(NUMBER, balanced(src.code, m.end() - 1)):
            yield m.start(), "radius literal; use an AppRadiusScale / AppRadius token"


def rule_decimal(src, rel, cfg):
    names = [n.lower() for n in cfg["decimalFieldNames"]]
    for m in re.finditer(r"\bdouble\??\s+(\w+)", src.code):
        if any(n in m.group(1).lower() for n in names):
            yield m.start(), f"'{m.group(1)}' is a decimal quantity stored as double; keep its precision"


# rule id -> (checker, scope) with scope in {"all", "presentation", "other"}
CHECKS = {
    "no-cubit": (rule_no_cubit, "all"),
    "no-json-codegen": (rule_no_json_codegen, "all"),
    "no-provider-changenotifier": (rule_no_provider, "all"),
    "no-forbidden-import": (rule_forbidden_import, "all"),
    "no-literal-user-strings": (rule_user_strings, "presentation"),
    "no-colour-literals": (rule_colours, "presentation"),
    "no-spacing-literals": (rule_spacing, "presentation"),
    "no-radius-literals": (rule_radius, "presentation"),
    "decimal-fields-not-double": (rule_decimal, "other"),
}


def is_presentation(rel, cfg):
    return "/presentation/" in "/" + rel or any(rel.startswith(p) for p in cfg["presentationPaths"])


def covers(pattern, rel):
    return rel.startswith(pattern) if pattern.endswith("/") else rel == pattern


def suppressed(cfg, budget, rule, rel, line_text):
    """True when an `allow` entry covers this finding; `maxCount` entries are a per-entry budget."""
    for n, entry in enumerate(cfg["allow"]):
        if entry["rule"] != rule or not covers(entry["file"], rel) or entry.get("contains", line_text) not in line_text:
            continue
        if "maxCount" not in entry:
            return True
        if budget.setdefault(n, entry["maxCount"]) > 0:
            budget[n] -= 1
            return True
    return False


def main(argv):
    ap = argparse.ArgumentParser(description=__doc__.split("\n")[0])
    ap.add_argument("--root", default="lib")
    ap.add_argument("--config")
    ap.add_argument("--rule", action="append", default=[])
    ap.add_argument("--summary", action="store_true")
    ap.add_argument("--suggest-allow", action="store_true", help="print `allow` entries (with maxCount) covering every current finding")
    ap.add_argument("--reason", help="reason text written into --suggest-allow entries")
    args = ap.parse_args(argv)

    if args.suggest_allow and not args.reason:
        print("--suggest-allow needs --reason (every suppression must carry a reason)")
        return 2

    for r in args.rule:
        if r not in RULES:
            print(f"unknown rule '{r}' (known: {', '.join(RULES)})")
            return 2
    if not os.path.isdir(args.root):
        print(f"{args.root}: not a directory")
        return 2
    config_path = args.config
    if not config_path:
        guess = os.path.join(os.path.dirname(os.path.abspath(args.root)), ".claude", "skill-config", "audit-golden-rules.json")
        config_path = guess if os.path.isfile(guess) else None
    try:
        cfg = load_config(config_path)
    except (ConfigError, OSError, ValueError) as e:
        print(f"config error: {e}")
        return 2

    active = [r for r in RULES if r not in cfg["disabledRules"] and (not args.rule or r in args.rule)]
    seen, counts, results, budget = set(), {r: 0 for r in active}, [], {}
    root = os.path.abspath(args.root)
    for dp, _, fns in sorted(os.walk(root)):
        for fn in sorted(fns):
            if not fn.endswith(".dart"):
                continue
            path = os.path.join(dp, fn)
            rel = os.path.relpath(path, root).replace(os.sep, "/")
            with open(path, encoding="utf-8", errors="replace") as f:
                src = Source(f.read())
            lines = src.text.split("\n")
            pres = is_presentation(rel, cfg)
            for rule in active:
                checker, scope = CHECKS[rule]
                if (scope == "presentation" and not pres) or (scope == "other" and pres):
                    continue
                ignored = cfg["ignorePaths"].get(rule, []) + cfg["ignorePaths"].get("*", [])
                if any(covers(p, rel) or rel.startswith(p) for p in ignored):
                    continue
                for off, hint in sorted(checker(src, rel, cfg)):
                    line = src.line(off) if off else 1
                    if (rel, line, rule) in seen:  # one finding per line, however many matches it has
                        continue
                    seen.add((rel, line, rule))
                    if suppressed(cfg, budget, rule, rel, lines[line - 1]):
                        continue
                    counts[rule] += 1
                    results.append((rel, line, rule, hint))
    if args.suggest_allow:
        grouped = {}
        for rel, _, rule, _ in results:
            grouped[(rule, rel)] = grouped.get((rule, rel), 0) + 1
        entries = [
            {"rule": r, "file": f, "maxCount": c, "reason": args.reason} for (r, f), c in sorted(grouped.items())
        ]
        print(json.dumps(entries, indent=2, ensure_ascii=False))
        return 0
    for rel, line, rule, hint in sorted(results):
        print(f"{rel}:{line}: {rule} — {hint}")
    if args.summary:
        print(f"{'rule':<30}findings")
        for rule in active:
            print(f"{rule:<30}{counts[rule]}")
    return 1 if results else 0


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))
