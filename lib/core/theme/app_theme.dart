import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'foodbook_colors.dart';
import 'foodbook_spacing.dart';
import 'foodbook_text_styles.dart';

/// Tema oficial de FoodBook 2.0.
///
/// Diseño visual:
///   • Modo oscuro por defecto (azul marino + celeste + blanco).
///   • Modo claro disponible (para usuarios que prefieran fondo blanco).
///   • Tipografía del sistema para mantener el bundle ligero.
///
/// El tema se aplica desde `main.dart` mediante `theme:` y `darkTheme:`
/// con `themeMode` controlado por el ajuste del usuario.
class AppTheme {
  AppTheme._();

  // ════════════════════════════════════════════════════════════
  // DARK THEME — IDENTIDAD OFICIAL
  // ════════════════════════════════════════════════════════════

  static ThemeData get dark {
    const colorScheme = ColorScheme(
      brightness: Brightness.dark,
      primary: FoodBookColors.sky,
      onPrimary: FoodBookColors.navyDeep,
      primaryContainer: FoodBookColors.navyVariant,
      onPrimaryContainer: FoodBookColors.textHigh,
      secondary: FoodBookColors.skyLight,
      onSecondary: FoodBookColors.navyDeep,
      secondaryContainer: FoodBookColors.navyElevated,
      onSecondaryContainer: FoodBookColors.textHigh,
      tertiary: FoodBookColors.cyanBright,
      onTertiary: FoodBookColors.navyDeep,
      tertiaryContainer: FoodBookColors.navyElevated,
      onTertiaryContainer: FoodBookColors.textHigh,
      error: FoodBookColors.danger,
      onError: FoodBookColors.navyDeep,
      errorContainer: Color(0xFF7F1D1D),
      onErrorContainer: FoodBookColors.textHigh,
      surface: FoodBookColors.navySurface,
      onSurface: FoodBookColors.textHigh,
      surfaceContainerHighest: FoodBookColors.navyVariant,
      surfaceContainerHigh: Color(0xFF15386F),
      surfaceContainer: FoodBookColors.navySurface,
      surfaceContainerLow: Color(0xFF0C264A),
      surfaceContainerLowest: FoodBookColors.navyDeep,
      onSurfaceVariant: FoodBookColors.textMedium,
      outline: FoodBookColors.outline,
      outlineVariant: FoodBookColors.outlineSoft,
      inverseSurface: FoodBookColors.textHigh,
      onInverseSurface: FoodBookColors.navyDeep,
      inversePrimary: FoodBookColors.navyVariant,
      shadow: Colors.black,
      scrim: Colors.black,
      surfaceTint: FoodBookColors.sky,
    );

    return _baseTheme(colorScheme);
  }

  // ════════════════════════════════════════════════════════════
  // LIGHT THEME — OPCIONAL
  // ════════════════════════════════════════════════════════════

  static ThemeData get light {
    const colorScheme = ColorScheme(
      brightness: Brightness.light,
      primary: FoodBookColors.skyMuted,
      onPrimary: Colors.white,
      primaryContainer: Color(0xFFE0F2FE),
      onPrimaryContainer: FoodBookColors.navyDeep,
      secondary: FoodBookColors.navyVariant,
      onSecondary: Colors.white,
      secondaryContainer: FoodBookColors.surfaceVariantLight,
      onSecondaryContainer: FoodBookColors.textOnLight,
      tertiary: FoodBookColors.cyanBright,
      onTertiary: Colors.white,
      tertiaryContainer: Color(0xFFCFFAFE),
      onTertiaryContainer: FoodBookColors.navyDeep,
      error: Color(0xFFDC2626),
      onError: Colors.white,
      errorContainer: Color(0xFFFEE2E2),
      onErrorContainer: Color(0xFF7F1D1D),
      surface: Colors.white,
      onSurface: FoodBookColors.textOnLight,
      surfaceContainerHighest: FoodBookColors.surfaceVariantLight,
      surfaceContainerHigh: Color(0xFFF1F5F9),
      surfaceContainer: Colors.white,
      surfaceContainerLow: FoodBookColors.backgroundLight,
      surfaceContainerLowest: Colors.white,
      onSurfaceVariant: FoodBookColors.textMediumOnLight,
      outline: Color(0xFFCBD5E1),
      outlineVariant: Color(0xFFE2E8F0),
      inverseSurface: FoodBookColors.navyDeep,
      onInverseSurface: FoodBookColors.textHigh,
      inversePrimary: FoodBookColors.sky,
      shadow: Color(0x33000000),
      scrim: Color(0x66000000),
      surfaceTint: FoodBookColors.skyMuted,
    );

    return _baseTheme(colorScheme);
  }

  // ════════════════════════════════════════════════════════════
  // BASE COMPARTIDA
  // ════════════════════════════════════════════════════════════

