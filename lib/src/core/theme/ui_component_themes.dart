import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';

/// Input decoration tokens for kit form fields.
class UIInputTheme extends ThemeExtension<UIInputTheme> {
  const UIInputTheme({
    this.borderRadius = 12,
    this.borderWidth = 1,
    this.focusedBorderWidth = 1.5,
    this.contentPadding = const EdgeInsets.symmetric(
      horizontal: 14,
      vertical: 12,
    ),
  });

  final double borderRadius;
  final double borderWidth;
  final double focusedBorderWidth;
  final EdgeInsetsGeometry contentPadding;

  static const standard = UIInputTheme();

  @override
  UIInputTheme copyWith({
    double? borderRadius,
    double? borderWidth,
    double? focusedBorderWidth,
    EdgeInsetsGeometry? contentPadding,
  }) {
    return UIInputTheme(
      borderRadius: borderRadius ?? this.borderRadius,
      borderWidth: borderWidth ?? this.borderWidth,
      focusedBorderWidth: focusedBorderWidth ?? this.focusedBorderWidth,
      contentPadding: contentPadding ?? this.contentPadding,
    );
  }

  @override
  UIInputTheme lerp(ThemeExtension<UIInputTheme>? other, double t) {
    if (other is! UIInputTheme) return this;
    return UIInputTheme(
      borderRadius: lerpDouble(borderRadius, other.borderRadius, t)!,
      borderWidth: lerpDouble(borderWidth, other.borderWidth, t)!,
      focusedBorderWidth: lerpDouble(
        focusedBorderWidth,
        other.focusedBorderWidth,
        t,
      )!,
    );
  }
}

/// Button sizing tokens for kit buttons.
///
/// Centralizes the per-variant heights and corner radii used by
/// `UIStyledButtonStyle` so host apps can restyle every button by overriding a
/// single theme extension instead of editing hardcoded values. Also exported
/// under the alias [UIButtonMetrics].
class UIButtonTheme extends ThemeExtension<UIButtonTheme> {
  const UIButtonTheme({
    this.borderRadius = 12,
    this.height = 48,
    this.horizontalPadding = 20,
    this.primaryHeight = 61,
    this.primaryRadius = 5,
    this.outlinedHeight = 61,
    this.outlinedRadius = 5,
    this.elevatedHeight = 56,
    this.elevatedRadius = 8,
    this.textHeight = 44,
    this.textRadius = 8,
  });

  final double borderRadius;
  final double height;
  final double horizontalPadding;

  /// Height for `UIStyledButtonStyle.primary`.
  final double primaryHeight;

  /// Corner radius for `UIStyledButtonStyle.primary`.
  final double primaryRadius;

  /// Height for `UIStyledButtonStyle.outlined`.
  final double outlinedHeight;

  /// Corner radius for `UIStyledButtonStyle.outlined`.
  final double outlinedRadius;

  /// Height for `UIStyledButtonStyle.elevated`.
  final double elevatedHeight;

  /// Corner radius for `UIStyledButtonStyle.elevated`.
  final double elevatedRadius;

  /// Height for `UIStyledButtonStyle.text`.
  final double textHeight;

  /// Corner radius for `UIStyledButtonStyle.text`.
  final double textRadius;

  static const standard = UIButtonTheme();

  @override
  UIButtonTheme copyWith({
    double? borderRadius,
    double? height,
    double? horizontalPadding,
    double? primaryHeight,
    double? primaryRadius,
    double? outlinedHeight,
    double? outlinedRadius,
    double? elevatedHeight,
    double? elevatedRadius,
    double? textHeight,
    double? textRadius,
  }) {
    return UIButtonTheme(
      borderRadius: borderRadius ?? this.borderRadius,
      height: height ?? this.height,
      horizontalPadding: horizontalPadding ?? this.horizontalPadding,
      primaryHeight: primaryHeight ?? this.primaryHeight,
      primaryRadius: primaryRadius ?? this.primaryRadius,
      outlinedHeight: outlinedHeight ?? this.outlinedHeight,
      outlinedRadius: outlinedRadius ?? this.outlinedRadius,
      elevatedHeight: elevatedHeight ?? this.elevatedHeight,
      elevatedRadius: elevatedRadius ?? this.elevatedRadius,
      textHeight: textHeight ?? this.textHeight,
      textRadius: textRadius ?? this.textRadius,
    );
  }

  @override
  UIButtonTheme lerp(ThemeExtension<UIButtonTheme>? other, double t) {
    if (other is! UIButtonTheme) return this;
    return UIButtonTheme(
      borderRadius: lerpDouble(borderRadius, other.borderRadius, t)!,
      height: lerpDouble(height, other.height, t)!,
      horizontalPadding: lerpDouble(
        horizontalPadding,
        other.horizontalPadding,
        t,
      )!,
      primaryHeight: lerpDouble(primaryHeight, other.primaryHeight, t)!,
      primaryRadius: lerpDouble(primaryRadius, other.primaryRadius, t)!,
      outlinedHeight: lerpDouble(outlinedHeight, other.outlinedHeight, t)!,
      outlinedRadius: lerpDouble(outlinedRadius, other.outlinedRadius, t)!,
      elevatedHeight: lerpDouble(elevatedHeight, other.elevatedHeight, t)!,
      elevatedRadius: lerpDouble(elevatedRadius, other.elevatedRadius, t)!,
      textHeight: lerpDouble(textHeight, other.textHeight, t)!,
      textRadius: lerpDouble(textRadius, other.textRadius, t)!,
    );
  }
}

