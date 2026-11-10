import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/error/result.dart';
import '../../../core/usecase/usecase.dart';
import '../../../core/utils/search.dart';
import '../domain/entities/activity.dart';
import '../domain/usecases/get_activities.dart';
import 'view_status.dart';

sealed class ActivityListEvent extends Equatable {
  const ActivityListEvent();

  @override
  List<Object?> get props => const [];
}

final class ActivityListStarted extends ActivityListEvent {
  const ActivityListStarted();
}

final class ActivityQueryChanged extends ActivityListEvent {
  const ActivityQueryChanged(this.query);

  final String query;

  @override
  List<Object?> get props => [query];
}

final class ActivityFilterChanged extends ActivityListEvent {
  const ActivityFilterChanged(this.filter);

  final ActivityFilter filter;

  @override
  List<Object?> get props => [filter];
}

final class ActivityListState extends Equatable {
  const ActivityListState({
    this.status = ViewStatus.initial,
    this.items = const [],
    this.query = '',
    this.filter = ActivityFilter.all,
    this.errorMessage,
  });

  final ViewStatus status;
  final List<Activity> items;
  final String query;
  final ActivityFilter filter;
  final String? errorMessage;

  /// [items] narrowed by [filter] and by [query] (title, method or category,
  /// ignoring case and accents).
  List<Activity> get visible {
    final q = normalizeForSearch(query);
    return [
      for (final a in items)
        if (filter.matches(a) &&
            (q.isEmpty ||
                normalizeForSearch(
                  '${a.title} ${a.method} ${a.category}',
                ).contains(q)))
          a,
    ];
  }

  ActivityListState copyWith({
    ViewStatus? status,
    List<Activity>? items,
    String? query,
    ActivityFilter? filter,
    String? Function()? errorMessage,
  }) => ActivityListState(
    status: status ?? this.status,
    items: items ?? this.items,
    query: query ?? this.query,
    filter: filter ?? this.filter,
    errorMessage: errorMessage == null ? this.errorMessage : errorMessage(),
  );

  @override
  List<Object?> get props => [status, items, query, filter, errorMessage];
}

class ActivityListBloc extends Bloc<ActivityListEvent, ActivityListState> {
  ActivityListBloc(this._getActivities) : super(const ActivityListState()) {
    on<ActivityListStarted>(_onStarted);
    on<ActivityQueryChanged>((e, emit) => emit(state.copyWith(query: e.query)));
    on<ActivityFilterChanged>(
      (e, emit) => emit(state.copyWith(filter: e.filter)),
    );
  }

  final GetActivities _getActivities;

  Future<void> _onStarted(
    ActivityListStarted event,
    Emitter<ActivityListState> emit,
  ) async {
    emit(state.copyWith(status: ViewStatus.loading, errorMessage: () => null));
    final result = await _getActivities(const NoParams());
    emit(switch (result) {
      Success(:final value) => state.copyWith(
        status: ViewStatus.ready,
        items: value,
      ),
      ResultFailure(:final failure) => state.copyWith(
        status: ViewStatus.failure,
        errorMessage: () => failure.message,
      ),
    });
  }
}
