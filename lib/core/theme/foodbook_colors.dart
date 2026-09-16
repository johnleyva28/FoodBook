import 'package:flutter/material.dart';

/// Paleta de colores oficial de FoodBook.
///
/// Identidad visual:
///   • Fondo azul marino profundo `#0B1E3F` (marca, seriedad).
///   • Acento celeste `#38BDF8` (modernidad, confianza).
///   • Texto blanco `#F8FAFC` (contraste alto, legibilidad).
///
/// Todos los colores cumplen contraste WCAG AA sobre el fondo principal.
class FoodBookColors {
  FoodBookColors._();

  // ── Marca ───────────────────────────────────────────────
  /// Azul marino profundo — fondo principal.
  static const Color navyDeep = Color(0xFF0B1E3F);

  /// Azul marino medio — superficies (cards, sheets).
  static const Color navySurface = Color(0xFF0F2A5C);

  /// Azul corporativo — variantes de superficie y hover.
  static const Color navyVariant = Color(0xFF1A3D80);

  /// Azul elevado — para FAB, raised buttons, focus rings.
  static const Color navyElevated = Color(0xFF234B9A);

  // ── Acentos ─────────────────────────────────────────────
  /// Celeste sky — color primario (CTA, switches activos).
  static const Color sky = Color(0xFF38BDF8);

  /// Celeste claro — color secundario (highlights, badges).
  static const Color skyLight = Color(0xFF7DD3FC);

  /// Cyan brillante — accentos sutiles y success.
  static const Color cyanBright = Color(0xFF22D3EE);

  /// Celeste apagado — disabled / hover sobre celeste.
  static const Color skyMuted = Color(0xFF0EA5E9);

  // ── Semánticos ──────────────────────────────────────────
  /// Verde agua — confirmación, "al día".
  static const Color success = Color(0xFF34D399);

  /// Ámbar — advertencia, casi llegando al límite.
  static const Color warning = Color(0xFFFBBF24);

  /// Rojo coral — error, deuda.
  static const Color danger = Color(0xFFF87171);

  /// Rosa suave — info destacado.
  static const Color info = Color(0xFFA5B4FC);

  // ── Texto ───────────────────────────────────────────────
  /// Blanco puro — texto de alto contraste sobre navy.
  static const Color textHigh = Color(0xFFF8FAFC);

  /// Gris claro — texto secundario.
  static const Color textMedium = Color(0xFFCBD5E1);

  /// Gris medio — texto deshabilitado / hints.
  static const Color textLow = Color(0xFF94A3B8);

  /// Gris muy oscuro — disabled.
  static const Color textDisabled = Color(0xFF64748B);

  // ── Bordes y separadores ────────────────────────────────
  static const Color outline = Color(0xFF334155);
  static const Color outlineSoft = Color(0xFF1E3A5F);

  // ── Fondos auxiliares ───────────────────────────────────
  /// Fondo de scaffold (azul marino profundo).
  static const Color background = navyDeep;

  /// Fondo de scaffold light (alternativa).
  static const Color backgroundLight = Color(0xFFF1F5F9);

  /// Surface light para tema claro.
  static const Color surfaceLight = Colors.white;

  /// Surface light variant para tema claro.
  static const Color surfaceVariantLight = Color(0xFFE2E8F0);

  /// Texto sobre tema claro.
  static const Color textOnLight = Color(0xFF0F172A);

  /// Texto medio sobre tema claro.
  static const Color textMediumOnLight = Color(0xFF475569);

  // ── Gradientes predefinidos ─────────────────────────────
  /// Gradiente principal para hero cards (deuda, gasto del día).
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [navyVariant, sky],
  );

  /// Gradiente inverso (cards de éxito / positivo).
  static const LinearGradient successGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [navySurface, Color(0xFF0E7490)],
  );

  /// Gradiente sutil para headers.
  static const LinearGradient headerGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [navyDeep, navySurface],
  );
}
