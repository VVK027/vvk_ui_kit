import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';
import 'package:vvk_ui_kit/src/widgets/glass/ui_glass_surface.dart'
    show UIGlassSurface;

/// Default blur, opacity, and radius values for glass widgets.
abstract final class UIGlassConstants {
  static const double defaultBlur = 10;
  static const double defaultTintOpacity = 0.12;
  static const double defaultBorderRadius = 12;
  static const double minBlur = 0;
  static const double maxBlur = 30;
}

/// Shared visual tokens for [UIGlassSurface] and other glass widgets.
class UIGlassTheme {
  const UIGlassTheme({
    this.blur = UIGlassConstants.defaultBlur,
    this.tintOpacity = UIGlassConstants.defaultTintOpacity,
    this.borderRadius = UIGlassConstants.defaultBorderRadius,
    this.tintColor,
    this.borderColor,
    this.borderWidth = 1,
    this.gradient,
    this.boxShadow,
    this.foregroundColor,
  });

  final double blur;
  final double tintOpacity;
  final double borderRadius;
  final Color? tintColor;
  final Color? borderColor;
  final double borderWidth;
  final Gradient? gradient;
  final List<BoxShadow>? boxShadow;
  final Color? foregroundColor;

  factory UIGlassTheme.fromTheme(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final tint = scheme.surface;

    return UIGlassTheme(
      tintColor: tint,
      borderColor: scheme.outline.withValues(alpha: 0.2),
      foregroundColor: scheme.onSurface,
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          tint.withValues(alpha: isDark ? 0.24 : 0.18),
          tint.withValues(alpha: isDark ? 0.12 : 0.08),
        ],
      ),
    );
  }

  UIGlassTheme copyWith({
    double? blur,
    double? tintOpacity,
    double? borderRadius,
    Color? tintColor,
    Color? borderColor,
    double? borderWidth,
    Gradient? gradient,
    List<BoxShadow>? boxShadow,
    Color? foregroundColor,
  }) {
    return UIGlassTheme(
      blur: blur ?? this.blur,
      tintOpacity: tintOpacity ?? this.tintOpacity,
      borderRadius: borderRadius ?? this.borderRadius,
      tintColor: tintColor ?? this.tintColor,
      borderColor: borderColor ?? this.borderColor,
      borderWidth: borderWidth ?? this.borderWidth,
      gradient: gradient ?? this.gradient,
      boxShadow: boxShadow ?? this.boxShadow,
      foregroundColor: foregroundColor ?? this.foregroundColor,
    );
  }

  static UIGlassTheme lerp(UIGlassTheme? a, UIGlassTheme? b, double t) {
    if (a == null && b == null) return const UIGlassTheme();
    if (a == null) return b!;
    if (b == null) return a;
    return UIGlassTheme(
      blur: lerpDouble(a.blur, b.blur, t)!,
      tintOpacity: lerpDouble(a.tintOpacity, b.tintOpacity, t)!,
      borderRadius: lerpDouble(a.borderRadius, b.borderRadius, t)!,
      tintColor: Color.lerp(a.tintColor, b.tintColor, t),
      borderColor: Color.lerp(a.borderColor, b.borderColor, t),
      borderWidth: lerpDouble(a.borderWidth, b.borderWidth, t)!,
      gradient: Gradient.lerp(a.gradient, b.gradient, t),
      foregroundColor: Color.lerp(a.foregroundColor, b.foregroundColor, t),
      boxShadow: t < 0.5 ? a.boxShadow : b.boxShadow,
    );
  }
}
