import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/error/result.dart';
import '../domain/entities/transfer.dart';
import '../domain/usecases/send_transfer.dart';
import 'view_status.dart';

sealed class TransferEvent extends Equatable {
  const TransferEvent();

  @override
  List<Object?> get props => const [];
}

final class TransferAmountSelected extends TransferEvent {
  const TransferAmountSelected(this.amountCents);

  final int amountCents;

  @override
  List<Object?> get props => [amountCents];
}

final class TransferRecipientChanged extends TransferEvent {
  const TransferRecipientChanged(this.recipient);

  final String recipient;

  @override
  List<Object?> get props => [recipient];
}

final class TransferDescriptionChanged extends TransferEvent {
  const TransferDescriptionChanged(this.description);

  final String description;

  @override
  List<Object?> get props => [description];
}

final class TransferSubmitted extends TransferEvent {
  const TransferSubmitted();
}

final class TransferState extends Equatable {
  const TransferState({
    this.amountCents = 0,
    this.recipient = '',
    this.description = '',
    this.submitted = false,
    this.status = ViewStatus.initial,
    this.receipt,
    this.errorMessage,
  });

  final int amountCents;
  final String recipient;
  final String description;

  /// Field errors show only after the first submit.
  final bool submitted;
  final ViewStatus status;
  final TransferReceipt? receipt;
  final String? errorMessage;

  String? get amountError =>
      submitted && amountCents <= 0 ? SendTransfer.invalidAmount : null;

  String? get recipientError => submitted && recipient.trim().isEmpty
      ? SendTransfer.missingRecipient
      : null;

  bool get isValid => amountCents > 0 && recipient.trim().isNotEmpty;

  TransferState copyWith({
    int? amountCents,
    String? recipient,
    String? description,
    bool? submitted,
    ViewStatus? status,
    TransferReceipt? receipt,
    String? Function()? errorMessage,
  }) => TransferState(
    amountCents: amountCents ?? this.amountCents,
    recipient: recipient ?? this.recipient,
    description: description ?? this.description,
    submitted: submitted ?? this.submitted,
    status: status ?? this.status,
    receipt: receipt ?? this.receipt,
    errorMessage: errorMessage == null ? this.errorMessage : errorMessage(),
  );

  @override
  List<Object?> get props => [
    amountCents,
    recipient,
    description,
    submitted,
    status,
    receipt,
    errorMessage,
  ];
}

class TransferBloc extends Bloc<TransferEvent, TransferState> {
  TransferBloc(this._send) : super(const TransferState()) {
    on<TransferAmountSelected>(
      (e, emit) => emit(state.copyWith(amountCents: e.amountCents)),
    );
    on<TransferRecipientChanged>(
      (e, emit) => emit(state.copyWith(recipient: e.recipient)),
    );
    on<TransferDescriptionChanged>(
      (e, emit) => emit(state.copyWith(description: e.description)),
    );
    on<TransferSubmitted>(_onSubmitted);
  }

  final SendTransfer _send;

  Future<void> _onSubmitted(
    TransferSubmitted event,
    Emitter<TransferState> emit,
  ) async {
    if (state.status == ViewStatus.loading) return;
    if (!state.isValid) {
      emit(state.copyWith(submitted: true));
      return;
    }
    emit(
      state.copyWith(
        submitted: true,
        status: ViewStatus.loading,
        errorMessage: () => null,
      ),
    );
    final result = await _send(
      TransferRequest(
        amountCents: state.amountCents,
        recipient: state.recipient,
        description: state.description,
      ),
    );
    emit(switch (result) {
      Success(:final value) => state.copyWith(
        status: ViewStatus.ready,
        receipt: value,
      ),
      ResultFailure(:final failure) => state.copyWith(
        status: ViewStatus.failure,
        errorMessage: () => failure.message,
      ),
    });
  }
}
