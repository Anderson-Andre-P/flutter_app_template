---
name: flutter-testing-conventions
description: Testing conventions for Flutter/Dart apps — tests are never weakened to pass, what to test in each layer (usecases, repositories, models, Blocs, widgets, integration flows), mocktail and bloc_test usage, test file mirroring, widget keys, regression-test-first, and reading test results from the real exit code. Use when writing, changing or reviewing a test, fixing a failing or flaky test, deciding which kind of test a behaviour needs, adding a widget key, testing a Bloc or usecase, running the suite, or about to say that tests pass.
compatibility: The runner script needs bash and the flutter CLI.
metadata:
  version: "1.0"
  scope: portable
---

# flutter-testing-conventions

## The rule

**Tests are not disposable.** Do not weaken, remove, skip (`skip`, `solo`), relax an assertion, reduce coverage, or mock away the behaviour under test just to make something pass. If a test conflicts with the intended behaviour, **report it and ask** before changing the test. A failing test found while doing something else is a finding, not an obstacle.

**A fixed regression starts with a failing regression test**, written first and watched to fail.

## What to test where

| Layer | Test | Assert |
|---|---|---|
| Usecase / repository | mock the layer below | the returned `Result`; `verify(...).called(1)` with the right arguments; no real HTTP, websocket or database |
| Model (`fromJson`) | a real fixture **and** a malformed payload | correct entity; the malformed item does not break a list |
| Bloc | `blocTest`, one `group` per event | the emitted state sequence (and the `done` completer completes) |
| Widget | `testWidgets` with a minimal `MaterialApp` wrapper | observable behaviour in each state (loading / error / empty / filled), light and dark; never private `State` |
| Calculation / formatting | plain unit tests | numbers, durations, percentages, dates, colour-by-range, edge cases |
| Integration | `integration_test/` on a device | the main journeys; credentials for a real backend only via `--dart-define`, never hard-coded; run by the human |

New behaviour is tested in the **host layer first** (unit/widget/bloc); it enters `integration_test/` only when a journey needs the real app.

## Conventions

- **Mirror paths 1:1:** `lib/features/<f>/<layer>/foo.dart` → `test/features/<f>/<layer>/foo_test.dart`.
- **Mocks:** `mocktail`, never `mockito`. Classes named `Mock<Type>`, declared at the top of the file. Register a `Fake` with `registerFallbackValue` in `setUpAll` for any non-primitive used with `any()`.
- **Blocs:** `bloc_test`. For states and events to be asserted by value they are `Equatable` (see `flutter-bloc-state`).
- **Widget keys:** tests find widgets by `ValueKey` constants from a keys registry, not by text, icon or type; a tap also needs the widget reachable (scroll it into view first). Details: [references/widget-keys.md](references/widget-keys.md).
- One behaviour per test, named for the behaviour; arrange/act/assert visible; no logic in tests.

More per-layer examples: [references/layers.md](references/layers.md).

## Reading results: the exit code, not the text

`flutter test | tail` (or `| grep`) returns the *last* command's status and masks a failing suite. Run

```bash
bash .claude/skills/flutter-testing-conventions/scripts/run_tests_checked.sh              # whole suite
bash .claude/skills/flutter-testing-conventions/scripts/run_tests_checked.sh test/a_test.dart
```

It prints `All tests passed` or `Some tests failed (exit N)` from flutter's own exit code. Say "tests pass" only after reading that line. For analyze + tests together before a commit, use the `git-commit-conventions` verify script.

Tests for the script: `python3 -m unittest discover .claude/skills/flutter-testing-conventions/scripts`.

## Before handing work back

`flutter analyze` clean and the suite green (above). Integration tests and device checks are the human's to run.
