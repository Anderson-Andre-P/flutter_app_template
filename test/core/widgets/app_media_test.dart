import 'dart:async';

import 'package:material_ui/material_ui.dart';
import 'package:flutter_app_template/core/constants/strings/common_strings.dart';
import 'package:flutter_app_template/core/widgets/app_drag_handle.dart';
import 'package:flutter_app_template/core/widgets/app_media_placeholder.dart';
import 'package:flutter_app_template/core/widgets/app_viewer.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/pump_app.dart';

void main() {
  testBothThemes('a media placeholder shows its kind', (tester, dark) async {
    await pumpApp(
      tester,
      SizedBox(
        width: 120.w,
        height: 80.h,
        child: const AppMediaPlaceholder(
          kind: AppMediaKind.diagram,
          label: 'diagrama',
        ),
      ),
      dark: dark,
    );
    expect(find.text('diagrama'), findsOneWidget);
    expect(find.byIcon(Icons.schema_outlined), findsOneWidget);
  });

  testWidgets('the drag handle reads its purpose', (tester) async {
    final handle = tester.ensureSemantics();
    await pumpApp(tester, const AppDragHandle());
    expect(find.bySemanticsLabel(CommonStrings.dragToReorder), findsOneWidget);
    handle.dispose();
  });

  testBothThemes('the viewer swipes pages, counts them and closes', (
    tester,
    dark,
  ) async {
    late BuildContext ctx;
    await pumpApp(
      tester,
      Builder(
        builder: (c) {
          ctx = c;
          return const SizedBox();
        },
      ),
      dark: dark,
    );
    unawaited(
      AppViewer.open(
        ctx,
        title: 'Visualizador',
        pages: const [Text('A'), Text('B'), Text('C')],
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text(CommonStrings.pageOf(1, 3)), findsOneWidget);
    await tester.fling(find.text('A'), const Offset(-600, 0), 1500);
    await tester.pumpAndSettle();
    expect(find.text(CommonStrings.pageOf(2, 3)), findsOneWidget);
    await tester.tap(find.byTooltip(CommonStrings.close));
    await tester.pumpAndSettle();
    expect(find.text('B'), findsNothing);
  });
}
