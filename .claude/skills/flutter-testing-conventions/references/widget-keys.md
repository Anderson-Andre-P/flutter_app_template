# Widget keys

Tests (especially integration tests) locate widgets by **`ValueKey` constants**, not by visible text, icon or widget type — text changes with wording and language, icons repeat, types are ambiguous.

## Registry

One keys class per area in a shared constants folder (for example `core/constants/keys/<area>_keys.dart`), `static const` `ValueKey<String>`s with unique values:

```dart
abstract final class LoginKeys {
  static const submitButton = ValueKey('login.submit');
  static const emailField = ValueKey('login.email');
}
```

Widgets receive `key: LoginKeys.submitButton`. Wrapper widgets forward `super.key`; the call site supplies the key.

## Guards (cheap tests that keep the convention true)

- A guard test scans the presentation sources and fails when an **interactive** widget (buttons, text fields, switches, list tiles with `onTap`, …) has no `key:`, or two registry keys share a value.
- A guard fails when an integration test taps without the project's tap helper.
- A guard fails when a test file is missing from the integration suite entry point.

## Tapping

A key finds a widget; the tap still needs it **reachable**: scroll it into view, close the keyboard if it covers it, and wait for animations. Wrap this in one helper (`tapKey(tester, key)`) used by every integration test instead of bare `tester.tap`.

## Adding a key

1. Add the constant to the area's keys class.
2. Put `key:` on the widget.
3. Use the constant in the test.
4. Run the guard tests.
