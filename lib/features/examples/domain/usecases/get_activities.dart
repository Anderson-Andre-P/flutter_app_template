import '../../../../core/error/failure_mapper.dart';
import '../../../../core/error/result.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/activity.dart';
import '../repositories/activity_repository.dart';

class GetActivities implements UseCase<List<Activity>, NoParams> {
  const GetActivities(this._repository);

  final ActivityRepository _repository;

  @override
  Future<Result<List<Activity>>> call(NoParams params) async {
    try {
      return Success(await _repository.list());
    } catch (e) {
      return ResultFailure(mapExceptionToFailure(e));
    }
  }
}
