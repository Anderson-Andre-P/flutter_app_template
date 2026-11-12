import 'package:material_ui/material_ui.dart';
import 'package:flutter_app_template/core/theme/app_tokens.dart';
import 'package:flutter_app_template/core/widgets/app_countdown_ring.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/pump_app.dart';

void main() {
  testBothThemes('shows the label, time and caption at every size', (
    tester,
    dark,
  ) async {
    for (final size in [
      AppSizes.countdownLg,
      AppSizes.countdownMd,
      AppSizes.countdownSm,
    ]) {
      await pumpApp(
        tester,
        AppCountdownRing(
          value: .8,
          time: '1:12',
          label: 'Descanso',
          caption: 'de 1:30',
          icon: Icons.water_drop_outlined,
          size: size,
        ),
        dark: dark,
      );
      expect(find.text('DESCANSO'), findsOneWidget);
      expect(find.text('1:12'), findsOneWidget);
      expect(find.text('de 1:30'), findsOneWidget);
      expect(tester.getSize(find.byType(AppCountdownRing)), Size.square(size));
      expect(tester.takeException(), isNull);
    }
  });

  testWidgets('leaves the icon out at the compact size', (tester) async {
    await pumpApp(
      tester,
      AppCountdownRing(
        value: .5,
        time: '0:45',
        icon: Icons.water_drop_outlined,
        size: AppSizes.countdownSm,
      ),
    );
    expect(find.byIcon(Icons.water_drop_outlined), findsNothing);
  });

  testWidgets('reads the label with the time and caption', (tester) async {
    final handle = tester.ensureSemantics();
    await pumpApp(
      tester,
      const AppCountdownRing(
        value: .8,
        time: '1:12',
        label: 'Descanso',
        caption: 'de 1:30',
      ),
    );
    expect(
      tester.getSemantics(find.byType(AppCountdownRing)),
      isSemantics(label: 'Descanso', value: '1:12 de 1:30'),
    );
    handle.dispose();
  });
}
