import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vvk_ui_kit/vvk_ui_kit.dart';

void main() {
  group('ResponsiveLayout', () {
    testWidgets('shows mobile widget on small screens', (tester) async {
      tester.view.physicalSize = const Size(400, 800);
      tester.view.devicePixelRatio = 1.0;

      await tester.pumpWidget(
        const MaterialApp(
          home: ResponsiveLayout(
            mobile: Text('Mobile'),
            tablet: Text('Tablet'),
            desktop: Text('Desktop'),
          ),
        ),
      );

      expect(find.text('Mobile'), findsOneWidget);
      expect(find.text('Tablet'), findsNothing);
      expect(find.text('Desktop'), findsNothing);

      addTearDown(tester.view.resetPhysicalSize);
    });

    testWidgets('shows desktop widget on large screens', (tester) async {
      tester.view.physicalSize = const Size(1200, 800);
      tester.view.devicePixelRatio = 1.0;

      await tester.pumpWidget(
        const MaterialApp(
          home: ResponsiveLayout(
            mobile: Text('Mobile'),
            tablet: Text('Tablet'),
            desktop: Text('Desktop'),
          ),
        ),
      );

      expect(find.text('Desktop'), findsOneWidget);
      expect(find.text('Mobile'), findsNothing);

      addTearDown(tester.view.resetPhysicalSize);
    });

    testWidgets('shows tablet widget with useLayoutBuilder', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 800,
              child: ResponsiveLayout(
                useLayoutBuilder: true,
                mobile: Text('Mobile'),
                tablet: Text('Tablet'),
                desktop: Text('Desktop'),
              ),
            ),
          ),
        ),
      );

      expect(find.text('Tablet'), findsOneWidget);
    });
  });

  group('Responsive', () {
    testWidgets('fromContext returns correct values', (tester) async {
      tester.view.physicalSize = const Size(500, 800);
      tester.view.devicePixelRatio = 1.0;

      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              final responsive = Responsive.fromContext(context);
              expect(responsive.isMobile, isTrue);
              expect(responsive.isDesktop, isFalse);
              return const SizedBox();
            },
          ),
        ),
      );

      addTearDown(tester.view.resetPhysicalSize);
    });
  });
}