  static ThemeData _baseTheme(ColorScheme colorScheme) {
    final isDark = colorScheme.brightness == Brightness.dark;
    final scaffoldBg = isDark
        ? FoodBookColors.navyDeep
        : FoodBookColors.backgroundLight;

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      brightness: colorScheme.brightness,
      scaffoldBackgroundColor: scaffoldBg,
      canvasColor: colorScheme.surface,
      splashColor: colorScheme.primary.withValues(alpha: 0.12),
      highlightColor: colorScheme.primary.withValues(alpha: 0.06),

      // ── Tipografía ──
      textTheme: TextTheme(
        displayLarge: FoodBookTextStyles.display.copyWith(
          color: colorScheme.onSurface,
        ),
        displayMedium: FoodBookTextStyles.displaySmall.copyWith(
          color: colorScheme.onSurface,
        ),
        displaySmall: FoodBookTextStyles.displaySmall.copyWith(
          color: colorScheme.onSurface,
        ),
        headlineLarge: FoodBookTextStyles.headline.copyWith(
          color: colorScheme.onSurface,
        ),
        headlineMedium: FoodBookTextStyles.headline.copyWith(
          color: colorScheme.onSurface,
        ),
        headlineSmall: FoodBookTextStyles.headlineSmall.copyWith(
          color: colorScheme.onSurface,
        ),
        titleLarge: FoodBookTextStyles.title.copyWith(
          color: colorScheme.onSurface,
        ),
        titleMedium: FoodBookTextStyles.titleSmall.copyWith(
          color: colorScheme.onSurface,
        ),
        titleSmall: FoodBookTextStyles.titleSmall.copyWith(
          color: colorScheme.onSurface,
          fontSize: 14,
        ),
        bodyLarge: FoodBookTextStyles.bodyLarge.copyWith(
          color: colorScheme.onSurface,
        ),
        bodyMedium: FoodBookTextStyles.body.copyWith(
          color: colorScheme.onSurface,
        ),
        bodySmall: FoodBookTextStyles.caption.copyWith(
          color: colorScheme.onSurfaceVariant,
        ),
        labelLarge: FoodBookTextStyles.label.copyWith(
          color: colorScheme.onSurface,
        ),
        labelMedium: FoodBookTextStyles.labelSmall.copyWith(
          color: colorScheme.onSurfaceVariant,
        ),
        labelSmall: FoodBookTextStyles.overline.copyWith(
          color: colorScheme.onSurfaceVariant,
        ),
      ),

      // ── AppBar ──
      appBarTheme: AppBarTheme(
        backgroundColor: scaffoldBg,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        systemOverlayStyle: isDark
            ? SystemUiOverlayStyle.light.copyWith(
                statusBarColor: Colors.transparent,
                systemNavigationBarColor: FoodBookColors.navyDeep,
              )
            : SystemUiOverlayStyle.dark.copyWith(
                statusBarColor: Colors.transparent,
                systemNavigationBarColor: Colors.white,
              ),
        titleTextStyle: FoodBookTextStyles.titleSmall.copyWith(
          color: colorScheme.onSurface,
        ),
      ),

      // ── Cards ──
      cardTheme: CardThemeData(
        color: colorScheme.surface,
        surfaceTintColor: Colors.transparent,
        elevation: FoodBookSpacing.elevationLow,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(FoodBookSpacing.radiusMd),
          side: BorderSide(
            color: colorScheme.outlineVariant,
            width: FoodBookSpacing.borderThin,
          ),
        ),
      ),