/// Alias for [UIButtonTheme]; the design-token name used across the kit.
typedef UIButtonMetrics = UIButtonTheme;

/// Alias for [UIInputTheme]; the design-token name used across the kit.
typedef UIInputMetrics = UIInputTheme;

/// Performance strategy for frosted-glass widgets.
///
/// [BackdropFilter] is expensive; stacking several glass layers can drop frames
/// on low-end devices. Use [staticTint] to swap the live blur for a cheap solid
/// tint, or [auto] to let the widget decide.
enum UIGlassPerformanceMode {
  /// Use a real-time [BackdropFilter] blur (highest fidelity, highest cost).
  fullBlur,

  /// Skip the blur and paint a solid semi-opaque tint (cheapest).
  staticTint,

  /// Currently behaves like [fullBlur]; reserved for future device-aware logic.
  auto,
}

/// Frosted-glass design tokens shared by all glass widgets.
///
/// Override on the theme to tune blur/opacity globally or to enable a
/// performance fallback for the whole app.
class UIGlassMetrics extends ThemeExtension<UIGlassMetrics> {
  const UIGlassMetrics({
    this.blur = 10,
    this.tintOpacity = 0.12,
    this.borderRadius = 12,
    this.borderWidth = 1,
    this.staticTintOpacity = 0.6,
    this.performanceMode = UIGlassPerformanceMode.auto,
    this.wrapInRepaintBoundary = true,
  });

  /// Default blur sigma for glass surfaces.
  final double blur;

  /// Tint opacity applied over the blur.
  final double tintOpacity;

  /// Default corner radius.
  final double borderRadius;

  /// Default border width.
  final double borderWidth;

  /// Tint opacity used when [performanceMode] falls back to a static tint.
  final double staticTintOpacity;

  /// Global performance strategy for glass widgets.
  final UIGlassPerformanceMode performanceMode;

  /// Whether glass surfaces wrap their blur in a [RepaintBoundary] to isolate
  /// repaints from the rest of the tree.
  final bool wrapInRepaintBoundary;

  /// Whether a live [BackdropFilter] blur should be used.
  bool get usesBlur => performanceMode != UIGlassPerformanceMode.staticTint;

  static const standard = UIGlassMetrics();

  @override
  UIGlassMetrics copyWith({
    double? blur,
    double? tintOpacity,
    double? borderRadius,
    double? borderWidth,
    double? staticTintOpacity,
    UIGlassPerformanceMode? performanceMode,
    bool? wrapInRepaintBoundary,
  }) {
    return UIGlassMetrics(
      blur: blur ?? this.blur,
      tintOpacity: tintOpacity ?? this.tintOpacity,
      borderRadius: borderRadius ?? this.borderRadius,
      borderWidth: borderWidth ?? this.borderWidth,
      staticTintOpacity: staticTintOpacity ?? this.staticTintOpacity,
      performanceMode: performanceMode ?? this.performanceMode,
      wrapInRepaintBoundary:
          wrapInRepaintBoundary ?? this.wrapInRepaintBoundary,
    );
  }

  @override
  UIGlassMetrics lerp(ThemeExtension<UIGlassMetrics>? other, double t) {
    if (other is! UIGlassMetrics) return this;
    return UIGlassMetrics(
      blur: lerpDouble(blur, other.blur, t)!,
      tintOpacity: lerpDouble(tintOpacity, other.tintOpacity, t)!,
      borderRadius: lerpDouble(borderRadius, other.borderRadius, t)!,
      borderWidth: lerpDouble(borderWidth, other.borderWidth, t)!,
      staticTintOpacity: lerpDouble(
        staticTintOpacity,
        other.staticTintOpacity,
        t,
      )!,
      performanceMode: t < 0.5 ? performanceMode : other.performanceMode,
      wrapInRepaintBoundary: t < 0.5
          ? wrapInRepaintBoundary
          : other.wrapInRepaintBoundary,
    );
  }
}

/// Badge styling tokens.
class UIBadgeTheme extends ThemeExtension<UIBadgeTheme> {
  const UIBadgeTheme({
    this.borderRadius = 8,
    this.padding = const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
  });

  final double borderRadius;
  final EdgeInsetsGeometry padding;

  static const standard = UIBadgeTheme();

  @override
  UIBadgeTheme copyWith({double? borderRadius, EdgeInsetsGeometry? padding}) {
    return UIBadgeTheme(
      borderRadius: borderRadius ?? this.borderRadius,
      padding: padding ?? this.padding,
    );
  }

