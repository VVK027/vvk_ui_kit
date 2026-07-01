import 'package:flutter/material.dart';
import 'package:vvk_ui_kit/src/widgets/text/ui_text.dart';

/// One tab inside [UIBottomNavyBar].
class UIBottomNavyBarItem {
  const UIBottomNavyBarItem({
    required this.icon,
    required this.label,
    this.activeColor,
    this.inactiveColor,
    this.textAlign = TextAlign.start,
  });

  final Widget icon;
  final String label;
  final Color? activeColor;
  final Color? inactiveColor;
  final TextAlign textAlign;
}

/// Animated bottom navigation bar where the selected item expands to show
/// its label beside the icon.
///
/// Supports 2–5 items. Inactive items show only the icon; the active item
/// animates to a wider pill with icon and label.
class UIBottomNavyBar extends StatelessWidget {
  const UIBottomNavyBar({
    super.key,
    this.selectedIndex = 0,
    this.iconSize = 24,
    required this.backgroundColor,
    this.showElevation = true,
    this.animationDuration = const Duration(milliseconds: 270),
    required this.items,
    required this.onItemSelected,
    this.mainAxisAlignment = MainAxisAlignment.spaceBetween,
    this.itemCornerRadius = 50,
    this.containerHeight = 56,
    this.selectedItemWidth = 130,
    this.itemMinWidth = 50,
    this.curve = Curves.easeInOut,
  }) : assert(items.length >= 2 && items.length <= 5);

  final int selectedIndex;
  final double iconSize;
  final Color backgroundColor;
  final bool showElevation;
  final Duration animationDuration;
  final List<UIBottomNavyBarItem> items;
  final ValueChanged<int> onItemSelected;
  final MainAxisAlignment mainAxisAlignment;
  final double itemCornerRadius;
  final double containerHeight;
  final double selectedItemWidth;
  final double itemMinWidth;
  final Curve curve;

  /// Builds a bar using [Theme.of] [ColorScheme] for the background.
  factory UIBottomNavyBar.fromTheme(
    BuildContext context, {
    Key? key,
    int selectedIndex = 0,
    double iconSize = 24,
    Color? backgroundColor,
    bool showElevation = true,
    Duration animationDuration = const Duration(milliseconds: 270),
    required List<UIBottomNavyBarItem> items,
    required ValueChanged<int> onItemSelected,
    MainAxisAlignment mainAxisAlignment = MainAxisAlignment.spaceBetween,
    double itemCornerRadius = 50,
    double containerHeight = 56,
    double selectedItemWidth = 130,
    double itemMinWidth = 50,
    Curve curve = Curves.easeInOut,
  }) {
    final scheme = Theme.of(context).colorScheme;
    return UIBottomNavyBar(
      key: key,
      selectedIndex: selectedIndex,
      iconSize: iconSize,
      backgroundColor: backgroundColor ?? scheme.surface,
      showElevation: showElevation,
      animationDuration: animationDuration,
      items: items,
      onItemSelected: onItemSelected,
      mainAxisAlignment: mainAxisAlignment,
      itemCornerRadius: itemCornerRadius,
      containerHeight: containerHeight,
      selectedItemWidth: selectedItemWidth,
      itemMinWidth: itemMinWidth,
      curve: curve,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final shadowColor = theme.colorScheme.shadow.withValues(alpha: 0.08);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: backgroundColor,
        boxShadow: showElevation
            ? [
                BoxShadow(
                  color: shadowColor,
                  blurRadius: 8,
                  offset: const Offset(0, -2),
                ),
              ]
            : null,
      ),
      child: SafeArea(
        child: SizedBox(
          width: double.infinity,
          height: containerHeight,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
            child: Row(
              mainAxisAlignment: mainAxisAlignment,
              children: [
                for (var index = 0; index < items.length; index++)
                  _UIBottomNavyBarTile(
                    key: ValueKey('ui_bottom_navy_bar_item_$index'),
                    item: items[index],
                    iconSize: iconSize,
                    isSelected: index == selectedIndex,
                    backgroundColor: backgroundColor,
                    itemCornerRadius: itemCornerRadius,
                    animationDuration: animationDuration,
                    curve: curve,
                    selectedItemWidth: selectedItemWidth,
                    itemMinWidth: itemMinWidth,
                    onTap: () => onItemSelected(index),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _UIBottomNavyBarTile extends StatelessWidget {
  const _UIBottomNavyBarTile({
    super.key,
    required this.item,
    required this.iconSize,
    required this.isSelected,
    required this.backgroundColor,
    required this.itemCornerRadius,
    required this.animationDuration,
    required this.curve,
    required this.selectedItemWidth,
    required this.itemMinWidth,
    required this.onTap,
  });

  final UIBottomNavyBarItem item;
  final double iconSize;
  final bool isSelected;
  final Color backgroundColor;
  final double itemCornerRadius;
  final Duration animationDuration;
  final Curve curve;
  final double selectedItemWidth;
  final double itemMinWidth;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final activeColor = item.activeColor ?? scheme.primary;
    final inactiveColor = item.inactiveColor ?? scheme.onSurfaceVariant;
    final width = isSelected ? selectedItemWidth : itemMinWidth;

    return Semantics(
      button: true,
      selected: isSelected,
      label: item.label,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(itemCornerRadius),
          child: AnimatedContainer(
            width: width,
            height: double.infinity,
            duration: animationDuration,
            curve: curve,
            decoration: BoxDecoration(
              color: isSelected
                  ? activeColor.withValues(alpha: 0.12)
                  : backgroundColor,
              borderRadius: BorderRadius.circular(itemCornerRadius),
            ),
            child: ClipRect(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconTheme(
                      data: IconThemeData(
                        size: iconSize,
                        color: isSelected ? activeColor : inactiveColor,
                      ),
                      child: item.icon,
                    ),
                    if (isSelected) ...[
                      const SizedBox(width: 4),
                      Expanded(
                        child: UIText(
                          item.label,
                          maxLines: 1,
                          textAlign: item.textAlign,
                          textOverflow: TextOverflow.ellipsis,
                          style: themeTextStyle(context, activeColor),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  TextStyle themeTextStyle(BuildContext context, Color activeColor) {
    return Theme.of(context).textTheme.labelLarge?.copyWith(
          color: activeColor,
          fontWeight: FontWeight.w700,
        ) ??
        TextStyle(color: activeColor, fontWeight: FontWeight.w700);
  }
}
