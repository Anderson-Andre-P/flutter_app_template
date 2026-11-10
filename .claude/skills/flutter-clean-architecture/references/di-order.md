# Dependency injection per feature

One function per feature, one call site.

```dart
/// datasource -> repository -> usecases -> blocs.
void registerThingFeature(GetIt sl) {
  sl
    ..registerLazySingleton(() => ThingRemoteDatasource(sl()))
    ..registerLazySingleton<ThingRepository>(
      () => ThingRepositoryImpl(remote: sl(), prefs: sl()),
    )
    ..registerLazySingleton(() => GetThingUseCase(sl()))
    ..registerLazySingleton(() => SaveThingUseCase(sl()))
    ..registerFactory(() => ThingBloc(getThing: sl(), saveThing: sl()));
}
```

## Rules

- **Order:** datasource → repository → usecases → blocs. Each line only resolves things registered above it or by `core`.
- Register repositories under their **interface** type (`registerLazySingleton<ThingRepository>`); usecases and Blocs depend on the interface.
- Feature-level Blocs: `registerFactory` (a new instance per screen) unless the state must be shared across the app's lifetime, then `registerLazySingleton`.
- Screen-local Blocs are **not** registered; the screen creates them.
- Only `core/di/injection_container.dart` (the composition root) imports every feature's `di.dart`:

```dart
Future<void> setupDependencies() async {
  // 1. core: storage, network, logging, session …
  // 2. features, in dependency order of their core needs
  registerAuthFeature(sl);
  registerThingFeature(sl);
  // 3. cross-feature seams, once everything exists: hand each feature's
  //    callbacks (e.g. "clear my cache at logout") to the owner of the flow
}
```

## Seams

A seam is a callback or a port interface from `core/`, provided by the owning feature and wired here. A feature exposes its usecase under the port's type —

```dart
..registerLazySingleton<LogoutPort>(() => sl<LogoutUseCase>())
```

— so other features depend on `LogoutPort` (declared in `core/`) and never import the auth feature. Because step 3 runs after every feature is registered, no feature has to import another.

## Testing the wiring

Keep one test that builds the container and resolves every public type (usecases, Blocs); it catches an order or missing-registration error without running the app.
