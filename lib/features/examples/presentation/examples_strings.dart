import '../domain/entities/transfer.dart';

/// User-facing copy of the example screens (pt-BR). Fake data, no backend.
abstract final class ExamplesStrings {
  /// The activity the "Detalhe" demo card opens.
  static const sampleActivityId = 'mercado-bela';

  /// The receipt the "Sucesso" demo card shows.
  static TransferReceipt sampleReceipt(DateTime now) => TransferReceipt(
    amountCents: 35000,
    recipient: 'Ana Souza',
    protocol: 'T48-1120-5521',
    issuedAt: now,
  );

  // Painel
  static const dashboardTitle = 'Painel';
  static const goalOverline = 'Meta do mês';
  static const goalValue = '7.420';
  static const goalCaption = 'de 10.000 pontos';
  static const goalProgress = .742;
  static const goalFooter = '74% concluído · faltam 2.580';
  static const highlightOverline = 'Ação rápida';
  static const highlightTitle = 'Nova transferência';
  static const highlightCaption = 'Valor, destinatário e resumo';
  static const highlightAction = 'Começar';
  static const weekTitle = 'Esta semana';
  static const weekValues = [3.0, 5.0, 2.0, 7.0, 4.0, 2.0, 6.0];
  static const weekLabels = ['S', 'T', 'Q', 'Q', 'S', 'S', 'D'];

  // Extrato
  static const statementTitle = 'Extrato';
  static const searchHint = 'Buscar movimentações';
  static const filterAll = 'Tudo';
  static const filterIncome = 'Entradas';
  static const filterExpense = 'Saídas';
  static const emptyTitle = 'Nada encontrado';
  static const emptyMessage = 'Tente outra busca ou outro filtro.';
  static const loadErrorTitle = 'Não foi possível carregar';
  static const retry = 'Tentar novamente';

  // Detalhes
  static const detailTitle = 'Detalhes';
  static const statusDone = 'Concluída';
  static const infoTitle = 'Informações';
  static const rowDate = 'Data';
  static const rowMethod = 'Pagamento';
  static const rowCategory = 'Categoria';
  static const rowProtocol = 'Protocolo';
  static const shareReceipt = 'Compartilhar comprovante';
  static const dispute = 'Contestar';
  static const comingSoon = 'Disponível em breve.';

  // Transferir
  static const transferTitle = 'Transferir';
  static const amountLabel = 'Valor da transferência';
  static const amountPresets = [5000, 10000, 20000, 35000];
  static const recipientLabel = 'Para';
  static const recipientHint = 'Nome ou CPF';
  static const descriptionLabel = 'Descrição';
  static const descriptionHint = 'Opcional';
  static const summaryTitle = 'Resumo';
  static const rowAmount = 'Valor';
  static const rowFee = 'Taxa';
  static const rowTotal = 'Total';
  static const transferContinue = 'Continuar';

  // Comprovante
  static const successTitle = 'Transferência enviada';
  static String successSubtitle(String amount, String recipient) =>
      '$amount para $recipient';
  static const receiptTitle = 'Comprovante';
  static const rowRecipient = 'Destinatário';
  static const backHome = 'Voltar ao início';

  // Feedback
  static const feedbackTitle = 'Feedback';
  static const toastsTitle = 'Avisos';
  static const toastSuccess = 'Sucesso';
  static const toastWarning = 'Atenção';
  static const toastError = 'Erro';
  static const toastInfo = 'Info';
  static const toastSuccessMessage = 'Alterações salvas.';
  static const toastWarningMessage = 'Sua sessão expira em 5 minutos.';
  static const toastErrorMessage = 'Não foi possível salvar.';
  static const toastInfoMessage = 'Uma nova versão está disponível.';
  static const dialogsTitle = 'Diálogos';
  static const dialogConfirm = 'Confirmação';
  static const dialogAlert = 'Alerta';
  static const dialogConfirmTitle = 'Excluir item?';
  static const dialogConfirmMessage = 'Essa ação não pode ser desfeita.';
  static const dialogConfirmLabel = 'Excluir';
  static const dialogAlertTitle = 'Tudo certo';
  static const dialogAlertMessage = 'Este é um alerta simples, com um botão.';
  static const statesTitle = 'Estados de tela';
  static const stateEmptyTitle = 'Nada por aqui ainda';
  static const stateEmptyMessage = 'Quando houver itens, eles aparecem aqui.';
  static const stateErrorTitle = 'Algo deu errado';
  static const stateErrorMessage = 'Verifique sua conexão e tente de novo.';
}
