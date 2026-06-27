import 'package:flutter/cupertino.dart';

abstract final class AppColors {
  // ── Accent ────────────────────────────────────────────────────────────────
  /// PDFlex signature coral-red — used for CTAs, active tab icons, branding
  static const accentRed = CupertinoDynamicColor.withBrightness(
    color: Color(0xFFFF3344), // slightly more vibrant
    darkColor: Color(0xFFFF4D5E),
  );

  static const accentBlue = CupertinoDynamicColor.withBrightness(
    color: Color(0xFF007AFF),
    darkColor: Color(0xFF0A84FF),
  );

  static const accentGreen = CupertinoDynamicColor.withBrightness(
    color: Color(0xFF34C759),
    darkColor: Color(0xFF30D158),
  );

  static const accentOrange = CupertinoDynamicColor.withBrightness(
    color: Color(0xFFFF9500),
    darkColor: Color(0xFFFF9F0A),
  );

  // ── Backgrounds ───────────────────────────────────────────────────────────
  static const backgroundPrimary = CupertinoDynamicColor.withBrightness(
    color: Color(0xFFF2F2F7),
    darkColor: Color(0xFF09090B), // deep OLED-friendly black
  );

  /// Aliases kept for backward-compat with existing screens
  static const surfacePrimary = backgroundPrimary;

  static const surfaceCard = CupertinoDynamicColor.withBrightness(
    color: Color(0xFFFFFFFF),
    darkColor: Color(0xFF18181A),
  );

  /// Alias for existing code that references surfaceSecondary
  static const surfaceSecondary = surfaceCard;

  static const surfaceInput = CupertinoDynamicColor.withBrightness(
    color: Color(0xFFF2F2F7),
    darkColor: Color(0xFF27272A),
  );

  static const surfaceTertiary = surfaceInput;

  static const tabBarBackground = CupertinoDynamicColor.withBrightness(
    color: Color(0xFFFFFFFF),
    darkColor: Color(0xFF09090B),
  );

  // ── Labels ────────────────────────────────────────────────────────────────
  static const labelPrimary = CupertinoDynamicColor.withBrightness(
    color: Color(0xFF1C1C1E),
    darkColor: Color(0xFFFFFFFF),
  );

  static const labelSecondary = CupertinoDynamicColor.withBrightness(
    color: Color(0xFF6C6C70),
    darkColor: Color(0xFF98989D),
  );

  static const labelTertiary = CupertinoDynamicColor.withBrightness(
    color: Color(0xFFAEAEB2),
    darkColor: Color(0xFF636366),
  );

  static const labelQuaternary = CupertinoDynamicColor.withBrightness(
    color: Color(0xFFD1D1D6),
    darkColor: Color(0xFF48484A),
  );

  static const labelOnAccent = CupertinoDynamicColor.withBrightness(
    color: Color(0xFFFFFFFF),
    darkColor: Color(0xFFFFFFFF),
  );

  // ── Separators & Borders ──────────────────────────────────────────────────
  static const separator = CupertinoDynamicColor.withBrightness(
    color: Color(0xFFE5E5EA),
    darkColor: Color(0xFF38383A),
  );

  static const separatorOpaque = separator;

  static const cardBorder = CupertinoDynamicColor.withBrightness(
    color: Color(0x1A000000),
    darkColor: Color(0x1AFFFFFF),
  );

  // ── Fills ─────────────────────────────────────────────────────────────────
  static const fillPrimary = CupertinoDynamicColor.withBrightness(
    color: Color(0x33787880),
    darkColor: Color(0x3D787880),
  );

  static const fillSecondary = CupertinoDynamicColor.withBrightness(
    color: Color(0x28787880),
    darkColor: Color(0x29787880),
  );

  static const fillTertiary = CupertinoDynamicColor.withBrightness(
    color: Color(0x1E767680),
    darkColor: Color(0x3D767680),
  );

  static const fillQuaternary = CupertinoDynamicColor.withBrightness(
    color: Color(0x14747480),
    darkColor: Color(0x2E747480),
  );

  // ── Glass bar tokens ──────────────────────────────────────────────────────
  /// Translucent background for backdrop-blurred nav bars and bottom bars.
  static const glassBarBackground = CupertinoDynamicColor.withBrightness(
    color: Color(0xD9FFFFFF),
    darkColor: Color(0xCC09090B),
  );

  // ── Legacy glass tokens (kept for backward-compat during migration) ────────
  static const glassBackground = CupertinoDynamicColor.withBrightness(
    color: Color(0xBBFFFFFF),
    darkColor: Color(0x882C2C2E),
  );

  static const glassBackgroundThick = CupertinoDynamicColor.withBrightness(
    color: Color(0xD9FFFFFF),
    darkColor: Color(0xCC2C2C2E),
  );

  static const glassBorder = cardBorder;

  // ── Semantic ──────────────────────────────────────────────────────────────
  static const destructive = CupertinoDynamicColor.withBrightness(
    color: Color(0xFFFF3B30),
    darkColor: Color(0xFFFF453A),
  );
}
