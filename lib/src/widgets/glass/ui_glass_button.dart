import 'package:flutter/material.dart';
import 'ui_glass_surface.dart';
import '../text/ui_text.dart';

/// Frosted-glass button with optional icon, label, and press-scale animation.
class UIGlassButton extends StatefulWidget {
  const UIGlassButton({
    super.key,
    required this.onPressed,
    this.label,
    this.icon,
    this.suffixIcon,
    this.color,
    this.height = 48,
    this.borderRadius = 12,
    this.padding = const EdgeInsets.symmetric(horizontal: 16),
    this.blur = 10,
    this.tintOpacity = 0.12,
    this.enabled = true,
    this.width,
    this.animationDuration = const Duration(milliseconds: 200),
    this.enablePressScale = true,
  });

  final VoidCallback onPressed;
  final String? label;
  final Widget? icon;
  final Widget? suffixIcon;
  final Color? color;
  final double height;
  final double borderRadius;
  final EdgeInsetsGeometry padding;
  final double blur;
  final double tintOpacity;
  final bool enabled;
  final double? width;
  final Duration animationDuration;
  final bool enablePressScale;

  factory UIGlassButton.fromTheme(
    BuildContext context, {
    Key? key,
    required VoidCallback onPressed,
    String? label,
    Widget? icon,
    Widget? suffixIcon,
    Color? color,
    double height = 48,
    double borderRadius = 12,
    EdgeInsetsGeometry padding = const EdgeInsets.symmetric(horizontal: 16),
    double blur = 10,
    double tintOpacity = 0.12,
    bool enabled = true,
    double? width,
    Duration animationDuration = const Duration(milliseconds: 200),
    bool enablePressScale = true,
  }) {
    return UIGlassButton(
      key: key,
      onPressed: onPressed,
      label: label,
      icon: icon,
      suffixIcon: suffixIcon,
      color: color ?? Theme.of(context).colorScheme.primary,
      height: height,
      borderRadius: borderRadius,
      padding: padding,
      blur: blur,
      tintOpacity: tintOpacity,
      enabled: enabled,
      width: width,
      animationDuration: animationDuration,
      enablePressScale: enablePressScale,
    );
  }

  @override
  State<UIGlassButton> createState() => _UIGlassButtonState();
}

class _UIGlassButtonState extends State<UIGlassButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.animationDuration,
      value: 1,
    );
  }

  @override
  void didUpdateWidget(covariant UIGlassButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.animationDuration != widget.animationDuration) {
      _controller.duration = widget.animationDuration;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  bool get _canInteract => widget.enabled;

  void _handleTapDown(TapDownDetails details) {
    if (!_canInteract || !widget.enablePressScale) return;
    _controller.reverse();
  }

  void _handleTapUp(TapUpDetails details) {
    if (!_canInteract) return;
    if (widget.enablePressScale) {
      _controller.forward();
    }
    widget.onPressed();
  }

  void _handleTapCancel() {
    if (!_canInteract || !widget.enablePressScale) return;
    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final accent = widget.color ?? scheme.primary;
    final textStyle = Theme.of(context).textTheme.labelLarge?.copyWith(
      color: accent,
      fontWeight: FontWeight.w600,
    );

    final button = UIGlassSurface(
      blur: widget.blur,
      tintColor: accent,
      tintOpacity: widget.tintOpacity,
      borderRadius: widget.borderRadius,
      borderColor: accent.withValues(alpha: 0.2),
      width: widget.width,
      height: widget.height,
      padding: widget.padding,
      child: Row(
        mainAxisSize: widget.width != null
            ? MainAxisSize.max
            : MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (widget.icon != null) ...[
            IconTheme(
              data: IconThemeData(color: accent, size: 18),
              child: widget.icon!,
            ),
            if (widget.label != null) const SizedBox(width: 8),
          ],
          if (widget.label != null)
            Flexible(
              child: UIText(
                widget.label!,
                maxLines: 1,
                textOverflow: TextOverflow.ellipsis,
                style: textStyle,
              ),
            ),
          if (widget.suffixIcon != null) ...[
            const SizedBox(width: 8),
            IconTheme(
              data: IconThemeData(color: accent, size: 18),
              child: widget.suffixIcon!,
            ),
          ],
        ],
      ),
    );

    final interactive = Opacity(
      opacity: _canInteract ? 1 : 0.6,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: _handleTapDown,
        onTapUp: _handleTapUp,
        onTapCancel: _handleTapCancel,
        child: button,
      ),
    );

    if (!widget.enablePressScale) {
      return interactive;
    }

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.scale(
          scale: 0.95 + (_controller.value * 0.05),
          child: child,
        );
      },
      child: interactive,
    );
  }
}
