import 'package:flutter/material.dart';

/// Linear progress indicator with determinate and indeterminate modes.
class UIProgressBar extends StatelessWidget {
  const UIProgressBar({
    super.key,
    this.value,
    this.minHeight = 6,
    this.backgroundColor,
    this.color,
    this.borderRadius = 999,
  }) : assert(value == null || (value >= 0 && value <= 1));

  const UIProgressBar.indeterminate({
    super.key,
    this.minHeight = 6,
    this.backgroundColor,
    this.color,
    this.borderRadius = 999,
  }) : value = null;

  final double? value;
  final double minHeight;
  final Color? backgroundColor;
  final Color? color;
  final double borderRadius;

  UIProgressBar copyWith({
    Key? key,
    double? value,
    double? minHeight,
    Color? backgroundColor,
    Color? color,
    double? borderRadius,
  }) {
    return UIProgressBar(
      key: key ?? this.key,
      value: value ?? this.value,
      minHeight: minHeight ?? this.minHeight,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      color: color ?? this.color,
      borderRadius: borderRadius ?? this.borderRadius,
    );
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final trackColor = backgroundColor ?? scheme.surfaceContainerHighest;
    final fillColor = color ?? scheme.primary;

    final indicator = value == null
        ? LinearProgressIndicator(
            minHeight: minHeight,
            backgroundColor: trackColor,
            color: fillColor,
            borderRadius: BorderRadius.circular(borderRadius),
          )
        : LinearProgressIndicator(
            value: value,
            minHeight: minHeight,
            backgroundColor: trackColor,
            color: fillColor,
            borderRadius: BorderRadius.circular(borderRadius),
          );

    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: indicator,
    );
  }
}
