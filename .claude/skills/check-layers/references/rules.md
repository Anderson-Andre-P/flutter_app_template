# check-layers — rules

Layout assumed (under `--root`, default `lib`):

```text
core/**                              shared infrastructure
features/<feature>/<layer>/**        layer ∈ data | domain | application | presentation
anything else                        "app" (entrypoints, routing, composition wiring)
```

## What each layer may import

| Importer | May import | Must not import |
|---|---|---|
| `domain` | `dart:*` (except the forbidden list), allowed packages (default `equatable`, `meta`), its own feature's `domain`, **pure** `core/` files | Flutter or any other package, `dart:ui`, `data`, `application`, `presentation`, another feature, app code |
| `data` | `domain`, `core/`, packages | `presentation` |
| `application` | `domain`, `core/`, packages | `presentation` |
| `presentation` | `domain`, `application`, `core/`, packages | `data` |
| `core` | anything inside `core/`, packages | any `features/` file |
| any feature | `core/`, its own layers as above | another feature |

## Rule ids

- `domain-imports` — a domain file imports a package outside `domainAllowedPackages` (prefix lookalikes such as `equatable_extras` do **not** match), a `domainForbiddenSdk` library, or a non-domain layer of its feature, or app code.
- `domain-impure-core` — a domain file imports a `core/` file that is not pure. A `core/` file is impure when it, or any `core/` file it imports (transitively), imports a package outside `domainAllowedPackages` or a `domainForbiddenSdk` library — the same limits that apply to `domain` itself. The finding prints the chain `a.dart → b.dart → package:x`.
- `presentation-imports-data`, `data-imports-presentation`, `application-imports-presentation` — the layer pairs above, same feature.
- `cross-feature-import` — an import from feature A into feature B (any layer).
- `core-imports-features` — an import from `core/` into `features/`.

One import breaks at most one rule; the first match in the order above is reported.

## What is parsed

`import` and `export` directives at the start of a line, with `package:<this package>/…` (the name is read from `pubspec.yaml` next to `--root`) and relative URIs resolved to files under the root. Not counted: directives inside `//` comments, `/* */` blocks, or multi-line `'''`/`"""` strings. `part` / `part of` are ignored. `dart:`-prefixed imports are SDK; every other `package:` is external.

## Config keys

| Key | Default | Meaning |
|---|---|---|
| `featuresDir` | `features` | folder holding the features |
| `coreDir` | `core` | folder holding shared code |
| `layers` | `data, domain, application, presentation` | layer folder names |
| `domainAllowedPackages` | `equatable, meta` | packages `domain` may import |
| `domainForbiddenSdk` | `dart:ui, dart:html, dart:js, dart:js_interop` | SDK libraries `domain` may not import |
| `allow` | `[]` | suppressions: `{rule, file, import, reason}` — all four required |

An `allow` entry matches when `rule` is equal, `file` equals the importing file (or is a folder prefix ending in `/`), and `import` is contained in the import URI or its resolved path.
