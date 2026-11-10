---
name: audit-golden-rules
description: Scans a Flutter/Dart lib/ tree for violations of architecture rules that the analyzer does not catch — Cubit or provider/ChangeNotifier instead of Bloc, json_serializable annotations and generated .g.dart files, imports of a forbidden folder, user-facing string literals in widgets, colour, spacing and radius literals instead of theme tokens, decimal quantities stored as double. Use before handing a plan back, after adding or editing widgets, models, blocs or imports, when reviewing a diff for convention drift, or when asked whether the code follows the project rules.
compatibility: Requires python3 >= 3.9 (standard library only). Expects a lib/ folder and optionally a project config.
metadata:
  version: "1.0"
  scope: portable
---

# audit-golden-rules

Mechanical checks for rules a project states in prose. It reports findings; it never edits. Pair it with `check-layers` (imports between layers).

## Run

```bash
python3 .claude/skills/audit-golden-rules/scripts/audit_rules.py                      # every enabled rule
python3 .claude/skills/audit-golden-rules/scripts/audit_rules.py --rule no-cubit      # one rule (repeatable)
python3 .claude/skills/audit-golden-rules/scripts/audit_rules.py --summary            # + findings per rule
```

Output is `path:line: rule — hint` with `path` relative to `--root` (default `lib`); exit `0` clean, `1` findings, `2` usage or config error. It reads `<project>/.claude/skill-config/audit-golden-rules.json` unless `--config` is given.

## Rules

| Id | Flags | Scope |
|---|---|---|
| `no-cubit` | any `…Cubit` identifier or a `cubit` import | all files |
| `no-json-codegen` | `@JsonSerializable`/`@JsonKey`, `json_annotation`, `*.g.dart` / `*.freezed.dart` files and parts | all files |
| `no-provider-changenotifier` | `ChangeNotifier`, `ChangeNotifierProvider`, `package:provider` | all files |
| `no-forbidden-import` | an import containing a configured prefix (a frozen reference folder) | all files |
| `no-literal-user-strings` | a string literal with letters passed to `Text(` or a text parameter (`title:`, `label:`, `hintText:`, …) | presentation |
| `no-colour-literals` | `Colors.x` (except allowed), `Color(0x…)`, `Color.fromARGB/RGBO` | presentation |
| `no-spacing-literals` | a non-zero number inside `EdgeInsets.*(…)` or in a spacer `SizedBox(width/height: n)` | presentation |
| `no-radius-literals` | a non-zero number inside `Radius.circular(…)` / `BorderRadius.circular(…)` | presentation |
| `decimal-fields-not-double` | `double name` where `name` contains a configured decimal-field word | everything except presentation |

"Presentation" is any path containing `/presentation/` plus the `presentationPaths` config (default `core/widgets/`). Exact patterns and known blind spots: [references/heuristics.md](references/heuristics.md). What each rule protects: [references/rules.md](references/rules.md).

## Acting on a finding

Follow [references/triage.md](references/triage.md): fix it, or baseline it with a reason that names the ticket that owns the debt. Never raise a `maxCount` or add an `allow` entry just to make the run pass.

## Config

All keys optional: `disabledRules`, `ignorePaths` (`{rule or "*": [path prefixes]}`), `forbiddenImportPrefixes`, `decimalFieldNames`, `allowColors` (default `["transparent"]`), `presentationPaths`, `textParams`, `allow`.

`allow` entries: `{rule, file, reason}` plus optional `contains` (text that must appear on the line) and `maxCount` (a **ratchet**: the first N findings in that file are covered, finding N+1 fails). `file` ending in `/` covers a folder. `reason` is mandatory.

To baseline existing debt: `python3 …/audit_rules.py --rule no-colour-literals --suggest-allow --reason "<ticket>: why"` prints ready-made entries with each file's current count; paste them into `allow`.

## Tests

`python3 -m unittest discover .claude/skills/audit-golden-rules/scripts` runs the script on `assets/fixtures/violations` (one file per rule, exact lines asserted) and `assets/fixtures/lookalike` (code that looks like a violation and must stay clean). Add a fixture line and an assertion before changing a pattern.
