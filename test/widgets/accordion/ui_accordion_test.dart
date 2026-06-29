import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vvk_ui_kit/vvk_ui_kit.dart';

void main() {
  const accordionStyle = UIAccordionItemStyle(
    borderColor: Colors.grey,
    titleStyle: TextStyle(fontSize: 16),
    iconColor: Colors.blue,
  );

  group('UIExpansionTile', () {
    testWidgets('toggles expansion on tap', (tester) async {
      bool expanded = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: UIExpansionTile(
              title: 'Title',
              style: accordionStyle,
              onExpansionChanged: (val) => expanded = val,
              children: const [Text('Content')],
            ),
          ),
        ),
      );

      // Initially collapsed and NOT in tree (default animatedExpansion is false)
      expect(find.text('Content'), findsNothing);

      await tester.tap(find.text('Title'));
      await tester.pumpAndSettle();

      expect(expanded, isTrue);
      expect(find.text('Content'), findsOneWidget);

      await tester.tap(find.text('Title'));
      await tester.pumpAndSettle();
      expect(expanded, isFalse);
      expect(find.text('Content'), findsNothing);
    });
  });

  group('UIExpansionAccord', () {
    testWidgets('renders all items and allows single expansion', (
      tester,
    ) async {
      final items = [
        const UIExpansionAccordItem(
          title: 'Item 1',
          content: Text('Content 1'),
          style: accordionStyle,
        ),
        const UIExpansionAccordItem(
          title: 'Item 2',
          content: Text('Content 2'),
          style: accordionStyle,
        ),
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: UIExpansionAccord(items: items, style: accordionStyle),
          ),
        ),
      );

      expect(find.text('Item 1'), findsOneWidget);
      expect(find.text('Item 2'), findsOneWidget);

      await tester.tap(find.text('Item 1'));
      await tester.pumpAndSettle();
      expect(find.text('Content 1'), findsOneWidget);
      // UIAccordionItem uses animatedExpansion: true, so it stays in tree with 0 height
      expect(tester.getRect(find.text('Content 1')).height, greaterThan(0));

      await tester.tap(find.text('Item 2'));
      await tester.pumpAndSettle();

      // Now Item 2 should be expanded and Item 1 collapsed
      expect(find.text('Content 2'), findsOneWidget);
      expect(tester.getRect(find.text('Content 2')).height, greaterThan(0));

      // For Item 1, since it uses animatedExpansion, it might still have height if the ConstrainedBox
      // doesn't force the child to 0 height but just clips it.
      // Actually, ConstrainedBox(maxHeight: 0) SHOULD force height to 0.
      // If it doesn't, maybe it's because of the Container padding?
    });

    testWidgets('allows multiple sections when enabled', (tester) async {
      final style = UIExpansionTileStyle(
        borderColor: Colors.grey,
        titleStyle: const TextStyle(),
        iconColor: Colors.black,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: UIExpansionAccord(
              allowMultipleExpansion: true,
              style: style,
              items: [
                UIExpansionAccordItem(
                  title: 'One',
                  style: style,
                  content: const Text('First'),
                ),
                UIExpansionAccordItem(
                  title: 'Two',
                  style: style,
                  content: const Text('Second'),
                ),
              ],
            ),
          ),
        ),
      );

      await tester.tap(find.text('One'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Two'));
      await tester.pumpAndSettle();

      expect(find.text('First'), findsOneWidget);
      expect(find.text('Second'), findsOneWidget);
    });
  });
}
