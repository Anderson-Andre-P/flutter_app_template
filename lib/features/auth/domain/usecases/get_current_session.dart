import '../../../../core/error/result.dart';
import '../../../../core/logging/app_logger.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

/// The user of the stored session, or `null`. A storage error (e.g. iOS
/// keychain data left by a reinstall) means "no session" — start-up must
/// never get stuck on it.
final class GetCurrentSession implements UseCase<User?, NoParams> {
  const GetCurrentSession(this._repository, this._logger);

  final AuthRepository _repository;
  final AppLogger _logger;

  @override
  Future<Result<User?>> call(NoParams params) async {
    try {
      return Success(await _repository.currentUser());
    } catch (e) {
      _logger.warning('could not read the stored session', error: e);
      return const Success(null);
    }
  }
}
