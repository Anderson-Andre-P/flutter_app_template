# Result, usecase, repository — a worked example

## core

```dart
sealed class Result<S> extends Equatable {
  const Result();
  R fold<R>(R Function(S value) onSuccess, R Function(Failure failure) onFailure) => switch (this) {
        Success<S>(:final value) => onSuccess(value),
        ResultFailure<S>(:final failure) => onFailure(failure),
      };
  Result<T> map<T>(T Function(S value) transform) => switch (this) {
        Success<S>(:final value) => Success(transform(value)),
        ResultFailure<S>(:final failure) => ResultFailure(failure),
      };
  @override
  List<Object?> get props => const [];
}
final class Success<S> extends Result<S> { const Success(this.value); final S value; /* props: [value] */ }
final class ResultFailure<S> extends Result<S> { const ResultFailure(this.failure); final Failure failure; /* props: [failure] */ }

abstract interface class UseCase<T, Params> {
  Future<Result<T>> call(Params params);
}

Failure failureFrom(AppException e) => switch (e) {
      NetworkUnavailableException() => const NetworkFailure(),
      UnauthorizedException() => const UnauthorizedFailure(),
      ServerException() || BadRequestException() || ResponseParseException() => const ServerFailure(),
      _ => const UnexpectedFailure(), // AppException is abstract, not sealed: the default is required
    };
```

## domain

```dart
abstract interface class ThingRepository {
  Future<Result<Thing>> get(String id);
}

class GetThingUseCase implements UseCase<Thing, GetThingParams> {
  const GetThingUseCase(this._repo);
  final ThingRepository _repo;
  @override
  Future<Result<Thing>> call(GetThingParams params) => _repo.get(params.id);
}
```

## data

```dart
class ThingRepositoryImpl implements ThingRepository {
  ThingRepositoryImpl({required this.remote});
  final ThingRemoteDatasource remote;

  @override
  Future<Result<Thing>> get(String id) async {
    try {
      final model = await remote.get(id);       // throws typed exceptions
      return Success(model.toEntity());
    } on AppException catch (e) {
      return ResultFailure(failureFrom(e));      // the one place that maps
    }
  }
}
```

## application

```dart
on<ThingRequested>((event, emit) async {
  final result = await _getThing(GetThingParams(event.id));
  emit(result.fold(
    (thing) => state.copyWith(status: Status.loaded, thing: thing),
    (failure) => state.copyWith(status: Status.failed, failure: failure),
  ));
});
```

## Test shape

- Usecase: mock the repository, assert the returned `Result`, `verify(...).called(1)`.
- Repository: mock the datasource, make it throw each exception type, assert the mapped `Failure`.
- Model: fixture payload → entity, and a malformed payload → no crash.
