/// Runtime configuration read from `--dart-define` (or
/// `--dart-define-from-file=.env.json`). The template has no flavors: every
/// value is optional and has a safe default.
final class EnvConfig {
  const EnvConfig({required this.apiBaseUrl, required this.sentryDsn});

  factory EnvConfig.fromEnvironment() => const EnvConfig(
    apiBaseUrl: String.fromEnvironment(
      'API_BASE_URL',
      defaultValue: 'https://api.example.com',
    ),
    sentryDsn: String.fromEnvironment('SENTRY_DSN'),
  );

  /// Base URL every `ApiClient` request is resolved against.
  final String apiBaseUrl;

  /// Sentry DSN; empty disables monitoring.
  final String sentryDsn;

  bool get hasSentry => sentryDsn.isNotEmpty;
}
