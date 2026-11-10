import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/error/result.dart';
import '../domain/entities/activity.dart';
import '../domain/usecases/get_activity.dart';
import 'view_status.dart';

sealed class ActivityDetailEvent extends Equatable {
  const ActivityDetailEvent();

  @override
  List<Object?> get props => const [];
}

final class ActivityDetailRequested extends ActivityDetailEvent {
  const ActivityDetailRequested(this.id);

  final String id;

  @override
  List<Object?> get props => [id];
}

final class ActivityDetailState extends Equatable {
  const ActivityDetailState({
    this.status = ViewStatus.initial,
    this.activity,
    this.errorMessage,
  });

  final ViewStatus status;
  final Activity? activity;
  final String? errorMessage;

  @override
  List<Object?> get props => [status, activity, errorMessage];
}

class ActivityDetailBloc
    extends Bloc<ActivityDetailEvent, ActivityDetailState> {
  ActivityDetailBloc(this._getActivity) : super(const ActivityDetailState()) {
    on<ActivityDetailRequested>(_onRequested);
  }

  final GetActivity _getActivity;

  Future<void> _onRequested(
    ActivityDetailRequested event,
    Emitter<ActivityDetailState> emit,
  ) async {
    emit(const ActivityDetailState(status: ViewStatus.loading));
    final result = await _getActivity(event.id);
    emit(switch (result) {
      Success(:final value) => ActivityDetailState(
        status: ViewStatus.ready,
        activity: value,
      ),
      ResultFailure(:final failure) => ActivityDetailState(
        status: ViewStatus.failure,
        errorMessage: failure.message,
      ),
    });
  }
}
