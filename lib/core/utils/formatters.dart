import 'package:intl/intl.dart';

final _currency = NumberFormat.currency(
  locale: 'pt_BR',
  symbol: r'R$',
  decimalDigits: 2,
);

const _months = [
  'jan',
  'fev',
  'mar',
  'abr',
  'mai',
  'jun',
  'jul',
  'ago',
  'set',
  'out',
  'nov',
  'dez',
];

/// `R$ 1.234,56` from an amount in cents. [signed] prefixes `+ ` or `– `.
/// Money is always carried as integer cents, never as a double.
String formatCents(int cents, {bool signed = false}) {
  // NumberFormat separates the symbol with a non-breaking space; use a plain
  // one so copy and tests stay predictable.
  final text = _currency.format(cents.abs() / 100).replaceAll(' ', ' ');
  if (!signed) return text;
  return cents < 0 ? '– $text' : '+ $text';
}

/// `12 mar`.
String formatShortDate(DateTime date) =>
    '${date.day} ${_months[date.month - 1]}';

/// `12 mar 2026, 18:42`.
String formatDateTime(DateTime date) {
  String two(int v) => v.toString().padLeft(2, '0');
  return '${formatShortDate(date)} ${date.year}, '
      '${two(date.hour)}:${two(date.minute)}';
}

/// `Hoje`, `Ontem` or the short date — the header of a day group in a list.
String dayLabel(DateTime date, {required DateTime now}) {
  final day = DateTime(date.year, date.month, date.day);
  final today = DateTime(now.year, now.month, now.day);
  final diff = today.difference(day).inDays;
  if (diff == 0) return 'Hoje';
  if (diff == 1) return 'Ontem';
  return formatShortDate(date);
}
