import '../../../../core/error/failure.dart';
import '../../../../core/error/failure_mapper.dart';
import '../../../../core/error/result.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/transfer.dart';
import '../repositories/activity_repository.dart';

/// Validates the form, then sends it.
class SendTransfer implements UseCase<TransferReceipt, TransferRequest> {
  const SendTransfer(this._repository);

  final ActivityRepository _repository;

  static const invalidAmount = 'Escolha um valor';
  static const missingRecipient = 'Informe para quem vai enviar';

  @override
  Future<Result<TransferReceipt>> call(TransferRequest params) async {
    if (params.amountCents <= 0) {
      return const ResultFailure(ValidationFailure(invalidAmount));
    }
    final recipient = params.recipient.trim();
    if (recipient.isEmpty) {
      return const ResultFailure(ValidationFailure(missingRecipient));
    }
    try {
      return Success(
        await _repository.send(
          TransferRequest(
            amountCents: params.amountCents,
            recipient: recipient,
            description: params.description.trim(),
          ),
        ),
      );
    } catch (e) {
      return ResultFailure(mapExceptionToFailure(e));
    }
  }
}
