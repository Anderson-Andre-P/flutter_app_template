import '../../../../core/error/failure.dart';
import '../../../../core/error/failure_mapper.dart';
import '../../../../core/error/result.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/activity.dart';
import '../repositories/activity_repository.dart';

class GetActivity implements UseCase<Activity, String> {
  const GetActivity(this._repository);

  final ActivityRepository _repository;

  static const notFound = 'Movimentação não encontrada.';

  @override
  Future<Result<Activity>> call(String id) async {
    try {
      final activity = await _repository.byId(id);
      return activity == null
          ? const ResultFailure(UnexpectedFailure(notFound))
          : Success(activity);
    } catch (e) {
      return ResultFailure(mapExceptionToFailure(e));
    }
  }
}
