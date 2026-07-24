import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vvk_ui_kit/vvk_ui_kit.dart';

void main() {
  group('theme-first factories (Issue 11)', () {
    testWidgets('UISnackbarStyle.fromTheme resolves colors from theme', (
      tester,
    ) async {
      late UISnackbarStyle style;
      await tester.pumpWidget(
        MaterialApp(
          theme: UIAppTheme.light,
          home: Builder(
            builder: (context) {
              style = UISnackbarStyle.fromTheme(context);
              return const SizedBox();
            },
          ),
        ),
      );

      expect(style.successColor, isNotNull);
      expect(style.errorColor, isNotNull);
      // Overrides win over the resolved theme value.
      final overridden = UISnackbarStyle.fromTheme(
        tester.element(find.byType(SizedBox)),
        errorColor: const Color(0xFF123456),
      );
      expect(overridden.errorColor, const Color(0xFF123456));
    });
  });

  group('design tokens (Issue 4 & 10)', () {
    testWidgets('UIButtonMetrics/UIGlassMetrics are registered on the theme', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: UIAppTheme.light,
          home: Builder(
            builder: (context) {
              final buttons = context.uiButtonMetrics;
              final glass = context.uiGlassMetrics;
              expect(buttons.primaryHeight, 56);
              expect(glass.performanceMode, UIGlassPerformanceMode.auto);
              expect(glass.usesBlur, isTrue);
              return const SizedBox();
            },
          ),
        ),
      );
    });

    testWidgets('UIGlassSurface static-tint mode skips the BackdropFilter', (
      tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: UIGlassSurface(
              performanceMode: UIGlassPerformanceMode.staticTint,
              child: SizedBox(width: 40, height: 40),
            ),
          ),
        ),
      );
      expect(find.byType(BackdropFilter), findsNothing);
    });
  });

  group('adaptive Cupertino (Issue 12)', () {
    testWidgets('UIPillSwitch forceCupertino renders CupertinoSwitch', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: UIPillSwitch(
              value: true,
              adaptive: true,
              forceCupertino: true,
              onChanged: (_) {},
            ),
          ),
        ),
      );
      expect(find.byType(CupertinoSwitch), findsOneWidget);
    });

    testWidgets('UIPillSwitch forceMaterial keeps the pill design', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: UIPillSwitch(
              value: true,
              adaptive: true,
              forceMaterial: true,
              onChanged: (_) {},
            ),
          ),
        ),
      );
      expect(find.byType(CupertinoSwitch), findsNothing);
    });
  });
}
