---
name: flutter-bloc-state
description: Bloc as the single state-management mechanism in a Flutter app — events in, states out, no Cubit, no provider/ChangeNotifier — plus the split between feature-level Blocs (application layer, DI-registered, built from usecases) and screen-local UI-only Blocs, and the pitfalls (emit outside a handler, equal states being swallowed, waiting on a Bloc stream, one-shot UI effects). Use when creating or editing a Bloc, event or state, deciding where a piece of UI state lives, a screen never reacts to a repeated state, a dialog or snackbar shows only once, a spinner never stops, or emit throws after a handler finished.
metadata:
  version: "1.0"
  scope: portable
---

# flutter-bloc-state

One mechanism for state: **`Bloc`** (events in, states out). No `Cubit` (not even for pure UI state), no `provider`/`ChangeNotifier`, no ad-hoc controllers holding state. Consistency beats the convenience of calling a method directly. `audit-golden-rules` flags `Cubit` and `ChangeNotifier` mechanically.

## Which kind of Bloc

| | Feature-level Bloc | Screen-local Bloc |
|---|---|---|
| Lives in | `features/<f>/application/<name>/` | `features/<f>/presentation/bloc/` |
| Built from | usecases (domain) | nothing — no usecase call |
| Registered in DI | yes (`registerFactory`, or a lazy singleton when the state must outlive screens) | **no** — the screen creates it |
| Owns | data and flows that outlive a screen | transient UI state of one screen (selected tab, password visible, form step) |

Transient UI flags never live in the feature Bloc. A screen-local Bloc never calls a usecase.

## Shape

- `ThingEvent` (sealed or a small hierarchy), `ThingState` (immutable), `ThingBloc extends Bloc<ThingEvent, ThingState>`; one handler per event registered with `on<E>(…)` in the constructor.
- **Events and states are `Equatable`** (value equality). `props` lists every field that matters.
- A handler calls a usecase, folds the `Result` (see `dart-result-and-models`), and emits a state. UI code reads state with `BlocBuilder`/`BlocListener`/`context.select`; it dispatches events and never calls methods that mutate the Bloc.

## Pitfalls that have bitten before

1. **`emit` only inside an event handler.** A `Timer` callback, a stream listener or any `then` that runs after the handler returned must **add an event** instead of calling `emit`; otherwise `emit` throws or is lost.
2. **Equal states are not re-emitted.** With `Equatable` states, `emit(sameState)` does nothing. Anything that needed the repeat breaks silently: a second success dialog never appears, a spinner never stops. Put a changing field in the state to force a distinct value (a monotonic `id`, a nonce) — see [references/pitfalls.md](references/pitfalls.md).
3. **Never wait for a Bloc by watching its state stream** (`await bloc.stream.first`). If the handler emits nothing new, the wait never ends. Give the event a `Completer<void> done` (excluded from `props`) that the handler completes in a `finally`, and `await` that.
4. **A one-shot UI effect carried by state** (dialog, snackbar, navigation) needs a nonce in the state, or it fires once and never again; consume it in a `BlocListener`, not in `build`.

## Testing

`blocTest` from `bloc_test`, one `group` per event, assert the emitted state sequence; see `flutter-testing-conventions`.
