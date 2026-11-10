import 'package:flutter/material.dart';

import '../../../../core/widgets/app_state_views.dart';

/// Shown while the stored session is read; the router leaves it as soon as
/// the session status is known.
class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) => const Scaffold(body: AppLoadingView());
}
