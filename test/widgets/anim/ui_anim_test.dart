import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vvk_ui_kit/vvk_ui_kit.dart';

void main() {
  group('UITapGuard', () {
    testWidgets('ignores overlapping taps while busy', (tester) async {
      var count = 0;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: UITapGuard(
              onTap: () async {
                count++;
                await Future<void>.delayed(const Duration(milliseconds: 200));
              },
              builder: (context, onTap) =>
                  ElevatedButton(onPressed: onTap, child: const Text('Submit')),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Submit'));
      await tester.pump();
      await tester.tap(find.text('Submit'));
      await tester.pump(const Duration(milliseconds: 250));

      expect(count, 1);
    });
  });

  group('UI entrance animations', () {
    testWidgets('staggered fade-in renders children', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: UIAnimationLimiter(
              child: Column(
                children: UIAnimationConfiguration.toStaggeredList(
                  duration: const Duration(milliseconds: 100),
                  childAnimationBuilder: (child) =>
                      UIFadeInAnimation(child: child),
                  children: const [Text('One'), Text('Two')],
                ),
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(find.text('One'), findsOneWidget);
      expect(find.text('Two'), findsOneWidget);
    });

    testWidgets('throws without UIAnimationConfiguration', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: UIFadeInAnimation(child: Text('x'))),
        ),
      );

      expect(tester.takeException(), isA<FlutterError>());
    });
  });

  group('UIGradientButton', () {
    testWidgets('fires onPressed', (tester) async {
      var tapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: UIGradientButton.fromTheme(
              label: 'Go',
              onPressed: () => tapped = true,
            ),
          ),
        ),
      );

      await tester.tap(find.text('Go'));
      expect(tapped, isTrue);
    });
  });

  group('UISocialAuthButton', () {
    testWidgets('shows provider label', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: UISocialAuthButton(
              provider: UISocialAuthProvider.google,
              onPressed: () {},
            ),
          ),
        ),
      );

      expect(find.text('Continue with Google'), findsOneWidget);
    });

    testWidgets('loads bundled SVG icon', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: UISocialAuthButton(
              provider: UISocialAuthProvider.google,
              onPressed: () {},
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(find.byType(CustomPaint), findsWidgets);
    });
  });

  group('UIHierarchySearchableDropdown', () {
    testWidgets('renders trigger hint', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 320,
              child: UIHierarchySearchableDropdown(
                buttonWidth: 320,
                items: const [
                  UIHierarchyItem(
                    title: 'Group',
                    subItems: [UIHierarchyItem(title: 'Leaf')],
                  ),
                ],
                onChanged: (_) {},
              ),
            ),
          ),
        ),
      );

      expect(find.text('Select items...'), findsOneWidget);
    });
  });

  group('AnimatedGestureDetector', () {
    testWidgets('fires onTap with scale effect', (tester) async {
      var tapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AnimatedGestureDetector(
              onTap: () => tapped = true,
              child: const Text('Press me'),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Press me'));
      expect(tapped, isTrue);
    });
  });

  group('UIAnimationConfigurator', () {
    testWidgets('animates when wrapped in configuration', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: UIAnimationConfiguration.synchronized(
              child: UIAnimationConfigurator(
                animatedChildBuilder: (animation) => Opacity(
                  opacity: animation.value,
                  child: const Text('Animated'),
                ),
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(find.text('Animated'), findsOneWidget);
    });
  });
}
