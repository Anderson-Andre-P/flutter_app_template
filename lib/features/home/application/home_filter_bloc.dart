import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

sealed class HomeFilterEvent extends Equatable {
  const HomeFilterEvent();

  @override
  List<Object?> get props => const [];
}

final class HomeFilterSelected extends HomeFilterEvent {
  const HomeFilterSelected(this.index);

  final int index;

  @override
  List<Object?> get props => [index];
}

final class HomeFilterState extends Equatable {
  const HomeFilterState(this.selected);

  final int selected;

  @override
  List<Object?> get props => [selected];
}

/// Screen-local UI state of the home filter chips (Bloc even for UI-only
/// state, per the project's golden rules).
class HomeFilterBloc extends Bloc<HomeFilterEvent, HomeFilterState> {
  HomeFilterBloc() : super(const HomeFilterState(0)) {
    on<HomeFilterSelected>((e, emit) => emit(HomeFilterState(e.index)));
  }
}
