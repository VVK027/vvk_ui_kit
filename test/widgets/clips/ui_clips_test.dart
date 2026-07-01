import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vvk_ui_kit/vvk_ui_kit.dart';

void main() {
  group('UITicketClip', () {
    testWidgets('renders clipped child', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: UITicketClip(
              child: SizedBox(
                width: 200,
                height: 100,
                child: ColoredBox(color: Colors.blue),
              ),
            ),
          ),
        ),
      );

      expect(find.byType(UITicketClip), findsOneWidget);
      expect(find.byType(ClipPath), findsOneWidget);
    });
  });

  group('UICouponClip', () {
    testWidgets('renders clipped child', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: UICouponClip(
              child: SizedBox(
                width: 200,
                height: 100,
                child: ColoredBox(color: Colors.orange),
              ),
            ),
          ),
        ),
      );

      expect(find.byType(UICouponClip), findsOneWidget);
      expect(find.byType(ClipPath), findsOneWidget);
    });
  });

  group('UICouponCard', () {
    testWidgets('renders both coupon sections', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: UICouponCard(
              backgroundColor: Colors.white,
              firstChild: Center(child: Text('Header')),
              secondChild: Center(child: Text('Body')),
            ),
          ),
        ),
      );

      expect(find.text('Header'), findsOneWidget);
      expect(find.text('Body'), findsOneWidget);
      expect(find.byType(UICouponCard), findsOneWidget);
    });
  });

  group('UICouponClipper', () {
    test('produces a closed path for horizontal axis', () {
      const clipper = UICouponClipper(curvePosition: 60, borderRadius: 8);
      final path = clipper.getClip(const Size(300, 150));
      expect(path.getBounds().width, greaterThan(0));
    });
  });

  group('UISharpCorners', () {
    testWidgets('renders clipped child', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: UISharpCorners(
              child: SizedBox(
                width: 120,
                height: 80,
                child: ColoredBox(color: Colors.green),
              ),
            ),
          ),
        ),
      );

      expect(find.byType(UISharpCorners), findsOneWidget);
      expect(find.byType(ClipPath), findsOneWidget);
    });
  });

  group('UIHexagon', () {
    testWidgets('renders clipped child', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: UIHexagon(
              child: SizedBox(
                width: 80,
                height: 80,
                child: ColoredBox(color: Colors.purple),
              ),
            ),
          ),
        ),
      );

      expect(find.byType(UIHexagon), findsOneWidget);
      expect(find.byType(ClipPath), findsOneWidget);
    });
  });

  group('UICouponDecorationPainter', () {
    test('paints without throwing', () {
      const clipper = UICouponClipper(curvePosition: 60, borderRadius: 8);
      const painter = UICouponDecorationPainter(
        clipper: clipper,
        border: BorderSide(color: Colors.grey),
      );

      final recorder = PictureRecorder();
      final canvas = Canvas(recorder);
      painter.paint(canvas, const Size(300, 150));
      expect(recorder.endRecording(), isNotNull);
    });
  });
}
