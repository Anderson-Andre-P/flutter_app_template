# Bloc pitfalls, with the fix

## 1. emit from a callback

```dart
// WRONG — the handler has returned; emit may throw or be dropped
on<TrackingStarted>((event, emit) {
  _timer = Timer.periodic(const Duration(seconds: 10), (_) => emit(state.copyWith(...)));
});

// RIGHT — the callback only dispatches
on<TrackingStarted>((event, emit) {
  _timer = Timer.periodic(const Duration(seconds: 10), (_) => add(const TrackingTicked()));
});
on<TrackingTicked>((event, emit) => emit(state.copyWith(...)));
```

For a stream, use `emit.forEach` / `emit.onEach` inside the handler, or listen outside and `add` events.

## 2. A repeated state is swallowed

`Bloc` skips an emission that equals the current state. Symptoms: a dialog shows only the first time; a refresh indicator never stops when nothing changed; a first load that results in a state equal to the initial one leaves `loading` forever.

Fixes, in order of preference:

- Make the *request* carry its own completion: a `done` completer on the event (see 3).
- Make the *state* differ: add a field that changes on every occurrence (`registrationId + 1`, a timestamp, a nonce).
- Do not fall back to making states non-Equatable; it hides the problem and re-renders everything.

## 3. Waiting for a Bloc

```dart
// WRONG — never completes if the handler emits an equal state
bloc.add(const RefreshRequested());
await bloc.stream.first;

// RIGHT — the event owns the signal
class RefreshRequested extends ThingEvent {
  RefreshRequested({Completer<void>? done}) : done = done ?? Completer<void>();
  final Completer<void> done;          // NOT in props
  @override
  List<Object?> get props => const [];
}

on<RefreshRequested>((event, emit) async {
  try {
    ...emit(...)
  } finally {
    if (!event.done.isCompleted) event.done.complete();
  }
});

bloc.add(request);
await request.done.future;
```

## 4. One-shot effects

State describes what the screen *is*; an effect (show a dialog) is something that *happened*. Carry it as a state with a nonce and react in a `BlocListener` with `listenWhen: (prev, next) => prev.effectId != next.effectId`. Never trigger dialogs or navigation from `build`.
