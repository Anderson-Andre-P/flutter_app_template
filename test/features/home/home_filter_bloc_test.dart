import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_app_template/features/home/application/home_filter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('starts on the first filter', () {
    expect(HomeFilterBloc().state, const HomeFilterState(0));
  });

  blocTest<HomeFilterBloc, HomeFilterState>(
    'Selected changes the filter',
    build: HomeFilterBloc.new,
    act: (b) => b.add(const HomeFilterSelected(2)),
    expect: () => [const HomeFilterState(2)],
  );
}
