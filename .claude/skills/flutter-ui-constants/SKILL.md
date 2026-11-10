---
name: flutter-ui-constants
description: Keeping literals out of Flutter widgets — user-facing strings in per-feature string-constant classes, asset paths in asset-constant classes, colours, spacing, radii and durations in theme tokens read from the context. Use when writing or editing a screen or widget, adding a label, message, dialog text, image or sound path, colour, padding, SizedBox gap or border radius, reviewing a diff for hard-coded UI values, or preparing text for translation or flavor/theme changes.
metadata:
  version: "1.0"
  scope: portable
---

# flutter-ui-constants

A widget describes *structure*. Every value that could change with wording, brand or theme comes from a named constant.

| Value | Not in a widget as… | Lives in |
|---|---|---|
| User-facing text | `Text('Salvar')`, `title: 'Erro'`, `hintText: '…'` | `core/constants/strings/<feature>_strings.dart` |
| Asset path | `'assets/images/logo.png'` | `core/constants/assets/` (`AppImages`, `AppSounds`, …) |
| Colour | `Colors.red`, `Color(0xFF…)` | theme: `AppColors` constants for the palette, semantic colours via the theme |
| Spacing / radius / duration | `EdgeInsets.all(16)`, `SizedBox(height: 8)`, `BorderRadius.circular(12)` | theme tokens read with `context.tokens` |

`audit-golden-rules` finds the first and third and fourth rows mechanically (`no-literal-user-strings`, `no-colour-literals`, `no-spacing-literals`).

## Strings

- One `abstract final class <Feature>Strings` per feature (plus `AppStrings` for app-wide text) with `static const` fields; a header comment says which language it holds.
- Group related fields under a comment; name by role, not by wording (`taskDone`, not `realizado`).
- Parameterised text is a prefix/suffix constant or a small function in the same class, never a literal with an interpolation in the widget.
- Accessibility labels, tooltips, hints, dialog titles, button labels, snackbar messages all count as user-facing.
- Not user-facing, so fine in code: log tags, map keys, route names, test keys (use key constants).

## Assets

Every path goes through the asset-constants classes; they are the only place that knows the folder layout. A file's name is derived from its constant. Declare each asset subfolder in `pubspec.yaml` (declarations are not recursive).

## Theme tokens

- Attach spacing, radii, semantic colours and durations to `ThemeData` as a `ThemeExtension` (`AppTokens`), expose them with an extension on `BuildContext` (`context.tokens`), and read `context.tokens.spacing.md` in widgets.
- Palette colours that are not semantic live in a flat `AppColors` constants class referenced by the theme; widgets prefer `Theme.of(context)` or semantic tokens.
- A value used once and truly local to a painter or animation can stay in the widget file as a private named constant — but not as an inline number.
- Zero is not a spacing literal (`EdgeInsets.zero`, `SizedBox.shrink()`); `Colors.transparent` is allowed.

## When you meet a literal that was copied from a reference

Copying a reference widget faithfully does not excuse the literal: move it to the constant with its **current value** so the screen looks the same, then reference the constant. If a file is too large to convert now, record the debt (gaps log) and baseline it in the audit config instead of adding more.
