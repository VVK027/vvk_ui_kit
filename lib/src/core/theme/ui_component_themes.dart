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
class UIButtonTheme extends ThemeExtension<UIButtonTheme> {
  const UIButtonTheme({
    this.borderRadius = 12,
    this.height = 48,
    this.horizontalPadding = 20,
  });

  final double borderRadius;
  final double height;
  final double horizontalPadding;

  static const standard = UIButtonTheme();

  @override
  UIButtonTheme copyWith({
    double? borderRadius,
    double? height,
    double? horizontalPadding,
  }) {
    return UIButtonTheme(
      borderRadius: borderRadius ?? this.borderRadius,
      height: height ?? this.height,
      horizontalPadding: horizontalPadding ?? this.horizontalPadding,
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
