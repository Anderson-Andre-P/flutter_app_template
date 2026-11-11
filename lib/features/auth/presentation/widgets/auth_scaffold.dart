import 'package:flutter/material.dart';

import '../../../../core/theme/app_tokens.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/theme_context.dart';

/// Shared layout of the public auth screens: title, subtitle, a scrollable
/// form and a footer.
class AuthScaffold extends StatelessWidget {
  const AuthScaffold({
    super.key,
    required this.title,
    required this.subtitle,
    required this.children,
    this.footer,
  });

  final String title;
  final String subtitle;
  final List<Widget> children;
  final Widget? footer;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(
            AppSpacing.xl,
            AppSpacing.x4l,
            AppSpacing.xl,
            AppSpacing.x2l,
          ),
          child: AutofillGroup(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  title,
                  style: AppTypography.display.copyWith(color: c.textPrimary),
                ),
                SizedBox(height: AppSpacing.sm),
                Text(
                  subtitle,
                  style: AppTypography.body.copyWith(color: c.textSecondary),
                ),
                SizedBox(height: AppSpacing.x3l),
                ...children,
                if (footer != null) ...[
                  SizedBox(height: AppSpacing.x2l),
                  footer!,
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// "Question? Action" line under the form.
class AuthFooterLink extends StatelessWidget {
  const AuthFooterLink({
    super.key,
    required this.question,
    required this.action,
    required this.onTap,
  });

  final String question;
  final String action;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    // Wraps on a narrow phone or with large text instead of overflowing.
    return Wrap(
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Text(question, style: AppTypography.body.copyWith(color: c.textMuted)),
        TextButton(onPressed: onTap, child: Text(action)),
      ],
    );
  }
}
