import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vvk_ui_kit/vvk_ui_kit.dart';

void main() {
  group('DoubleExtension', () {
    test('roundToDecimal rounds correctly', () {
      expect(1.23456789.roundToDecimal(places: 2), 1.23);
      expect(1.235.roundToDecimal(places: 2), 1.24);
      expect(1.0.roundToDecimal(places: 5), 1.0);
    });
  });

  group('StringExtension', () {
    test('equalsIgnoreCase works', () {
      expect('Hello'.equalsIgnoreCase('hello '), isTrue);
      expect('Test'.equalsIgnoreCase('abc'), isFalse);
    });

    test('capitalizeFirstLetter works', () {
      expect('hello'.capitalizeFirstLetter(), 'Hello');
      expect('WORLD'.capitalizeFirstLetter(), 'World');
    });

    test('capitalizeAllFirstLetters works', () {
      expect('hello world'.capitalizeAllFirstLetters(), 'Hello World');
    });

    test('toDouble works', () {
      expect('123.45'.toDouble(), 123.45);
      expect('invalid'.toDouble(), 0.0);
    });
  });

  group('UIAppTheme', () {
    test('light theme has correct primary color', () {
      final theme = UIAppTheme.light;
      expect(theme.brightness, Brightness.light);
      expect(theme.colorScheme.primary, const Color(0xFF0D9488));
    });

    test('dark theme has correct primary color', () {
      final theme = UIAppTheme.dark;
      expect(theme.brightness, Brightness.dark);
      expect(theme.colorScheme.primary, const Color(0xFF14B8A6));
    });

    test('zinc preset builds theme', () {
      final theme = UIAppTheme.zinc(Brightness.light);
      expect(theme.brightness, Brightness.light);
      expect(theme.extensions.isNotEmpty, isTrue);
    });

    test('fromSeed derives primary from the seed color', () {
      const seed = Color(0xFF6750A4);
      final light = UIAppTheme.fromSeed(seed);
      final dark = UIAppTheme.fromSeed(seed, brightness: Brightness.dark);
      final expected = ColorScheme.fromSeed(seedColor: seed);
      expect(light.brightness, Brightness.light);
      expect(light.colorScheme.primary, expected.primary);
      expect(dark.brightness, Brightness.dark);
      expect(dark.extensions.isNotEmpty, isTrue);
    });

    test('highContrast presets build light and dark themes', () {
      final light = UIAppTheme.highContrast(Brightness.light);
      final dark = UIAppTheme.highContrast(Brightness.dark);
      expect(light.brightness, Brightness.light);
      expect(light.scaffoldBackgroundColor, const Color(0xFFFFFFFF));
      expect(dark.brightness, Brightness.dark);
      expect(dark.scaffoldBackgroundColor, const Color(0xFF000000));
    });

    test('buildUIKitTheme auto-picks the extension by brightness', () {
      final dark = buildUIKitTheme(
        brightness: Brightness.dark,
        colors: UIThemePalette.dark,
      );
      final light = buildUIKitTheme(
        brightness: Brightness.light,
        colors: UIThemePalette.light,
      );

      expect(
        dark.extension<UIThemeExtension>()!.chartBackground,
        UIThemeExtension.dark.chartBackground,
      );
      expect(
        light.extension<UIThemeExtension>()!.chartBackground,
        UIThemeExtension.light.chartBackground,
      );
    });

    test('extraExtensions are registered on the theme', () {
      const metrics = UIMetrics(sectionHPad: 99);
      final theme = UIAppTheme.custom(
        brightness: Brightness.light,
        colors: UIThemePalette.light,
        extraExtensions: const [_AppTokens(brand: Color(0xFF123456))],
      );

      expect(theme.extension<_AppTokens>()?.brand, const Color(0xFF123456));
      // Sanity: kit extensions still present alongside the extra one.
      expect(theme.extension<UIThemeExtension>(), isNotNull);
      expect(metrics.sectionHPad, 99);
    });
  });

  group('UITypography', () {
    test('produces styles', () {
      final style = UITypography.h1(Colors.black);
      expect(style.fontSize, 36);
    });
  });

  group('UIBreakpoints', () {
    test('helpers classify viewport width', () {
      expect(UIBreakpoints.isMobile(400), isTrue);
      expect(UIBreakpoints.isDesktop(1300), isTrue);
    });
  });

  group('Component theme extensions', () {
    testWidgets('context exposes navigation theme', (tester) async {
      UINavigationTheme? navTheme;

      await tester.pumpWidget(
        MaterialApp(
          theme: UIAppTheme.light,
          home: Builder(
            builder: (context) {
              navTheme = context.uiNavigationTheme;
              return const SizedBox();
            },
          ),
        ),
      );

      expect(navTheme?.sheetBorderRadius, 16);
      expect(navTheme?.breadcrumbSpacing, 4);
    });
  });
}

class _AppTokens extends ThemeExtension<_AppTokens> {
  const _AppTokens({required this.brand});

  final Color brand;

  @override
  _AppTokens copyWith({Color? brand}) => _AppTokens(brand: brand ?? this.brand);

  @override
  _AppTokens lerp(ThemeExtension<_AppTokens>? other, double t) {
    if (other is! _AppTokens) return this;
    return _AppTokens(brand: Color.lerp(brand, other.brand, t)!);
  }
}
