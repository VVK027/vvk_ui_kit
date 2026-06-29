import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:vvk_ui_kit/src/widgets/glass/ui_glass_theme.dart';

/// Frosted-glass surface using [BackdropFilter] (no extra dependencies).
class UIGlassSurface extends StatelessWidget {
  const UIGlassSurface({
    super.key,
    required this.child,
    this.theme,
    this.blur = UIGlassConstants.defaultBlur,
    this.tintColor,
    this.tintOpacity = UIGlassConstants.defaultTintOpacity,
    this.borderRadius = UIGlassConstants.defaultBorderRadius,
    this.borderRadiusGeometry,
    this.borderColor,
    this.borderWidth = 1,
    this.gradient,
    this.boxShadow,
    this.margin,
    this.padding,
    this.width,
    this.height,
  });

  final Widget child;
  final UIGlassTheme? theme;
  final double blur;
  final Color? tintColor;
  final double tintOpacity;
  final double borderRadius;
  final BorderRadiusGeometry? borderRadiusGeometry;
  final Color? borderColor;
  final double borderWidth;
  final Gradient? gradient;
  final List<BoxShadow>? boxShadow;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final double? width;
  final double? height;

  UIGlassTheme _resolve(BuildContext context) {
    final base = theme ?? UIGlassTheme.fromTheme(context);
    return base.copyWith(
      blur: blur,
      tintOpacity: tintOpacity,
      borderRadius: borderRadius,
      tintColor: tintColor ?? base.tintColor,
      borderColor: borderColor ?? base.borderColor,
      borderWidth: borderWidth,
      gradient: gradient ?? base.gradient,
      boxShadow: boxShadow ?? base.boxShadow,
    );
  }

  @override
  Widget build(BuildContext context) {
    final style = _resolve(context);
    final tint = style.tintColor ?? Theme.of(context).colorScheme.surface;
    final border = style.borderColor ??
        Theme.of(context).colorScheme.outline.withValues(alpha: 0.2);
    final radius =
        borderRadiusGeometry ?? BorderRadius.circular(style.borderRadius);

    Widget surface = ClipRRect(
      borderRadius: radius,
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: style.blur.clamp(
            UIGlassConstants.minBlur,
            UIGlassConstants.maxBlur,
          ),
          sigmaY: style.blur.clamp(
            UIGlassConstants.minBlur,
            UIGlassConstants.maxBlur,
          ),
        ),
        child: Container(
          width: width,
          height: height,
          padding: padding,
          decoration: BoxDecoration(
            color: style.gradient == null
                ? tint.withValues(alpha: style.tintOpacity)
                : null,
            gradient: style.gradient,
            borderRadius: radius,
            border: Border.all(color: border, width: style.borderWidth),
          ),
          child: child,
        ),
      ),
    );

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
