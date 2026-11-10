import 'package:equatable/equatable.dart';
import 'failure.dart';

/// The return type of every usecase: either a [Success] carrying a value or a
/// [ResultFailure] carrying a [Failure]. Usecases never throw.
///
/// `sealed`, so consuming it with a `switch` is exhaustive — the compiler
/// rejects a missing branch, and no `default` is allowed.
sealed class Result<S> extends Equatable {
  const Result();

  /// Collapse both branches to a single [R] (e.g. a widget state).
  R fold<R>(
    R Function(S value) onSuccess,
    R Function(Failure failure) onFailure,
  ) => switch (this) {
    Success<S>(:final value) => onSuccess(value),
    ResultFailure<S>(:final failure) => onFailure(failure),
  };

  /// Transform the success value; pass failures through untouched, re-wrapped
  /// at the new type [T].
  Result<T> map<T>(T Function(S value) transform) => switch (this) {
    Success<S>(:final value) => Success(transform(value)),
    ResultFailure<S>(:final failure) => ResultFailure(failure),
  };

  @override
  List<Object?> get props => const [];
}

final class Success<S> extends Result<S> {
  const Success(this.value);

  final S value;

  @override
  List<Object?> get props => [...super.props, value];
}

final class ResultFailure<S> extends Result<S> {
  const ResultFailure(this.failure);

  final Failure failure;

  @override
  List<Object?> get props => [...super.props, failure];
}
