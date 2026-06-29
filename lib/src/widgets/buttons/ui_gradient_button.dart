import 'package:flutter/material.dart';

import '../decoration/ui_gradient_box.dart';

/// A filled button with a linear gradient background.
class UIGradientButton extends StatelessWidget {
  const UIGradientButton({
    super.key,
    required this.label,
    required this.onPressed,
    required this.colors,
    this.borderRadius = 8,
    this.textStyle,
    this.textColor,
    this.padding = const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
    this.splashColor,
    this.enabled = true,
    this.width,
    this.height,
    this.gradient,
  });

  /// Creates a [UIGradientButton] using the theme primary and secondary colors.
  factory UIGradientButton.fromTheme({
    Key? key,
    required String label,
    required VoidCallback? onPressed,
    List<Color>? colors,
    double borderRadius = 8,
    EdgeInsets padding = const EdgeInsets.symmetric(
      horizontal: 24,
      vertical: 16,
    ),
    bool enabled = true,
    double? width,
    double? height,
  }) {
    return UIGradientButton(
      key: key,
      label: label,
      onPressed: onPressed,
      colors: colors ?? const [],
      borderRadius: borderRadius,
      padding: padding,
      enabled: enabled,
      width: width,
      height: height,
    );
  }

  final String label;
  final VoidCallback? onPressed;
  final List<Color> colors;
  final double borderRadius;
  final TextStyle? textStyle;
  final Color? textColor;
  final EdgeInsets padding;
  final Color? splashColor;
  final bool enabled;
  final double? width;
  final double? height;
  final Gradient? gradient;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final resolvedColors = colors.isEmpty
        ? [scheme.primary, scheme.secondary]
        : colors;
    final fg = textColor ?? scheme.onPrimary;
    final effectiveOnPressed = enabled ? onPressed : null;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(borderRadius),
        onTap: effectiveOnPressed,
        splashColor: splashColor ?? scheme.primary.withValues(alpha: 0.2),
        child: UIGradientBox(
          width: width,
          height: height,
          borderRadius: BorderRadius.circular(borderRadius),
          gradient: gradient ?? LinearGradient(colors: resolvedColors),
          padding: padding,
          child: Center(
            child: Text(
              label,
              style: (textStyle ?? theme.textTheme.labelLarge)?.copyWith(
                color: fg,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
