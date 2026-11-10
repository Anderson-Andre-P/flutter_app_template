import 'package:sentry_flutter/sentry_flutter.dart';

import '../config/env_config.dart';

/// Wraps app start-up with crash reporting when a Sentry DSN is configured.
abstract final class Monitoring {
  /// Runs [appRunner] inside Sentry when [config] has a DSN; otherwise runs it
  /// directly, so a fresh clone works with no account.
  static Future<void> run(
    EnvConfig config,
    Future<void> Function() appRunner,
  ) async {
    if (!config.hasSentry) {
      await appRunner();
      return;
    }
    await SentryFlutter.init(
      (options) => options.dsn = config.sentryDsn,
      appRunner: appRunner,
    );
  }
}
