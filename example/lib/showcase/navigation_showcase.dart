import 'package:flutter/material.dart';
import 'package:vvk_ui_kit/vvk_ui_kit.dart';

import 'common.dart';
import 'showcase_scaffold.dart';

class NavigationShowcase extends StatelessWidget {
  const NavigationShowcase({
    super.key,
    required this.themeMode,
    required this.onThemeModeChanged,
  });

  final ThemeMode themeMode;
  final ValueChanged<ThemeMode> onThemeModeChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ShowcaseScaffold(
      title: 'Navigation',
      child: Column(
        children: [
          ShowcaseTile(name: 'UIBottomNavyBar', child: _BottomNavyBarDemo()),
          ShowcaseTile(
            name: 'UIFloatingBottomBar',
            child: _FloatingBottomBarDemo(),
          ),
          ShowcaseTile(
            name: 'UIGlassAppBar',
            child: UIGlassAppBar.fromTheme(
              context,
              title: 'Glass app bar',
              actions: [
                IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
              ],
            ),
          ),
          ShowcaseTile(
            name: 'UIGlassBottomNavBar',
            child: _GlassBottomNavBarDemo(),
          ),
          ShowcaseTile(
            name: 'UIBreadcrumb',
            child: UIBreadcrumb(
              items: [
                UIBreadcrumbItem(label: 'Home', onTap: () {}),
                UIBreadcrumbItem(label: 'Projects', onTap: () {}),
                const UIBreadcrumbItem(label: 'UI Kit', isCurrent: true),
              ],
            ),
          ),
          ShowcaseTile(name: 'UIMenuBar', child: _MenuBarDemo()),
          ShowcaseTile(name: 'UITreeView', child: _TreeViewDemo()),
          ShowcaseTile(
            name: 'UIContextMenuRegion',
            child: UIContextMenuRegion(
              items: const [
                UIContextMenuItem(label: 'Edit', icon: Icons.edit_outlined),
                UIContextMenuItem(
                  label: 'Delete',
                  icon: Icons.delete_outline,
                  destructive: true,
                ),
              ],
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  border: Border.all(color: theme.dividerColor),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text('Long-press or right-click me'),
              ),
            ),
          ),
          ShowcaseTile(
            name: 'UIAppBar (standard)',
            child: UIAppBar(title: 'Standard', showBackButton: false),
          ),
          ShowcaseTile(
            name: 'UIAppBar.accent',
            child: UIAppBar.accent(
              title: 'Accent bar',
              accentColor: theme.colorScheme.primary,
            ),
          ),
          ShowcaseTile(
            name: 'UIAppBar.brand',
            child: UIAppBar.brand(title: 'Brand bar'),
          ),
          ShowcaseTile(
            name: 'UIAvatarWithEdit',
            child: Center(
              child: UIAvatarWithEdit(
                displayName: 'Jane Doe',
                initials: initialsFromName('Jane Doe'),
                onTap: () {},
              ),
            ),
          ),
          ShowcaseTile(
            name: 'UIDetailActivityHeader',
            child: UIDetailActivityHeader(label: 'Running'),
          ),
          ShowcaseTile(
            name: 'UIDetailDateNavigator',
            child: UIDetailDateNavigator(
              dateTitle: 'Mon, Jun 17',
              isNextDisabled: false,
              onPrevious: () {},
              onNext: () {},
            ),
          ),
          ShowcaseTile(
            name: 'UITitleWithBorderedLine',
            child: UITitleWithBorderedLine(
              text: 'Section title',
              dividerColor: theme.dividerColor,
            ),
          ),
          ShowcaseTile(
            name: 'UITitleWithSwitch',
            child: UITitleWithSwitch.fromTheme(context, 'Enable feature'),
          ),
          ShowcaseTile(
            name: 'UIThemeToggleButton',
            child: Align(
              alignment: Alignment.centerLeft,
              child: UIThemeToggleButton(
                themeMode: themeMode,
                onThemeModeChanged: onThemeModeChanged,
                tooltipLightMode: 'Light',
                tooltipDarkMode: 'Dark',
              ),
            ),
          ),
          ShowcaseTile(
            name: 'UIDetailScrollLayout',
            child: SizedBox(
              height: 220,
              child: UIDetailScrollLayout(
                activityLabel: 'Activity',
                dateTitle: 'Today',
                isNextDisabled: true,
                onPreviousDay: () {},
                onNextDay: () {},
                chart: Container(
                  height: 100,
                  color: theme.colorScheme.primaryContainer,
                  alignment: Alignment.center,
                  child: const Text('Chart area'),
                ),
              ),
            ),
          ),
          ShowcaseTile(
            name: 'UISettingsPageScaffold',
            child: UIPrimaryTextButton(
              text: 'Open settings scaffold',
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => UISettingsPageScaffold(
                    title: 'Settings',
                    onSave: () => Navigator.pop(context),
                    body: ListView(
                      padding: const EdgeInsets.all(16),
                      children: const [
                        UISettingsSectionLabel(label: 'Account'),
                        UISettingsNavigationTile(title: 'Profile'),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          ShowcaseTile(
            name: 'UITabbedDetailScaffold',
            child: UIPrimaryTextButton(
              text: 'Open tabbed detail',
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => UITabbedDetailScaffold(
                    title: 'Analytics',
                    accentColor: theme.colorScheme.primary,
                    tabs: [
                      Tab(
                        child: Align(
                          alignment: Alignment.center,
                          child: UIText('Day'),
                        ),
                      ),
                      Tab(
                        child: Align(
                          alignment: Alignment.center,
                          child: UIText('Week'),
                        ),
                      ),
                      Tab(
                        child: Align(
                          alignment: Alignment.center,
                          child: UIText('Month'),
                        ),
                      ),
                    ],
                    tabViews: const [
                      Center(child: Text('Day view')),
                      Center(child: Text('Week view')),
                      Center(child: Text('Month view')),
                    ],
                  ),
                ),
              ),
            ),
          ),
          ShowcaseTile(
            name: 'UIAccentTabDetailScaffold',
            child: UIPrimaryTextButton(
              text: 'Open accent tab detail',
              hasBorder: true,
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => UIAccentTabDetailScaffold(
                    title: 'Reports',
                    tabs: const [
                      Tab(text: 'D'),
                      Tab(text: 'W'),
                      Tab(text: 'M'),
                    ],
                    tabViews: const [
                      Center(child: Text('Daily')),
                      Center(child: Text('Weekly')),
                      Center(child: Text('Monthly')),
                    ],
                  ),
                ),
              ),
            ),
          ),
          ShowcaseTile(
            name: 'UIDoubleBackToExit',
            child: UIPrimaryTextButton(
              text: 'Open double-back demo',
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => UIDoubleBackToExit(
                    child: Scaffold(
                      appBar: AppBar(title: const Text('Double back')),
                      body: const Center(
                        child: Text('Press back twice quickly to exit'),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          ShowcaseTile(
            name: 'UISideMenu',
            child: UIPrimaryTextButton(
              text: 'Open side menu demo',
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute<void>(builder: (_) => const _SideMenuDemo()),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SideMenuDemo extends StatelessWidget {
  const _SideMenuDemo();

  @override
  Widget build(BuildContext context) {
    return UISideMenu(
      menu: const Drawer(
        child: SafeArea(child: ListTile(title: Text('Menu item'))),
      ),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Side menu'),
          leading: Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () => UISideMenu.of(context)?.openSideMenu(),
            ),
          ),
        ),
        body: Center(
          child: UIPrimaryTextButton(
            text: 'Close menu',
            onPressed: () => UISideMenu.of(context)?.closeSideMenu(),
          ),
        ),
      ),
    );
  }
}

class _FloatingBottomBarDemo extends StatefulWidget {
  @override
  State<_FloatingBottomBarDemo> createState() => _FloatingBottomBarDemoState();
}

class _FloatingBottomBarDemoState extends State<_FloatingBottomBarDemo> {
  int _selected = 2;

  @override
  Widget build(BuildContext context) {
    return UIFloatingBottomBar.fromTheme(
      context,
      currentIndex: _selected,
      onTap: (index) => setState(() => _selected = index),
      leftItems: const [
        UIFloatingBottomBarItem(icon: Icon(Icons.home_outlined), label: 'Home'),
        UIFloatingBottomBarItem(
          icon: Icon(Icons.search_outlined),
          label: 'Search',
        ),
      ],
      rightItems: const [
        UIFloatingBottomBarItem(
          icon: Icon(Icons.notifications_outlined),
          label: 'Alerts',
        ),
        UIFloatingBottomBarItem(
          icon: Icon(Icons.person_outline),
          label: 'Profile',
        ),
      ],
      centerAction: const UIFloatingBottomBarCenterAction(
        icon: Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

class _BottomNavyBarDemo extends StatefulWidget {
  @override
  State<_BottomNavyBarDemo> createState() => _BottomNavyBarDemoState();
}

class _GlassBottomNavBarDemo extends StatefulWidget {
  @override
  State<_GlassBottomNavBarDemo> createState() => _GlassBottomNavBarDemoState();
}

class _GlassBottomNavBarDemoState extends State<_GlassBottomNavBarDemo> {
  int _selected = 0;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.primary,
            Theme.of(context).colorScheme.secondary,
          ],
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: UIGlassBottomNavBar.fromTheme(
        context,
        currentIndex: _selected,
        onTap: (index) => setState(() => _selected = index),
        items: const [
          UIGlassBottomNavBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          UIGlassBottomNavBarItem(icon: Icon(Icons.search), label: 'Search'),
          UIGlassBottomNavBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

class _BottomNavyBarDemoState extends State<_BottomNavyBarDemo> {
  int _selected = 0;

  @override
  Widget build(BuildContext context) {
    return UIBottomNavyBar.fromTheme(
      context,
      selectedIndex: _selected,
      onItemSelected: (index) => setState(() => _selected = index),
      items: const [
        UIBottomNavyBarItem(icon: Icon(Icons.home_outlined), label: 'Home'),
        UIBottomNavyBarItem(
          icon: Icon(Icons.chat_bubble_outline),
          label: 'Chat',
        ),
        UIBottomNavyBarItem(icon: Icon(Icons.person_outline), label: 'Profile'),
      ],
    );
  }
}

class _MenuBarDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return UIMenuBar.fromTheme(
      context,
      items: const [
        UIMenuBarItem(
          label: 'File',
          actions: [
            UIMenuBarAction(label: 'New', icon: Icons.add),
            UIMenuBarAction(label: 'Open', icon: Icons.folder_open_outlined),
            UIMenuBarAction(
              label: 'Share',
              icon: Icons.share_outlined,
              children: [
                UIMenuBarAction(label: 'Copy link'),
                UIMenuBarAction(label: 'Export PDF'),
              ],
            ),
          ],
        ),
        UIMenuBarItem(
          label: 'Edit',
          actions: [
            UIMenuBarAction(label: 'Undo', icon: Icons.undo),
            UIMenuBarAction(label: 'Redo', icon: Icons.redo),
            UIMenuBarAction(
              label: 'Delete',
              icon: Icons.delete_outline,
              destructive: true,
            ),
          ],
        ),
      ],
    );
  }
}

class _TreeViewDemo extends StatefulWidget {
  @override
  State<_TreeViewDemo> createState() => _TreeViewDemoState();
}

class _TreeViewDemoState extends State<_TreeViewDemo> {
  final _expanded = {'docs', 'design'};
  final _selected = <String>{'colors'};

  @override
  Widget build(BuildContext context) {
    return UITreeView.fromTheme(
      context,
      selectionMode: UITreeViewSelectionMode.single,
      expandedKeys: _expanded,
      selectedKeys: _selected,
      onExpansionChanged: (keys) => setState(() {
        _expanded
          ..clear()
          ..addAll(keys);
      }),
      onSelectionChanged: (keys) => setState(() {
        _selected
          ..clear()
          ..addAll(keys);
      }),
      nodes: [
        UITreeNode(
          key: 'docs',
          label: 'Documents',
          icon: Icons.folder_outlined,
          children: [
            UITreeNode(
              key: 'design',
              label: 'Design',
              icon: Icons.palette_outlined,
              children: [
                UITreeNode(
                  key: 'colors',
                  label: 'Colors',
                  icon: Icons.color_lens_outlined,
                ),
                UITreeNode(
                  key: 'typography',
                  label: 'Typography',
                  icon: Icons.text_fields_outlined,
                ),
              ],
            ),
            UITreeNode(key: 'notes', label: 'Notes', icon: Icons.note_outlined),
          ],
        ),
        UITreeNode(
          key: 'downloads',
          label: 'Downloads',
          icon: Icons.download_outlined,
        ),
      ],
    );
  }
}
