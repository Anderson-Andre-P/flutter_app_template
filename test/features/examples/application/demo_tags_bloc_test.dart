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
}
