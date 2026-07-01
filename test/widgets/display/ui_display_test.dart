import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vvk_ui_kit/vvk_ui_kit.dart';

void main() {
  group('UIStatSummaryCard', () {
    testWidgets('renders multiple stat items', (tester) async {
      final items = [
        const UIStatSummaryItem(label: 'Label 1', value: 'Val 1'),
        const UIStatSummaryItem(label: 'Label 2', value: 'Val 2'),
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: UIStatSummaryCard(items: items)),
        ),
      );

      expect(find.text('Label 1'), findsOneWidget);
      expect(find.text('Val 1'), findsOneWidget);
      expect(find.text('Label 2'), findsOneWidget);
      expect(find.text('Val 2'), findsOneWidget);
    });
  });

  group('UIStatusBanner', () {
    testWidgets('renders title, subtitle and leading widget', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: UIStatusBanner(
              title: 'Status Title',
              subtitle: 'Status Subtitle',
              leading: Icon(Icons.info),
            ),
          ),
        ),
      );

      expect(find.text('Status Title'), findsOneWidget);
      expect(find.text('Status Subtitle'), findsOneWidget);
      expect(find.byIcon(Icons.info), findsOneWidget);
    });
  });

  group('UIIconBadge', () {
    testWidgets('renders with correct color and size', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: UIIconBadge(
              icon: Icon(Icons.star),
              accentColor: Colors.amber,
              size: 60,
            ),
          ),
        ),
      );

      final container = tester.widget<Container>(find.byType(Container));
      final decoration = container.decoration as BoxDecoration;
      expect(decoration.color, Colors.amber.withValues(alpha: 0.12));
      expect(container.constraints?.maxWidth, 60);
    });
  });

  group('UISectionHeader', () {
    testWidgets('renders title and icon', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: UISectionHeader(title: 'Section Title', icon: Icons.settings),
          ),
        ),
      );

      expect(find.text('Section Title'), findsOneWidget);
      expect(find.byIcon(Icons.settings), findsOneWidget);
    });
  });

  group('UICurrentReadingRow', () {
    testWidgets('renders icon and value', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: UICurrentReadingRow(
              icon: Icon(Icons.speed),
              value: '120 km/h',
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.speed), findsOneWidget);
      expect(find.text('120 km/h'), findsOneWidget);
    });
  });

  group('UISummaryGrid', () {
    testWidgets('renders all items', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: UISummaryGrid(
              items: [
                UISummaryGridItem(
                  icon: Icon(Icons.directions_walk),
                  label: 'Steps',
                  value: Text('8,000'),
                ),
                UISummaryGridItem(
                  icon: Icon(Icons.local_fire_department),
                  label: 'Calories',
                  value: Text('320 kCal'),
                ),
              ],
            ),
          ),
        ),
      );

      expect(find.text('Steps'), findsOneWidget);
      expect(find.text('8,000'), findsOneWidget);
      expect(find.text('Calories'), findsOneWidget);
      expect(find.text('320 kCal'), findsOneWidget);
    });
  });

  group('UICommandBar', () {
    testWidgets('renders primary items and overflow menu affordance', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) => Scaffold(
              body: UICommandBar.fromTheme(
                context,
                items: [
                  UICommandBarItem(label: 'New', icon: Icons.add),
                  UICommandBarItem(label: 'Edit', icon: Icons.edit),
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
        ),
      );

      await tester.pump();
      await tester.pump();
      await tester.pump();

      expect(find.text('New'), findsOneWidget);
      expect(find.text('Edit'), findsOneWidget);
      expect(find.byIcon(Icons.more_horiz), findsOneWidget);
    });
  });

  group('UIProgressBar', () {
    testWidgets('renders determinate value', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: UIProgressBar(value: 0.5))),
      );

      expect(find.byType(LinearProgressIndicator), findsOneWidget);
    });

    testWidgets('renders indeterminate', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: UIProgressBar.indeterminate())),
      );

      expect(find.byType(LinearProgressIndicator), findsOneWidget);
    });
  });

  group('UITextAvatar', () {
    testWidgets('shows initials from name', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: UITextAvatar(name: 'John Doe')),
        ),
      );

      expect(find.text('JD'), findsOneWidget);
    });
  });

  group('UIAvatarGlow', () {
    testWidgets('renders child with glow wrapper', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: UIAvatarGlow(child: SizedBox(width: 40, height: 40)),
          ),
        ),
      );

      expect(find.byType(UIAvatarGlow), findsOneWidget);
      expect(find.byType(SizedBox), findsWidgets);
    });
  });

  group('UIAnimatedCounter', () {
    testWidgets('animates value changes', (tester) async {
      final controller = UIAnimatedCounterController(10);
      addTearDown(controller.dispose);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: UIAnimatedCounter(controller: controller)),
        ),
      );

      expect(find.text('10'), findsOneWidget);
      controller.value = 25;
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 400));
      expect(find.text('25'), findsOneWidget);
    });
  });

  group('UITimerBuilder', () {
    testWidgets('rebuilds on periodic timer', (tester) async {
      var tickCount = 0;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: UITimerBuilder.periodic(
              const Duration(milliseconds: 100),
              builder: (context) {
                tickCount++;
                return Text('ticks:$tickCount');
              },
            ),
          ),
        ),
      );

      expect(find.text('ticks:1'), findsOneWidget);
      await tester.pump(const Duration(milliseconds: 150));
      await tester.pump();
      expect(tickCount, greaterThan(1));
    });
  });

  group('UIStackBadge', () {
    testWidgets('overlays label on child', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: UIStackBadge(
              label: 'NEW',
              child: SizedBox(width: 80, height: 80),
            ),
          ),
        ),
      );

      expect(find.text('NEW'), findsOneWidget);
      expect(find.byType(UIStackBadge), findsOneWidget);
    });
  });

  group('UIBatteryIndicator', () {
    testWidgets('renders percentage', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: UIBatteryIndicator(batteryLevel: 75, percentNumSize: 8),
          ),
        ),
      );

      expect(find.text('75%'), findsOneWidget);
      expect(find.byType(UIBatteryIndicator), findsOneWidget);
    });
  });

  group('UICircleProgressPainter', () {
    testWidgets('paints', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 100,
              height: 100,
              child: CustomPaint(
                painter: UICircleProgressPainter(progress: 50),
              ),
            ),
          ),
        ),
      );

      expect(find.byType(CustomPaint), findsWidgets);
    });
  });

  group('UIIconTextColumn', () {
    testWidgets('renders content', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: UIIconTextColumn(
              icon: Icon(Icons.home),
              mainTitle: 'Home',
              subTitle: 'Dashboard',
            ),
          ),
        ),
      );

      expect(find.text('Home'), findsOneWidget);
      expect(find.text('Dashboard'), findsOneWidget);
    });
  });

  group('UIMetricListTile', () {
    testWidgets('renders and handles tap', (tester) async {
      var tapped = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: UIMetricListTile(
              icon: const Icon(Icons.speed),
              title: 'Speed',
              valueLine: '120',
              trailingText: 'km/h',
              onTap: () => tapped = true,
            ),
          ),
        ),
      );

      expect(find.text('Speed'), findsOneWidget);
      expect(find.text('120'), findsOneWidget);
      await tester.tap(find.byType(InkWell));
      expect(tapped, isTrue);
    });
  });

  group('UIPrimaryActionBar', () {
    testWidgets('renders and handles press', (tester) async {
      var pressed = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: UIPrimaryActionBar(
              accentColor: Colors.blue,
              label: 'Continue',
              onPressed: () => pressed = true,
            ),
          ),
        ),
      );

      expect(find.text('Continue'), findsOneWidget);
      await tester.tap(find.text('Continue'));
      expect(pressed, isTrue);
    });
  });

  group('UIDetailInfoBanner', () {
    testWidgets('renders text correctly', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: UIDetailInfoBanner(text: 'Banner Message')),
        ),
      );

      expect(find.text('Banner Message'), findsOneWidget);
    });
  });

  group('UISettingsSectionCard', () {
    testWidgets('renders children with dividers', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: UISettingsSectionCard(
              children: [Text('Item 1'), Text('Item 2')],
            ),
          ),
        ),
      );

      expect(find.text('Item 1'), findsOneWidget);
      expect(find.text('Item 2'), findsOneWidget);
      expect(find.byType(Divider), findsOneWidget);
    });
  });

  group('UISegmentedBar', () {
    testWidgets('renders segments proportionally', (tester) async {
      final segments = [
        const UISegmentValue(size: 20, color: Colors.red),
        const UISegmentValue(size: 30, color: Colors.blue),
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: UISegmentedBar(
              width: 100,
              radius: 5,
              segments: segments,
              segmentLimit: 100,
              order: SegmentOrder.none,
            ),
          ),
        ),
      );

      expect(find.byType(ColoredBox), findsAtLeastNWidgets(2));
    });
  });

  group('UILabeledDataTable', () {
    testWidgets('renders columns and rows', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: UILabeledDataTable(
              columns: ['Name', 'Value'],
              rows: [
                ['Item A', '100'],
                ['Item B', '200'],
              ],
            ),
          ),
        ),
      );

      expect(find.text('Name'), findsOneWidget);
      expect(find.text('Item A'), findsOneWidget);
      expect(find.text('200'), findsOneWidget);
    });
  });
}
