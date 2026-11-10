/// User-facing copy of the home feature (pt-BR).
abstract final class HomeStrings {
  static const tabHome = 'Início';
  static const tabProfile = 'Perfil';

  static String greeting(String firstName) => 'Olá, $firstName';

  static const summary = 'Resumo';
  static const filters = ['Todos', 'Abertas', 'Concluídas'];

  static const weekTitle = 'Tarefas da semana';
  static const weekBody = '3 de 5 concluídas';
  static const onTrack = 'Em dia';
  static const pending = 'Pendente';

  static const reviewTitle = 'Próxima revisão';
  static const reviewBody = 'Amanhã às 9h';
  static const scheduled = 'Agendada';

  static const activity = 'Atividade';
  static const emptyTitle = 'Nada por aqui ainda';
  static const emptyMessage =
      'Este é o lugar das suas telas. Comece criando uma feature em lib/features.';
}
