import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vvk_ui_kit/vvk_ui_kit.dart';

import '../../test_assets.dart';

void main() {
  group('UIDottedBorder', () {
    testWidgets('renders child inside border', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: UIDottedBorder(
              child: SizedBox(width: 100, height: 100, child: Text('Inside')),
            ),
          ),
        ),
      );

      expect(find.text('Inside'), findsOneWidget);
      expect(find.byType(UIDottedBorder), findsOneWidget);
    });
  });

  group('UICornerRibbon', () {
    testWidgets('paints ribbon over child', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: UICornerRibbon(
              message: 'NEW',
              location: UICornerRibbonLocation.topEnd,
              child: SizedBox(width: 200, height: 200),
            ),
          ),
        ),
      );

      expect(find.byType(UICornerRibbon), findsOneWidget);
    });
  });

  group('UIGlassTheme', () {
    test('lerp interpolates blur and opacity', () {
      const a = UIGlassTheme(blur: 4, tintOpacity: 0.1);
      const b = UIGlassTheme(blur: 20, tintOpacity: 0.3);
      final midway = UIGlassTheme.lerp(a, b, 0.5);
      expect(midway.blur, 12);
      expect(midway.tintOpacity, closeTo(0.2, 0.001));
    });
  });

  group('UIGlassSurface', () {
    testWidgets('renders with gradient and backdrop blur', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: UIGlassSurface(
              gradient: LinearGradient(
                colors: [Colors.white24, Colors.white10],
              ),
              padding: EdgeInsets.all(16),
              child: Text('Glass surface'),
            ),
          ),
        ),
      );

      expect(find.text('Glass surface'), findsOneWidget);
      expect(find.byType(BackdropFilter), findsOneWidget);
    });
  });

  group('UIGradientBox', () {
    testWidgets('renders child and applies parameters', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: UIGradientBox(
              colors: [Colors.red, Colors.blue],
              borderRadius: BorderRadius.all(Radius.circular(20)),
              child: Text('Gradient Box Content'),
            ),
          ),
        ),
      );

      expect(find.text('Gradient Box Content'), findsOneWidget);
    });
  });

  group('UIGradientText', () {
    testWidgets('renders text with shader mask', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: UIGradientText(
              'Gradient Text',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              gradient: LinearGradient(colors: [Colors.red, Colors.blue]),
            ),
          ),
        ),
      );

      expect(find.text('Gradient Text'), findsOneWidget);
    });
  });

  group('UIGradientSvgIcon', () {
    testWidgets('renders with custom parameters', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: UIGradientSvgIcon(
              assetName: kTestSvgAsset,
              width: 50,
              height: 50,
              gradient: RadialGradient(colors: [Colors.yellow, Colors.orange]),
            ),
          ),
        ),
      );

      expect(find.byType(ShaderMask), findsOneWidget);
      expect(find.byType(UISvgImage), findsOneWidget);
    });
  });
}
