import 'package:get_it/get_it.dart';

import 'application/activity_detail_bloc.dart';
import 'application/activity_list_bloc.dart';
import 'application/demo_selection_bloc.dart';
import 'application/transfer_bloc.dart';
import 'data/fake_activity_repository.dart';
import 'domain/repositories/activity_repository.dart';
import 'domain/usecases/get_activities.dart';
import 'domain/usecases/get_activity.dart';
import 'domain/usecases/send_transfer.dart';

/// Registers the example screens. The whole feature is disposable: delete
/// `lib/features/examples`, its tests, this call and its routes.
void registerExamplesFeature(GetIt sl) {
  sl
    ..registerLazySingleton<ActivityRepository>(FakeActivityRepository.new)
    ..registerLazySingleton(() => GetActivities(sl()))
    ..registerLazySingleton(() => GetActivity(sl()))
    ..registerLazySingleton(() => SendTransfer(sl()))
    ..registerFactory(() => ActivityListBloc(sl()))
    ..registerFactory(() => ActivityDetailBloc(sl()))
    ..registerFactory(() => TransferBloc(sl()))
    ..registerFactory(DemoSelectionBloc.new);
}
