import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vvk_ui_kit/vvk_ui_kit.dart';

void main() {
  group('UIText', () {
    testWidgets('renders text with custom style', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: UIText(
              'Styled Text',
              size: 24,
              color: Colors.blue,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );

      final textWidget = tester.widget<Text>(find.text('Styled Text'));
      expect(textWidget.style?.fontSize, 24);
      expect(textWidget.style?.color, Colors.blue);
      expect(textWidget.style?.fontWeight, FontWeight.bold);
    });
  });

  group('UIRichText', () {
    testWidgets('renders multiple spans', (tester) async {
      final spans = [
        const UIRichTextSpan(
          text: 'Normal ',
          style: TextStyle(color: Colors.black),
        ),
        const UIRichTextSpan(
          text: 'Bold',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: UIRichText(spans: spans)),
        ),
      );

      expect(find.byType(RichText), findsOneWidget);
      // Checking if text is present
      expect(find.textContaining('Normal'), findsOneWidget);
      expect(find.textContaining('Bold'), findsOneWidget);
    });

    testWidgets('handles span tap', (tester) async {
      bool tapped = false;
      final spans = [
        UIRichTextSpan(text: 'Tap Me', onTap: () => tapped = true),
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: UIRichText(spans: spans)),
        ),
      );

      await tester.tap(find.textContaining('Tap Me'));
      expect(tapped, isTrue);
    });
  });

  group('UIReadMoreText', () {
    testWidgets('toggles collapsed state via isCollapsed notifier', (
      tester,
    ) async {
      const longText =
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit. '
          'Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. '
          'Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris.';

      final collapsed = ValueNotifier(true);
      addTearDown(collapsed.dispose);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Padding(
              padding: const EdgeInsets.all(16),
              child: UIReadMoreText(
                longText,
                isCollapsed: collapsed,
                trimLength: 20,
                trimCollapsedText: 'Read more',
                trimExpandedText: 'Show less',
              ),
            ),
          ),
        ),
      );

      var plainText = tester
          .widget<RichText>(find.byType(RichText))
          .text
          .toPlainText();
      expect(plainText, contains('Read more'));

      collapsed.value = false;
      await tester.pump();

      plainText = tester
          .widget<RichText>(find.byType(RichText))
          .text
          .toPlainText();
      expect(plainText, contains('Show less'));
      expect(plainText, isNot(contains('Read more')));
    });
  });

  group('UIMarquee', () {
    testWidgets('renders scrollable child', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 100,
              child: UIMarquee(
                child: Text('This is a very long marquee text sample'),
              ),
            ),
          ),
        ),
      );

      expect(find.byType(UIMarquee), findsOneWidget);
      expect(find.byType(SingleChildScrollView), findsOneWidget);
    });
  });

  group('UITextRow', () {
    testWidgets('renders prefix, text, and suffix', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: UITextRow(
              prefix: Icon(Icons.star, key: Key('prefix')),
              text: 'Featured item',
              suffix: Icon(Icons.chevron_right, key: Key('suffix')),
            ),
          ),
        ),
      );

      expect(find.text('Featured item'), findsOneWidget);
      expect(find.byKey(const Key('prefix')), findsOneWidget);
      expect(find.byKey(const Key('suffix')), findsOneWidget);
    });
  });
}
