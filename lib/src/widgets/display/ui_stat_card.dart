import 'package:flutter/material.dart';
import '../../core/theme/ui_theme.dart';
import '../text/ui_text.dart';

/// Represents a single statistic item with a label and a value.
class UIStatSummaryItem {
  /// Creates a [UIStatSummaryItem].
  const UIStatSummaryItem({required this.label, required this.value});

  /// The label describing the statistic.
  final String label;

  /// The value of the statistic.
  final String value;
}

/// A card that displays a row of statistics.
class UIStatSummaryCard extends StatelessWidget {
  /// Creates a [UIStatSummaryCard].
  const UIStatSummaryCard({super.key, required this.items});

  /// The list of statistics to display.
  final List<UIStatSummaryItem> items;

  UIStatSummaryCard copyWith({Key? key, List<UIStatSummaryItem>? items}) {
    return UIStatSummaryCard(key: key ?? this.key, items: items ?? this.items);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: theme.dividerColor.withValues(alpha: 0.5)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 4),
        child: IntrinsicHeight(
          child: Row(
            children: [
              for (var i = 0; i < items.length; i++) ...[
                if (i > 0)
                  VerticalDivider(
                    width: 1,
                    thickness: 1,
                    color: theme.dividerColor,
                  ),
                Expanded(child: _StatCell(item: items[i])),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _StatCell extends StatelessWidget {
  const _StatCell({required this.item});

  final UIStatSummaryItem item;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final subtitle = context.uiTheme.subtitleColor;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 40,
            child: Center(
              child: UIText(
                item.label,
                textAlign: TextAlign.center,
                maxLines: 2,
                textOverflow: TextOverflow.ellipsis,
                style: theme.textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: subtitle,
                  height: 1.2,
                  fontSize: 12,
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          UIText(
            item.value,
            textAlign: TextAlign.center,
            maxLines: 1,
            textOverflow: TextOverflow.ellipsis,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w700,
              fontSize: 22,
              height: 1,
            ),
          ),
        ],
      ),
    );
  }
}

/// A row displaying a current reading with an icon and a value.
class UICurrentReadingRow extends StatelessWidget {
  /// Creates a [UICurrentReadingRow].
  const UICurrentReadingRow({
    super.key,
    required this.icon,
    required this.value,
    this.accentColor,
    this.iconSize = 44,
  });

  /// The icon representing the reading.
  final Widget icon;

  /// The value of the reading.
  final String value;

  /// Optional accent color for the icon background.
  final Color? accentColor;

  /// Size of the icon.
  final double iconSize;

  UICurrentReadingRow copyWith({
    Key? key,
    Widget? icon,
    String? value,
    Color? accentColor,
    double? iconSize,
  }) {
    return UICurrentReadingRow(
      key: key ?? this.key,
      icon: icon ?? this.icon,
      value: value ?? this.value,
      accentColor: accentColor ?? this.accentColor,
      iconSize: iconSize ?? this.iconSize,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final accent = accentColor ?? theme.colorScheme.primary;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      child: Row(
        children: [
          Container(
            width: iconSize + 8,
            height: iconSize + 8,
            decoration: BoxDecoration(
              color: accent.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(14),
            ),
            alignment: Alignment.center,
            child: icon,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: UIText(
              value,
              maxLines: 1,
              textOverflow: TextOverflow.ellipsis,
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// A standard section header with an optional icon and title.
class UISectionHeader extends StatelessWidget {
  /// Creates a [UISectionHeader].
  const UISectionHeader({
    super.key,
    required this.title,
    this.icon,
    this.iconColor,
  });

  /// The title text.
  final String title;

  /// Optional icon to display before the title.
  final IconData? icon;

  /// Optional color for the icon.
  final Color? iconColor;

  UISectionHeader copyWith({
    Key? key,
    String? title,
    IconData? icon,
    Color? iconColor,
  }) {
    return UISectionHeader(
      key: key ?? this.key,
      title: title ?? this.title,
      icon: icon ?? this.icon,
      iconColor: iconColor ?? this.iconColor,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      child: Row(
        children: [
          if (icon != null) ...[
            Icon(icon, color: iconColor ?? theme.colorScheme.primary, size: 22),
            const SizedBox(width: 8),
          ],
          Expanded(
            child: UIText(
              title,
              fontWeight: FontWeight.w600,
              style: theme.textTheme.titleSmall,
            ),
          ),
        ],
      ),
    );
  }
}

/// A simple data table with labeled columns and rows.
class UILabeledDataTable extends StatelessWidget {
  /// Creates a [UILabeledDataTable].
  const UILabeledDataTable({
    super.key,
    required this.columns,
    required this.rows,
  });

  /// The list of column headers.
  final List<String> columns;

  /// The list of rows, each containing a list of strings.
  final List<List<String>> rows;

  UILabeledDataTable copyWith({
    Key? key,
    List<String>? columns,
    List<List<String>>? rows,
  }) {
    return UILabeledDataTable(
      key: key ?? this.key,
      columns: columns ?? this.columns,
      rows: rows ?? this.rows,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final labelStyle = theme.textTheme.labelMedium?.copyWith(
      fontWeight: FontWeight.w600,
      color: theme.colorScheme.onSurface.withValues(alpha: 0.65),
    );
    final valueStyle = theme.textTheme.bodyMedium?.copyWith(
      fontWeight: FontWeight.w500,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          Row(
            children: [
              for (var i = 0; i < columns.length; i++)
                Expanded(
                  flex: i == 0 ? 2 : 3,
                  child: UIText(
                    columns[i],
                    textAlign: i == 0 ? TextAlign.start : TextAlign.center,
                    style: labelStyle,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          ...rows.map(
            (row) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Row(
                children: [
                  for (var i = 0; i < row.length; i++)
                    Expanded(
                      flex: i == 0 ? 2 : 3,
                      child: UIText(
                        row[i],
                        textAlign: i == 0 ? TextAlign.start : TextAlign.center,
                        style: valueStyle,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
