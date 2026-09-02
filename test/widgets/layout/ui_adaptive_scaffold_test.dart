import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vvk_ui_kit/vvk_ui_kit.dart';

void main() {
  group('UIAdaptiveScaffold', () {
    testWidgets('renders bottom navigation on mobile width', (tester) async {
      tester.view.physicalSize = const Size(400, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        MaterialApp(
          home: UIAdaptiveScaffold(
            selectedIndex: 0,
            destinations: const [
              UIAdaptiveDestination(icon: Icon(Icons.home), label: 'Home'),
              UIAdaptiveDestination(icon: Icon(Icons.settings), label: 'Settings'),
            ],
            body: const Text('Mobile Body'),
          ),
        ),
      );

      expect(find.text('Mobile Body'), findsOneWidget);
      expect(find.byType(NavigationBar), findsOneWidget);
    });

    testWidgets('renders navigation rail on desktop width', (tester) async {
      tester.view.physicalSize = const Size(1400, 900);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        MaterialApp(
          home: UIAdaptiveScaffold(
            selectedIndex: 0,
            destinations: const [
              UIAdaptiveDestination(icon: Icon(Icons.home), label: 'Home'),
              UIAdaptiveDestination(icon: Icon(Icons.settings), label: 'Settings'),
            ],
            body: const Text('Desktop Body'),
          ),
        ),
      );

      expect(find.text('Desktop Body'), findsOneWidget);
      expect(find.byType(NavigationRail), findsOneWidget);
    });
  });
}
