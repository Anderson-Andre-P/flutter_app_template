import 'package:equatable/equatable.dart';

/// One movement of the example statement. Money is integer cents: negative
/// is an expense, positive an income.
final class Activity extends Equatable {
  const Activity({
    required this.id,
    required this.title,
    required this.method,
    required this.category,
    required this.amountCents,
    required this.date,
    required this.protocol,
  });

  final String id;
  final String title;

  /// How it was paid (Cartão, Pix, Débito…).
  final String method;
  final String category;
  final int amountCents;
  final DateTime date;
  final String protocol;

  bool get isIncome => amountCents > 0;

  @override
  List<Object?> get props => [
    id,
    title,
    method,
    category,
    amountCents,
    date,
    protocol,
  ];
}

/// Filter chips of the statement.
enum ActivityFilter {
  all,
  income,
  expense;

  bool matches(Activity a) => switch (this) {
    ActivityFilter.all => true,
    ActivityFilter.income => a.isIncome,
    ActivityFilter.expense => !a.isIncome,
  };
}
