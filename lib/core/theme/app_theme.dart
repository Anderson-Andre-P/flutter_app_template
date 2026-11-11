import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_tokens.dart';
import 'app_typography.dart';

/// Builds the Material [ThemeData] for each mode from the design-system
/// tokens, so stock Material widgets already follow the system. Light and
/// dark differ only in colours (and shadows, which dark mode drops).
abstract final class AppTheme {
  static ThemeData light() =>
      _build(AppColors.light, AppShadows.light, Brightness.light);

  static ThemeData dark() =>
      _build(AppColors.dark, AppShadows.dark, Brightness.dark);

  static ThemeData _build(AppColors c, AppShadows s, Brightness brightness) {
    final scheme = ColorScheme(
      brightness: brightness,
      primary: c.primary,
      onPrimary: c.onPrimary,
      primaryContainer: c.primarySubtle,
      onPrimaryContainer: c.primary,
      secondary: c.primary,
      onSecondary: c.onPrimary,
      error: c.danger,
      onError: c.onPrimary,
      errorContainer: c.dangerSubtle,
      onErrorContainer: c.danger,
      surface: c.card,
      onSurface: c.textPrimary,
      onSurfaceVariant: c.textSecondary,
      surfaceContainerLowest: c.sunken,
      surfaceContainer: c.field,
      surfaceContainerHighest: c.raised,
      outline: c.borderStrong,
      outlineVariant: c.border,
      scrim: c.scrim,
    );

    final textTheme = TextTheme(
      displaySmall: AppTypography.display,
      headlineMedium: AppTypography.title,
      headlineSmall: AppTypography.heading,
      titleMedium: AppTypography.section,
      bodyLarge: AppTypography.body,
      bodyMedium: AppTypography.body,
      bodySmall: AppTypography.bodySmall,
      labelLarge: AppTypography.label,
      labelMedium: AppTypography.labelMedium,
      labelSmall: AppTypography.caption,
    ).apply(bodyColor: c.textPrimary, displayColor: c.textPrimary);

    OutlineInputBorder border(Color color, double width) => OutlineInputBorder(
      borderRadius: AppRadius.brMd,
      borderSide: BorderSide(color: color, width: width),
    );

    final buttonShape = WidgetStatePropertyAll<OutlinedBorder>(
      RoundedRectangleBorder(borderRadius: AppRadius.brMd),
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      fontFamily: AppTypography.fontFamily,
      colorScheme: scheme,
      textTheme: textTheme,
      scaffoldBackgroundColor: c.screen,
      canvasColor: c.screen,
      dividerTheme: DividerThemeData(
        color: c.border,
        thickness: AppSizes.hairline,
        space: AppSizes.hairline,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: c.screen,
        foregroundColor: c.textPrimary,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: AppTypography.heading.copyWith(color: c.textPrimary),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: c.field,
        hintStyle: AppTypography.body.copyWith(color: c.textMuted),
        contentPadding: EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.md,
        ),
        border: border(c.borderStrong, 1),
        enabledBorder: border(c.borderStrong, 1),
        focusedBorder: border(c.focus, AppSizes.focusRing),
        errorBorder: border(c.danger, AppSizes.errorBorder),
        focusedErrorBorder: border(c.danger, AppSizes.errorBorder),
        disabledBorder: border(c.border, 1),
        errorStyle: AppTypography.caption.copyWith(color: c.danger),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: ButtonStyle(
          shape: buttonShape,
          textStyle: WidgetStatePropertyAll(AppTypography.label),
          minimumSize: WidgetStatePropertyAll(
            Size(AppSizes.minTouchTarget, AppSizes.buttonMd),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: ButtonStyle(
          shape: buttonShape,
          textStyle: WidgetStatePropertyAll(AppTypography.label),
          side: WidgetStatePropertyAll(BorderSide(color: c.borderStrong)),
          foregroundColor: WidgetStatePropertyAll(c.textPrimary),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
          shape: buttonShape,
          textStyle: WidgetStatePropertyAll(AppTypography.label),
          foregroundColor: WidgetStatePropertyAll(c.link),
        ),
      ),
      cardTheme: CardThemeData(
        color: c.card,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.brLg,
          side: BorderSide(color: c.border),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: c.raised,
        surfaceTintColor: Colors.transparent,
        barrierColor: c.scrim,
        shape: RoundedRectangleBorder(borderRadius: AppRadius.brXl),
        titleTextStyle: AppTypography.section.copyWith(color: c.textPrimary),
        contentTextStyle: AppTypography.body.copyWith(color: c.textSecondary),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: c.raised,
        surfaceTintColor: Colors.transparent,
        modalBarrierColor: c.scrim,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppRadius.xl),
          ),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        elevation: 0,
        backgroundColor: c.raised,
        contentTextStyle: AppTypography.body.copyWith(color: c.textPrimary),
        shape: RoundedRectangleBorder(borderRadius: AppRadius.brMd),
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: c.primary,
        linearTrackColor: c.sunken,
      ),
      extensions: [c, s],
    );
  }
}
