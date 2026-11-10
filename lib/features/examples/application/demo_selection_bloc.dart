import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Screen-local "which one is selected" for the demo screens (tabs of each
/// sample bar, chips, the sort option), keyed by a name per control.
final class DemoSelected extends Equatable {
  const DemoSelected(this.key, this.index);

  final String key;
  final int index;

  @override
  List<Object?> get props => [key, index];
}

final class DemoSelectionState extends Equatable {
  const DemoSelectionState([this.selections = const {}]);

  final Map<String, int> selections;

  int of(String key, {int fallback = 0}) => selections[key] ?? fallback;

  @override
  List<Object?> get props => [selections];
}

class DemoSelectionBloc extends Bloc<DemoSelected, DemoSelectionState> {
  DemoSelectionBloc() : super(const DemoSelectionState()) {
    on<DemoSelected>(
      (e, emit) =>
          emit(DemoSelectionState({...state.selections, e.key: e.index})),
    );
  }
}
