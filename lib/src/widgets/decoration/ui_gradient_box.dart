import 'package:flutter/material.dart';

/// A container that supports gradient backgrounds and borders.
class UIGradientBox extends StatelessWidget {
  /// Creates a [UIGradientBox].
  const UIGradientBox({
    super.key,
    required this.child,
    this.borderRadius,
    this.colors,
    this.stops,
    this.radius = 1.3,
    this.center = const Alignment(0.0858, 1.6648),
    this.padding = EdgeInsets.zero,
    this.margin = EdgeInsets.zero,
    this.gradient,
    this.border,
    this.gradientBorder,
    this.width,
    this.height,
    this.innerColor,
  });

  /// The widget to display inside the box.
  final Widget child;

  /// Optional border radius for the box.
  final BorderRadiusGeometry? borderRadius;

  /// List of colors for the default gradient.
  final List<Color>? colors;

  /// Stops for the default gradient.
  final List<double>? stops;

  /// Radius for the default radial gradient.
  final double radius;

  /// Center for the default radial gradient.
  final Alignment center;

  /// Inner padding.
  final EdgeInsets padding;

  /// Outer margin.
  final EdgeInsetsGeometry margin;

  /// Optional gradient to use instead of default colors/radial setup.
  final Gradient? gradient;

  /// Optional standard border.
  final BoxBorder? border;

  /// Optional gradient border.
  final Gradient? gradientBorder;

  /// Optional fixed width.
  final double? width;

  /// Optional fixed height.
  final double? height;

  /// Optional background color (used if gradient is null).
  final Color? innerColor;

  UIGradientBox copyWith({
    Key? key,
    Widget? child,
    BorderRadiusGeometry? borderRadius,
    List<Color>? colors,
    List<double>? stops,
    double? radius,
    Alignment? center,
    EdgeInsets? padding,
    EdgeInsetsGeometry? margin,
    Gradient? gradient,
    BoxBorder? border,
    Gradient? gradientBorder,
    double? width,
    double? height,
    Color? innerColor,
  }) {
    return UIGradientBox(
      key: key ?? this.key,
      borderRadius: borderRadius ?? this.borderRadius,
      colors: colors ?? this.colors,
      stops: stops ?? this.stops,
      radius: radius ?? this.radius,
      center: center ?? this.center,
      padding: padding ?? this.padding,
      margin: margin ?? this.margin,
      gradient: gradient ?? this.gradient,
      border: border ?? this.border,
      gradientBorder: gradientBorder ?? this.gradientBorder,
      width: width ?? this.width,
      height: height ?? this.height,
      innerColor: innerColor ?? this.innerColor,
      child: child ?? this.child,
    );
  }

  @override
  Widget build(BuildContext context) {
    final resolvedColors =
        colors ?? [Colors.grey.shade200, Colors.grey.shade200];
    final borderRadiusValue =
        borderRadius ?? const BorderRadius.all(Radius.circular(12));

    return Container(
      margin: margin,
      padding: const EdgeInsets.all(1),
      decoration: BoxDecoration(
        border: border,
        borderRadius: borderRadiusValue,
        gradient: gradientBorder ?? LinearGradient(colors: resolvedColors),
      ),
      child: Container(
        width: width,
        height: height,
        padding: padding,
        decoration: BoxDecoration(
          borderRadius: borderRadiusValue,
          color: innerColor,
          gradient:
              gradient ??
              RadialGradient(
                center: center,
                radius: radius,
                colors: resolvedColors,
                stops: stops,
              ),
        ),
        child: child,
      ),
    );
  }
}
