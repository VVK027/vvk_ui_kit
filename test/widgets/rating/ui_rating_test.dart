import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vvk_ui_kit/vvk_ui_kit.dart';

void main() {
  group('UIRatingBarIndicator', () {
    testWidgets('renders default stars for fractional rating', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: UIRatingBarIndicator(rating: 3.5)),
        ),
      );

      expect(find.byIcon(Icons.star_rounded), findsNWidgets(3));
      expect(find.byIcon(Icons.star_half_rounded), findsOneWidget);
      expect(find.byIcon(Icons.star_outline_rounded), findsOneWidget);
    });

    testWidgets('clamps rating above itemCount', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: UIRatingBarIndicator(rating: 10, itemCount: 5)),
        ),
      );

      expect(find.byIcon(Icons.star_rounded), findsNWidgets(5));
    });
  });

  group('UIRatingBar', () {
    testWidgets('updates rating on tap', (tester) async {
      double? latest;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: UIRatingBar(
              initialRating: 1,
              onRatingUpdate: (value) => latest = value,
            ),
          ),
        ),
      );

      await tester.tap(find.byType(UIRatingBar));
      await tester.pump();

      expect(latest, isNotNull);
      expect(latest! > 1, isTrue);
    });

    testWidgets('builder constructor renders custom items', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: UIRatingBar.builder(
              initialRating: 2,
              itemBuilder: (context, index) => Text('s$index'),
            ),
          ),
        ),
      );

      expect(find.text('s0'), findsOneWidget);
      expect(find.text('s4'), findsOneWidget);
    });
  });

  group('UIRatingWidget', () {
    testWidgets('defaultUIRatingWidget uses theme colors', (tester) async {
      UIRatingWidget? ratingWidget;

      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              ratingWidget = defaultUIRatingWidget(context);
              return const SizedBox();
            },
          ),
        ),
      );

      expect(ratingWidget!.full, isA<Icon>());
      expect(ratingWidget!.half, isA<Icon>());
      expect(ratingWidget!.empty, isA<Icon>());
    });
  });
}
