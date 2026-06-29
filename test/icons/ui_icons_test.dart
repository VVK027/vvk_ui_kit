import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vvk_ui_kit/vvk_ui_kit.dart';
import 'package:vvk_ui_kit/src/icons/ui_svg_asset_icon.dart';
import 'package:vvk_ui_kit/src/icons/ui_svg_image.dart';
import 'package:vvk_ui_kit/src/icons/ui_svg_path_parser.dart';

void main() {
  group('SvgPathParser', () {
    test('parses simple MoveTo and LineTo', () {
      const pathData = 'M 0 0 L 10 10 Z';
      final path = parseSvgPathData(pathData);
      expect(path, isA<Path>());
    });

    test('parses cubic curves', () {
      const pathData = 'M 10 10 C 20 20, 40 20, 50 10';
      final path = parseSvgPathData(pathData);
      expect(path, isA<Path>());
    });

    test('parses horizontal and vertical lines', () {
      const pathData = 'M 0 0 H 10 V 10';
      final path = parseSvgPathData(pathData);
      expect(path, isA<Path>());
    });

    test('throws on unsupported command', () {
      const pathData = 'M 0 0 Q 5 5 10 0';
      expect(
        () => parseSvgPathData(pathData),
        throwsA(isA<UnsupportedError>()),
      );
    });
  });

  group('parseSvgDocument', () {
    test('parses viewBox and path data', () {
      const svg = '''
<svg viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
  <path d="M 0 0 L 24 24 Z"/>
</svg>
''';
      final parsed = parseSvgDocument(svg);
      expect(parsed, isNotNull);
      expect(parsed!.viewBox, const Rect.fromLTWH(0, 0, 24, 24));
      expect(parsed.paths, hasLength(1));
    });

    test('returns null when path uses unsupported commands', () {
      const svg = '<svg><path d="M 0 0 Q 5 5 10 0"/></svg>';
      expect(parseSvgDocument(svg), isNull);
    });
  });

  group('UISvgImage', () {
    testWidgets('loads asset SVG', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: UISvgImage.asset(
              source: 'test/assets/sample.svg',
              width: 24,
              height: 24,
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(find.byType(UISvgImage), findsOneWidget);
    });

    testWidgets('applies color filter', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: UISvgImage.asset(
              source: 'test/assets/sample.svg',
              color: Colors.red,
              width: 24,
              height: 24,
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(find.byType(UISvgImage), findsOneWidget);
    });
  });

  group('UISvgAssetIcon', () {
    testWidgets('renders SVG asset icon', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: UISvgAssetIcon(
              assetPath: 'test/assets/sample.svg',
              size: 32,
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(find.byType(UISvgAssetIcon), findsOneWidget);
    });
  });

  group('UISocialAuthIcon', () {
    testWidgets('renders provider icon', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: UISocialAuthIcon(provider: UISocialAuthProvider.google),
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(find.byType(UISocialAuthIcon), findsOneWidget);
    });
  });
}
