import 'package:flutter/material.dart';
import 'package:flutter_app_template/core/theme/app_tokens.dart';
import 'package:flutter_app_template/core/widgets/app_skeleton.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/pump_app.dart';

void main() {
  testBothThemes('the shapes repeat the content and the shimmer loops', (
    tester,
    dark,
  ) async {
    await pumpApp(
      tester,
      AppShimmer(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppSkeleton.circle(size: AppSizes.avatarLg),
            AppSkeleton.line(width: 120.w),
            AppSkeleton.block(height: 80.h),
          ],
        ),
      ),
      dark: dark,
    );
    expect(find.byType(AppSkeleton), findsNWidgets(3));
    await tester.pump(AppDurations.shimmer * 2.5);
    expect(tester.takeException(), isNull);
    expect(tester.hasRunningAnimations, isTrue);
  });

  testWidgets('with animations disabled the shimmer stands still', (
    tester,
  ) async {
    await pumpApp(
      tester,
      Builder(
        builder: (context) => MediaQuery(
          data: MediaQuery.of(context).copyWith(disableAnimations: true),
          child: const AppShimmer(child: AppSkeleton.line()),
        ),
      ),
    );
    expect(tester.hasRunningAnimations, isFalse);
  });

  testWidgets('is announced as loading', (tester) async {
    final handle = tester.ensureSemantics();
    await pumpApp(tester, const AppShimmer(child: AppSkeleton.line()));
    expect(find.bySemanticsLabel(AppShimmer.loadingLabel), findsOneWidget);
    handle.dispose();
  });
}
