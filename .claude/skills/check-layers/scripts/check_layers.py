#!/usr/bin/env python3
"""Check Clean Architecture layer boundaries in a Flutter/Dart `lib/` tree.

Usage: python3 check_layers.py [--root lib] [--config file.json] [--summary]

Prints `path:line: rule — hint` (path relative to --root) per violation; exit 0 clean,
1 violations, 2 usage/config error. Python 3 standard library only.
Layout assumed: <root>/core/**, <root>/features/<feature>/<layer>/**. See references/rules.md.
"""
import argparse
import json
import os
import re
import sys

DEFAULTS = {
    "featuresDir": "features",
    "coreDir": "core",
    "layers": ["data", "domain", "application", "presentation"],
    "domainAllowedPackages": ["equatable", "meta"],
    "domainForbiddenSdk": ["dart:ui", "dart:html", "dart:js", "dart:js_interop"],
    "allow": [],
}
IMPORT_RE = re.compile(r"""^\s*(?:import|export)\s+r?['"]([^'"]+)['"]""")
TRIPLE_RE = re.compile(r"'''.*?'''|\"\"\".*?\"\"\"", re.S)
BLOCK_COMMENT_RE = re.compile(r"/\*.*?\*/", re.S)


class ConfigError(Exception):
    pass


def load_config(path):
    cfg = dict(DEFAULTS)
    if path:
        with open(path, encoding="utf-8") as f:
            cfg.update(json.load(f))
    for i, entry in enumerate(cfg["allow"]):
        for key in ("rule", "file", "import", "reason"):
            if not entry.get(key):
                raise ConfigError(f"allow[{i}] needs '{key}' (every suppression must carry a reason)")
    return cfg


def blank_keep_lines(m):
    return "\n" * m.group(0).count("\n")


def read_imports(path):
    """Yield (line, uri) for import/export directives, ignoring comments and multi-line strings."""
    with open(path, encoding="utf-8", errors="replace") as f:
        text = f.read()
    text = TRIPLE_RE.sub(blank_keep_lines, text)
    text = BLOCK_COMMENT_RE.sub(blank_keep_lines, text)
    for n, line in enumerate(text.split("\n"), 1):
        m = IMPORT_RE.match(line)
        if m:
            yield n, m.group(1)


def package_name(root):
    pubspec = os.path.join(os.path.dirname(os.path.abspath(root)), "pubspec.yaml")
    try:
        with open(pubspec, encoding="utf-8") as f:
            for line in f:
                m = re.match(r"^name:\s*(\S+)", line)
                if m:
                    return m.group(1)
    except OSError:
        pass
    return None


class Tree:
    def __init__(self, root, cfg):
        self.root, self.cfg = os.path.abspath(root), cfg
        self.pkg = package_name(root)
        self.files = {}
        for dp, _, fns in os.walk(self.root):
            for fn in fns:
                if fn.endswith(".dart"):
                    self.files[self.rel(os.path.join(dp, fn))] = os.path.join(dp, fn)
        self._imports = {}
        self._impure = {}

    def rel(self, path):
        return os.path.relpath(path, self.root).replace(os.sep, "/")

    def imports(self, rel):
        if rel not in self._imports:
            self._imports[rel] = [(n, u, self.resolve(rel, u)) for n, u in read_imports(self.files[rel])]
        return self._imports[rel]

    def resolve(self, importer, uri):
        """Return ('sdk', uri) | ('pkg', name) | ('local', rel) | ('outside', uri)."""
        if uri.startswith("dart:"):
            return ("sdk", uri)
        if uri.startswith("package:"):
            name, _, rest = uri[len("package:"):].partition("/")
            return ("local", rest) if name == self.pkg else ("pkg", name)
        target = os.path.normpath(os.path.join(os.path.dirname(importer), uri)).replace(os.sep, "/")
        return ("outside", uri) if target.startswith("..") else ("local", target)

    def context(self, rel):
        parts = rel.split("/")
        if parts[0] == self.cfg["coreDir"]:
            return ("core", None, "core")
        if parts[0] == self.cfg["featuresDir"] and len(parts) >= 3:
            layer = parts[2] if parts[2] in self.cfg["layers"] else "other"
            return ("feature", parts[1], layer)
        return ("app", None, "app")

    def impure_chain(self, rel, stack=()):
        """Return the import chain ending at an impure dependency, or None when `rel` is pure."""
        if rel in self._impure:
            return self._impure[rel]
        if rel in stack or rel not in self.files:
            return None
        result = None
        for _, uri, (kind, value) in self.imports(rel):
            if kind == "sdk" and value in self.cfg["domainForbiddenSdk"]:
                result = [rel, value]
            elif kind == "pkg" and self.is_impure_pkg(value):
                result = [rel, f"package:{value}"]
            elif kind == "local" and self.context(value)[0] == "core":
                sub = self.impure_chain(value, stack + (rel,))
                if sub:
                    result = [rel] + sub
            if result:
                break
        self._impure[rel] = result
        return result

    def is_impure_pkg(self, name):
        """A core file is impure when it reaches any package `domain` itself may not import."""
        return name not in self.cfg["domainAllowedPackages"]


