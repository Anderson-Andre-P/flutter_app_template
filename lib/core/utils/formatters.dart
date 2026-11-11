import 'package:intl/intl.dart';

final _currency = NumberFormat.currency(
  locale: 'pt_BR',
  symbol: r'R$',
  decimalDigits: 2,
);
final _currencyWhole = NumberFormat.currency(
  locale: 'pt_BR',
  symbol: r'R$',
  decimalDigits: 0,
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

const _monthNames = [
  'Janeiro',
  'Fevereiro',
  'Março',
  'Abril',
  'Maio',
  'Junho',
  'Julho',
  'Agosto',
  'Setembro',
  'Outubro',
  'Novembro',
  'Dezembro',
];

String _two(int v) => v.toString().padLeft(2, '0');

/// `Outubro 2026` — the title of a calendar month.
String formatMonthYear(DateTime month) =>
    '${_monthNames[month.month - 1]} ${month.year}';

/// `23/10/2026` — the format a date field shows and accepts.
String formatNumericDate(DateTime date) =>
    '${_two(date.day)}/${_two(date.month)}/${date.year}';

final _numericDate = RegExp(r'^(\d{2})/(\d{2})/(\d{4})$');

/// Reads `DD/MM/AAAA`; `null` for a partial or impossible date (31/02).
DateTime? parseNumericDate(String text) {
  final m = _numericDate.firstMatch(text.trim());
  if (m == null) return null;
  final (day, month, year) = (
    int.parse(m[1]!),
    int.parse(m[2]!),
    int.parse(m[3]!),
  );
  final date = DateTime(year, month, day);
  return date.year == year && date.month == month && date.day == day
      ? date
      : null;
}

/// `14:30` — 24h, as a time field shows and accepts.
String formatTime(int hour, int minute) => '${_two(hour)}:${_two(minute)}';

final _time = RegExp(r'^(\d{2}):(\d{2})$');

/// Reads `HH:MM` (24h); `null` when partial or out of range.
({int hour, int minute})? parseTime(String text) {
  final m = _time.firstMatch(text.trim());
  if (m == null) return null;
  final (hour, minute) = (int.parse(m[1]!), int.parse(m[2]!));
  return hour < 24 && minute < 60 ? (hour: hour, minute: minute) : null;
}

/// `R$ 1.234,56` from an amount in cents. [signed] prefixes `+ ` or `– `;
/// `showCents: false` gives `R$ 1.234` (for round preset values).
/// Money is always carried as integer cents, never as a double.
String formatCents(int cents, {bool signed = false, bool showCents = true}) {
  final format = showCents ? _currency : _currencyWhole;
  // NumberFormat separates the symbol with a non-breaking space; use a plain
  // one so copy and tests stay predictable.
  final text = format.format(cents.abs() / 100).replaceAll(' ', ' ');
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
