import 'package:flutter/material.dart';
import '../text/ui_text.dart';

/// Corner placement for [UIStackBadge].
enum UIStackBadgePosition { topStart, topEnd, bottomStart, bottomEnd }

/// Overlays a small label badge on [child] in a [Stack].
///
/// Minimal alternative to full tag systems — useful for counts, "NEW", or status.
class UIStackBadge extends StatelessWidget {
  const UIStackBadge({
    super.key,
    required this.child,
    this.label,
    this.badge,
    this.position = UIStackBadgePosition.topEnd,
    this.backgroundColor,
    this.textStyle,
    this.padding = const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
    this.offset = const Offset(4, -4),
    this.borderRadius = 8,
  }) : assert(
         badge != null || label != null,
         'Either label or badge must be provided.',
       );

  final Widget child;
  final String? label;
  final Widget? badge;
  final UIStackBadgePosition position;
  final Color? backgroundColor;
  final TextStyle? textStyle;
  final EdgeInsets padding;
  final Offset offset;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveBackground = backgroundColor ?? theme.colorScheme.error;
    final effectiveTextColor = theme.colorScheme.onError;

    final badgeWidget =
        badge ??
        UIText(
          label!,
          style:
              textStyle ??
              theme.textTheme.labelSmall?.copyWith(
                color: effectiveTextColor,
                fontWeight: FontWeight.w700,
                height: 1.1,
              ),
        );

    final decoratedBadge = DecoratedBox(
      decoration: BoxDecoration(
        color: effectiveBackground,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Padding(padding: padding, child: badgeWidget),
    );

    return Stack(
      clipBehavior: Clip.none,
      children: [child, _positionedBadge(decoratedBadge)],
    );
  }

  Widget _positionedBadge(Widget badgeWidget) {
    switch (position) {
      case UIStackBadgePosition.topStart:
        return Positioned(top: offset.dy, left: offset.dx, child: badgeWidget);
      case UIStackBadgePosition.topEnd:
        return Positioned(top: offset.dy, right: offset.dx, child: badgeWidget);
      case UIStackBadgePosition.bottomStart:
        return Positioned(
          bottom: offset.dy,
          left: offset.dx,
          child: badgeWidget,
        );
      case UIStackBadgePosition.bottomEnd:
        return Positioned(
          bottom: offset.dy,
          right: offset.dx,
          child: badgeWidget,
        );
    }
  }
}
