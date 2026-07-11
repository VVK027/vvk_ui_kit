import 'package:flutter/material.dart';

/// Extended color tokens carried on [ThemeData] as a [ThemeExtension].
///
/// Material's [ColorScheme] intentionally exposes a small, semantic palette.
/// Apps often need additional slots (gradients, a dedicated app-bar color,
/// selected/unselected states, status colors) plus arbitrary named colors.
/// [UIThemeTokens] provides typed slots for the common cases and an [extra]
/// map for anything else, so apps can drop bespoke color-bundle plumbing while
/// keeping the kit's component theming.
///
/// ```dart
/// final theme = ThemeData.light().withThemeTokens(
///   const UIThemeTokens(
///     appBarBackground: Color(0xFF4671C6),
///     gradient: [Color(0xFF4671C6), Color(0xFF3762CC)],
///     selected: Color(0xFF3762CC),
///     unselected: Color(0xFFA4C9FF),
///     extra: {'headerBlue': Color(0xFF4671C6)},
///   ),
/// );
///
/// // Read anywhere:
/// final tokens = Theme.of(context).themeTokens;
/// final blue = tokens?.color('headerBlue');
/// ```
@immutable
class UIThemeTokens extends ThemeExtension<UIThemeTokens> {
  const UIThemeTokens({
    this.appBarBackground,
    this.gradient,
    this.selected,
    this.unselected,
    this.accent,
    this.success,
    this.warning,
    this.danger,
    this.info,
    this.surfaceMuted,
    this.textPrimary,
    this.textSecondary,
    this.extra = const {},
  });

  /// Background used for app bars / headers when it differs from the scheme.
  final Color? appBarBackground;

  /// Ordered gradient stops (2+ colors).
  final List<Color>? gradient;

  /// Color for selected/active states (tabs, chips, toggles).
  final Color? selected;

  /// Color for unselected/inactive states.
  final Color? unselected;

  /// Secondary accent color.
  final Color? accent;

  final Color? success;
  final Color? warning;
  final Color? danger;
  final Color? info;

  /// Muted surface for subtle backgrounds.
  final Color? surfaceMuted;

  /// Primary body text color.
  final Color? textPrimary;

  /// Secondary/subtle text color.
  final Color? textSecondary;

  /// Arbitrary named colors keyed by a stable string id.
  final Map<String, Color> extra;

  /// Returns the [extra] color named [key], or `null` if absent.
  Color? color(String key) => extra[key];

  @override
  UIThemeTokens copyWith({
    Color? appBarBackground,
    List<Color>? gradient,
    Color? selected,
    Color? unselected,
    Color? accent,
    Color? success,
    Color? warning,
    Color? danger,
    Color? info,
    Color? surfaceMuted,
    Color? textPrimary,
    Color? textSecondary,
    Map<String, Color>? extra,
  }) {
    return UIThemeTokens(
      appBarBackground: appBarBackground ?? this.appBarBackground,
      gradient: gradient ?? this.gradient,
      selected: selected ?? this.selected,
      unselected: unselected ?? this.unselected,
      accent: accent ?? this.accent,
      success: success ?? this.success,
      warning: warning ?? this.warning,
      danger: danger ?? this.danger,
      info: info ?? this.info,
      surfaceMuted: surfaceMuted ?? this.surfaceMuted,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      extra: extra ?? this.extra,
    );
  }

  @override
  UIThemeTokens lerp(ThemeExtension<UIThemeTokens>? other, double t) {
    if (other is! UIThemeTokens) return this;
    return UIThemeTokens(
      appBarBackground: Color.lerp(appBarBackground, other.appBarBackground, t),
      gradient: _lerpGradient(gradient, other.gradient, t),
      selected: Color.lerp(selected, other.selected, t),
      unselected: Color.lerp(unselected, other.unselected, t),
      accent: Color.lerp(accent, other.accent, t),
      success: Color.lerp(success, other.success, t),
      warning: Color.lerp(warning, other.warning, t),
      danger: Color.lerp(danger, other.danger, t),
      info: Color.lerp(info, other.info, t),
      surfaceMuted: Color.lerp(surfaceMuted, other.surfaceMuted, t),
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t),
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t),
      extra: t < 0.5 ? extra : other.extra,
    );
  }

  static List<Color>? _lerpGradient(List<Color>? a, List<Color>? b, double t) {
    if (a == null || b == null || a.length != b.length) {
      return t < 0.5 ? a : b;
    }
    return [
      for (var i = 0; i < a.length; i++) Color.lerp(a[i], b[i], t) ?? a[i],
    ];
  }
}

/// Convenience access to [UIThemeTokens] from [ThemeData].
extension UIThemeTokensThemeX on ThemeData {
  /// The registered [UIThemeTokens], or `null` when none was attached.
  UIThemeTokens? get themeTokens => extension<UIThemeTokens>();

  /// Returns a copy of this theme with [tokens] attached (replacing any
  /// existing [UIThemeTokens]).
  ThemeData withThemeTokens(UIThemeTokens tokens) {
    final others = extensions.values.where((e) => e is! UIThemeTokens);
    return copyWith(extensions: [...others, tokens]);
  }
}
