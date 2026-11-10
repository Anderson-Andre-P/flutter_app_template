/// Base for exceptions **thrown** by infrastructure (storage, network, …).
///
/// Distinct from `Failure` (`failure.dart`), which is the value a usecase
/// *returns* in a `Result`. A usecase or repository catches an [AppException]
/// and maps it to a `Failure` (see `failure_mapper.dart`).
class AppException implements Exception {
  const AppException(this.message, {this.cause, this.stackTrace});

  final String message;

  /// The lower-level error this wraps, if any.
  final Object? cause;
  final StackTrace? stackTrace;

  @override
  String toString() =>
      '$runtimeType: $message${cause != null ? ' (cause: $cause)' : ''}';
}

/// No connection, timeout or transport error.
final class NetworkException extends AppException {
  const NetworkException(super.message, {super.cause, super.stackTrace});
}

/// The server answered with a non-2xx status other than 401.
final class ServerException extends AppException {
  const ServerException(
    super.message, {
    required this.statusCode,
    super.cause,
    super.stackTrace,
  });

  final int statusCode;
}

/// The server rejected the credentials or the session (HTTP 401).
final class UnauthorizedException extends AppException {
  const UnauthorizedException(super.message, {super.cause, super.stackTrace});
}

/// Reading or writing local storage failed.
final class StorageException extends AppException {
  const StorageException(super.message, {super.cause, super.stackTrace});
}
