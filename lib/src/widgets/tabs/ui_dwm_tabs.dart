import 'package:flutter/material.dart';

import '../text/ui_text.dart';

/// Labels for Day / Week / Month period tabs.
class UIDwmTabLabels {
  const UIDwmTabLabels({
    required this.dayLabel,
    required this.weekLabel,
    required this.monthLabel,
  });

  final String dayLabel;
  final String weekLabel;
  final String monthLabel;

  UIDwmTabLabels copyWith({
    String? dayLabel,
    String? weekLabel,
    String? monthLabel,
  }) {
    return UIDwmTabLabels(
      dayLabel: dayLabel ?? this.dayLabel,
      weekLabel: weekLabel ?? this.weekLabel,
      monthLabel: monthLabel ?? this.monthLabel,
    );
  }
}

/// Builds a standard list of tabs for Day / Week / Month selection.
List<Tab> buildDwmTabs({
  required String dayLabel,
  required String weekLabel,
  required String monthLabel,
  TextStyle? labelStyle,
}) {
  return buildDwmTabsFromLabels(
    UIDwmTabLabels(
      dayLabel: dayLabel,
      weekLabel: weekLabel,
      monthLabel: monthLabel,
    ),
    labelStyle: labelStyle,
  );
}

/// Builds DWM tabs from a [UIDwmTabLabels] value.
List<Tab> buildDwmTabsFromLabels(
  UIDwmTabLabels labels, {
  TextStyle? labelStyle,
}) {
  Tab dwmTab(String label) {
    return Tab(
      child: Align(
        alignment: Alignment.center,
        child: UIText(
          label,
          style: labelStyle,
        ),
      ),
    );
  }

  return <Tab>[
    dwmTab(labels.dayLabel),
    dwmTab(labels.weekLabel),
    dwmTab(labels.monthLabel),
  ];
}

/// Builds a [TabBar] styled for Day / Week / Month detail screens.
///
/// Used by [UITabbedDetailScaffold] and any custom period-selector layout.
TabBar buildDwmTabBar(
  BuildContext context, {
  required List<Tab> tabs,
  ValueChanged<int>? onTap,
}) {
  final theme = Theme.of(context);
  return TabBar(
    tabs: tabs,
    onTap: onTap,
    indicatorSize: TabBarIndicatorSize.tab,
    indicator: BoxDecoration(
      color: theme.cardColor,
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(12),
        topRight: Radius.circular(12),
      ),
    ),
    labelColor: theme.colorScheme.onSurface,
    unselectedLabelColor: Colors.white,
    labelStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
    unselectedLabelStyle: const TextStyle(
      fontWeight: FontWeight.w500,
      fontSize: 14,
    ),
  );
}
