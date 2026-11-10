# audit-golden-rules — heuristics and blind spots

The script lexes each file once into three views that keep every offset and line number: comments blanked (nested `/* */` handled), string contents blanked (quotes kept), and a table of string literals. Patterns run on the "code" view, so a rule name inside a comment or a string never matches. Interpolations (`${…}`, including nested quotes) stay inside their string.

## Patterns

| Rule | Pattern (on code) |
|---|---|
| `no-cubit` | `\b\w*Cubit\b` (so `CubitTest` does not match); imports whose URI contains `cubit` |
| `no-json-codegen` | `@Json(Serializable\|Key\|Converter\|Enum\|Literal)`; directives importing `json_annotation` or ending `.g.dart` / `.freezed.dart`; any file named `*.g.dart` / `*.freezed.dart` |
| `no-provider-changenotifier` | `ChangeNotifier`, `ChangeNotifierProvider`, `Provider.of`, `MultiProvider`; `package:provider/` |
| `no-forbidden-import` | a directive URI containing any `forbiddenImportPrefixes` entry |
| `no-literal-user-strings` | `Text(` or `<param>:` followed by a string literal, where `<param>` is in `textParams`; the literal is flagged when, after removing `$x` / `${…}`, it has ≥ 2 letters |
| `no-colour-literals` | `Colors.<name>` not preceded by an identifier character (`AppColors.` does not match) and not in `allowColors`; `Color(0x…`; `Color.fromARGB(` / `Color.fromRGBO(` |
| `no-spacing-literals` | a number ≥ 1 (or a non-zero decimal) in the balanced arguments of `EdgeInsets.all/symmetric/only/fromLTRB(`; `SizedBox(` without `child` having `width:`/`height:` followed by an expression with such a number |
| `decimal-fields-not-double` | `double` or `double?` followed by an identifier containing (case-insensitive) a `decimalFieldNames` word |

One finding is reported per line per rule, however many matches the line has.

## Known blind spots (accepted)

- Strings built by concatenation or passed through a variable are not seen; only the literal at the call site is.
- Parameters not in `textParams` (for example a custom widget's `caption:`) are not checked; add the name to the config.
- `double.parse(x)` / `double.tryParse(x)` of a decimal value, and arithmetic on parsed values, are not flagged — only declarations are. Derived values computed right before sending are a conscious choice a human makes.
- Colours reached through `Theme.of(context)` or constants are fine by design; colours in a `ColorScheme.fromSeed(seedColor: …)` inside a presentation file would be flagged.
- A number in `EdgeInsets` that is not spacing (for example a divisor in `size.width / 8`) is flagged; baseline it with a `contains` entry if it is intentional.
- `Padding` / `Gap` custom spacers are not recognised; only `EdgeInsets` and spacer `SizedBox`.
