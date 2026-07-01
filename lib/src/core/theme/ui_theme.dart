import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';
import 'package:vvk_ui_kit/src/core/theme/ui_component_themes.dart';
import 'package:vvk_ui_kit/src/core/theme/ui_theme_palettes.dart';

/// Semantic color tokens used to build a [UIAppTheme].
///
/// Host apps can pass a custom implementation to [buildUIKitTheme], or use
/// the built-in [UIThemePalette.light] / [UIThemePalette.dark] presets.
abstract class UIThemeColors {
  /// Background color for [Scaffold].
  Color get scaffold;

  /// General surface color.
  Color get surface;

  /// Background color for [Card] and related components.
  Color get card;

  /// Border color for section dividers.
  Color get sectionBorder;

  /// Primary text color.
  Color get textPrimary;

  /// Secondary text color.
  Color get textSecondary;

  /// Muted text color for less important information.
  Color get textMuted;

  /// Background color for [Chip] components.
  Color get chipBackground;

  /// Border color for [Chip] components.
  Color get chipBorder;

  /// Text/Label color for [Chip] components.
  Color get chipLabel;

  /// Primary accent/brand color.
  Color get accent;

  /// Secondary accent color.
  Color get accentSecondary;
}

/// Default light/dark palettes for [UIAppTheme].
class UIThemePalette implements UIThemeColors {
  /// Creates a [UIThemePalette] with all required colors.
  const UIThemePalette({
    required this.scaffold,
    required this.surface,
    required this.card,
    required this.sectionBorder,
    required this.textPrimary,
    required this.textSecondary,
    required this.textMuted,
    required this.chipBackground,
    required this.chipBorder,
    required this.chipLabel,
    required this.accent,
    required this.accentSecondary,
  });

  @override
  final Color scaffold;
  @override
  final Color surface;
  @override
  final Color card;
  @override
  final Color sectionBorder;
  @override
  final Color textPrimary;
  @override
  final Color textSecondary;
  @override
  final Color textMuted;
  @override
  final Color chipBackground;
  @override
  final Color chipBorder;
  @override
  final Color chipLabel;
  @override
  final Color accent;
  @override
  final Color accentSecondary;

  static const light = UIThemePalette(
    scaffold: Color(0xFFF8FAFC),
    surface: Colors.white,
    card: Colors.white,
    sectionBorder: Color(0xFFE2E8F0),
    textPrimary: Color(0xFF1E293B),
    textSecondary: Color(0xFF475569),
    textMuted: Color(0xFF64748B),
    chipBackground: Color(0xFFF1F5F9),
    chipBorder: Color(0xFFE2E8F0),
    chipLabel: Color(0xFF334155),
    accent: Color(0xFF0D9488),
    accentSecondary: Color(0xFF334155),
  );

  static const dark = UIThemePalette(
    scaffold: Color(0xFF1A1B26),
    surface: Color(0xFF2A2D3E),
    card: Color(0xFF2A2D3E),
    sectionBorder: Colors.white24,
    textPrimary: Colors.white,
    textSecondary: Color(0xFFCBD5E1),
    textMuted: Color(0xFF94A3B8),
    chipBackground: Color(0xFF363A4F),
    chipBorder: Colors.white24,
    chipLabel: Color(0xFFE2E8F0),
    accent: Color(0xFF14B8A6),
    accentSecondary: Color(0xFF38BDF8),
  );
}

/// Kit-specific layout and surface tokens attached to [ThemeData].
class UIThemeExtension extends ThemeExtension<UIThemeExtension> {
  /// Creates a [UIThemeExtension] with kit-specific tokens.
  const UIThemeExtension({
    required this.cardElevation,
    required this.iconBadgeSize,
    required this.chartBackground,
    required this.subtitleColor,
  });

  /// Elevation value for standard cards.
  final double cardElevation;

  /// Standard size for icon badges.
  final double iconBadgeSize;

  /// Background color for chart components.
  final Color chartBackground;

  /// Color for subtitle text elements.
  final Color subtitleColor;

  static const light = UIThemeExtension(
    cardElevation: 1,
    iconBadgeSize: 40,
    chartBackground: Color(0xFFF1F5F9),
    subtitleColor: Color(0xFF64748B),
  );

  static const dark = UIThemeExtension(
    cardElevation: 0,
    iconBadgeSize: 40,
    chartBackground: Color(0xFF252836),
    subtitleColor: Color(0xFF94A3B8),
  );

  @override
  UIThemeExtension copyWith({
    double? cardElevation,
    double? iconBadgeSize,
    Color? chartBackground,
    Color? subtitleColor,
  }) {
    return UIThemeExtension(
      cardElevation: cardElevation ?? this.cardElevation,
      iconBadgeSize: iconBadgeSize ?? this.iconBadgeSize,
      chartBackground: chartBackground ?? this.chartBackground,
      subtitleColor: subtitleColor ?? this.subtitleColor,
    );
  }