      // ── Botones ──
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          minimumSize: const Size(64, 48),
          padding: const EdgeInsets.symmetric(
            horizontal: FoodBookSpacing.lg,
            vertical: FoodBookSpacing.md,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(FoodBookSpacing.radiusMd),
          ),
          textStyle: FoodBookTextStyles.label,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          minimumSize: const Size(64, 48),
          elevation: FoodBookSpacing.elevationLow,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(FoodBookSpacing.radiusMd),
          ),
          textStyle: FoodBookTextStyles.label,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: colorScheme.primary,
          side: BorderSide(color: colorScheme.primary, width: 1.5),
          minimumSize: const Size(64, 48),
          padding: const EdgeInsets.symmetric(
            horizontal: FoodBookSpacing.lg,
            vertical: FoodBookSpacing.md,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(FoodBookSpacing.radiusMd),
          ),
          textStyle: FoodBookTextStyles.label,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: colorScheme.primary,
          textStyle: FoodBookTextStyles.label,
          padding: const EdgeInsets.symmetric(
            horizontal: FoodBookSpacing.md,
            vertical: FoodBookSpacing.sm,
          ),
        ),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          foregroundColor: colorScheme.onSurface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(FoodBookSpacing.radiusMd),
          ),
        ),
      ),

      // ── Input fields ──
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colorScheme.surfaceContainerHigh,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: FoodBookSpacing.lg,
          vertical: FoodBookSpacing.md,
        ),
        labelStyle: FoodBookTextStyles.body.copyWith(
          color: colorScheme.onSurfaceVariant,
        ),
        hintStyle: FoodBookTextStyles.body.copyWith(
          color: colorScheme.onSurfaceVariant,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(FoodBookSpacing.radiusMd),
          borderSide: BorderSide(color: colorScheme.outline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(FoodBookSpacing.radiusMd),
          borderSide: BorderSide(color: colorScheme.outlineVariant),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(FoodBookSpacing.radiusMd),
          borderSide: BorderSide(color: colorScheme.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(FoodBookSpacing.radiusMd),
          borderSide: BorderSide(color: colorScheme.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(FoodBookSpacing.radiusMd),
          borderSide: BorderSide(color: colorScheme.error, width: 2),
        ),
        prefixIconColor: colorScheme.onSurfaceVariant,
        suffixIconColor: colorScheme.onSurfaceVariant,
      ),

      // ── Diálogos ──
      dialogTheme: DialogThemeData(
        backgroundColor: colorScheme.surface,
        surfaceTintColor: Colors.transparent,
        elevation: FoodBookSpacing.elevationHigh,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(FoodBookSpacing.radiusLg),
        ),
        titleTextStyle: FoodBookTextStyles.title.copyWith(
          color: colorScheme.onSurface,
        ),
        contentTextStyle: FoodBookTextStyles.body.copyWith(
          color: colorScheme.onSurface,
        ),
      ),

      // ── Bottom sheets ──
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: colorScheme.surface,
        surfaceTintColor: Colors.transparent,
        elevation: FoodBookSpacing.elevationHigh,
        modalBackgroundColor: colorScheme.surface,
        modalElevation: FoodBookSpacing.elevationHigh,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(FoodBookSpacing.radiusXl),
          ),
        ),
      ),

      // ── Navigation bar ──
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: colorScheme.surface,
        indicatorColor: colorScheme.primary.withValues(alpha: 0.18),
        elevation: FoodBookSpacing.elevationMd,
        height: 72,
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return FoodBookTextStyles.labelSmall.copyWith(
              color: colorScheme.primary,
              fontWeight: FontWeight.w700,
            );
          }
          return FoodBookTextStyles.labelSmall.copyWith(
            color: colorScheme.onSurfaceVariant,
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return IconThemeData(color: colorScheme.primary, size: 26);
          }
          return IconThemeData(
            color: colorScheme.onSurfaceVariant,
            size: 24,
          );
        }),
      ),

      // ── Switches ──
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return colorScheme.primary;
          return colorScheme.onSurfaceVariant;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return colorScheme.primary.withValues(alpha: 0.4);
          }
          return colorScheme.surfaceContainerHighest;
        }),
      ),

      // ── Checkboxes ──
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return colorScheme.primary;
          return Colors.transparent;
        }),
        checkColor: WidgetStateProperty.all(colorScheme.onPrimary),
        side: BorderSide(color: colorScheme.outline, width: 2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(FoodBookSpacing.radiusSm),
        ),
      ),

      // ── Chips ──
      chipTheme: ChipThemeData(
        backgroundColor: colorScheme.surfaceContainerHigh,
        labelStyle: FoodBookTextStyles.labelSmall.copyWith(
          color: colorScheme.onSurface,
        ),
        side: BorderSide(color: colorScheme.outlineVariant),
        padding: const EdgeInsets.symmetric(
          horizontal: FoodBookSpacing.md,
          vertical: FoodBookSpacing.xs,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(FoodBookSpacing.radiusFull),
        ),
      ),

      // ── Divisor ──
      dividerTheme: DividerThemeData(
        color: colorScheme.outlineVariant,
        thickness: 1,
        space: 1,
      ),

      // ── SnackBar ──
      snackBarTheme: SnackBarThemeData(
        backgroundColor: colorScheme.inverseSurface,
        contentTextStyle: FoodBookTextStyles.body.copyWith(
          color: colorScheme.onInverseSurface,
        ),
        actionTextColor: colorScheme.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(FoodBookSpacing.radiusMd),
        ),
      ),

      // ── ListTile ──
      listTileTheme: ListTileThemeData(
        iconColor: colorScheme.primary,
        textColor: colorScheme.onSurface,
        titleTextStyle: FoodBookTextStyles.bodyLarge.copyWith(
          color: colorScheme.onSurface,
        ),
        subtitleTextStyle: FoodBookTextStyles.caption.copyWith(
          color: colorScheme.onSurfaceVariant,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: FoodBookSpacing.lg,
          vertical: FoodBookSpacing.xs,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(FoodBookSpacing.radiusMd),
        ),
      ),

      // ── Floating Action Button ──
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        elevation: FoodBookSpacing.elevationMd,
        focusElevation: FoodBookSpacing.elevationHigh,
        hoverElevation: FoodBookSpacing.elevationHigh,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(FoodBookSpacing.radiusLg),
        ),
      ),

      // ── Tab bar ──
      tabBarTheme: TabBarThemeData(
        labelColor: colorScheme.primary,
        unselectedLabelColor: colorScheme.onSurfaceVariant,
        indicatorColor: colorScheme.primary,
        indicatorSize: TabBarIndicatorSize.label,
        labelStyle: FoodBookTextStyles.label,
        unselectedLabelStyle: FoodBookTextStyles.label,
      ),

      // ── Progress indicators ──
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: colorScheme.primary,
        linearTrackColor: colorScheme.surfaceContainerHigh,
        circularTrackColor: colorScheme.surfaceContainerHigh,
      ),
    );
  }
}
