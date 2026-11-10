/// User-facing copy of the settings feature (pt-BR).
abstract final class SettingsStrings {
  static const title = 'Configurações';

  static const personalData = 'Dados pessoais';
  static const personalDataHint = 'Nome, e-mail e contato';
  static const security = 'Segurança';
  static const securityHint = 'Senha e biometria';
  static const notifications = 'Notificações';
  static const notificationsHint = 'Alertas e lembretes';
  static const help = 'Ajuda';
  static const helpHint = 'Fale com a gente';
  static const comingSoon = 'Disponível em breve.';

  static const appearance = 'Aparência';
  static const themeSystem = 'Sistema';
  static const themeLight = 'Claro';
  static const themeDark = 'Escuro';
  static const about = 'Sobre';

  static String version(String version, String build) =>
      'Versão $version ($build)';

  static const signOut = 'Sair da conta';
  static const signOutTitle = 'Sair da conta?';
  static const signOutMessage =
      'Você vai precisar entrar de novo para continuar.';
  static const signOutConfirm = 'Sair';
}
