import 'dart:ui';

import 'package:flutter/material.dart';
import '../../core/theme/ui_component_themes.dart';
import 'ui_glass_theme.dart';

/// Frosted-glass surface using [BackdropFilter] (no extra dependencies).
///
/// Unset visual values fall back to the ambient [UIGlassMetrics] theme
/// extension, so blur, opacity, radius, the performance strategy, and repaint
/// isolation can all be tuned globally. See [UIGlassPerformanceMode] for the
/// blur-vs-static-tint trade-off on low-end devices.
class UIGlassSurface extends StatelessWidget {
  const UIGlassSurface({
    super.key,
    required this.child,
    this.theme,
    this.blur,
    this.tintColor,
    this.tintOpacity,
    this.borderRadius,
    this.borderRadiusGeometry,
    this.borderColor,
    this.borderWidth,
    this.gradient,
    this.boxShadow,
    this.margin,
    this.padding,
    this.width,
    this.height,
    this.performanceMode,
    this.wrapInRepaintBoundary,
  });

  final Widget child;
  final UIGlassTheme? theme;
  final double? blur;
  final Color? tintColor;
  final double? tintOpacity;
  final double? borderRadius;
  final BorderRadiusGeometry? borderRadiusGeometry;
  final Color? borderColor;
  final double? borderWidth;
  final Gradient? gradient;
  final List<BoxShadow>? boxShadow;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final double? width;
  final double? height;

  /// Overrides the ambient [UIGlassMetrics.performanceMode] for this surface.
  final UIGlassPerformanceMode? performanceMode;

  /// Overrides the ambient [UIGlassMetrics.wrapInRepaintBoundary].
  final bool? wrapInRepaintBoundary;

  UIGlassTheme _resolve(BuildContext context, UIGlassMetrics metrics) {
    final base = theme ?? UIGlassTheme.fromTheme(context);
    return base.copyWith(
      blur: blur ?? metrics.blur,
      tintOpacity: tintOpacity ?? metrics.tintOpacity,
      borderRadius: borderRadius ?? metrics.borderRadius,
      tintColor: tintColor ?? base.tintColor,
      borderColor: borderColor ?? base.borderColor,
      borderWidth: borderWidth ?? metrics.borderWidth,
      gradient: gradient ?? base.gradient,
      boxShadow: boxShadow ?? base.boxShadow,
    );
  }

  @override
  Widget build(BuildContext context) {
    final metrics = context.uiGlassMetrics;
    final style = _resolve(context, metrics);
    final mode = performanceMode ?? metrics.performanceMode;
    final useBlur = mode != UIGlassPerformanceMode.staticTint;

    final tint = style.tintColor ?? Theme.of(context).colorScheme.surface;
    final border =
        style.borderColor ??
        Theme.of(context).colorScheme.outline.withValues(alpha: 0.2);
    final radius =
        borderRadiusGeometry ?? BorderRadius.circular(style.borderRadius);

    // When the live blur is disabled, gradients would still read as glassy but
    // remain cheap; a solid tint is used only when no gradient is supplied.
    final decoration = BoxDecoration(
      color: style.gradient == null
          ? tint.withValues(
              alpha: useBlur ? style.tintOpacity : metrics.staticTintOpacity,
            )
          : null,
      gradient: style.gradient,
      borderRadius: radius,
      border: Border.all(color: border, width: style.borderWidth),
    );

    final inner = Container(
      width: width,
      height: height,
      padding: padding,
      decoration: decoration,
      child: child,
    );

    Widget surface;
    if (useBlur) {
      final sigma = style.blur.clamp(
        UIGlassConstants.minBlur,
        UIGlassConstants.maxBlur,
      );
      surface = ClipRRect(
        borderRadius: radius,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: sigma, sigmaY: sigma),
          child: inner,
        ),
      );
    } else {
      surface = ClipRRect(borderRadius: radius, child: inner);
    }

    if ((wrapInRepaintBoundary ?? metrics.wrapInRepaintBoundary) && useBlur) {
      surface = RepaintBoundary(child: surface);
    }

    if (style.boxShadow != null) {
      surface = DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: radius,
          boxShadow: style.boxShadow,
        ),
        child: surface,
      );
    }

    if (margin != null) {
      surface = Padding(padding: margin!, child: surface);
    }

    return surface;
  }
}
