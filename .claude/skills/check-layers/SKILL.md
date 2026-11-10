---
name: check-layers
description: Checks Clean Architecture layer boundaries in a Flutter/Dart lib/ tree — domain purity (including transitive Flutter/plugin leaks through core), presentation importing data, data importing presentation, feature-to-feature imports, core importing features. Use after creating, moving or editing files under lib/features or lib/core, when adding an import to a domain, data, application or presentation file, when a layering or dependency-flow question comes up, and before handing a plan back.
compatibility: Requires python3 >= 3.9 (standard library only). Expects lib/core and lib/features/<feature>/<layer>/.
metadata:
  version: "1.0"
  scope: portable
---

# check-layers

Reports imports that break the dependency flow of a feature-first Clean Architecture. It reads files and prints findings; it never edits.

## Run

```bash
python3 .claude/skills/check-layers/scripts/check_layers.py            # whole lib/
python3 .claude/skills/check-layers/scripts/check_layers.py --summary  # + files and violations per layer
python3 .claude/skills/check-layers/scripts/check_layers.py --root lib --config path/to/config.json
```

Output is one line per finding, `path:line: rule — hint`, with `path` relative to `--root`. Exit `0` clean, `1` findings, `2` usage or config error.
Run it from the project root; it reads `<project>/.claude/skill-config/check-layers.json` when `--config` is not given.

## Reading a finding

| Rule | Meaning | Usual fix |
|---|---|---|
| `domain-imports` | `domain` imports Flutter, a non-allowed package, `dart:ui`, another layer, or app code | Move the code to the layer that may know it, or hide it behind an interface in `domain` |
| `domain-impure-core` | `domain` imports a `core/` file that reaches Flutter or a plugin through its own imports (the finding prints the chain) | Put a pure-Dart interface in `core/` and implement it elsewhere |
| `presentation-imports-data` | A screen or widget imports the `data` layer | Go through a usecase or an `application` Bloc |
| `data-imports-presentation` | `data` imports `presentation` | Invert it; `data` never knows the UI |
| `application-imports-presentation` | A feature-level Bloc imports `presentation` | Move the shared piece to `domain` or `core/` |
| `cross-feature-import` | A feature imports another feature | Share through `core/` or a port wired at the composition root |
| `core-imports-features` | `core/` imports a feature | Move the shared code into `core/` (the composition root is configured as an exception) |

Full definitions and what each layer may import: [references/rules.md](references/rules.md).

## Acting on results

1. Fix the import, or move the code, when the finding is right. Do not hide it.
2. When it is a known, accepted debt, add an `allow` entry to the project config. **Every entry needs `rule`, `file`, `import` and a `reason`** (the script rejects entries without one); the reason should name the ticket or decision that owns the debt, so a *new* violation still fails.
3. `file` ending in `/` covers a whole folder (use it for a composition root); otherwise it is an exact path relative to `--root`.
4. A finding you cannot fix inside the current task goes in the project's gaps log, then gets baselined in config. Never baseline without recording it.

## Config

Optional JSON; every key has a default (see [references/rules.md](references/rules.md#config-keys)): `featuresDir`, `coreDir`, `layers`, `domainAllowedPackages`, `domainForbiddenSdk`, `allow`.

## Tests

`python3 -m unittest discover .claude/skills/check-layers/scripts` runs the script against the trees in `assets/fixtures/` (`clean`, `lookalike`, `violations`). Add a fixture and an assertion before changing a rule.
