# audit-golden-rules — what each rule protects

| Id | Rule it enforces | Why it matters |
|---|---|---|
| `no-cubit` | One state-management style: every state holder is a Bloc (events in, states out). | Mixed Cubit/Bloc code splits testing and review conventions; the rule is cheap to keep once and expensive to restore. |
| `no-json-codegen` | `fromJson` / `toJson` are written by hand to the exact backend shape. | Generated code hides key names and defaults, and a code generator step becomes a build dependency. |
| `no-provider-changenotifier` | No `provider` / `ChangeNotifier` / ad-hoc controllers next to Blocs. | Same as `no-cubit`: one mechanism for state. |
| `no-forbidden-import` | A frozen reference folder (for example the previous production app kept for parity) is read-only and never imported. | An import would compile old code into the new app and defeat the rebuild. |
| `no-literal-user-strings` | User-facing text lives in a strings constants folder, never in a widget. | One place to review wording, ready for translation, and no copy-pasted variants. |
| `no-colour-literals` | Colours come from theme tokens. | A theme or flavor change reaches every screen. |
| `no-spacing-literals` | Spacing comes from theme tokens. | Same, for layout rhythm. |
| `decimal-fields-not-double` | Quantities that must keep their precision (money, totals, quantities and measured readings) are parsed once and stored without a lossy `double`; formatting happens at display. | A `double` round-trip silently changes values such as `10.10`. |

## Scope of each rule

- Rules 1–4 look at every `.dart` file under `--root`.
- Rules 5–7 look only at presentation files; constants and theme folders are outside presentation by definition, so they are never scanned.
- Rule 8 looks at everything except presentation (the places that declare data, not the places that format it).

## Not covered on purpose

- Whether a screen is faithful to a reference design (human judgement).
- Whether a Bloc is feature-level or screen-local (see the project's architecture skill).
- Layer boundaries (`check-layers`).
