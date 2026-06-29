import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vvk_ui_kit/vvk_ui_kit.dart';

void main() {
  group('NavigationUtil', () {
    testWidgets('pushPage navigates to new page', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) => Scaffold(
              body: ElevatedButton(
                onPressed: () => NavigationUtil.pushPage(
                  context,
                  const Scaffold(body: Text('New Page')),
                ),
                child: const Text('Go'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Go'));
      await tester.pumpAndSettle();

      expect(find.text('New Page'), findsOneWidget);
    });

    testWidgets('pop returns to previous page', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) => Scaffold(
              body: ElevatedButton(
                onPressed: () => NavigationUtil.pushPage(
                  context,
                  Scaffold(
                    body: Builder(
                      builder: (ctx) => ElevatedButton(
                        onPressed: () => NavigationUtil.pop(ctx),
                        child: const Text('Back'),
                      ),
                    ),
                  ),
                ),
                child: const Text('Go'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Go'));
      await tester.pumpAndSettle();
      expect(find.text('Back'), findsOneWidget);

      await tester.tap(find.text('Back'));
      await tester.pumpAndSettle();
      expect(find.text('Go'), findsOneWidget);
    });

    testWidgets('pushPageWithEntrance navigates with custom route', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) => Scaffold(
              body: ElevatedButton(
                onPressed: () => NavigationUtil.pushPageWithEntrance(
                  context,
                  const Scaffold(body: Text('Entrance Page')),
                ),
                child: const Text('Entrance'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Entrance'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.text('Entrance Page'), findsOneWidget);
      expect(find.byType(UIEntrancePageTransition), findsOneWidget);
    });

    testWidgets('pushPageWithDrillIn navigates with drill route', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) => Scaffold(
              body: ElevatedButton(
                onPressed: () => NavigationUtil.pushPageWithDrillIn(
                  context,
                  const Scaffold(body: Text('Drill Page')),
                ),
                child: const Text('Drill'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Drill'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.text('Drill Page'), findsOneWidget);
      expect(find.byType(UIDrillInPageTransition), findsOneWidget);
    });
  });
}
