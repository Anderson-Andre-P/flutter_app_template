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

final class DemoTagMoved extends DemoTagsEvent {
  const DemoTagMoved(this.from, this.to);

  /// Indices as `ReorderableListView.onReorderItem` gives them: [to] is
  /// the item's final position.
  final int from;
  final int to;

  @override
  List<Object?> get props => [from, to];
}

/// Screen-local list of strings for the demos: the tags of the tag field,
/// the order of a reorderable list, the messages of a conversation.
class DemoTagsBloc extends Bloc<DemoTagsEvent, List<String>> {
  DemoTagsBloc(List<String> initial) : super(List.unmodifiable(initial)) {
    on<DemoTagAdded>((e, emit) {
      if (state.contains(e.tag)) return;
      emit(List.unmodifiable([...state, e.tag]));
    });
    on<DemoTagMoved>((e, emit) {
      final list = [...state];
      final item = list.removeAt(e.from);
      list.insert(e.to, item);
      emit(List.unmodifiable(list));
    });
    on<DemoTagRemoved>(
      (e, emit) => emit(List.unmodifiable([...state]..removeAt(e.index))),
    );
  }
}
