import 'package:flutter/material.dart';
import 'package:vvk_ui_kit/src/widgets/text/ui_text.dart';

/// Single cell in a [UISummaryGrid] with icon, label, and value.
class UISummaryGridItem {
  const UISummaryGridItem({
    required this.icon,
    this.label,
    this.labelChild,
    required this.value,
  }) : assert(
         labelChild != null || label != null,
         'Either label or labelChild must be provided.',
       );

  final Widget icon;
  final String? label;
  final Widget? labelChild;
  final Widget value;

  UISummaryGridItem copyWith({
    Widget? icon,
    String? label,
    Widget? labelChild,
    Widget? value,
  }) {
    return UISummaryGridItem(
      icon: icon ?? this.icon,
      label: label ?? this.label,
      labelChild: labelChild ?? this.labelChild,
      value: value ?? this.value,
    );
  }
}

/// Two-column (by default) grid of icon + label + value cards.
class UISummaryGrid extends StatelessWidget {
  const UISummaryGrid({
    super.key,
    required this.items,
    this.crossAxisCount = 2,
    this.childAspectRatio = 1.55,
    this.mainAxisSpacing = 8,
    this.crossAxisSpacing = 8,
    this.padding,
    this.expanded = false,
  });

  final List<UISummaryGridItem> items;
  final int crossAxisCount;
  final double childAspectRatio;
  final double mainAxisSpacing;
  final double crossAxisSpacing;
  final EdgeInsetsGeometry? padding;
  final bool expanded;

  UISummaryGrid copyWith({
    Key? key,
    List<UISummaryGridItem>? items,
    int? crossAxisCount,
    double? childAspectRatio,
    double? mainAxisSpacing,
    double? crossAxisSpacing,
    EdgeInsetsGeometry? padding,
    bool? expanded,
  }) {
    return UISummaryGrid(
      key: key ?? this.key,
      items: items ?? this.items,
      crossAxisCount: crossAxisCount ?? this.crossAxisCount,
      childAspectRatio: childAspectRatio ?? this.childAspectRatio,
      mainAxisSpacing: mainAxisSpacing ?? this.mainAxisSpacing,
      crossAxisSpacing: crossAxisSpacing ?? this.crossAxisSpacing,
      padding: padding ?? this.padding,
      expanded: expanded ?? this.expanded,
    );
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.paddingOf(context).bottom;
    final resolvedPadding =
        padding ?? EdgeInsets.fromLTRB(12, 4, 12, bottom + 8);

    final grid = GridView.builder(
      padding: resolvedPadding,
      shrinkWrap: !expanded,
      physics: expanded ? null : const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        mainAxisSpacing: mainAxisSpacing,
        crossAxisSpacing: crossAxisSpacing,
        childAspectRatio: childAspectRatio,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) => _SummaryGridCard(item: items[index]),
    );

    if (expanded) {
      return Expanded(child: grid);
    }
    return grid;
  }
}

class _SummaryGridCard extends StatelessWidget {
  const _SummaryGridCard({required this.item});

  final UISummaryGridItem item;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final labelWidget =
        item.labelChild ??
        UIText(
          item.label!,
          maxLines: 1,
          textOverflow: TextOverflow.ellipsis,
          style: theme.textTheme.labelMedium?.copyWith(
            fontWeight: FontWeight.w600,
            height: 1.2,
          ),
        );

    return Card(
      elevation: theme.brightness == Brightness.dark ? 0 : 1,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: theme.dividerColor.withValues(alpha: 0.6)),
      ),
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(width: 36, height: 36, child: item.icon),
              const SizedBox(width: 6),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    labelWidget,
                    const SizedBox(height: 2),
                    DefaultTextStyle.merge(
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                      child: item.value,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
