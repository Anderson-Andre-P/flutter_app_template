# Per-layer test shapes

## Usecase

```dart
class MockThingRepository extends Mock implements ThingRepository {}

void main() {
  late MockThingRepository repo;
  late GetThingUseCase useCase;

  setUp(() {
    repo = MockThingRepository();
    useCase = GetThingUseCase(repo);
  });

  test('returns the thing the repository found', () async {
    when(() => repo.get('1')).thenAnswer((_) async => const Success(thing));

    final result = await useCase(const GetThingParams('1'));

    expect(result, const Success(thing));
    verify(() => repo.get('1')).called(1);
  });

  test('passes a failure through unchanged', () async {
    when(() => repo.get('1')).thenAnswer((_) async => const ResultFailure(NetworkFailure()));
    expect(await useCase(const GetThingParams('1')), const ResultFailure<Thing>(NetworkFailure()));
  });
}
```

## Repository implementation

Mock the datasource and make it **throw each exception type**; assert the mapped `Failure` for each. Assert the entity conversion on success.

## Model

```dart
test('fromJson reads the server payload', () => expect(ThingModel.fromJson(fixture).id, '1'));
test('fromJson tolerates a malformed item', () => expect(() => ThingModel.fromJson(badFixture), returnsNormally));
```

Keep payload fixtures as files or constants copied from a real response.

## Bloc

```dart
blocTest<ThingBloc, ThingState>(
  'ThingRequested loads the thing',
  build: () {
    when(() => getThing(any())).thenAnswer((_) async => const Success(thing));
    return ThingBloc(getThing: getThing);
  },
  act: (b) => b.add(const ThingRequested('1')),
  expect: () => [const ThingState.loading(), ThingState.loaded(thing)],
);
```

One `group` per event; include the failure path and, for events with a `done` completer, that it completes.

## Widget

Wrap in a minimal `MaterialApp` (and the Bloc provider); pump each state; assert text/keys/visibility; run once under the light and once under the dark theme. Do not read private `State`.

## Calculation / formatting

Table-driven: input → expected, including zero, negative, boundary, very large, and locale-specific formats.

## Integration

Few and tagged by purpose (navigation, persistence, platform, wiring, journey). A behaviour that can be proven in a unit or widget test belongs there, not here.
