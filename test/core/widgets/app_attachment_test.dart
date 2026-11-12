import 'package:material_ui/material_ui.dart';
import 'package:flutter_app_template/core/constants/strings/common_strings.dart';
import 'package:flutter_app_template/core/theme/app_colors.dart';
import 'package:flutter_app_template/core/widgets/app_attachment.dart';
import 'package:flutter_app_template/core/widgets/app_progress_bar.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/pump_app.dart';

void main() {
  testBothThemes('a sent file shows its type and opens', (tester, dark) async {
    var opened = 0;
    await pumpApp(
      tester,
      AppAttachmentTile(
        name: 'Relatorio_agosto.pdf',
        detail: '1,8 MB · enviado hoje',
        status: AppAttachmentStatus.sent,
        onOpen: () => opened++,
      ),
      dark: dark,
    );
    expect(find.text('PDF'), findsOneWidget);
    await tester.tap(find.bySemanticsLabel(CommonStrings.openFile));
    expect(opened, 1);
  });

  testWidgets('an upload shows its progress and can be cancelled', (
    tester,
  ) async {
    var cancelled = 0;
    await pumpApp(
      tester,
      AppAttachmentTile(
        name: 'Anexo_referencia.jpg',
        detail: 'Enviando · 72%',
        status: AppAttachmentStatus.uploading,
        progress: .72,
        onCancel: () => cancelled++,
      ),
    );
    expect(find.text('JPG'), findsOneWidget);
    expect(find.byType(AppProgressBar), findsOneWidget);
    await tester.tap(find.bySemanticsLabel(CommonStrings.cancelUpload));
    expect(cancelled, 1);
  });

  testWidgets('waiting for a connection says so', (tester) async {
    final handle = tester.ensureSemantics();
    await pumpApp(
      tester,
      const AppAttachmentTile(
        name: 'Dados_semana34.xlsx',
        detail: '420 KB · aguardando sync',
        status: AppAttachmentStatus.waiting,
      ),
    );
    expect(find.text('XLS'), findsOneWidget);
    expect(
      find.bySemanticsLabel(CommonStrings.waitingConnection),
      findsOneWidget,
    );
    handle.dispose();
  });

  testWidgets('a failed upload offers Remover', (tester) async {
    var removed = 0;
    await pumpApp(
      tester,
      AppAttachmentTile(
        name: 'foto.png',
        detail: 'Falha no envio',
        status: AppAttachmentStatus.failed,
        onRemove: () => removed++,
      ),
    );
    await tester.tap(find.text(CommonStrings.removeFile));
    expect(removed, 1);
  });

  testBothThemes('the upload button explains the accepted files', (
    tester,
    dark,
  ) async {
    var picks = 0;
    await pumpApp(
      tester,
      AppUploadButton(
        label: 'Enviar documento',
        hint: 'PDF, PNG ou XLSX até 25 MB',
        onPressed: () => picks++,
      ),
      dark: dark,
    );
    expect(find.text('PDF, PNG ou XLSX até 25 MB'), findsOneWidget);
    await tester.tap(find.text('Enviar documento'));
    expect(picks, 1);
  });

  testBothThemes('the photo grid removes a photo and captures another', (
    tester,
    dark,
  ) async {
    final removed = <int>[];
    var captures = 0;
    await pumpApp(
      tester,
      SizedBox(
        width: 360.w,
        child: AppPhotoGrid(
          photos: const [null, null],
          onRemove: removed.add,
          onCapture: () => captures++,
        ),
      ),
      dark: dark,
    );
    await tester.tap(find.bySemanticsLabel(CommonStrings.removePhoto(1)));
    await tester.tap(find.text(CommonStrings.capture));
    expect(removed, [0]);
    expect(captures, 1);
  });

  testBothThemes('the status tints the tile and a sent file can download', (
    tester,
    dark,
  ) async {
    final c = dark ? AppColors.dark : AppColors.light;
    var downloads = 0;
    await pumpApp(
      tester,
      Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppAttachmentTile(
            name: 'Manual.pdf',
            detail: '4,2 MB',
            status: AppAttachmentStatus.sent,
            onOpen: () {},
            onDownload: () => downloads++,
          ),
          const AppAttachmentTile(
            name: 'foto.jpg',
            detail: 'Enviando',
            status: AppAttachmentStatus.uploading,
          ),
        ],
      ),
      dark: dark,
    );
    await tester.tap(find.bySemanticsLabel(CommonStrings.download));
    expect(downloads, 1);
    final uploading = tester.widget<Container>(
      find.byKey(const ValueKey('attachment-foto.jpg')),
    );
    expect((uploading.decoration! as BoxDecoration).color, c.primarySubtle);
  });
}