  @override
  UIThemeExtension lerp(ThemeExtension<UIThemeExtension>? other, double t) {
    if (other is! UIThemeExtension) return this;
    return UIThemeExtension(
      cardElevation: cardElevation,
      iconBadgeSize: iconBadgeSize,
      chartBackground: Color.lerp(chartBackground, other.chartBackground, t)!,
      subtitleColor: Color.lerp(subtitleColor, other.subtitleColor, t)!,
    );
  }
}

/// Layout metrics attached to the theme.
class UIMetrics extends ThemeExtension<UIMetrics> {
  /// Horizontal padding for screen sections.
  final double sectionHPad;

  /// Creates a [UIMetrics] instance.
  const UIMetrics({this.sectionHPad = 20});

  @override
  UIMetrics copyWith({double? sectionHPad}) =>
      UIMetrics(sectionHPad: sectionHPad ?? this.sectionHPad);

  @override
  UIMetrics lerp(ThemeExtension<UIMetrics>? other, double t) => UIMetrics(
    sectionHPad: lerpDouble(sectionHPad, (other as UIMetrics).sectionHPad, t)!,
  );
}

extension UIThemeContext on BuildContext {
  /// Quick access to [UIThemeExtension] from the current context.
  UIThemeExtension get uiTheme =>
      Theme.of(this).extension<UIThemeExtension>() ?? UIThemeExtension.light;
}

TextTheme _baseTextTheme(
  Brightness brightness,
  UIThemeColors colors, {
  String? fontFamily,
}) {
  final source = brightness == Brightness.dark
      ? ThemeData.dark().textTheme
      : ThemeData.light().textTheme;
  final themed = fontFamily != null && fontFamily.isNotEmpty
      ? source.apply(fontFamily: fontFamily)
      : source;
  return themed.copyWith(
    headlineMedium: themed.headlineMedium?.copyWith(
      fontSize: 32,
      fontWeight: FontWeight.w800,
      letterSpacing: -0.3,
      height: 1.12,
      color: colors.textPrimary,
    ),
    headlineSmall: themed.headlineSmall?.copyWith(
      fontSize: 27,
      fontWeight: FontWeight.w700,
      letterSpacing: -0.2,
      height: 1.15,
      color: colors.textPrimary,
    ),
    titleLarge: themed.titleLarge?.copyWith(
      fontSize: 22,
      fontWeight: FontWeight.w700,
      letterSpacing: -0.15,
      height: 1.2,
      color: colors.textPrimary,
    ),
    titleMedium: themed.titleMedium?.copyWith(
      fontSize: 18,
      fontWeight: FontWeight.w600,
      height: 1.25,
      color: colors.textPrimary,
    ),
    bodyLarge: themed.bodyLarge?.copyWith(
      fontSize: 18,
      fontWeight: FontWeight.w500,
      height: 1.52,
      letterSpacing: 0.05,
      color: colors.textSecondary,
    ),
    bodyMedium: themed.bodyMedium?.copyWith(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      height: 1.5,
      letterSpacing: 0.05,
      color: colors.textSecondary,
    ),
    bodySmall: themed.bodySmall?.copyWith(
      fontSize: 13.5,
      fontWeight: FontWeight.w500,
      height: 1.45,
      letterSpacing: 0.15,
      color: colors.textMuted,
    ),
    labelLarge: themed.labelLarge?.copyWith(
      fontSize: 14,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.45,
      color: colors.textPrimary,
    ),
  );
}

ColorScheme _colorScheme(Brightness brightness, UIThemeColors colors) {
  final isDark = brightness == Brightness.dark;
  return isDark
      ? ColorScheme.dark(
          primary: colors.accent,
          onPrimary: colors.textPrimary,
          secondary: colors.accentSecondary,
          onSecondary: Colors.white,
          surface: colors.surface,
          onSurface: colors.textSecondary,
          surfaceContainerHighest: colors.chipBackground,
        )
      : ColorScheme.light(
          primary: colors.accent,
          onPrimary: Colors.white,
          secondary: colors.accentSecondary,
          onSecondary: Colors.white,
          surface: colors.surface,
          onSurface: colors.textPrimary,
          surfaceContainerHighest: colors.chipBackground,
        );
}

