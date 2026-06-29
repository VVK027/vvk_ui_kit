import 'package:flutter/material.dart';
import 'package:vvk_ui_kit/vvk_ui_kit.dart';

import 'common.dart';
import 'showcase_scaffold.dart';

class DisplayShowcase extends StatelessWidget {
  const DisplayShowcase({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ShowcaseScaffold(
      title: 'Display',
      child: Column(
        children: [
          ShowcaseTile(
            name: 'UIStatSummaryCard',
            child: UIStatSummaryCard(
              items: const [
                UIStatSummaryItem(label: 'Steps', value: '8,432'),
                UIStatSummaryItem(label: 'Calories', value: '320'),
              ],
            ),
          ),
          ShowcaseTile(
            name: 'UISummaryGrid',
            child: UISummaryGrid(
              items: [
                UISummaryGridItem(
                  icon: const Icon(Icons.directions_walk),
                  label: 'Steps',
                  value: const UIText('8,000'),
                ),
                UISummaryGridItem(
                  icon: const Icon(Icons.local_fire_department),
                  label: 'Calories',
                  value: const UIText('320'),
                ),
              ],
            ),
          ),
          ShowcaseTile(
            name: 'UIStatusBanner.copyWith',
            child:
                const UIStatusBanner(
                  title: 'Status',
                  subtitle: 'Everything looks good',
                  leading: Icon(Icons.check_circle_outline),
                ).copyWith(
                  listTile: const UIListTileProps(
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                  ),
                ),
          ),
          ShowcaseTile(
            name: 'UIDetailInfoBanner',
            child: UIDetailInfoBanner(text: 'Informational banner message'),
          ),
          ShowcaseTile(
            name: 'UISettingsSectionCard',
            child: UISettingsSectionCard(
              children: const [
                ListTile(title: Text('Setting A')),
                ListTile(title: Text('Setting B')),
              ],
            ),
          ),
          ShowcaseTile(
            name: 'UIIconBadge',
            child: UIIconBadge(
              icon: const Icon(Icons.star),
              accentColor: theme.colorScheme.primary,
            ),
          ),
          ShowcaseTile(
            name: 'UIIconTextColumn',
            child: UIIconTextColumn(
              icon: const Icon(Icons.speed),
              mainTitle: '120',
              subTitle: 'km/h',
            ),
          ),
          ShowcaseTile(
            name: 'UIMetricListTile',
            child: UIMetricListTile(
              icon: const Icon(Icons.favorite),
              title: 'Heart rate',
              valueLine: '72 bpm',
              accentColor: theme.colorScheme.error,
            ),
          ),
          ShowcaseTile(
            name: 'UICurrentReadingRow',
            child: const UICurrentReadingRow(
              icon: Icon(Icons.speed),
              value: '120 km/h',
            ),
          ),
          ShowcaseTile(
            name: 'UISectionHeader',
            child: const UISectionHeader(
              title: 'Section',
              icon: Icons.settings,
            ),
          ),
          ShowcaseTile(
            name: 'UISegmentedBar',
            child: UISegmentedBar(
              width: 280,
              radius: 4,
              segmentLimit: 100,
              order: SegmentOrder.none,
              segments: const [
                UISegmentValue(size: 40, color: Colors.blue),
                UISegmentValue(size: 30, color: Colors.green),
                UISegmentValue(size: 30, color: Colors.orange),
              ],
            ),
          ),
          ShowcaseTile(
            name: 'UIBatteryIndicator',
            child: UIBatteryIndicator(percentNumSize: 14, batteryLevel: 68),
          ),
          ShowcaseTile(
            name: 'UICircleProgressPainter',
            child: SizedBox(
              width: 80,
              height: 80,
              child: CustomPaint(
                painter: UICircleProgressPainter(progress: 0.65),
              ),
            ),
          ),
          ShowcaseTile(
            name: 'UIProgressBar',
            child: Column(
              children: const [
                UIProgressBar(value: 0.62),
                SizedBox(height: 12),
                UIProgressBar.indeterminate(),
              ],
            ),
          ),
          ShowcaseTile(
            name: 'UICommandBar',
            child: SizedBox(
              width: 280,
              child: UICommandBar.fromTheme(
                context,
                items: [
                UICommandBarItem(
                  label: 'New',
                  icon: Icons.add,
                ),
                UICommandBarItem(
                  label: 'Edit',
                  icon: Icons.edit_outlined,
                ),
                UICommandBarItem(
                  label: 'Share',
                  icon: Icons.share_outlined,
                ),
                UICommandBarItem(
                  label: 'Archive',
                  icon: Icons.archive_outlined,
                ),
              ],
              secondaryItems: [
                UICommandBarItem(
                  label: 'Delete',
                  icon: Icons.delete_outline,
                  destructive: true,
                ),
                ],
              ),
            ),
          ),
          ShowcaseTile(
            name: 'UIPrimaryActionBar',
            child: UIPrimaryActionBar(
              accentColor: theme.colorScheme.primary,
              label: 'Continue',
              onPressed: () {},
            ),
          ),
          ShowcaseTile(
            name: 'UILabeledDataTable',
            child: UILabeledDataTable(
              columns: const ['Metric', 'Value'],
              rows: const [
                ['Distance', '5.2 km'],
                ['Duration', '32 min'],
              ],
            ),
          ),
          ShowcaseTile(
            name: 'UIAnimatedCounter',
            child: UIAnimatedCounter(
              value: 1284,
              enableGrouping: true,
              suffix: ' pts',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ),
          ShowcaseTile(
            name: 'UITextAvatar',
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: const [
                UITextAvatar(name: 'Alice'),
                UITextAvatar(name: 'Bob'),
                UITextAvatar(name: 'Carol'),
              ],
            ),
          ),
          ShowcaseTile(
            name: 'UIStackBadge',
            child: Center(
              child: UIStackBadge(
                label: '3',
                child: Icon(
                  Icons.mail_outline,
                  size: 48,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
          ),
          ShowcaseTile(
            name: 'UITimerBuilder',
            child: UITimerBuilder.periodic(
              const Duration(seconds: 1),
              builder: (context) => Text(
                'Updated: ${DateTimeUtil.getCurrentHourMin()}',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
