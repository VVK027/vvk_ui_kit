import 'package:flutter/material.dart';
import 'package:vvk_ui_kit/src/widgets/text/ui_text.dart';

/// One navigation slot in [UIFloatingBottomBar].
class UIFloatingBottomBarItem {
  const UIFloatingBottomBarItem({
    required this.icon,
    required this.label,
  });

  final Widget icon;
  final String label;
}

/// Center action for [UIFloatingBottomBar].
class UIFloatingBottomBarCenterAction {
  const UIFloatingBottomBarCenterAction({
    required this.icon,
    this.color,
  });

  final Widget icon;
  final Color? color;
}

/// Bottom bar with a raised center action and items split on both sides.
///
/// The center action index is `leftItems.length`. Total indices:
/// `leftItems.length + 1 + rightItems.length`.
class UIFloatingBottomBar extends StatelessWidget {
  const UIFloatingBottomBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.leftItems,
    required this.rightItems,
    required this.centerAction,
    this.backgroundColor,
    this.height = 90,
    this.barHeight = 64,
    this.borderRadius = 24,
    this.padding = const EdgeInsets.fromLTRB(24, 0, 24, 24),
    this.centerButtonSize = 56,
  }) : assert(leftItems.length >= 1 && rightItems.length >= 1);

  final int currentIndex;
  final ValueChanged<int> onTap;
  final List<UIFloatingBottomBarItem> leftItems;
  final List<UIFloatingBottomBarItem> rightItems;
  final UIFloatingBottomBarCenterAction centerAction;
  final Color? backgroundColor;
  final double height;
  final double barHeight;
  final double borderRadius;
  final EdgeInsetsGeometry padding;
  final double centerButtonSize;

  int get _centerIndex => leftItems.length;

  factory UIFloatingBottomBar.fromTheme(
    BuildContext context, {
    Key? key,
    required int currentIndex,
    required ValueChanged<int> onTap,
    required List<UIFloatingBottomBarItem> leftItems,
    required List<UIFloatingBottomBarItem> rightItems,
    required UIFloatingBottomBarCenterAction centerAction,
    Color? backgroundColor,
    double height = 90,
    double barHeight = 64,
    double borderRadius = 24,
    EdgeInsetsGeometry padding = const EdgeInsets.fromLTRB(24, 0, 24, 24),
    double centerButtonSize = 56,
  }) {
    final scheme = Theme.of(context).colorScheme;
    return UIFloatingBottomBar(
      key: key,
      currentIndex: currentIndex,
      onTap: onTap,
      leftItems: leftItems,
      rightItems: rightItems,
      centerAction: centerAction,
      backgroundColor: backgroundColor ?? scheme.surface,
      height: height,
      barHeight: barHeight,
      borderRadius: borderRadius,
      padding: padding,
      centerButtonSize: centerButtonSize,
    );
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final barColor = backgroundColor ?? scheme.surface;
    final centerColor = centerAction.color ?? scheme.primary;
    final shadow = scheme.shadow.withValues(alpha: 0.08);

    return SizedBox(
      height: height,
      child: Padding(
        padding: padding,
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Container(
              height: barHeight,
              decoration: BoxDecoration(
                color: barColor,
                borderRadius: BorderRadius.circular(borderRadius),
                boxShadow: [
                  BoxShadow(
                    color: shadow,
                    blurRadius: 20,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        for (var i = 0; i < leftItems.length; i++)
                          _NavSlot(
                            item: leftItems[i],
                            isSelected: currentIndex == i,
                            onTap: () => onTap(i),
                          ),
                      ],
                    ),
                  ),
                  SizedBox(width: centerButtonSize),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        for (var i = 0; i < rightItems.length; i++)
                          _NavSlot(
                            item: rightItems[i],
                            isSelected: currentIndex == _centerIndex + 1 + i,
                            onTap: () => onTap(_centerIndex + 1 + i),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 0,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => onTap(_centerIndex),
                  customBorder: const CircleBorder(),
                  child: Ink(
                    width: centerButtonSize,
                    height: centerButtonSize,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          centerColor,
                          Color.lerp(centerColor, Colors.white, 0.2)!,
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: centerColor.withValues(alpha: 0.3),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                      border: currentIndex == _centerIndex
                          ? Border.all(
                              color: scheme.onPrimary.withValues(alpha: 0.5),
                              width: 2,
                            )
                          : null,
                    ),
                    child: Center(child: centerAction.icon),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavSlot extends StatelessWidget {
  const _NavSlot({
    required this.item,
    required this.isSelected,
    required this.onTap,
  });

  final UIFloatingBottomBarItem item;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final color = isSelected ? scheme.primary : scheme.onSurfaceVariant;

    return Semantics(
      button: true,
      selected: isSelected,
      label: item.label,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconTheme(
                data: IconThemeData(color: color, size: 22),
                child: item.icon,
              ),
              if (isSelected) ...[
                const SizedBox(height: 4),
                UIText(
                  item.label,
                  maxLines: 1,
                  textOverflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: color,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
