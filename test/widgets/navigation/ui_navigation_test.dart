import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vvk_ui_kit/vvk_ui_kit.dart';

void main() {
  group('UIAppBar', () {
    testWidgets('renders title and responds to back press', (tester) async {
      bool backPressed = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            appBar: UIAppBar(
              title: 'AppBar Title',
              showBackButton: true,
              onBackPressed: () => backPressed = true,
            ),
            body: Container(),
          ),
        ),
      );

      expect(find.text('AppBar Title'), findsOneWidget);
      await tester.tap(find.byIcon(Icons.arrow_back_ios_new));
      expect(backPressed, isTrue);
    });

    testWidgets('accent variant renders correctly', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            appBar: UIAppBar.accent(
              title: 'Accent Title',
              accentColor: Colors.blue,
            ),
            body: SizedBox.shrink(),
          ),
        ),
      );

      expect(find.text('Accent Title'), findsOneWidget);
      final appBar = tester.widget<AppBar>(find.byType(AppBar));
      expect(appBar.backgroundColor, Colors.blue);
    });
  });

  group('UIDoubleBackToExit', () {
    testWidgets('shows reminder on first back press', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: UIDoubleBackToExit(
            message: 'Press back again',
            child: Scaffold(body: Text('Home')),
          ),
        ),
      );

      final handled = await tester.binding.handlePopRoute();
      expect(handled, isTrue);
      await tester.pump();

      expect(find.text('Press back again'), findsOneWidget);
    });
  });

  group('UIBottomNavyBar', () {
    testWidgets('renders labels for selected item only', (tester) async {
      var selected = 0;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) {
                return UIBottomNavyBar.fromTheme(
                  context,
                  selectedIndex: selected,
                  onItemSelected: (index) => setState(() => selected = index),
                  items: const [
                    UIBottomNavyBarItem(
                      icon: Icon(Icons.home_outlined),
                      label: 'Home',
                    ),
                    UIBottomNavyBarItem(
                      icon: Icon(Icons.search_outlined),
                      label: 'Search',
                    ),
                    UIBottomNavyBarItem(
                      icon: Icon(Icons.person_outline),
                      label: 'Profile',
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      );

      expect(find.text('Home'), findsOneWidget);
      expect(find.text('Search'), findsNothing);
      expect(find.text('Profile'), findsNothing);

      await tester.tap(find.byIcon(Icons.search_outlined));
      await tester.pumpAndSettle();

      expect(find.text('Home'), findsNothing);
      expect(find.text('Search'), findsOneWidget);
      expect(find.text('Profile'), findsNothing);
    });

    testWidgets('asserts when item count is out of range', (tester) async {
      expect(
        () => UIBottomNavyBar(
          backgroundColor: Colors.white,
          items: const [
            UIBottomNavyBarItem(icon: Icon(Icons.home), label: 'Home'),
          ],
          onItemSelected: (_) {},
        ),
        throwsAssertionError,
      );
    });
  });

  group('UIFloatingBottomBar', () {
    testWidgets('renders center action and side items', (tester) async {
      var selected = 0;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) {
                return UIFloatingBottomBar.fromTheme(
                  context,
                  currentIndex: selected,
                  onTap: (index) => setState(() => selected = index),
                  leftItems: const [
                    UIFloatingBottomBarItem(
                      icon: Icon(Icons.home_outlined),
                      label: 'Home',
                    ),
                  ],
                  rightItems: const [
                    UIFloatingBottomBarItem(
                      icon: Icon(Icons.person_outline),
                      label: 'Profile',
                    ),
                  ],
                  centerAction: const UIFloatingBottomBarCenterAction(
                    icon: Icon(Icons.add, color: Colors.white),
                  ),
                );
              },
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.add), findsOneWidget);
      expect(find.text('Home'), findsOneWidget);

      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();
      expect(selected, 1);
    });
  });

  group('UIGlassAppBar', () {
    testWidgets('renders title inside glass app bar', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) => Scaffold(
              appBar: UIGlassAppBar.fromTheme(
                context,
                title: 'Glass Title',
              ),
              body: const SizedBox.shrink(),
            ),
          ),
        ),
      );

      expect(find.text('Glass Title'), findsOneWidget);
      expect(find.byType(BackdropFilter), findsOneWidget);
    });
  });

  group('UIGlassBottomNavBar', () {
    testWidgets('renders items and reports selection', (tester) async {
      var selected = 0;

      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) => Scaffold(
              body: UIGlassBottomNavBar.fromTheme(
                context,
                currentIndex: selected,
                onTap: (index) => selected = index,
                items: const [
                  UIGlassBottomNavBarItem(
                    icon: Icon(Icons.home),
                    label: 'Home',
                  ),
                  UIGlassBottomNavBarItem(
                    icon: Icon(Icons.settings),
                    label: 'Settings',
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      expect(find.text('Home'), findsOneWidget);
      expect(find.text('Settings'), findsOneWidget);
      await tester.tap(find.text('Settings'));
      expect(selected, 1);
    });
  });

  group('UITitleWithSwitch', () {
    testWidgets('fromTheme renders title and switch', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) =>
                  UITitleWithSwitch.fromTheme(context, 'Notifications'),
            ),
          ),
        ),
      );

      expect(find.text('Notifications'), findsOneWidget);
      expect(find.byType(Switch), findsOneWidget);
    });
  });

  group('UITreeView', () {
    testWidgets('expands node and shows children', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) => Scaffold(
              body: UITreeView.fromTheme(
                context,
                nodes: [
                  UITreeNode(
                    key: 'parent',
                    label: 'Parent',
                    children: [
                      UITreeNode(key: 'child', label: 'Child'),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      expect(find.text('Child'), findsNothing);
      await tester.tap(find.text('Parent'));
      await tester.pump();

      expect(find.text('Child'), findsOneWidget);
    });
  });

  group('UIMenuBar', () {
    testWidgets('renders top-level menu labels', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) => Scaffold(
              body: UIMenuBar.fromTheme(
                context,
                items: const [
                  UIMenuBarItem(
                    label: 'File',
                    actions: [UIMenuBarAction(label: 'New')],
                  ),
                  UIMenuBarItem(
                    label: 'Edit',
                    actions: [UIMenuBarAction(label: 'Undo')],
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      expect(find.text('File'), findsOneWidget);
      expect(find.text('Edit'), findsOneWidget);
    });
  });

  group('UIBreadcrumb', () {
    testWidgets('renders items with separators', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: UIBreadcrumb(
              items: [
                UIBreadcrumbItem(label: 'Home', onTap: null),
                UIBreadcrumbItem(label: 'Library', onTap: null),
                UIBreadcrumbItem(label: 'Data', isCurrent: true),
              ],
            ),
          ),
        ),
      );

      expect(find.text('Home'), findsOneWidget);
      expect(find.text('Data'), findsOneWidget);
      expect(find.byIcon(Icons.chevron_right), findsWidgets);
    });

    testWidgets('collapses long trails when maxItems is set', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: UIBreadcrumb(
              maxItems: 3,
              items: [
                UIBreadcrumbItem(label: 'A'),
                UIBreadcrumbItem(label: 'B'),
                UIBreadcrumbItem(label: 'C'),
                UIBreadcrumbItem(label: 'D'),
              ],
            ),
          ),
        ),
      );

      expect(find.text('...'), findsOneWidget);
      expect(find.text('D'), findsOneWidget);
    });
  });

  group('UIContextMenu', () {
    testWidgets('opens menu on long press', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: UIContextMenuRegion(
              items: const [
                UIContextMenuItem(label: 'Copy', icon: Icons.copy),
                UIContextMenuItem(label: 'Delete', icon: Icons.delete),
              ],
              child: Container(
                width: 200,
                height: 80,
                color: Colors.blue,
                child: const Text('Long press'),
              ),
            ),
          ),
        ),
      );

      await tester.longPress(find.text('Long press'));
      await tester.pumpAndSettle();
      expect(find.text('Copy'), findsOneWidget);
      expect(find.text('Delete'), findsOneWidget);
    });
  });

  group('UIThemeToggleButton', () {
    testWidgets('toggles theme mode', (tester) async {
      ThemeMode? changed;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: UIThemeToggleButton(
              themeMode: ThemeMode.light,
              onThemeModeChanged: (mode) => changed = mode,
              tooltipLightMode: 'Light',
              tooltipDarkMode: 'Dark',
            ),
          ),
        ),
      );

      await tester.tap(find.byType(IconButton));
      expect(changed, ThemeMode.dark);
    });
  });

  group('UITitleWithBorderedLine', () {
    testWidgets('renders title', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: UITitleWithBorderedLine(
              text: 'Section',
              dividerColor: Colors.blue,
            ),
          ),
        ),
      );

      expect(find.text('Section'), findsOneWidget);
    });
  });

  group('UISideMenu', () {
    testWidgets('opens and closes side menu', (tester) async {
      var opened = false;
      final menuKey = GlobalKey<UISideMenuState>();
      await tester.pumpWidget(
        MaterialApp(
          home: UISideMenu(
            key: menuKey,
            menu: const Text('Menu Content'),
            onChange: (val) => opened = val,
            child: const Text('Main Content'),
          ),
        ),
      );

      expect(find.text('Menu Content'), findsOneWidget);
      expect(find.text('Main Content'), findsOneWidget);

      menuKey.currentState?.openSideMenu();
      await tester.pumpAndSettle();
      expect(opened, isTrue);

      menuKey.currentState?.closeSideMenu();
      await tester.pumpAndSettle();
      expect(opened, isFalse);
    });
  });

  group('UIAvatarWithEdit', () {
    testWidgets('renders initials when no image provided', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: UIAvatarWithEdit(displayName: 'John Doe'),
          ),
        ),
      );

      expect(find.text('JD'), findsOneWidget);
    });

    testWidgets('responds to tap', (tester) async {
      var tapped = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: UIAvatarWithEdit(
              displayName: 'John Doe',
              onTap: () => tapped = true,
            ),
          ),
        ),
      );

      await tester.tap(find.byType(UIAvatarWithEdit));
      expect(tapped, isTrue);
    });
  });

  group('UITabbedDetailScaffold', () {
    testWidgets('renders all components', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: UITabbedDetailScaffold(
            title: 'Tabbed Detail',
            accentColor: Colors.blue,
            tabs: const [Tab(text: 'D'), Tab(text: 'W')],
            tabViews: const [Text('Day View'), Text('Week View')],
            header: const Text('Header Widget'),
          ),
        ),
      );

      expect(find.text('Tabbed Detail'), findsOneWidget);
      expect(find.text('Header Widget'), findsOneWidget);
      expect(find.text('D'), findsOneWidget);
      expect(find.text('Day View'), findsOneWidget);

      await tester.tap(find.text('W'));
      await tester.pumpAndSettle();
      expect(find.text('Week View'), findsOneWidget);
    });
  });

  group('UISettingsPageScaffold', () {
    testWidgets('renders title and body', (tester) async {
      var saved = false;
      await tester.pumpWidget(
        MaterialApp(
          home: UISettingsPageScaffold(
            title: 'Settings Title',
            body: const Text('Settings Body'),
            onSave: () => saved = true,
            saveFabTooltip: 'Save Changes',
          ),
        ),
      );

      expect(find.text('Settings Title'), findsOneWidget);
      expect(find.text('Settings Body'), findsOneWidget);

      await tester.tap(find.byType(FloatingActionButton));
      expect(saved, isTrue);
    });
  });

  group('UIDetailDateNavigator', () {
    testWidgets('renders title and fires navigation callbacks', (tester) async {
      var previous = false;
      var next = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: UIDetailDateNavigator(
              dateTitle: 'Today',
              isNextDisabled: false,
              onPrevious: () => previous = true,
              onNext: () => next = true,
            ),
          ),
        ),
      );

      expect(find.text('Today'), findsOneWidget);
      await tester.tap(find.byIcon(Icons.arrow_back_ios_outlined));
      expect(previous, isTrue);
      await tester.tap(find.byIcon(Icons.arrow_forward_ios_outlined));
      expect(next, isTrue);
    });
  });

  group('UIDetailActivityHeader', () {
    testWidgets('renders activity label', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: UIDetailActivityHeader(label: 'Running'),
          ),
        ),
      );

      expect(find.text('Running'), findsOneWidget);
    });
  });

  group('UIDetailScrollLayout', () {
    testWidgets('renders sections', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: UIDetailScrollLayout(
              activityLabel: 'Running',
              dateTitle: 'Today',
              isNextDisabled: true,
              onPreviousDay: () {},
              onNextDay: () {},
              chart: const SizedBox(height: 100, child: Text('Chart')),
              belowChart: const [Text('Stats')],
            ),
          ),
        ),
      );

      expect(find.text('Running'), findsOneWidget);
      expect(find.text('Today'), findsOneWidget);
      expect(find.text('Chart'), findsOneWidget);
      expect(find.text('Stats'), findsOneWidget);
    });
  });

  group('UIAccentTabDetailScaffold', () {
    testWidgets('renders tabs and content', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: UIAccentTabDetailScaffold(
            title: 'Detail',
            tabs: const [Tab(text: 'A'), Tab(text: 'B')],
            tabViews: const [Text('View A'), Text('View B')],
          ),
        ),
      );

      expect(find.text('Detail'), findsOneWidget);
      expect(find.text('View A'), findsOneWidget);
      await tester.tap(find.text('B'));
      await tester.pumpAndSettle();
      expect(find.text('View B'), findsOneWidget);
    });
  });
}