/// Builds a Material 3 theme from semantic color tokens.
///
/// Pass [fontFamily] only when the host app bundles that font.
ThemeData buildUIKitTheme({
  required Brightness brightness,
  required UIThemeColors colors,
  UIThemeExtension extension = UIThemeExtension.light,
  String? fontFamily,
  UIMetrics metrics = const UIMetrics(sectionHPad: 20),
}) {
  final isDark = brightness == Brightness.dark;
  final scheme = _colorScheme(brightness, colors);
  final textTheme = _baseTextTheme(brightness, colors, fontFamily: fontFamily);

  final base = ThemeData(
    brightness: brightness,
    useMaterial3: true,
    colorScheme: scheme,
    scaffoldBackgroundColor: colors.scaffold,
    cardColor: colors.card,
    dividerColor: colors.sectionBorder,
    textTheme: textTheme,
    appBarTheme: AppBarTheme(
      centerTitle: true,
      backgroundColor: isDark ? colors.surface : colors.card,
      foregroundColor: colors.textPrimary,
      elevation: 0,
      scrolledUnderElevation: 0,
      surfaceTintColor: Colors.transparent,
      titleTextStyle: textTheme.titleLarge,
      iconTheme: IconThemeData(color: colors.textPrimary),
    ),
    iconTheme: IconThemeData(color: colors.textPrimary),
    chipTheme: ChipThemeData(
      backgroundColor: colors.chipBackground,
      side: BorderSide(color: colors.chipBorder),
      labelStyle: TextStyle(color: colors.chipLabel, fontSize: 12.5),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
    ),
    popupMenuTheme: PopupMenuThemeData(
      color: colors.card,
      textStyle: TextStyle(color: colors.textPrimary),
    ),
    progressIndicatorTheme: ProgressIndicatorThemeData(color: colors.accent),
    cardTheme: CardThemeData(
      elevation: extension.cardElevation,
      color: colors.card,
      margin: const EdgeInsets.all(4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: scheme.primary,
        foregroundColor: scheme.onPrimary,
        elevation: 1,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(foregroundColor: scheme.primary),
    ),
    tabBarTheme: TabBarThemeData(
      labelColor: scheme.primary,
      unselectedLabelColor: scheme.onSurface.withValues(alpha: 0.55),
      indicatorColor: scheme.primary,
      indicatorSize: TabBarIndicatorSize.label,
    ),
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: scheme.surface,
      modalBackgroundColor: scheme.surface,
      surfaceTintColor: Colors.transparent,
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: scheme.primary,
      foregroundColor: scheme.onPrimary,
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return scheme.primary;
        return isDark ? Colors.grey.shade400 : Colors.white;
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return scheme.primary.withValues(alpha: 0.45);
        }
        return isDark ? Colors.white24 : Colors.black12;
      }),
    ),
    listTileTheme: ListTileThemeData(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    ),
    extensions: [
      extension,
      metrics,
      UIInputTheme.standard,
      UIButtonTheme.standard,
      UIBadgeTheme.standard,
      UIAlertTheme.standard,
      UICardTheme.standard,
      UINavigationTheme.standard,
      UIGlassMetrics.standard,
    ],
  );

  return base;
}

/// Ready-to-use light and dark themes for host applications.
class UIAppTheme {
  UIAppTheme._();

  static ThemeData get light => buildUIKitTheme(
    brightness: Brightness.light,
    colors: UIThemePalette.light,
    extension: UIThemeExtension.light,
  );

  static ThemeData get dark => buildUIKitTheme(
    brightness: Brightness.dark,
    colors: UIThemePalette.dark,
    extension: UIThemeExtension.dark,
  );

  /// Creates a theme with custom colors while keeping kit component styling.
  static ThemeData custom({
    required Brightness brightness,
    required UIThemeColors colors,
    UIThemeExtension? extension,
    String? fontFamily,
    UIMetrics metrics = const UIMetrics(sectionHPad: 20),
  }) {
    final isDark = brightness == Brightness.dark;
    return buildUIKitTheme(
      brightness: brightness,
      colors: colors,
      extension:
          extension ??
          (isDark ? UIThemeExtension.dark : UIThemeExtension.light),
      fontFamily: fontFamily,
      metrics: metrics,
    );
  }

  /// Zinc light/dark themes.
  static ThemeData zinc(Brightness brightness) => custom(
    brightness: brightness,
    colors: brightness == Brightness.dark
        ? UIThemePalettes.zincDark
        : UIThemePalettes.zincLight,
  );

  /// Slate light/dark themes.
  static ThemeData slate(Brightness brightness) => custom(
    brightness: brightness,
    colors: brightness == Brightness.dark
        ? UIThemePalettes.slateDark
        : UIThemePalettes.slateLight,
  );

  /// Stone light/dark themes.
  static ThemeData stone(Brightness brightness) => custom(
    brightness: brightness,
    colors: brightness == Brightness.dark
        ? UIThemePalettes.stoneDark
        : UIThemePalettes.stoneLight,
  );
}
