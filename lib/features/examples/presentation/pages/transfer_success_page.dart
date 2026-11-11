import 'package:flutter/material.dart';

import '../../../../core/theme/app_tokens.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/theme_context.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_icon_box.dart';
import '../../../../core/widgets/app_info_card.dart';
import '../../../../core/widgets/app_snackbar.dart';
import '../../domain/entities/transfer.dart';
import '../examples_strings.dart';

/// Example confirmation: success icon, summary, receipt and the way out.
/// Has no back button — the flow is over, [onHome] leaves it.
class TransferSuccessPage extends StatelessWidget {
  const TransferSuccessPage({
    super.key,
    required this.receipt,
    required this.onHome,
  });

  final TransferReceipt receipt;
  final VoidCallback onHome;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: EdgeInsets.fromLTRB(
                  AppSpacing.xl,
                  AppSpacing.x4l,
                  AppSpacing.xl,
                  AppSpacing.x2l,
                ),
                children: [
                  Center(
                    child: AppIconBox(
                      icon: Icons.check,
                      tone: AppTone.success,
                      size: AppSizes.heroIcon,
                      circle: true,
                    ),
                  ),
                  SizedBox(height: AppSpacing.x2l),
                  Text(
                    ExamplesStrings.successTitle,
                    textAlign: TextAlign.center,
                    style: AppTypography.title.copyWith(color: c.textPrimary),
                  ),
                  SizedBox(height: AppSpacing.sm),
                  Text(
                    ExamplesStrings.successSubtitle(
                      formatCents(receipt.amountCents),
                      receipt.recipient,
                    ),
                    textAlign: TextAlign.center,
                    style: AppTypography.body.copyWith(color: c.textSecondary),
                  ),
                  SizedBox(height: AppSpacing.x3l),
                  AppInfoCard(
                    title: ExamplesStrings.receiptTitle,
                    rows: [
                      (
                        ExamplesStrings.rowDate,
                        formatDateTime(receipt.issuedAt),
                      ),
                      (ExamplesStrings.rowRecipient, receipt.recipient),
                      (ExamplesStrings.rowProtocol, receipt.protocol),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(
                AppSpacing.xl,
                0,
                AppSpacing.xl,
                AppSpacing.lg,
              ),
              child: Column(
                children: [
                  AppButton(label: ExamplesStrings.backHome, onPressed: onHome),
                  SizedBox(height: AppSpacing.md),
                  AppButton(
                    label: ExamplesStrings.shareReceipt,
                    variant: AppButtonVariant.secondary,
                    onPressed: () =>
                        AppSnackbar.info(context, ExamplesStrings.comingSoon),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
