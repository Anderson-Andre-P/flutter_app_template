import 'package:equatable/equatable.dart';

/// Base type for every recoverable error surfaced by a usecase.
///
/// `sealed` so a `switch` over a [Failure] is exhaustive: adding a subtype
/// forces every call site to handle it (no `default` clause).
sealed class Failure extends Equatable {
  const Failure(this.message);

  /// Human-readable, user-facing (pt-BR). Widgets may show this directly.
  final String message;

  @override
  List<Object?> get props => [message];
}

/// Fallback for anything not mapped to a more specific failure.
final class UnexpectedFailure extends Failure {
  const UnexpectedFailure([super.message = 'Algo deu errado. Tente de novo.']);
}

/// No connection, timeout or transport error.
final class NetworkFailure extends Failure {
  const NetworkFailure([
    super.message = 'Sem conexão. Tente de novo em instantes.',
  ]);
}

/// The session or the credentials were rejected.
final class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure([
    super.message = 'Sua sessão expirou. Entre novamente.',
  ]);
}

/// The server answered with an error status.
final class ServerFailure extends Failure {
  const ServerFailure({
    required this.statusCode,
    String message = 'Não foi possível concluir. Tente de novo.',
  }) : super(message);

  final int statusCode;

  @override
  List<Object?> get props => [...super.props, statusCode];
}

/// Input rejected before reaching a repository (e.g. invalid e-mail).
final class ValidationFailure extends Failure {
  const ValidationFailure(super.message);
}

/// Reading or writing local storage failed.
final class StorageFailure extends Failure {
  const StorageFailure([
    super.message = 'Não foi possível acessar os dados do aparelho.',
  ]);
}
