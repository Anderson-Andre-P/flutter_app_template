/// User-facing copy of the settings feature (pt-BR).
abstract final class SettingsStrings {
  static const title = 'Perfil';
  static const appearance = 'Aparência';
  static const themeSystem = 'Sistema';
  static const themeLight = 'Claro';
  static const themeDark = 'Escuro';
  static const about = 'Sobre';

  static String version(String version, String build) =>
      'Versão $version ($build)';

  static const signOut = 'Sair';
  static const signOutTitle = 'Sair da conta?';
  static const signOutMessage =
      'Você vai precisar entrar de novo para continuar.';
  static const signOutConfirm = 'Sair';
}
