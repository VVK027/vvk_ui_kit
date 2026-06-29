import 'package:flutter/material.dart';
import 'package:vvk_ui_kit/src/widgets/layout/ui_portal.dart';
import 'package:vvk_ui_kit/src/widgets/text/ui_text.dart';

/// Tooltip anchored to [child] via [UIPortal].
class UITooltip extends StatefulWidget {
  const UITooltip({
    super.key,
    required this.message,
    required this.child,
    this.visible,
    this.waitDuration = const Duration(milliseconds: 400),
    this.showDuration = const Duration(seconds: 2),
    this.backgroundColor,
    this.textStyle,
    this.padding = const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
    this.borderRadius = 8,
    this.anchor = const UIPortalAnchor(
      targetAnchor: Alignment.topCenter,
      followerAnchor: Alignment.bottomCenter,
      offset: Offset(0, -6),
    ),
    this.preferBelow = true,
  });

  final String message;
  final Widget child;
  final bool? visible;
  final Duration waitDuration;
  final Duration showDuration;
  final Color? backgroundColor;
  final TextStyle? textStyle;
  final EdgeInsetsGeometry padding;
  final double borderRadius;
  final UIPortalAnchor anchor;
  final bool preferBelow;

  @override
  State<UITooltip> createState() => _UITooltipState();
}

class _UITooltipState extends State<UITooltip> {
  bool _hovering = false;
  bool _pressed = false;

  bool get _effectiveVisible {
    if (widget.visible != null) return widget.visible!;
    return _hovering || _pressed;
  }

  void _setHovering(bool value) {
    if (_hovering == value) return;
    setState(() => _hovering = value);
  }

  void _setPressed(bool value) {
    if (_pressed == value) return;
    setState(() => _pressed = value);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final background = widget.backgroundColor ?? scheme.inverseSurface;
    final textStyle =
        widget.textStyle ??
        theme.textTheme.labelSmall?.copyWith(color: scheme.onInverseSurface);

    final tooltip = Material(
      color: Colors.transparent,
      child: Container(
        padding: widget.padding,
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(widget.borderRadius),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.12),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: UIText(widget.message, style: textStyle),
      ),
    );

    return UIPortal(
      visible: _effectiveVisible,
      anchor: widget.anchor,
      overlay: tooltip,
      child: MouseRegion(
        onEnter: (_) => _setHovering(true),
        onExit: (_) => _setHovering(false),
        child: GestureDetector(
          onLongPressStart: (_) => _setPressed(true),
          onLongPressEnd: (_) => _setPressed(false),
          child: widget.child,
        ),
      ),
    );
  }
}
