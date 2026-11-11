import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_app_template/features/examples/application/demo_tags_bloc.dart';

void main() {
  blocTest<DemoTagsBloc, List<String>>(
    'adds at the end and removes by index',
    build: () => DemoTagsBloc(const ['Marina Alves']),
    act: (b) => b
      ..add(const DemoTagAdded('Rafael Souza'))
      ..add(const DemoTagRemoved(0)),
    expect: () => [
      ['Marina Alves', 'Rafael Souza'],
      ['Rafael Souza'],
    ],
  );

  blocTest<DemoTagsBloc, List<String>>(
    'a tag already in the list is not added twice',
    build: () => DemoTagsBloc(const ['Marina Alves']),
    act: (b) => b.add(const DemoTagAdded('Marina Alves')),
    expect: () => <List<String>>[],
  );

  blocTest<DemoTagsBloc, List<String>>(
    'moves an item as a reorderable list reports it',
    build: () => DemoTagsBloc(const ['a', 'b', 'c']),
    // onReorderItem gives the final index: moving 'a' to the end is (0, 2).
    act: (b) => b.add(const DemoTagMoved(0, 2)),
    expect: () => [
      ['b', 'c', 'a'],
    ],
  );
}
