---
paths: ["test/**", "integration_test/**"]
---

# Testing

The conventions (what to test per layer, mocktail / bloc_test, path mirroring,
widget keys, reading results from the real exit code) are in the skill
**`flutter-testing-conventions`**. This file keeps what is specific to this
project.

**Tests are not disposable.** Do not weaken, remove, skip (`skip` / `solo`),
relax an assertion, reduce coverage, or mock away the behaviour under test just
to make something pass. If a test conflicts with the intended behaviour, report
it and ask before changing the test.

- **New behaviour is test-first** (unit / bloc / widget), and a fixed
  regression starts with a failing regression test.
- `test/` mirrors `lib/`. Shared helpers live in `test/helpers/`
  (`pumpApp`, `testBothThemes`, `MemorySecureStorage`).
- Every widget in `core/widgets` is pumped in **both** themes
  (`testBothThemes`).
- App-flow tests build the real DI with `setupDependencies(config,
  secureStorage: MemorySecureStorage())` and `sl.reset()` in `tearDown`.
- **Integration tests** (`integration_test/`) run on a device, by the human.
  Real-backend credentials only via `--dart-define`, never hard-coded.
- Run the suite with `bash scripts/test.sh` (summary per feature) or
  `flutter test`.
