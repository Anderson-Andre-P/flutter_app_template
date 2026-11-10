---
name: dart-result-and-models
description: Error handling and data modelling conventions for Dart/Flutter Clean Architecture — usecases return a sealed Result and never throw, repositories map typed exceptions to Failures, entities versus data models, hand-written fromJson/toJson (no json_serializable or generated files), and decimal quantities that must keep their precision. Use when writing a usecase, repository implementation, datasource, entity, model or JSON mapping, deciding how an error reaches the UI, parsing a server payload, or storing money, quantities or other decimal readings.
metadata:
  version: "1.0"
  scope: portable
---

# dart-result-and-models

## Errors: `Result<T>` in, exceptions below

- A **usecase never throws.** It implements `UseCase<T, Params>` and returns `Future<Result<T>>`. It is invoked like a function: `await someUseCase(params)`; one without input takes `NoParams`.
- `Result` is `sealed`: `Success(value)` or `ResultFailure(failure)`. Consume it with an exhaustive `switch` (no `default`) or `fold` / `map`.
- **Datasources and repositories throw typed exceptions** (`NetworkUnavailableException`, `UnauthorizedException`, `ServerException`, `ResponseParseException`, `StorageException`, … all under one `AppException` base).
- The **repository implementation catches** those exceptions and maps them to a user-facing `Failure` through one function (`failureFrom(AppException)`). Every repository funnels its `catch` through it; none invents its own mapping.
- The Bloc folds the `Result` into a state; widgets never see an exception.

Skeleton and a worked example: [references/result-example.md](references/result-example.md).

## Entities vs. models

| | `domain/entities/` | `data/models/` |
|---|---|---|
| What | Pure objects the business talks about; Flutter- and data-agnostic; `Equatable` | The wire/storage shape of an entity |
| Knows JSON | **No** | **Yes** — `fromJson` / `toJson` |
| Used by | usecases, Blocs, widgets | datasources and repository implementations only |

Only `data/` code constructs or references a model. A model extends or wraps its entity and converts at the repository boundary.

## JSON: hand-written, to the exact shape

`fromJson` / `toJson` are **written by hand**, matching the shape the reference client and the backend actually use — keys, nesting, envelope, casing, null handling. Never `@JsonSerializable`, `@JsonKey`, `json_annotation` or `*.g.dart` / `*.freezed.dart` files (`audit-golden-rules` flags them).

- Parse defensively: a malformed item must not break a whole list; a missing optional key is `null`, not a crash. Throw `ResponseParseException` only when the payload as a whole is unusable.
- Keep the contract's source of truth explicit (the working reference client or the agreed API doc), and remove a modelled key that has no counterpart there.
- Test every model with a real payload fixture and a malformed one.

## Decimal quantities keep their precision

Money, totals, quantities and measured readings: **parse once, store without a lossy `double` round-trip, format only at display.** Store the user's decimal as the string they entered (or a decimal type), send it as such, and format with `NumberFormat` at the last moment. A `double` turns `10.10` into `10.1` and `0.1 + 0.2` into `0.30000000000000004`. `audit-golden-rules` flags `double` fields whose names match the configured words (`decimalFieldNames`).

If a derived value (a unit price) must be computed, do it in one place, right before use, and keep the inputs as decimals.
