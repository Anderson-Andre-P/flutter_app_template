# CLAUDE.md

Guidance for Claude Code when working in this repository.

## Project

**Flutter App Template** — the starting point for new Flutter apps (Android +
iOS). It ships the whole foundation so a new app only writes its screens:
feature-first Clean Architecture, Bloc, DI, typed errors, logging, optional
Sentry, secure + preference storage, an HTTP client, go_router with a
session-aware redirect, a light/dark design system (tokens + widgets +
dialogs + snackbars) and example screens (splash, sign in, sign up, a home
grid of seventeen demos — six screens and eleven component catalogues: widgets,
bottom bar, modals, bottom sheets, toasts, charts, controls, forms, navigation,
chat and media, cards — and settings) running on **fake repositories — there is no backend**.

No flavors: one `lib/main.dart`, optional config via `--dart-define`
(`API_BASE_URL`, `SENTRY_DSN`) or `--dart-define-from-file=.env.json`.

## Skills

Project skills live in `.claude/skills/` and load by task; their project
values are in `.claude/skill-config/`. The golden rules below stay here
because they must hold even when a skill is not loaded.

| When you are… | Use the skill |
|---|---|
| creating or moving a feature, adding a file, wiring DI | `flutter-clean-architecture`, then `check-layers` |
| writing a Bloc, event or state | `flutter-bloc-state` |
| writing a usecase, repository, entity, model or JSON mapping, or handling decimals | `dart-result-and-models` |
| adding local persistence, an outbox or sync (adds sembast/sqflite first) | `flutter-offline-first` |
| writing a screen or widget (strings, colours, spacing, assets) | `flutter-ui-constants` |
| writing or fixing a test | `flutter-testing-conventions` |
| committing | `git-commit-conventions` |
| before handing work back | `check-layers` + `audit-golden-rules` (python3 scripts; baselines in `.claude/skill-config/`) |

## Golden rules

1. **Dependency flow.** `domain` imports only the Dart SDK, `package:equatable`
   and pure-Dart `core/` files (`core/error`, `core/usecase`,
   `core/utils`, `core/logging/app_logger.dart`, `core/session/session_port.dart`)
   — never `data`, Flutter or a plugin. `data` implements `domain`
   interfaces. `presentation` depends on `domain` and `application`, never
   on `data`. No feature imports another feature, and features never import
   `lib/app`. `core/` never imports a feature — except `core/di`, the
   composition root.
2. **Bloc is the only state manager.** Every state holder — feature-level or
   screen-local UI state — is a `Bloc` (events in, states out). No Cubit, no
   `provider`, no `ChangeNotifier`. Widgets read blocs through
   `BlocProvider`, never through `sl` directly.
3. **Usecases never throw.** They return the sealed `Result<T>`
   (`Success` / `ResultFailure`); repositories throw `AppException`s and
   `mapExceptionToFailure` turns them into `Failure`s.
4. **No literals in widgets.** User-facing strings go to per-feature
   `*_strings.dart` (shared ones in `core/constants/strings/`); colours,
   spacing, radius, sizes, durations and text styles come from
   `core/theme` (`context.colors`, `AppSpacing`, `AppRadius`, `AppSizes`,
   `AppDurations`, `AppTypography`); asset paths from
   `core/constants/assets/`. Screens are built from `core/widgets`.
5. **Both themes, always.** Light and dark differ only in colours
   (`AppColors.light` / `AppColors.dark`) and shadows (dark has none). Every
   new widget is checked in both.
6. **`fromJson` / `toJson` are hand-written** in `data/` models — no code
   generation.
7. **Never invent a dependency version.** Only what is in `pubspec.yaml`.
   Adding a dependency requires asking the human first.
8. **Everything in English** — code, comments, agent docs. User-facing copy is
   pt-BR. Commit messages in Portuguese.
9. **Before claiming work done:** `bash scripts/analyze.sh` clean,
   `bash scripts/test.sh` green, `check-layers` and `audit-golden-rules`
   report nothing new.

## Adding a feature

1. `lib/features/<feature>/{domain,data,application,presentation}` — entity
   and repository interface in `domain`, implementation in `data`, usecases in
   `domain/usecases`, Blocs in `application`, pages/widgets/strings in
   `presentation`.
2. `lib/features/<feature>/<feature>_feature.dart` with
   `void register<Feature>Feature(GetIt sl)`; call it from
   `setupDependencies` in `lib/core/di/injection_container.dart`.
3. Add the path to `lib/app/navigation/app_routes.dart` and a `GoRoute` in
   `app_router.dart` (create the page's Bloc there with `BlocProvider`, pass
   navigation in as callbacks). Public routes go in `AppRoutes.public`.
4. Tests mirror `lib/` under `test/`.

To use a real backend, implement `AuthRepository` with `ApiClient` and
register it in `registerAuthFeature` instead of `FakeAuthRepository`.

## Guardrails

`.claude/settings.json` enforces the mechanical ones: confirmation before
destructive git commands, `flutter build`, `flutter clean`, `dart fix` and
dependency changes; branch creation, merges, rebases, pushes, emulator
launches and device integration tests are denied; `.claude/hooks/` blocks
attribution trailers and PRs into anything but `prAllowedBases`. The rest:

- **Scope discipline.** Only modify files the current task requires.
- **Never start `flutter run`, emulators or device tests on your own.**
- **Commit locally**; pushing, branches and promotion are the human's.

## Commands

```bash
flutter pub get
bash scripts/run.sh                 # flutter run (+ .env.json if present) — human only
bash scripts/analyze.sh             # format check + analyze
bash scripts/test.sh                # tests + per-feature summary
bash scripts/build.sh apk           # apk | appbundle | ipa
python3 .claude/skills/check-layers/scripts/check_layers.py
python3 .claude/skills/audit-golden-rules/scripts/audit_rules.py
python3 tool/validate_skills.py
```

## Where things live

```
lib/
  main.dart            bootstrap: config, DI, Sentry (optional), router, runApp
  app/                 App (theme, pt-BR, blocs) + navigation/ (routes, redirect)
  core/                config/ constants/ di/ error/ logging/ monitoring/ network/
                       session/ storage/ theme/ usecase/ utils/ widgets/
  features/
    auth/              splash, sign in, sign up (fake repository)
    examples/          disposable demo screens on fake data (see README)
    home/              shell with bottom nav + grid linking the demos
    settings/          settings tab: account menu, theme mode, version, sign out
assets/                images/ vectors/ audios/ fonts/
scripts/  tool/  .claude/  .githooks/
```
