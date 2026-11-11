/// Every route path of the app, in one place.
abstract final class AppRoutes {
  static const splash = '/';
  static const signIn = '/entrar';
  static const signUp = '/criar-conta';
  static const home = '/inicio';
  static const settings = '/configuracoes';

  // Example screens (lib/features/examples) — delete with the feature.
  static const dashboard = '/inicio/painel';
  static const statement = '/inicio/extrato';
  static String statementItem(String id) => '$statement/$id';
  static const transfer = '/inicio/transferir';
  static const states = '/inicio/estados';
  static const widgets = '/inicio/widgets';
  static const bottomNav = '/inicio/barra-inferior';
  static const modals = '/inicio/modais';
  static const sheets = '/inicio/bottom-sheets';
  static const toasts = '/inicio/toasts';
  static const charts = '/inicio/graficos';
  static const controls = '/inicio/controles';
  static const forms = '/inicio/formularios';

  /// Outside the shell: the confirmation has no bottom navigation.
  static const transferDone = '/transferencia-enviada';

  /// Reachable without a session.
  static const public = {signIn, signUp};
}
