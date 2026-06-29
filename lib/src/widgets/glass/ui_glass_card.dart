import 'package:flutter/material.dart';
import 'package:vvk_ui_kit/src/widgets/glass/ui_glass_surface.dart';
import 'package:vvk_ui_kit/src/widgets/glass/ui_glass_theme.dart';

/// Frosted-glass card with optional tap handling.
class UIGlassCard extends StatelessWidget {
  const UIGlassCard({
    super.key,
    required this.child,
    this.onTap,
    this.onLongPress,
    this.theme,
    this.blur = 10,
    this.tintColor,
    this.tintOpacity = 0.12,
    this.borderRadius = 12,
    this.padding = const EdgeInsets.all(16),
    this.width,
    this.height,
    this.enabled = true,
  });

  final Widget child;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final UIGlassTheme? theme;
  final double blur;
  final Color? tintColor;
  final double tintOpacity;
  final double borderRadius;
  final EdgeInsetsGeometry padding;
  final double? width;
  final double? height;
  final bool enabled;

  factory UIGlassCard.fromTheme(
    BuildContext context, {
    Key? key,
    required Widget child,
    VoidCallback? onTap,
    VoidCallback? onLongPress,
    double blur = 10,
    Color? tintColor,
    double tintOpacity = 0.12,
    double borderRadius = 12,
    EdgeInsetsGeometry padding = const EdgeInsets.all(16),
    double? width,
    double? height,
    bool enabled = true,
  }) {
    final scheme = Theme.of(context).colorScheme;
    return UIGlassCard(
      key: key,
      onTap: onTap,
      onLongPress: onLongPress,
      theme: UIGlassTheme.fromTheme(context),
      blur: blur,
      tintColor: tintColor ?? scheme.surface,
      tintOpacity: tintOpacity,
      borderRadius: borderRadius,
      padding: padding,
      width: width,
      height: height,
      enabled: enabled,
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    final surface = UIGlassSurface(
      theme: theme,
      blur: blur,
      tintColor: tintColor,
      tintOpacity: tintOpacity,
      borderRadius: borderRadius,
      padding: padding,
      width: width,
      height: height,
      child: child,
    );

    if (onTap == null && onLongPress == null) {
      return surface;
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: enabled ? onTap : null,
        onLongPress: enabled ? onLongPress : null,
        borderRadius: BorderRadius.circular(borderRadius),
        child: surface,
      ),
    );
  }
}
