---
name: flutter-clean-architecture
description: Feature-first Clean Architecture for Flutter apps — the data/domain/application/presentation split under lib/features, the shared lib/core layer, the dependency flow between layers, ports for cross-feature needs, and per-feature dependency-injection registration with GetIt. Use when creating or moving a feature, adding a file and deciding which layer or folder it belongs in, wiring a new datasource, repository, usecase or Bloc into DI, resolving a circular or cross-feature dependency, or reviewing where code lives.
metadata:
  version: "1.0"
  scope: portable
---

# flutter-clean-architecture

Every functional area is a self-contained module under `lib/features/<feature>/`, split into layers, on top of a shared `lib/core/`. The split keeps business rules testable without Flutter and keeps features replaceable.

## Dependency flow (the rules)

1. `domain` imports only the Dart SDK (`dart:async`, `dart:convert`, …) and `package:equatable`. Never `data`, never Flutter, never a plugin.
2. `data` implements `domain` interfaces. It may use plugins, HTTP, databases.
3. `application` (feature-level Blocs) is built from `domain` usecases.
4. `presentation` depends on `domain` and `application`, **never on `data`**.
5. **No feature imports another feature.** Shared code goes to `core/`, or to a shared domain module.
6. `core/` never imports `features/` (the composition root is the one place that wires features together).

Check these mechanically with the `check-layers` skill after every structural change.

## Where a new file goes

| It is… | Put it in |
|---|---|
| a plain object the business talks about | `domain/entities/` |
| the contract a repository must meet | `domain/repositories/` (interface only) |
| one business action | `domain/usecases/<verb>_<thing>_usecase.dart` |
| API / websocket calls | `data/datasources/<feature>_remote_datasource.dart` |
| a local DAO | `data/datasources/<feature>_local_datasource.dart` |
| JSON ↔ entity mapping | `data/models/` (see `dart-result-and-models`) |
| the concrete repository | `data/repositories/<feature>_repository_impl.dart` |
| state that outlives a screen | `application/<name>/<name>_bloc.dart` |
| state owned by one screen, UI-only | `presentation/bloc/` (see `flutter-bloc-state`) |
| a screen / a widget | `presentation/screens/` / `presentation/widgets/` |
| infrastructure used by several features (network, storage, theme, logging) | `core/<area>/` |

Full tree and naming: [references/feature-structure.md](references/feature-structure.md).

## Crossing feature boundaries

When feature A needs something from feature B, do not import B. Define a **port** (a small pure-Dart interface or callback type) in `core/` — or in a shared domain module — that A depends on; B (or the composition root) provides the implementation. The composition root wires the seam after every feature is registered. Examples of a good seam: "log the user out", "re-authenticate", "clear my caches at logout".

## Dependency injection

Each feature registers itself in `lib/features/<feature>/di.dart` as `register<Feature>Feature(GetIt sl)`, **in this order: datasource → repository → usecases → blocs**. A single `setupDependencies()` in `core/di/` calls every feature's function and then wires the cross-feature seams. Details and a skeleton: [references/di-order.md](references/di-order.md).

## Common mistakes

- A usecase importing a concrete `core` class that itself imports Flutter or a plugin — the leak is transitive; `check-layers` reports it as `domain-impure-core`. Put an interface in `core/` instead.
- A screen reading a datasource or model "just this once" — go through a usecase or a Bloc.
- Putting a feature-specific helper in `core/` because two screens of the same feature need it — keep it inside the feature.
- Registering a Bloc before its usecases in DI — resolution order errors at startup.
