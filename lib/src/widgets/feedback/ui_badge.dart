import 'package:flutter/material.dart';
import '../text/ui_text.dart';

/// Visual variants for [UIBadge].
enum UIBadgeVariant { primary, secondary, outline, destructive, live }

/// Unified badge for tags, status chips, and live indicators.
class UIBadge extends StatelessWidget {
  const UIBadge({
    super.key,
    required this.child,
    this.variant = UIBadgeVariant.primary,
    this.backgroundColor,
    this.foregroundColor,
    this.borderColor,
    this.padding = const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
    this.borderRadius = 8,
    this.onTap,
    this.showLiveDot = true,
    this.dotColor,
    this.dotSize = 6,
  });

  const UIBadge.primary({
    super.key,
    required this.child,
    this.backgroundColor,
    this.foregroundColor,
    this.borderColor,
    this.padding = const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
    this.borderRadius = 8,
    this.onTap,
    this.showLiveDot = true,
    this.dotColor,
    this.dotSize = 6,
  }) : variant = UIBadgeVariant.primary;

  const UIBadge.secondary({
    super.key,
    required this.child,
    this.backgroundColor,
    this.foregroundColor,
    this.borderColor,
    this.padding = const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
    this.borderRadius = 8,
    this.onTap,
    this.showLiveDot = true,
    this.dotColor,
    this.dotSize = 6,
  }) : variant = UIBadgeVariant.secondary;

  const UIBadge.outline({
    super.key,
    required this.child,
    this.backgroundColor,
    this.foregroundColor,
    this.borderColor,
    this.padding = const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
    this.borderRadius = 8,
    this.onTap,
    this.showLiveDot = true,
    this.dotColor,
    this.dotSize = 6,
  }) : variant = UIBadgeVariant.outline;

  const UIBadge.destructive({
    super.key,
    required this.child,
    this.backgroundColor,
    this.foregroundColor,
    this.borderColor,
    this.padding = const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
    this.borderRadius = 8,
    this.onTap,
    this.showLiveDot = true,
    this.dotColor,
    this.dotSize = 6,
  }) : variant = UIBadgeVariant.destructive;

  const UIBadge.live({
    super.key,
    required this.child,
    this.backgroundColor,
    this.foregroundColor,
    this.borderColor,
    this.padding = const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
    this.borderRadius = 6,
    this.onTap,
    this.showLiveDot = true,
    this.dotColor,
    this.dotSize = 5,
  }) : variant = UIBadgeVariant.live;

  final Widget child;
  final UIBadgeVariant variant;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final Color? borderColor;
  final EdgeInsetsGeometry padding;
  final double borderRadius;
  final VoidCallback? onTap;
  final bool showLiveDot;
  final Color? dotColor;
  final double dotSize;

  /// Builds a [UIBadge] with colors from [Theme.of(context)].
  factory UIBadge.text(
    BuildContext context, {
    Key? key,
    required String label,
    UIBadgeVariant variant = UIBadgeVariant.primary,
    TextStyle? textStyle,
    VoidCallback? onTap,
  }) {
    final theme = Theme.of(context);
    final style =
        textStyle ??
        theme.textTheme.labelSmall?.copyWith(fontWeight: FontWeight.w600);
    return UIBadge(
      key: key,
      variant: variant,
      onTap: onTap,
      child: UIText(label, style: style),
    );
  }

  UIBadge copyWith({
    Key? key,
    Widget? child,
    UIBadgeVariant? variant,
    Color? backgroundColor,
    Color? foregroundColor,
    Color? borderColor,
    EdgeInsetsGeometry? padding,
    double? borderRadius,
    VoidCallback? onTap,
    bool? showLiveDot,
    Color? dotColor,
    double? dotSize,
  }) {
    return UIBadge(
      key: key ?? this.key,
      variant: variant ?? this.variant,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      foregroundColor: foregroundColor ?? this.foregroundColor,
      borderColor: borderColor ?? this.borderColor,
      padding: padding ?? this.padding,
      borderRadius: borderRadius ?? this.borderRadius,
      onTap: onTap ?? this.onTap,
      showLiveDot: showLiveDot ?? this.showLiveDot,
      dotColor: dotColor ?? this.dotColor,
      dotSize: dotSize ?? this.dotSize,
      child: child ?? this.child,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final colors = _resolveColors(scheme);

    Widget content = child;
    if (variant == UIBadgeVariant.live && showLiveDot) {
      content = Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: dotSize,
            height: dotSize,
            decoration: BoxDecoration(
              color: dotColor ?? colors.$3,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 4),
          DefaultTextStyle.merge(
            style: TextStyle(color: colors.$2),
            child: child,
          ),
        ],
      );
    } else if (foregroundColor != null) {
      content = DefaultTextStyle.merge(
        style: TextStyle(color: colors.$2),
        child: child,
      );
    } else {
      content = DefaultTextStyle.merge(
        style: TextStyle(color: colors.$2),
        child: child,
      );
    }

    final badge = Container(
      padding: padding,
      decoration: BoxDecoration(
        color: colors.$1,
        borderRadius: BorderRadius.circular(borderRadius),
        border: colors.$4 != null ? Border.all(color: colors.$4!) : null,
      ),
      child: content,
    );

    if (onTap == null) return badge;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(borderRadius),
        child: badge,
      ),
    );
  }

  (Color bg, Color fg, Color dot, Color? border) _resolveColors(
    ColorScheme scheme,
  ) {
    switch (variant) {
      case UIBadgeVariant.primary:
        return (
          backgroundColor ?? scheme.primary,
          foregroundColor ?? scheme.onPrimary,
          dotColor ?? scheme.onPrimary,
          borderColor,
        );
      case UIBadgeVariant.secondary:
        return (
          backgroundColor ?? scheme.secondaryContainer,
          foregroundColor ?? scheme.onSecondaryContainer,
          dotColor ?? scheme.onSecondaryContainer,
          borderColor,
        );
      case UIBadgeVariant.outline:
        return (
          backgroundColor ?? Colors.transparent,
          foregroundColor ?? scheme.onSurface,
          dotColor ?? scheme.primary,
          borderColor ?? scheme.outline,
        );
      case UIBadgeVariant.destructive:
        return (
          backgroundColor ?? scheme.error,
          foregroundColor ?? scheme.onError,
          dotColor ?? scheme.onError,
          borderColor,
        );
      case UIBadgeVariant.live:
        return (
          backgroundColor ?? scheme.errorContainer.withValues(alpha: 0.35),
          foregroundColor ?? scheme.error,
          dotColor ?? scheme.error,
          borderColor,
        );
    }
  }
}
