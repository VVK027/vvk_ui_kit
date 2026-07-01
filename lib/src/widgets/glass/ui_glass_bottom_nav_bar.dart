import 'package:flutter/material.dart';
import 'package:vvk_ui_kit/src/widgets/glass/ui_glass_surface.dart';
import 'package:vvk_ui_kit/src/widgets/glass/ui_glass_theme.dart';
import 'package:vvk_ui_kit/src/widgets/text/ui_text.dart';

/// One tab inside [UIGlassBottomNavBar].
class UIGlassBottomNavBarItem {
  const UIGlassBottomNavBarItem({
    required this.icon,
    this.label,
    this.activeColor,
    this.inactiveColor,
  });

  final Widget icon;
  final String? label;
  final Color? activeColor;
  final Color? inactiveColor;
}

/// Frosted-glass bottom navigation bar.
class UIGlassBottomNavBar extends StatelessWidget {
  const UIGlassBottomNavBar({
    super.key,
    required this.items,
    required this.currentIndex,
    this.onTap,
    this.height = kBottomNavigationBarHeight,
    this.blur = UIGlassConstants.defaultBlur,
    this.tintOpacity = UIGlassConstants.defaultTintOpacity,
    this.theme,
    this.gradient,
    this.padding = const EdgeInsets.symmetric(horizontal: 8),
    this.borderRadius = 16,
    this.activeColor,
    this.inactiveColor,
  }) : assert(items.length >= 2),
       assert(currentIndex >= 0 && currentIndex < items.length);

  final List<UIGlassBottomNavBarItem> items;
  final int currentIndex;
  final ValueChanged<int>? onTap;
  final double height;
  final double blur;
  final double tintOpacity;
  final UIGlassTheme? theme;
  final Gradient? gradient;
  final EdgeInsetsGeometry padding;
  final double borderRadius;
  final Color? activeColor;
  final Color? inactiveColor;

  factory UIGlassBottomNavBar.fromTheme(
    BuildContext context, {
    Key? key,
    required List<UIGlassBottomNavBarItem> items,
    required int currentIndex,
    ValueChanged<int>? onTap,
    double height = kBottomNavigationBarHeight,
    double blur = UIGlassConstants.defaultBlur,
    double tintOpacity = UIGlassConstants.defaultTintOpacity,
    UIGlassTheme? theme,
    Gradient? gradient,
    EdgeInsetsGeometry padding = const EdgeInsets.symmetric(horizontal: 8),
    double borderRadius = 16,
    Color? activeColor,
    Color? inactiveColor,
  }) {
    final scheme = Theme.of(context).colorScheme;
    return UIGlassBottomNavBar(
      key: key,
      items: items,
      currentIndex: currentIndex,
      onTap: onTap,
      height: height,
      blur: blur,
      tintOpacity: tintOpacity,
      theme: theme,
      gradient: gradient,
      padding: padding,
      borderRadius: borderRadius,
      activeColor: activeColor ?? scheme.onSurface,
      inactiveColor: inactiveColor ?? scheme.onSurface.withValues(alpha: 0.6),
    );
  }

  @override
  Widget build(BuildContext context) {
    final resolvedActive =
        activeColor ?? Theme.of(context).colorScheme.onSurface;
    final resolvedInactive =
        inactiveColor ?? resolvedActive.withValues(alpha: 0.6);

    return UIGlassSurface(
      theme: theme,
      blur: blur,
      tintOpacity: tintOpacity,
      gradient: gradient,
      borderRadiusGeometry: BorderRadius.vertical(
        top: Radius.circular(borderRadius),
      ),
      child: Padding(
        padding: padding,
        child: SizedBox(
          height: height,
          child: Row(
            children: List.generate(items.length, (index) {
              final item = items[index];
              final isSelected = index == currentIndex;
              final color = isSelected
                  ? (item.activeColor ?? resolvedActive)
                  : (item.inactiveColor ?? resolvedInactive);

              return Expanded(
                child: InkWell(
                  onTap: onTap != null ? () => onTap!(index) : null,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      IconTheme(
                        data: IconThemeData(color: color, size: 22),
                        child: item.icon,
                      ),
                      if (item.label != null) ...[
                        const SizedBox(height: 2),
                        UIText(
                          item.label!,
                          maxLines: 1,
                          textOverflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.labelSmall
                              ?.copyWith(color: color, fontSize: 11),
                        ),
                      ],
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