def classify(tree, rel, line, uri, target):
    """Return (rule, hint) for the first rule the import breaks, else None."""
    kind, value = target
    cfg = tree.cfg
    c_kind, c_feat, c_layer = tree.context(rel)

    if kind == "local" and value in tree.files:
        t_kind, t_feat, t_layer = tree.context(value)
        if c_kind == "core" and t_kind == "feature":
            return "core-imports-features", f"core must not depend on features ({value}); move shared code into core/"
        if c_kind == "feature" and t_kind == "feature" and c_feat != t_feat:
            return "cross-feature-import", f"feature '{c_feat}' imports feature '{t_feat}' ({value}); share through core/ or a ports seam"
        if c_kind == "feature" and t_kind == "feature":
            if c_layer == "domain" and t_layer != "domain":
                return "domain-imports", f"domain must not import {t_layer} ({value})"
            if c_layer == "presentation" and t_layer == "data":
                return "presentation-imports-data", f"presentation must depend on domain/application, not data ({value})"
            if c_layer == "data" and t_layer == "presentation":
                return "data-imports-presentation", f"data must not import presentation ({value})"
            if c_layer == "application" and t_layer == "presentation":
                return "application-imports-presentation", f"application must not import presentation ({value})"
        if c_kind == "feature" and c_layer == "domain" and t_kind == "core":
            chain = tree.impure_chain(value)
            if chain:
                return "domain-impure-core", f"{value} is not pure Dart: {' → '.join(chain)}"
        if c_kind == "feature" and c_layer == "domain" and t_kind == "app":
            return "domain-imports", f"domain must not import app code ({value})"
        return None

    if c_kind == "feature" and c_layer == "domain":
        if kind == "pkg" and value not in cfg["domainAllowedPackages"]:
            return "domain-imports", f"domain may import only dart:* and {', '.join(cfg['domainAllowedPackages'])} (got package:{value})"
        if kind == "sdk" and value in cfg["domainForbiddenSdk"]:
            return "domain-imports", f"domain must not import {value}"
    return None


def allowed(cfg, rule, rel, uri, target):
    resolved = target[1]
    for entry in cfg["allow"]:
        file_ok = rel.startswith(entry["file"]) if entry["file"].endswith("/") else rel == entry["file"]
        if entry["rule"] == rule and file_ok and (entry["import"] in resolved or entry["import"] in uri):
            return True
    return False


def main(argv):
    ap = argparse.ArgumentParser(description=__doc__.split("\n")[0])
    ap.add_argument("--root", default="lib")
    ap.add_argument("--config")
    ap.add_argument("--summary", action="store_true")
    args = ap.parse_args(argv)

    if not os.path.isdir(args.root):
        print(f"{args.root}: not a directory")
        return 2
    config_path = args.config
    if not config_path:
        guess = os.path.join(os.path.dirname(os.path.abspath(args.root)), ".claude", "skill-config", "check-layers.json")
        config_path = guess if os.path.isfile(guess) else None
    try:
        cfg = load_config(config_path)
    except (ConfigError, OSError, ValueError) as e:
        print(f"config error: {e}")
        return 2

    tree = Tree(args.root, cfg)
    found, counts = [], {}
    for rel in sorted(tree.files):
        layer = tree.context(rel)[2]
        counts.setdefault(layer, [0, 0])[0] += 1
        for line, uri, target in tree.imports(rel):
            hit = classify(tree, rel, line, uri, target)
            if hit and not allowed(cfg, hit[0], rel, uri, target):
                found.append((rel, line, hit[0], hit[1]))
                counts[layer][1] += 1

    for rel, line, rule, hint in found:
        print(f"{rel}:{line}: {rule} — {hint}")
    if args.summary:
        print(f"{'layer':<14}{'files':<8}violations")
        for layer in cfg["layers"] + ["core", "app", "other"]:
            files, bad = counts.get(layer, [0, 0])
            if files or layer in cfg["layers"] + ["core"]:
                print(f"{layer:<14}{files:<8}{bad}")
    return 1 if found else 0


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))
