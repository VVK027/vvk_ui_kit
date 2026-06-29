import 'package:flutter/material.dart';
import 'package:vvk_ui_kit/vvk_ui_kit.dart';

import 'common.dart';
import 'showcase_scaffold.dart';

class TabsShowcase extends StatefulWidget {
  const TabsShowcase({super.key});

  @override
  State<TabsShowcase> createState() => _TabsShowcaseState();
}

class _TabsShowcaseState extends State<TabsShowcase> {
  int _tabIndex = 0;
  int _segmentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    const tabItems = ['Home', 'Stats', 'Profile'];

    return ShowcaseScaffold(
      title: 'Tabs',
      child: Column(
        children: [
          ShowcaseTile(
            name: 'UITabBar',
            child: UITabBar<String>(
              items: tabItems,
              selectedIndex: _tabIndex,
              getTextFromItem: (item) => item,
              onTabClicked: (index, _) => setState(() => _tabIndex = index),
              selectedTextStyle: theme.textTheme.titleSmall!.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
              unSelectedTextStyle: theme.textTheme.titleSmall!,
            ),
          ),
          ShowcaseTile(
            name: 'UISegmentedTabBar',
            child: UISegmentedTabBar(
              isWide: true,
              onTabPressed: (i) => setState(() => _segmentIndex = i),
              tabs: [
                UISegmentTabItem(
                  label: 'Day',
                  value: 'd',
                  isActive: _segmentIndex == 0,
                ),
                UISegmentTabItem(
                  label: 'Week',
                  value: 'w',
                  isActive: _segmentIndex == 1,
                ),
                UISegmentTabItem(
                  label: 'Month',
                  value: 'm',
                  isActive: _segmentIndex == 2,
                ),
              ],
            ),
          ),
          ShowcaseTile(
            name: 'Material TabBar',
            child: DefaultTabController(
              length: 3,
              child: Column(
                children: [
                  const TabBar(
                    tabs: [
                      Tab(text: 'Day'),
                      Tab(text: 'Week'),
                      Tab(text: 'Month'),
                    ],
                  ),
                  const SizedBox(
                    height: 48,
                    child: TabBarView(
                      children: [
                        Center(child: UIText('Day')),
                        Center(child: UIText('Week')),
                        Center(child: UIText('Month')),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          ShowcaseTile(
            name: 'UIButtonsTab',
            child: DefaultTabController(
              length: 3,
              child: Column(
                children: [
                  UIButtonsTab(
                    tabs: const [
                      Tab(text: 'One'),
                      Tab(text: 'Two'),
                      Tab(text: 'Three'),
                    ],
                  ),
                  const SizedBox(
                    height: 80,
                    child: TabBarView(
                      children: [
                        Center(child: UIText('Tab one')),
                        Center(child: UIText('Tab two')),
                        Center(child: UIText('Tab three')),
                      ],
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
