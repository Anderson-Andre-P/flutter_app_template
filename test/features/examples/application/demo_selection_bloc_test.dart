import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_app_template/features/examples/application/demo_selection_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('an unset key reads as its fallback', () {
    const s = DemoSelectionState();
    expect(s.of('nav-3'), 0);
    expect(s.of('sort', fallback: 2), 2);
  });

  blocTest<DemoSelectionBloc, DemoSelectionState>(
    'selections are kept per key',
    build: DemoSelectionBloc.new,
    act: (b) => b
      ..add(const DemoSelected('nav-3', 2))
      ..add(const DemoSelected('chips', 1)),
    verify: (b) {
      expect(b.state.of('nav-3'), 2);
      expect(b.state.of('chips'), 1);
      expect(b.state.of('nav-4'), 0);
    },
  );
}
