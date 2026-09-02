import 'package:flutter/material.dart';

import '../../core/theme/ui_breakpoints.dart';

/// Navigation destination model for [UIAdaptiveScaffold].
class UIAdaptiveDestination {
  const UIAdaptiveDestination({
    required this.icon,
    required this.label,
    this.selectedIcon,
    this.tooltip,
  });

  final Widget icon;
  final Widget? selectedIcon;
  final String label;
  final String? tooltip;
}

/// Responsive scaffold that adapts navigation layouts based on screen width.
///
/// Automatically switches between a bottom [NavigationBar] on mobile screens,
/// a compact [NavigationRail] on tablet screens, and an extended [NavigationRail]
/// or side drawer on desktop screens.
class UIAdaptiveScaffold extends StatelessWidget {
  const UIAdaptiveScaffold({
    super.key,
    required this.body,
    required this.destinations,
    required this.selectedIndex,
    this.onDestinationSelected,
    this.appBar,
    this.floatingActionButton,
    this.drawer,
    this.endDrawer,
    this.backgroundColor,
    this.mobileBreakpoint = UIBreakpoints.mobile,
    this.desktopBreakpoint = UIBreakpoints.desktop,
  }) : assert(destinations.length >= 2);

  /// Main content body.
  final Widget body;

  /// Navigation destinations.
  final List<UIAdaptiveDestination> destinations;

  /// Index of the currently selected destination.
  final int selectedIndex;

  /// Callback when a destination is selected.
  final ValueChanged<int>? onDestinationSelected;

  /// App bar displayed at top.
  final PreferredSizeWidget? appBar;

  /// Floating action button.
  final Widget? floatingActionButton;

  /// Drawer for mobile/tablet.
  final Widget? drawer;

  /// End drawer.
  final Widget? endDrawer;

  /// Background color.
  final Color? backgroundColor;

  /// Width threshold below which bottom navigation is used.
  final double mobileBreakpoint;

  /// Width threshold above which extended rail is used.
  final double desktopBreakpoint;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final isMobile = width < mobileBreakpoint;
    final isDesktop = width >= desktopBreakpoint;

    if (isMobile) {
      return Scaffold(
        appBar: appBar,
        body: body,
        drawer: drawer,
        endDrawer: endDrawer,
        floatingActionButton: floatingActionButton,
        backgroundColor: backgroundColor,
        bottomNavigationBar: NavigationBar(
          selectedIndex: selectedIndex,
          onDestinationSelected: onDestinationSelected,
          destinations: destinations
              .map(
                (d) => NavigationDestination(
                  icon: d.icon,
                  selectedIcon: d.selectedIcon,
                  label: d.label,
                  tooltip: d.tooltip,
                ),
              )
              .toList(),
        ),
      );
    }

    return Scaffold(
      appBar: appBar,
      drawer: drawer,
      endDrawer: endDrawer,
      floatingActionButton: floatingActionButton,
      backgroundColor: backgroundColor,
      body: Row(
        children: [
          NavigationRail(
            selectedIndex: selectedIndex,
            onDestinationSelected: onDestinationSelected,
            extended: isDesktop,
            destinations: destinations
                .map(
                  (d) => NavigationRailDestination(
                    icon: d.icon,
                    selectedIcon: d.selectedIcon ?? d.icon,
                    label: Text(d.label),
                  ),
                )
                .toList(),
          ),
          const VerticalDivider(thickness: 1, width: 1),
          Expanded(child: body),
        ],
      ),
    );
  }
}
