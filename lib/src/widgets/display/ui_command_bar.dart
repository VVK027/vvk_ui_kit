import 'package:flutter/material.dart';
import '../layout/ui_dynamic_overflow.dart';
import '../navigation/ui_context_menu.dart';
import '../text/ui_text.dart';

/// One action displayed in [UICommandBar].
class UICommandBarItem {
  UICommandBarItem({
    this.label,
    this.icon,
    this.onPressed,
    this.enabled = true,
    this.destructive = false,
    this.tooltip,
  }) : assert(
         icon != null || (label != null && label.isNotEmpty),
         'Provide an icon or label.',
       );

  final String? label;
  final IconData? icon;
  final VoidCallback? onPressed;
  final bool enabled;
  final bool destructive;
  final String? tooltip;

  UIContextMenuItem toMenuItem() {
    return UIContextMenuItem.fromAction(
      label: label ?? '',
      icon: icon,
      onTap: onPressed,
      enabled: enabled,
      destructive: destructive,
    );
  }
}

/// Horizontal toolbar with dynamic overflow into a "more" menu.
///
/// Primary [items] stay visible while they fit. Overflowed primary items and
/// all [secondaryItems] are grouped in the overflow menu.
class UICommandBar extends StatelessWidget {
  const UICommandBar({
    super.key,
    required this.items,
    this.secondaryItems = const [],
    this.compact = false,
    this.spacing = 8,
    this.padding = const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
    this.backgroundColor,
    this.borderColor,
    this.borderRadius = 12,
    this.showBorder = true,
    this.overflowIcon = Icons.more_horiz,
    this.overflowTooltip = 'More actions',
  });

  final List<UICommandBarItem> items;
  final List<UICommandBarItem> secondaryItems;
  final bool compact;
  final double spacing;
  final EdgeInsetsGeometry padding;
  final Color? backgroundColor;
  final Color? borderColor;
  final double borderRadius;
  final bool showBorder;
  final IconData overflowIcon;
  final String overflowTooltip;

  factory UICommandBar.fromTheme(
    BuildContext context, {
    Key? key,
    required List<UICommandBarItem> items,
    List<UICommandBarItem> secondaryItems = const [],
    bool compact = false,
    double spacing = 8,
    EdgeInsetsGeometry padding = const EdgeInsets.symmetric(
      horizontal: 8,
      vertical: 6,
    ),
    Color? backgroundColor,
    Color? borderColor,
    double borderRadius = 12,
    bool showBorder = true,
    IconData overflowIcon = Icons.more_horiz,
    String overflowTooltip = 'More actions',
  }) {
    final scheme = Theme.of(context).colorScheme;
    return UICommandBar(
      key: key,
      items: items,
      secondaryItems: secondaryItems,
      compact: compact,
      spacing: spacing,
      padding: padding,
      backgroundColor: backgroundColor ?? scheme.surfaceContainerHighest,
      borderColor: borderColor ?? scheme.outlineVariant,
      borderRadius: borderRadius,
      showBorder: showBorder,
      overflowIcon: overflowIcon,
      overflowTooltip: overflowTooltip,
    );
  }

  List<UIContextMenuItem> _overflowMenuItems(List<int> hiddenIndices) {
    final menu = <UIContextMenuItem>[
      for (final index in hiddenIndices) items[index].toMenuItem(),
      ...secondaryItems.map((item) => item.toMenuItem()),
    ];
    return menu.where((item) => item.label.isNotEmpty).toList();
  }

  Widget _buildItem(BuildContext context, UICommandBarItem item) {
    final scheme = Theme.of(context).colorScheme;
    final color = item.destructive ? scheme.error : scheme.onSurface;
    final onPressed = item.enabled ? item.onPressed : null;

    if (compact || (item.label == null && item.icon != null)) {
      return IconButton(
        tooltip: item.tooltip ?? item.label,
        onPressed: onPressed,
        icon: Icon(item.icon, color: color),
      );
    }

    if (item.icon != null) {
      return TextButton.icon(
        onPressed: onPressed,
        icon: Icon(item.icon, size: 18, color: color),
        label: UIText(
          item.label!,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(color: color),
        ),
      );
    }

    return TextButton(
      onPressed: onPressed,
      child: UIText(
        item.label!,
        style: Theme.of(context).textTheme.labelLarge?.copyWith(color: color),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final children = items.map((item) => _buildItem(context, item)).toList();
    if (children.isEmpty && secondaryItems.isEmpty) {
      return const SizedBox.shrink();
    }

    return DecoratedBox(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(borderRadius),
        border: showBorder ? Border.all(color: borderColor!) : null,
      ),
      child: Padding(
        padding: padding,
        child: UIDynamicOverflow(
          spacing: spacing,
          alwaysShowOverflow: secondaryItems.isNotEmpty,
          overflowReserveWidth: secondaryItems.isNotEmpty ? 44 : 44,
          children: children,
          overflowBuilder: (context, hiddenIndices) {
            final menuItems = _overflowMenuItems(hiddenIndices);
            if (menuItems.isEmpty) {
              return const SizedBox.shrink();
            }
            return UIDynamicOverflowMenuButton(
              hiddenIndices: hiddenIndices,
              menuItems: menuItems,
              icon: overflowIcon,
              tooltip: overflowTooltip,
            );
          },
        ),
      ),
    );
  }
}
