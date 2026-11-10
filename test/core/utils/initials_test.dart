import 'package:flutter_app_template/core/utils/initials.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('first and last initials, upper-cased', () {
    expect(initialsOf('ana maria souza'), 'AS');
    expect(initialsOf('Ana'), 'A');
    expect(initialsOf('  '), '');
  });
}
