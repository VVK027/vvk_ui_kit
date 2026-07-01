import 'package:flutter/material.dart';
import 'ui_theme.dart';

/// Named color presets beyond the default teal palette.
abstract final class UIThemePalettes {
  /// Default kit palette (teal accent).
  static const tealLight = UIThemePalette.light;
  static const tealDark = UIThemePalette.dark;

  /// Neutral zinc palette (shadcn-inspired).
  static const zincLight = UIThemePalette(
    scaffold: Color(0xFFFAFAFA),
    surface: Color(0xFFFFFFFF),
    card: Color(0xFFFFFFFF),
    sectionBorder: Color(0xFFE4E4E7),
    textPrimary: Color(0xFF09090B),
    textSecondary: Color(0xFF3F3F46),
    textMuted: Color(0xFF71717A),
    chipBackground: Color(0xFFF4F4F5),
    chipBorder: Color(0xFFE4E4E7),
    chipLabel: Color(0xFF18181B),
    accent: Color(0xFF18181B),
    accentSecondary: Color(0xFF52525B),
  );

  static const zincDark = UIThemePalette(
    scaffold: Color(0xFF09090B),
    surface: Color(0xFF18181B),
    card: Color(0xFF18181B),
    sectionBorder: Color(0xFF27272A),
    textPrimary: Color(0xFFFAFAFA),
    textSecondary: Color(0xFFE4E4E7),
    textMuted: Color(0xFFA1A1AA),
    chipBackground: Color(0xFF27272A),
    chipBorder: Color(0xFF3F3F46),
    chipLabel: Color(0xFFFAFAFA),
    accent: Color(0xFFFAFAFA),
    accentSecondary: Color(0xFFA1A1AA),
  );

  /// Cool slate palette.
  static const slateLight = UIThemePalette(
    scaffold: Color(0xFFF8FAFC),
    surface: Color(0xFFFFFFFF),
    card: Color(0xFFFFFFFF),
    sectionBorder: Color(0xFFE2E8F0),
    textPrimary: Color(0xFF0F172A),
    textSecondary: Color(0xFF334155),
    textMuted: Color(0xFF64748B),
    chipBackground: Color(0xFFF1F5F9),
    chipBorder: Color(0xFFE2E8F0),
    chipLabel: Color(0xFF1E293B),
    accent: Color(0xFF0F172A),
    accentSecondary: Color(0xFF475569),
  );

  static const slateDark = UIThemePalette(
    scaffold: Color(0xFF020617),
    surface: Color(0xFF0F172A),
    card: Color(0xFF0F172A),
    sectionBorder: Color(0xFF1E293B),
    textPrimary: Color(0xFFF8FAFC),
    textSecondary: Color(0xFFCBD5E1),
    textMuted: Color(0xFF94A3B8),
    chipBackground: Color(0xFF1E293B),
    chipBorder: Color(0xFF334155),
    chipLabel: Color(0xFFF1F5F9),
    accent: Color(0xFFF8FAFC),
    accentSecondary: Color(0xFF94A3B8),
  );

  /// Warm stone palette.
  static const stoneLight = UIThemePalette(
    scaffold: Color(0xFFFAFAF9),
    surface: Color(0xFFFFFFFF),
    card: Color(0xFFFFFFFF),
    sectionBorder: Color(0xFFE7E5E4),
    textPrimary: Color(0xFF1C1917),
    textSecondary: Color(0xFF44403C),
    textMuted: Color(0xFF78716C),
    chipBackground: Color(0xFFF5F5F4),
    chipBorder: Color(0xFFE7E5E4),
    chipLabel: Color(0xFF292524),
    accent: Color(0xFF292524),
    accentSecondary: Color(0xFF57534E),
  );

  static const stoneDark = UIThemePalette(
    scaffold: Color(0xFF0C0A09),
    surface: Color(0xFF1C1917),
    card: Color(0xFF1C1917),
    sectionBorder: Color(0xFF292524),
    textPrimary: Color(0xFFFAFAF9),
    textSecondary: Color(0xFFE7E5E4),
    textMuted: Color(0xFFA8A29E),
    chipBackground: Color(0xFF292524),
    chipBorder: Color(0xFF44403C),
    chipLabel: Color(0xFFFAFAF9),
    accent: Color(0xFFFAFAF9),
    accentSecondary: Color(0xFFA8A29E),
  );
}
