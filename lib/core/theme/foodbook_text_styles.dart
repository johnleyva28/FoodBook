import 'package:flutter/material.dart';

import 'foodbook_colors.dart';

/// Tipografía base de FoodBook.
///
/// Usamos la familia del sistema (San Francisco / Roboto) para mantener
/// el bundle pequeño y el rendimiento óptimo. Cuando se decida emparejar
/// con una fuente de marca (p. ej. Inter o Manrope), basta con cambiar
/// el `fontFamily` aquí y se propaga a toda la app.
class FoodBookTextStyles {
  FoodBookTextStyles._();

  static const String _family = 'System';

  // ── Display (pantallas hero / splash) ──
  static const TextStyle display = TextStyle(
    fontFamily: _family,
    fontSize: 48,
    height: 1.1,
    fontWeight: FontWeight.w800,
    letterSpacing: -1,
    color: FoodBookColors.textHigh,
  );

  static const TextStyle displaySmall = TextStyle(
    fontFamily: _family,
    fontSize: 36,
    height: 1.15,
    fontWeight: FontWeight.w800,
    letterSpacing: -0.5,
    color: FoodBookColors.textHigh,
  );

  // ── Headline (títulos de sección, números grandes) ──
  static const TextStyle headline = TextStyle(
    fontFamily: _family,
    fontSize: 28,
    height: 1.2,
    fontWeight: FontWeight.w700,
    color: FoodBookColors.textHigh,
  );

  static const TextStyle headlineSmall = TextStyle(
    fontFamily: _family,
    fontSize: 22,
    height: 1.25,
    fontWeight: FontWeight.w700,
    color: FoodBookColors.textHigh,
  );

  // ── Title (títulos de card, diálogos) ──
  static const TextStyle title = TextStyle(
    fontFamily: _family,
    fontSize: 18,
    height: 1.3,
    fontWeight: FontWeight.w600,
    color: FoodBookColors.textHigh,
  );

  static const TextStyle titleSmall = TextStyle(
    fontFamily: _family,
    fontSize: 16,
    height: 1.35,
    fontWeight: FontWeight.w600,
    color: FoodBookColors.textHigh,
  );

  // ── Body ──
  static const TextStyle bodyLarge = TextStyle(
    fontFamily: _family,
    fontSize: 16,
    height: 1.5,
    fontWeight: FontWeight.w400,
    color: FoodBookColors.textHigh,
  );

  static const TextStyle body = TextStyle(
    fontFamily: _family,
    fontSize: 14,
    height: 1.5,
    fontWeight: FontWeight.w400,
    color: FoodBookColors.textHigh,
  );

  // ── Label (botones, chips, switches) ──
  static const TextStyle label = TextStyle(
    fontFamily: _family,
    fontSize: 14,
    height: 1.2,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.3,
    color: FoodBookColors.textHigh,
  );

  static const TextStyle labelSmall = TextStyle(
    fontFamily: _family,
    fontSize: 12,
    height: 1.3,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.4,
    color: FoodBookColors.textMedium,
  );

  // ── Caption (hints, secundarios) ──
  static const TextStyle caption = TextStyle(
    fontFamily: _family,
    fontSize: 12,
    height: 1.4,
    fontWeight: FontWeight.w400,
    color: FoodBookColors.textMedium,
  );

  static const TextStyle overline = TextStyle(
    fontFamily: _family,
    fontSize: 11,
    height: 1.4,
    fontWeight: FontWeight.w600,
    letterSpacing: 1.5,
    color: FoodBookColors.textLow,
  );

  // ── Money (números monetarios grandes) ──
  static const TextStyle moneyHero = TextStyle(
    fontFamily: _family,
    fontSize: 40,
    height: 1.1,
    fontWeight: FontWeight.w800,
    letterSpacing: -0.5,
    color: FoodBookColors.textHigh,
  );

  static const TextStyle money = TextStyle(
    fontFamily: _family,
    fontSize: 18,
    fontWeight: FontWeight.w700,
    color: FoodBookColors.textHigh,
  );
}
