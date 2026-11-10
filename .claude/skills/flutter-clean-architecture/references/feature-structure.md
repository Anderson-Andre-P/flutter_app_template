# Feature structure

```text
lib/
├── app/                      app widget, router, per-flavor/entry wiring
├── core/                     shared infrastructure (never imports features/)
│   ├── error/                Result, Failure, typed exceptions
│   ├── usecase/              UseCase<T, Params>, NoParams
│   ├── di/                   setupDependencies(): calls each feature, wires seams
│   ├── network/  storage/  sync/  theme/  logging/  constants/ …
│   └── <port>.dart           pure-Dart ports other features depend on
└── features/<feature>/
    ├── data/
    │   ├── datasources/      <feature>_remote_datasource.dart, <feature>_local_datasource.dart
    │   ├── models/           <feature>_model.dart            (hand-written fromJson / toJson)
    │   └── repositories/     <feature>_repository_impl.dart
    ├── domain/
    │   ├── entities/         <feature>_entity.dart           (pure objects, Equatable)
    │   ├── repositories/     <feature>_repository.dart       (interfaces)
    │   └── usecases/         <verb>_<thing>_usecase.dart     (one business action per class)
    ├── application/
    │   └── <name>/<name>_bloc.dart   feature-level Blocs: DI-registered, built from usecases
    ├── presentation/
    │   ├── bloc/             <name>_bloc.dart                screen-local, UI-only Blocs (no usecase, no DI)
    │   ├── screens/          <screen>_screen.dart
    │   └── widgets/
    └── di.dart               register<Feature>Feature(GetIt sl)
```

## Naming

- One class per file; the file name is the class name in `snake_case`.
- Usecase: `<Verb><Thing>UseCase` in `<verb>_<thing>_usecase.dart`; it takes a small params object (or `NoParams`) and returns a `Result`.
- Repository interface `ThingRepository` in `domain`; implementation `ThingRepositoryImpl` in `data`.
- Bloc `ThingBloc` with `ThingEvent` / `ThingState` next to it (`thing_bloc.dart`, `thing_event.dart`, `thing_state.dart`), or `part` files — pick one style per project and keep it.

## Mirrors

Tests mirror source paths: `lib/features/<f>/<layer>/foo.dart` → `test/features/<f>/<layer>/foo_test.dart` (see `flutter-testing-conventions`).

## A feature that is small

Skip a folder only when it would stay empty; keep the layer names. A feature with no remote data has no `remote_datasource`; it still has `domain/` and `di.dart`.
