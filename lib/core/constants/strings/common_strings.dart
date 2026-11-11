/// User-facing strings shared by `core/widgets` and every feature.
/// Feature-specific copy lives in each feature's own `*_strings.dart`.
abstract final class CommonStrings {
  static const showPassword = 'Mostrar senha';
  static const hidePassword = 'Ocultar senha';
  static const back = 'Voltar';
  static const cancel = 'Cancelar';
  static const ok = 'Entendi';
  static const close = 'Fechar';
  static const readOnlySeal = 'SOMENTE LEITURA';

  // Form fields
  static String counter(int length, int max) => '$length/$max';
  static const selectHint = 'Selecione uma opção';
  static const searchHint = 'Buscar';
  static const noResults = 'Nenhum resultado';
  static const apply = 'Aplicar';
  static const previousMonth = 'Mês anterior';
  static const nextMonth = 'Próximo mês';
  static const weekdayInitials = ['D', 'S', 'T', 'Q', 'Q', 'S', 'S'];
  static const chooseDate = 'Escolher data';
  static const chooseTime = 'Escolher horário';
  static const dateHint = 'DD/MM/AAAA';
  static const timeHint = 'HH:MM';
  static const decrease = 'Diminuir';
  static const increase = 'Aumentar';

  // Feedback and states
  static String remove(String label) => 'Remover $label';
  static const offlineTitle = 'Você está offline';
  static const offlineMessage =
      'As alterações ficam salvas no aparelho e sincronizam quando a '
      'conexão voltar.';
  static String pendingChanges(int n) =>
      n == 1 ? '1 alteração pendente' : '$n alterações pendentes';
  static String errorCode(String code) =>
      'Se persistir, informe o código $code.';

  // Navigation
  static const moreActions = 'Mais ações';
  static const loading = 'Carregando';
  static String stepOf(int step, int total) => 'Passo $step de $total';
  static String stepPosition(int step, int total, String label) =>
      'Passo $step de $total: $label';
  static const retry = 'Tentar novamente';
  static const genericError = 'Algo deu errado. Tente de novo em instantes.';
  static const offline = 'Sem conexão. Tente de novo em instantes.';
}
