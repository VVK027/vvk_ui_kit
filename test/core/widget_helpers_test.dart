import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vvk_ui_kit/vvk_ui_kit.dart';

void main() {
  group('Widget helpers', () {
    test('textStyle merges base style', () {
      final style = textStyle(
        color: Colors.red,
        fontWeight: FontWeight.bold,
        fontSize: 20,
        base: const TextStyle(height: 1.2),
      );

      expect(style.color, Colors.red);
      expect(style.fontWeight, FontWeight.bold);
      expect(style.fontSize, 20);
      expect(style.height, 1.2);
    });

    test('textSpan creates tappable span', () {
      var tapped = false;
      final span = textSpan(
        'Tap me',
        Colors.blue,
        FontWeight.w600,
        14,
        onTap: () => tapped = true,
      );

      expect(span.text, 'Tap me');
      expect(span.recognizer, isA<TapGestureRecognizer>());
      (span.recognizer as TapGestureRecognizer).onTap?.call();
      expect(tapped, isTrue);
    });

    test('getMaxLines counts wrapped lines', () {
      const style = TextStyle(fontSize: 12);
      const text = 'Line one\nLine two\nLine three';
      expect(getMaxLines(text, style, 200), 3);
    });

    testWidgets('getTextHeight returns positive height', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              final height = getTextHeight(
                context,
                'Sample text',
                const TextStyle(fontSize: 14),
                200,
                2,
              );
              expect(height, greaterThan(0));
              return const SizedBox();
            },
          ),
        ),
      );
    });

    test('intersperse inserts dividers between widgets', () {
      final result = intersperse([
        const Text('A'),
        const Text('B'),
      ], const Divider());

      expect(result, hasLength(3));
      expect(result[1], isA<Divider>());
    });

    testWidgets('buildUILabel renders UIText by default', (tester) async {
      await tester.pumpWidget(
        MaterialApp(home: Scaffold(body: buildUILabel('Hello'))),
      );

      expect(find.text('Hello'), findsOneWidget);
    });
  });
}
