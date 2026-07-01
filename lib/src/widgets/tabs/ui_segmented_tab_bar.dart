import 'package:flutter/material.dart';
import '../buttons/ui_tab_text_button.dart';

/// Represents an item in the [UISegmentedTabBar].
class UISegmentTabItem {
  /// The display label.
  final String label;

  /// The underlying value.
  final String value;

  /// Whether this tab is currently selected.
  final bool isActive;

  /// Creates a [UISegmentTabItem].
  const UISegmentTabItem({
    required this.label,
    required this.value,
    required this.isActive,
  });

  UISegmentTabItem copyWith({String? label, String? value, bool? isActive}) {
    return UISegmentTabItem(
      label: label ?? this.label,
      value: value ?? this.value,
      isActive: isActive ?? this.isActive,
    );
  }
}

/// A segmented control used for switching between mutually exclusive options.
class UISegmentedTabBar extends StatelessWidget {
  /// Whether the tab bar should take up the full width or be compact.
  final bool isWide;

  /// Callback when a tab is pressed.
  final ValueChanged<int> onTabPressed;

  /// The list of tabs to display.
  final List<UISegmentTabItem> tabs;

  /// Creates a [UISegmentedTabBar].
  const UISegmentedTabBar({
    super.key,
    required this.isWide,
    required this.onTabPressed,
    required this.tabs,
  });

  UISegmentedTabBar copyWith({
    Key? key,
    bool? isWide,
    ValueChanged<int>? onTabPressed,
    List<UISegmentTabItem>? tabs,
  }) {
    return UISegmentedTabBar(
      key: key ?? this.key,
      isWide: isWide ?? this.isWide,
      onTabPressed: onTabPressed ?? this.onTabPressed,
      tabs: tabs ?? this.tabs,
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      height: kToolbarHeight - 10,
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: const BorderRadius.all(Radius.circular(8.0)),
        boxShadow: isWide
            ? [
                BoxShadow(
                  color: colorScheme.shadow.withValues(alpha: 0.12),
                  blurRadius: 2,
                ),
              ]
            : null,
      ),
      child: Row(
        mainAxisAlignment: isWide
            ? MainAxisAlignment.start
            : MainAxisAlignment.spaceBetween,
        mainAxisSize: isWide ? MainAxisSize.min : MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          for (int i = 0; i < tabs.length; i++) ...[
            SizedBox(width: isWide ? 8 : 4),
            UITabTextButton(
              isActive: tabs[i].isActive,
              title: tabs[i].label,
              value: tabs[i].value,
              isCompact: !isWide,
              onPressed: () => onTabPressed(i),
            ),
          ],
          SizedBox(width: isWide ? 8 : 4),
        ],
      ),
    );
  }
}
