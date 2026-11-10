import 'package:equatable/equatable.dart';

final class TransferRequest extends Equatable {
  const TransferRequest({
    required this.amountCents,
    required this.recipient,
    this.description = '',
  });

  final int amountCents;
  final String recipient;
  final String description;

  @override
  List<Object?> get props => [amountCents, recipient, description];
}

final class TransferReceipt extends Equatable {
  const TransferReceipt({
    required this.amountCents,
    required this.recipient,
    required this.protocol,
    required this.issuedAt,
  });

  final int amountCents;
  final String recipient;
  final String protocol;
  final DateTime issuedAt;

  @override
  List<Object?> get props => [amountCents, recipient, protocol, issuedAt];
}
