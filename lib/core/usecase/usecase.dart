import 'package:equatable/equatable.dart';

import '../error/result.dart';

/// One business action. Implementations live in `features/<f>/domain/usecases/`,
/// are built from repository interfaces, and are invoked like a function:
/// `final result = await someUseCase(params);`
///
/// [T] is the success payload; [Params] is the input — a small value object
/// per usecase, or [NoParams]. A usecase returns a [Result] and never throws.
abstract interface class UseCase<T, Params> {
  Future<Result<T>> call(Params params);
}

/// Input placeholder for a usecase that takes no arguments, so `call` stays
/// uniform: `await someUseCase(const NoParams())`.
final class NoParams extends Equatable {
  const NoParams();

  @override
  List<Object?> get props => const [];
}
