import 'package:flutter/material.dart';
import 'package:flutter_app_template/core/theme/app_colors.dart';
import 'package:flutter_app_template/core/theme/app_theme.dart';
import 'package:flutter_app_template/core/theme/app_tokens.dart';
import 'package:flutter_app_template/core/theme/app_typography.dart';
import 'package:flutter_app_template/core/theme/theme_context.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('palettes', () {
    test('light uses the light design-system values', () {
      final c = AppTheme.light().extension<AppColors>()!;
      expect(c.primary, const Color(0xFF004AC6));
      expect(c.screen, const Color(0xFFF7F9FB));
      expect(c.textPrimary, const Color(0xFF111C2E));
      expect(c.danger, const Color(0xFFC81E1E));
    });

    test('dark uses the dark design-system values', () {
      final c = AppTheme.dark().extension<AppColors>()!;
      expect(c.primary, const Color(0xFF5B92F0));
      expect(c.screen, const Color(0xFF0E1626));
      expect(c.card, const Color(0xFF16213A));
      expect(c.onPrimary, const Color(0xFF08122A));
    });

    test('lerp at 1 reaches the target palette', () {
      expect(
        AppColors.light.lerp(AppColors.dark, 1).screen,
        AppColors.dark.screen,
      );
    });
  });

  group('ThemeData', () {
    test('brightness and scaffold follow the palette', () {
      expect(AppTheme.light().brightness, Brightness.light);
      expect(AppTheme.dark().brightness, Brightness.dark);
      expect(AppTheme.light().scaffoldBackgroundColor, const Color(0xFFF7F9FB));
      expect(AppTheme.dark().colorScheme.primary, const Color(0xFF5B92F0));
    });

    test('dark mode has no shadows', () {
      expect(AppTheme.dark().extension<AppShadows>()!.elev1, isEmpty);
      expect(AppTheme.light().extension<AppShadows>()!.elev1, isNotEmpty);
    });
  });

  test('typography matches the design-system scale', () {
    expect(AppTypography.display.fontSize, 26);
    expect(AppTypography.display.letterSpacing, -0.7);
    expect(AppTypography.display.fontWeight, FontWeight.w700);
    expect(AppTypography.body.fontSize, 13.5);
    expect(AppTypography.overline.letterSpacing, 0.9);
  });

  test('spacing and radius scales', () {
    expect(AppSpacing.xl, 20);
    expect(AppSpacing.x4l, 40);
    expect(AppRadius.md, 12);
    expect(AppRadius.xl, 22);
    expect(AppSizes.buttonLg, 48);
    expect(AppSizes.bottomNav, 64);
    expect(AppSizes.bottomNavContent, 48);
    expect(AppSizes.chip, 32);
  });

  testWidgets('context.colors reads the active palette', (tester) async {
    late Color card;
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.dark(),
        home: Builder(
          builder: (context) {
            card = context.colors.card;
            return const SizedBox();
          },
        ),
      ),
    );
    expect(card, const Color(0xFF16213A));
  });
}
