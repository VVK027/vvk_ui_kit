import 'package:flutter/material.dart';
import 'package:vvk_ui_kit/src/widgets/text/ui_text.dart';

/// A single link or label inside [UIBreadcrumb].
class UIBreadcrumbItem extends StatelessWidget {
  const UIBreadcrumbItem({
    super.key,
    required this.label,
    this.onTap,
    this.isCurrent = false,
    this.textStyle,
  });

  final String label;
  final VoidCallback? onTap;
  final bool isCurrent;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = isCurrent
        ? theme.colorScheme.onSurface
        : theme.colorScheme.primary;

    final style = (textStyle ?? theme.textTheme.bodyMedium)?.copyWith(
      color: color,
      fontWeight: isCurrent ? FontWeight.w600 : FontWeight.w500,
    );

    final child = UIText(label, style: style);

    if (isCurrent || onTap == null) return child;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
        child: child,
      ),
    );
  }
}

/// Horizontal breadcrumb trail for hierarchical navigation.
class UIBreadcrumb extends StatelessWidget {
  const UIBreadcrumb({
    super.key,
    required this.items,
    this.separator,
    this.spacing = 4,
    this.maxItems = 0,
    this.overflowLabel = '...',
  });

  final List<UIBreadcrumbItem> items;
  final Widget? separator;
  final double spacing;
  final int maxItems;
  final String overflowLabel;

  List<UIBreadcrumbItem> _visibleItems() {
    if (maxItems <= 0 || items.length <= maxItems) return items;
    if (maxItems < 2) return items;

    return [
      items.first,
      UIBreadcrumbItem(label: overflowLabel, isCurrent: false),
      ...items.sublist(items.length - (maxItems - 2)),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final sep =
        separator ??
        Icon(Icons.chevron_right, size: 16, color: theme.colorScheme.outline);
    final visible = _visibleItems();

    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: spacing,
      runSpacing: spacing,
      children: [
        for (var i = 0; i < visible.length; i++) ...[
          visible[i],
          if (i < visible.length - 1) sep,
        ],
      ],
    );
  }
}
