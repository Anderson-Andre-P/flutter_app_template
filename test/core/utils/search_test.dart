import 'package:flutter_app_template/core/utils/search.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('normalizeForSearch lower-cases, trims and drops accents', () {
    expect(normalizeForSearch('  Café Ação  '), 'cafe acao');
  });
}
