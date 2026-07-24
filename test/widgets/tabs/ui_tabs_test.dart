import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vvk_ui_kit/vvk_ui_kit.dart';

void main() {
  group('UITabBar', () {
    testWidgets('renders items and handles click', (tester) async {
      int clickedIndex = -1;
      final items = ['Tab 1', 'Tab 2', 'Tab 3'];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: UITabBar<String>(
              items: items,
              getTextFromItem: (item) => item,
              onTabClicked: (index, item) => clickedIndex = index,
              selectedTextStyle: const TextStyle(color: Colors.blue),
              unSelectedTextStyle: const TextStyle(color: Colors.grey),
            ),
          ),
        ),
      );

      expect(find.text('Tab 1'), findsOneWidget);
      expect(find.text('Tab 2'), findsOneWidget);
      expect(find.text('Tab 3'), findsOneWidget);

      await tester.tap(find.text('Tab 2'));
      expect(clickedIndex, 1);
    });
  });

  group('UISegmentedTabBar', () {
    testWidgets('renders tabs and handles press', (tester) async {
      int pressedIndex = -1;
      final tabs = [
        const UISegmentTabItem(label: 'Day', value: 'day', isActive: true),
        const UISegmentTabItem(label: 'Week', value: 'week', isActive: false),
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: UISegmentedTabBar(
              isWide: true,
              onTabPressed: (index) => pressedIndex = index,
              tabs: tabs,
            ),
          ),
        ),
      );

      expect(find.text('Day'), findsOneWidget);
      expect(find.text('Week'), findsOneWidget);

      await tester.tap(find.text('Week'));
      expect(pressedIndex, 1);
    });
  });

  group('UIButtonsTab', () {
    testWidgets('renders and handles tab changes', (tester) async {
      var tappedIndex = -1;
      await tester.pumpWidget(
        MaterialApp(
          home: DefaultTabController(
            length: 3,
            child: Scaffold(
              appBar: UIButtonsTab(
                tabs: const [
                  Tab(text: 'Home'),
                  Tab(text: 'Settings'),
                  Tab(text: 'Profile'),
                ],
                onTap: (index) => tappedIndex = index,
              ),
              body: const TabBarView(
                children: [
                  Center(child: Text('Home Screen')),
                  Center(child: Text('Settings Screen')),
                  Center(child: Text('Profile Screen')),
                ],
              ),
            ),
          ),
        ),
      );

      expect(find.text('Home'), findsOneWidget);
      expect(find.text('Settings'), findsOneWidget);

      await tester.tap(find.text('Settings'));
      await tester.pumpAndSettle();

      expect(tappedIndex, 1);
      expect(find.text('Settings Screen'), findsOneWidget);
    });
  });

  group('DWM tab helpers', () {
    test('buildDwmTabs returns three labeled tabs', () {
      final tabs = buildDwmTabs(
        dayLabel: 'Day',
        weekLabel: 'Week',
        monthLabel: 'Month',
      );

      expect(tabs, hasLength(3));
    });

    testWidgets('buildDwmTabBar renders tabs in a scaffold', (tester) async {
      final tabs = buildDwmTabs(
        dayLabel: 'Day',
        weekLabel: 'Week',
        monthLabel: 'Month',
      );

      await tester.pumpWidget(
        MaterialApp(
          theme: UIAppTheme.light,
          home: DefaultTabController(
            length: tabs.length,
            child: Builder(
              builder: (context) {
                return Scaffold(
                  appBar: AppBar(
                    bottom: buildDwmTabBar(context, tabs: tabs),
                  ),
                );
              },
            ),
          ),
        ),
      );

      expect(find.byType(Tab), findsNWidgets(3));
    });
  });
}
