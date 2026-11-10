import 'package:flutter_app_template/core/utils/formatters.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('formatCents', () {
    test('formats Brazilian reais with thousands and decimals', () {
      expect(formatCents(680000), 'R\$ 6.800,00');
      expect(formatCents(18640), 'R\$ 186,40');
      expect(formatCents(0), 'R\$ 0,00');
    });

    test('signed shows + for income and – for expenses', () {
      expect(formatCents(680000, signed: true), '+ R\$ 6.800,00');
      expect(formatCents(-18640, signed: true), '– R\$ 186,40');
    });

    test('showCents: false drops the decimals', () {
      expect(formatCents(35000, showCents: false), 'R\$ 350');
      expect(formatCents(1000000, showCents: false), 'R\$ 10.000');
    });

    test('unsigned drops the sign of a negative value', () {
      expect(formatCents(-18640), 'R\$ 186,40');
    });
  });

  test('formatShortDate uses pt-BR month abbreviations', () {
    expect(formatShortDate(DateTime(2026, 3, 12)), '12 mar');
    expect(formatShortDate(DateTime(2026, 12, 1)), '1 dez');
  });

  test('formatDateTime pads the time', () {
    expect(formatDateTime(DateTime(2026, 3, 12, 18, 2)), '12 mar 2026, 18:02');
  });

  group('dayLabel', () {
    final now = DateTime(2026, 3, 12, 9);

    test('today and yesterday get words', () {
      expect(dayLabel(DateTime(2026, 3, 12, 23), now: now), 'Hoje');
      expect(dayLabel(DateTime(2026, 3, 11, 1), now: now), 'Ontem');
    });

    test('older days get the short date', () {
      expect(dayLabel(DateTime(2026, 3, 10), now: now), '10 mar');
    });
  });
}
