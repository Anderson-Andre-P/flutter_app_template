import 'package:flutter/material.dart';
import 'package:flutter_app_template/core/constants/strings/common_strings.dart';
import 'package:flutter_app_template/core/widgets/app_filter_bar.dart';
import 'package:flutter_app_template/core/widgets/app_search_field.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/pump_app.dart';

void main() {
  testBothThemes('the search clears with its button', (tester, dark) async {
    final queries = <String>[];
    await pumpApp(
      tester,
      AppSearchField(hint: 'Buscar', onChanged: queries.add),
      dark: dark,
    );
    expect(find.bySemanticsLabel(CommonStrings.clearSearch), findsNothing);
    await tester.enterText(find.byType(TextField), 'bomba');
    await tester.pump();
    await tester.tap(find.bySemanticsLabel(CommonStrings.clearSearch));
    await tester.pump();
    expect(queries, ['bomba', '']);
    expect(find.text('bomba'), findsNothing);
  });

  testBothThemes('filters show how many are on; sort opens', (
    tester,
    dark,
  ) async {
    var filters = 0;
    var sorts = 0;
    await pumpApp(
      tester,
      AppFilterBar(
        searchHint: 'Buscar ordens',
        onSearch: (_) {},
        activeFilters: 2,
        onFilters: () => filters++,
        onSort: () => sorts++,
      ),
      dark: dark,
    );
    expect(find.text('2'), findsOneWidget);
    await tester.tap(find.bySemanticsLabel(CommonStrings.filtersOn(2)));
    await tester.tap(find.bySemanticsLabel(CommonStrings.sort));
    expect(filters, 1);
    expect(sorts, 1);
  });
}
