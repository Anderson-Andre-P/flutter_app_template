import 'package:flutter/material.dart';

import '../../../../core/widgets/app_snackbar.dart';
import '../../../../core/widgets/dialogs/app_dialog.dart';
import '../examples_strings.dart';
import '../widgets/demo_scaffold.dart';

/// The dialog patterns: confirm, destructive confirm and alert.
class ModalsDemoPage extends StatelessWidget {
  const ModalsDemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    Future<void> confirm({required bool destructive}) async {
      final ok = await AppDialog.confirm(
        context,
        title: destructive
            ? ExamplesStrings.modalDestructiveTitle
            : ExamplesStrings.modalConfirmTitle,
        message: destructive
            ? ExamplesStrings.modalDestructiveMessage
            : ExamplesStrings.modalConfirmMessage,
        confirmLabel: destructive
            ? ExamplesStrings.modalDestructiveLabel
            : ExamplesStrings.modalConfirmLabel,
        destructive: destructive,
        icon: destructive ? Icons.delete_outline : null,
      );
      if (!context.mounted) return;
      AppSnackbar.info(
        context,
        ok ? ExamplesStrings.modalConfirmed : ExamplesStrings.modalCancelled,
      );
    }

    return DemoScaffold(
      title: ExamplesStrings.modalsTitle,
      children: [
        DemoTrigger(
          title: ExamplesStrings.modalConfirm,
          hint: ExamplesStrings.modalConfirmHint,
          onTap: () => confirm(destructive: false),
        ),
        DemoTrigger(
          title: ExamplesStrings.modalDestructive,
          hint: ExamplesStrings.modalDestructiveHint,
          onTap: () => confirm(destructive: true),
        ),
        DemoTrigger(
          title: ExamplesStrings.modalAlert,
          hint: ExamplesStrings.modalAlertHint,
          onTap: () => AppDialog.alert(
            context,
            title: ExamplesStrings.modalAlertTitle,
            message: ExamplesStrings.modalAlertMessage,
          ),
        ),
      ],
    );
  }
}
