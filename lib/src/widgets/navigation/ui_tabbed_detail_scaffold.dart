import 'package:flutter/material.dart';
import 'ui_app_bar.dart';
import '../text/ui_text.dart';

TabBar _buildDetailTabBar(
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

/// Detail screen scaffold with accent header and tabbed body content.
class UITabbedDetailScaffold extends StatelessWidget {
  const UITabbedDetailScaffold({
    super.key,
    this.title,
    this.titleChild,
    required this.accentColor,
    required this.tabs,
    required this.tabViews,
    this.onBack,
    this.onTabTap,
    this.header,
    this.tabViewPhysics,
    this.centerTitle = false,
    this.appBarActions = const [],
    this.backTooltip,
  }) : assert(
         titleChild != null || title != null,
         'Either title or titleChild must be provided.',
       );

  final String? title;
  final Widget? titleChild;
  final Color accentColor;
  final List<Tab> tabs;
  final List<Widget> tabViews;
  final VoidCallback? onBack;
  final ValueChanged<int>? onTabTap;
  final Widget? header;
  final ScrollPhysics? tabViewPhysics;
  final bool centerTitle;
  final List<Widget> appBarActions;

  /// Tooltip / semantic label for the back button.
  ///
  /// When null, falls back to the locale-aware
  /// [MaterialLocalizations.backButtonTooltip].
  final String? backTooltip;

  UITabbedDetailScaffold copyWith({
    Key? key,
    String? title,
    Widget? titleChild,
    Color? accentColor,
    List<Tab>? tabs,
    List<Widget>? tabViews,
    VoidCallback? onBack,
    ValueChanged<int>? onTabTap,
    Widget? header,
    ScrollPhysics? tabViewPhysics,
    bool? centerTitle,
    List<Widget>? appBarActions,
    String? backTooltip,
  }) {
    return UITabbedDetailScaffold(
      key: key ?? this.key,
      title: title ?? this.title,
      titleChild: titleChild ?? this.titleChild,
      accentColor: accentColor ?? this.accentColor,
      tabs: tabs ?? this.tabs,
      tabViews: tabViews ?? this.tabViews,
      onBack: onBack ?? this.onBack,
      onTabTap: onTabTap ?? this.onTabTap,
      header: header ?? this.header,
      tabViewPhysics: tabViewPhysics ?? this.tabViewPhysics,
      centerTitle: centerTitle ?? this.centerTitle,
      appBarActions: appBarActions ?? this.appBarActions,
      backTooltip: backTooltip ?? this.backTooltip,
    );
  }

  @override
  Widget build(BuildContext context) {
    final onBar = UIAppBar.contrastOn(accentColor);
    final theme = Theme.of(context);
    final titleWidget =
        titleChild ??
        UIText(
          title!,
          color: onBar,
          size: 18,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.2,
        );

    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        appBar: AppBar(
          elevation: 0,
          automaticallyImplyLeading: false,
          centerTitle: centerTitle,
          leading: IconButton(
            tooltip:
                backTooltip ??
                MaterialLocalizations.of(context).backButtonTooltip,
            icon: Icon(
              Icons.arrow_back_ios_new_rounded,
              color: onBar,
              size: 20,
            ),
            onPressed: onBack ?? () => Navigator.of(context).pop(),
          ),
          title: titleWidget,
          foregroundColor: onBar,
          iconTheme: IconThemeData(color: onBar),
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  accentColor,
                  Color.lerp(accentColor, const Color(0xFF0F766E), 0.25)!,
                ],
              ),
            ),
          ),
          backgroundColor: accentColor,
          actions: appBarActions,
          bottom: _buildDetailTabBar(context, tabs: tabs, onTap: onTabTap),
        ),
        body: SafeArea(
          top: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ?header,
              Expanded(
                child: TabBarView(physics: tabViewPhysics, children: tabViews),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Detail scaffold variant with accent-colored tab bar styling.
class UIAccentTabDetailScaffold extends StatelessWidget {
  const UIAccentTabDetailScaffold({
    super.key,
    this.title,
    this.titleChild,
    required this.tabs,
    required this.tabViews,
    this.accentColor,
    this.onBack,
    this.appBarActions = const [],
  }) : assert(
         titleChild != null || title != null,
         'Either title or titleChild must be provided.',
       );

  final String? title;
  final Widget? titleChild;
  final List<Tab> tabs;
  final List<Widget> tabViews;
  final Color? accentColor;
  final VoidCallback? onBack;
  final List<Widget> appBarActions;

  UIAccentTabDetailScaffold copyWith({
    Key? key,
    String? title,
    Widget? titleChild,
    List<Tab>? tabs,
    List<Widget>? tabViews,
    Color? accentColor,
    VoidCallback? onBack,
    List<Widget>? appBarActions,
  }) {
    return UIAccentTabDetailScaffold(
      key: key ?? this.key,
      title: title ?? this.title,
      titleChild: titleChild ?? this.titleChild,
      tabs: tabs ?? this.tabs,
      tabViews: tabViews ?? this.tabViews,
      accentColor: accentColor ?? this.accentColor,
      onBack: onBack ?? this.onBack,
      appBarActions: appBarActions ?? this.appBarActions,
    );
  }

  @override
  Widget build(BuildContext context) {
    return UITabbedDetailScaffold(
      title: title,
      titleChild: titleChild,
      accentColor: accentColor ?? Theme.of(context).colorScheme.primary,
      tabs: tabs,
      tabViews: tabViews,
      onBack: onBack,
      centerTitle: true,
      appBarActions: appBarActions,
    );
  }
}
