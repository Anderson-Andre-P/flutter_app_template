import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_tokens.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/theme_context.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_chip.dart';
import '../../../../core/widgets/app_info_card.dart';
import '../../../../core/widgets/app_snackbar.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/app_top_bar.dart';
import '../../application/transfer_bloc.dart';
import '../../application/view_status.dart';
import '../../domain/entities/transfer.dart';
import '../examples_strings.dart';

/// Example form: amount presets, two fields, a live summary and the primary
/// action pinned to the bottom.
class TransferPage extends StatelessWidget {
  const TransferPage({super.key, required this.onSent});

  final ValueChanged<TransferReceipt> onSent;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final bloc = context.read<TransferBloc>();
    return BlocListener<TransferBloc, TransferState>(
      listenWhen: (a, b) => a.status != b.status,
      listener: (context, state) {
        if (state.status == ViewStatus.ready && state.receipt != null) {
          onSent(state.receipt!);
        } else if (state.status == ViewStatus.failure) {
          AppSnackbar.error(context, state.errorMessage ?? '');
        }
      },
      child: Scaffold(
        appBar: const AppTopBar(
          title: ExamplesStrings.transferTitle,
          showBack: true,
        ),
        body: BlocBuilder<TransferBloc, TransferState>(
          builder: (context, state) => ListView(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.xl,
              AppSpacing.lg,
              AppSpacing.xl,
              AppSpacing.x3l,
            ),
            children: [
              Text(
                ExamplesStrings.amountLabel,
                textAlign: TextAlign.center,
                style: AppTypography.body.copyWith(color: c.textSecondary),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                formatCents(state.amountCents),
                textAlign: TextAlign.center,
                style: AppTypography.display.copyWith(color: c.textPrimary),
              ),
              const SizedBox(height: AppSpacing.lg),
              Wrap(
                alignment: WrapAlignment.center,
                spacing: AppSpacing.sm,
                runSpacing: AppSpacing.sm,
                children: [
                  for (final cents in ExamplesStrings.amountPresets)
                    AppChip(
                      label: formatCents(cents, showCents: false),
                      selected: state.amountCents == cents,
                      onSelected: (_) =>
                          bloc.add(TransferAmountSelected(cents)),
                    ),
                ],
              ),
              if (state.amountError != null) ...[
                const SizedBox(height: AppSpacing.sm),
                Text(
                  state.amountError!,
                  textAlign: TextAlign.center,
                  style: AppTypography.caption.copyWith(color: c.danger),
                ),
              ],
              const SizedBox(height: AppSpacing.x2l),
              AppTextField(
                label: ExamplesStrings.recipientLabel,
                hint: ExamplesStrings.recipientHint,
                required: true,
                errorText: state.recipientError,
                textInputAction: TextInputAction.next,
                onChanged: (v) => bloc.add(TransferRecipientChanged(v)),
              ),
              const SizedBox(height: AppSpacing.lg),
              AppTextField(
                label: ExamplesStrings.descriptionLabel,
                hint: ExamplesStrings.descriptionHint,
                textInputAction: TextInputAction.done,
                onChanged: (v) => bloc.add(TransferDescriptionChanged(v)),
              ),
              const SizedBox(height: AppSpacing.x2l),
              AppInfoCard(
                title: ExamplesStrings.summaryTitle,
                emphasizeLast: true,
                rows: [
                  (ExamplesStrings.rowAmount, formatCents(state.amountCents)),
                  (ExamplesStrings.rowFee, formatCents(0)),
                  (ExamplesStrings.rowTotal, formatCents(state.amountCents)),
                ],
              ),
            ],
          ),
        ),
        bottomNavigationBar: SafeArea(
          // Room below for the primary button's elevation shadow.
          minimum: const EdgeInsets.fromLTRB(
            AppSpacing.xl,
            AppSpacing.sm,
            AppSpacing.xl,
            AppSpacing.x2l,
          ),
          child: BlocSelector<TransferBloc, TransferState, bool>(
            selector: (s) => s.status == ViewStatus.loading,
            builder: (context, loading) => AppButton(
              label: ExamplesStrings.transferContinue,
              loading: loading,
              onPressed: () => bloc.add(const TransferSubmitted()),
            ),
          ),
        ),
      ),
    );
  }
}