  @override
  UIBadgeTheme lerp(ThemeExtension<UIBadgeTheme>? other, double t) {
    if (other is! UIBadgeTheme) return this;
    return UIBadgeTheme(
      borderRadius: lerpDouble(borderRadius, other.borderRadius, t)!,
    );
  }
}

/// Inline alert styling tokens.
class UIAlertTheme extends ThemeExtension<UIAlertTheme> {
  const UIAlertTheme({
    this.borderRadius = 12,
    this.padding = const EdgeInsets.all(16),
  });

  final double borderRadius;
  final EdgeInsetsGeometry padding;

  static const standard = UIAlertTheme();

  @override
  UIAlertTheme copyWith({double? borderRadius, EdgeInsetsGeometry? padding}) {
    return UIAlertTheme(
      borderRadius: borderRadius ?? this.borderRadius,
      padding: padding ?? this.padding,
    );
  }

  @override
  UIAlertTheme lerp(ThemeExtension<UIAlertTheme>? other, double t) {
    if (other is! UIAlertTheme) return this;
    return UIAlertTheme(
      borderRadius: lerpDouble(borderRadius, other.borderRadius, t)!,
    );
  }
}

/// Card surface tokens.
class UICardTheme extends ThemeExtension<UICardTheme> {
  const UICardTheme({
    this.borderRadius = 12,
    this.elevation = 1,
    this.padding = const EdgeInsets.all(16),
  });

  final double borderRadius;
  final double elevation;
  final EdgeInsetsGeometry padding;

  static const standard = UICardTheme();

  @override
  UICardTheme copyWith({
    double? borderRadius,
    double? elevation,
    EdgeInsetsGeometry? padding,
  }) {
    return UICardTheme(
      borderRadius: borderRadius ?? this.borderRadius,
      elevation: elevation ?? this.elevation,
      padding: padding ?? this.padding,
    );
  }

  @override
  UICardTheme lerp(ThemeExtension<UICardTheme>? other, double t) {
    if (other is! UICardTheme) return this;
    return UICardTheme(
      borderRadius: lerpDouble(borderRadius, other.borderRadius, t)!,
      elevation: lerpDouble(elevation, other.elevation, t)!,
    );
  }
}

/// Navigation component tokens (breadcrumbs, menus).
class UINavigationTheme extends ThemeExtension<UINavigationTheme> {
  const UINavigationTheme({
    this.breadcrumbSpacing = 4,
    this.sheetBorderRadius = 16,
    this.contextMenuBorderRadius = 12,
  });

  final double breadcrumbSpacing;
  final double sheetBorderRadius;
  final double contextMenuBorderRadius;

  static const standard = UINavigationTheme();

  @override
  UINavigationTheme copyWith({
    double? breadcrumbSpacing,
    double? sheetBorderRadius,
    double? contextMenuBorderRadius,
  }) {
    return UINavigationTheme(
      breadcrumbSpacing: breadcrumbSpacing ?? this.breadcrumbSpacing,
      sheetBorderRadius: sheetBorderRadius ?? this.sheetBorderRadius,
      contextMenuBorderRadius:
          contextMenuBorderRadius ?? this.contextMenuBorderRadius,
    );
  }

  @override
  UINavigationTheme lerp(ThemeExtension<UINavigationTheme>? other, double t) {
    if (other is! UINavigationTheme) return this;
    return UINavigationTheme(
      breadcrumbSpacing: lerpDouble(
        breadcrumbSpacing,
        other.breadcrumbSpacing,
        t,
      )!,
      sheetBorderRadius: lerpDouble(
        sheetBorderRadius,
        other.sheetBorderRadius,
        t,
      )!,
      contextMenuBorderRadius: lerpDouble(
        contextMenuBorderRadius,
        other.contextMenuBorderRadius,
        t,
      )!,
    );
  }
}

extension UIComponentThemeContext on BuildContext {
  UIInputTheme get uiInputTheme =>
      Theme.of(this).extension<UIInputTheme>() ?? UIInputTheme.standard;

  UIButtonTheme get uiButtonTheme =>
      Theme.of(this).extension<UIButtonTheme>() ?? UIButtonTheme.standard;

  /// Alias of [uiButtonTheme] using the design-token name.
  UIButtonMetrics get uiButtonMetrics => uiButtonTheme;

  /// Alias of [uiInputTheme] using the design-token name.
  UIInputMetrics get uiInputMetrics => uiInputTheme;

  UIGlassMetrics get uiGlassMetrics =>
      Theme.of(this).extension<UIGlassMetrics>() ?? UIGlassMetrics.standard;

  UIBadgeTheme get uiBadgeTheme =>
      Theme.of(this).extension<UIBadgeTheme>() ?? UIBadgeTheme.standard;

  UIAlertTheme get uiAlertTheme =>
      Theme.of(this).extension<UIAlertTheme>() ?? UIAlertTheme.standard;

  UICardTheme get uiCardTheme =>
      Theme.of(this).extension<UICardTheme>() ?? UICardTheme.standard;

  UINavigationTheme get uiNavigationTheme =>
      Theme.of(this).extension<UINavigationTheme>() ??
      UINavigationTheme.standard;
}
