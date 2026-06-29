import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vvk_ui_kit/vvk_ui_kit.dart';

void main() {
  group('UICard', () {
    testWidgets('renders child content', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: UICard(child: Text('Card Content'))),
        ),
      );

      expect(find.text('Card Content'), findsOneWidget);
    });

    testWidgets('applies custom padding and color', (tester) async {
      const padding = EdgeInsets.all(20);
      const color = Colors.red;
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: UICard(
              padding: padding,
              color: color,
              child: Text('Custom Card'),
            ),
          ),
        ),
      );

      final card = tester.widget<Card>(find.byType(Card));
      expect(card.color, color);

      // Look for the Padding widget specifically wrapping 'Custom Card'
      final paddingWidget = tester.widget<Padding>(
        find
            .ancestor(
              of: find.text('Custom Card'),
              matching: find.byType(Padding),
            )
            .first,
      );
      expect(paddingWidget.padding, padding);
    });
  });

  group('UIGlassCard', () {
    testWidgets('renders child and handles tap', (tester) async {
      var tapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: UIGlassCard(
              onTap: () => tapped = true,
              child: const Text('Glass content'),
            ),
          ),
        ),
      );

      expect(find.text('Glass content'), findsOneWidget);
      expect(find.byType(BackdropFilter), findsOneWidget);

      await tester.tap(find.text('Glass content'));
      expect(tapped, isTrue);
    });
  });

  group('UIAnimatedFlipCard', () {
    testWidgets('flips between front and back on tap', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => UIAnimatedFlipCard.fromTheme(
                context,
                front: const Text('Front'),
                back: const Text('Back'),
              ),
            ),
          ),
        ),
      );

      expect(find.text('Front'), findsOneWidget);
      expect(find.text('Back'), findsNothing);

      await tester.tap(find.text('Front'));
      await tester.pumpAndSettle();

      expect(find.text('Back'), findsOneWidget);
      expect(find.text('Front'), findsNothing);
    });
  });

  group('UICardTopContainer', () {
    testWidgets('renders title and view all label', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: UICardTopContainer(
              title: 'Featured',
              isViewAll: true,
              viewAllLabel: 'View all',
              iconData: Icons.star,
            ),
          ),
        ),
      );

      expect(find.text('Featured'), findsOneWidget);
      expect(find.text('View all'), findsOneWidget);
      expect(find.byIcon(Icons.star), findsOneWidget);
    });
  });
}
