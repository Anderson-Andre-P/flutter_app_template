import 'app_exception.dart';
import 'failure.dart';

/// Turns anything a repository or datasource threw into the [Failure] a
/// usecase returns. Unknown errors become [UnexpectedFailure].
Failure mapExceptionToFailure(Object error) => switch (error) {
  NetworkException() => const NetworkFailure(),
  UnauthorizedException() => const UnauthorizedFailure(),
  ServerException(:final statusCode) => ServerFailure(statusCode: statusCode),
  StorageException() => const StorageFailure(),
  _ => const UnexpectedFailure(),
};
