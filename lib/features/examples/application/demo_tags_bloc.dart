import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

sealed class DemoTagsEvent extends Equatable {
  const DemoTagsEvent();
}

final class DemoTagAdded extends DemoTagsEvent {
  const DemoTagAdded(this.tag);

  final String tag;

  @override
  List<Object?> get props => [tag];
}

final class DemoTagRemoved extends DemoTagsEvent {
  const DemoTagRemoved(this.index);

  final int index;

  @override
  List<Object?> get props => [index];
}

/// Screen-local list of tags for the tag field demo.
class DemoTagsBloc extends Bloc<DemoTagsEvent, List<String>> {
  DemoTagsBloc(List<String> initial) : super(List.unmodifiable(initial)) {
    on<DemoTagAdded>((e, emit) {
      if (state.contains(e.tag)) return;
      emit(List.unmodifiable([...state, e.tag]));
    });
    on<DemoTagRemoved>(
      (e, emit) => emit(List.unmodifiable([...state]..removeAt(e.index))),
    );
  }
}
