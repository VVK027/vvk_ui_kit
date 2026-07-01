import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vvk_ui_kit/vvk_ui_kit.dart';

void main() {
  group('UIEmptyState', () {
    testWidgets('renders icon and message', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: UIEmptyState(
              icon: Icons.search_off,
              message: 'No results found',
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.search_off), findsOneWidget);
      expect(find.text('No results found'), findsOneWidget);
    });

    testWidgets('renders custom child', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: UIEmptyState(
              message: 'Nothing here',
              child: ElevatedButton(
                onPressed: () {},
                child: const Text('Retry'),
              ),
            ),
          ),
        ),
      );

      expect(find.text('Nothing here'), findsOneWidget);
      expect(find.text('Retry'), findsOneWidget);
    });
  });

  group('UIPopover', () {
    testWidgets('shows content when controller opens', (tester) async {
      final controller = UIAnchoredOverlayController();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: UIPopover(
              controller: controller,
              content: const Text('Popover body'),
              child: const Text('Anchor'),
            ),
          ),
        ),
      );

      expect(find.text('Popover body'), findsNothing);

      controller.show();
      await tester.pump();
      await tester.pump();

      expect(find.text('Popover body'), findsOneWidget);

      controller.dispose();
    });

    testWidgets('close button dismisses popover', (tester) async {
      final controller = UIAnchoredOverlayController();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: UIPopover(
              controller: controller,
              showCloseButton: true,
              content: const Text('Dismiss me'),
              child: const Text('Anchor'),
            ),
          ),
        ),
      );

      controller.show();
      await tester.pump();
      await tester.pump();

      expect(find.text('Dismiss me'), findsOneWidget);

      await tester.tap(find.byKey(const Key('ui_popover_close')));
      await tester.pump();
      await tester.pump();

      expect(controller.isOpen, isFalse);
      expect(find.text('Dismiss me'), findsNothing);

      controller.dispose();
    });

    testWidgets('scrim tap dismisses when enabled', (tester) async {
      final controller = UIAnchoredOverlayController();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: UIPopover(
              controller: controller,
              showScrim: true,
              dismissOnTapOutside: true,
              content: const Text('Coach mark'),
              child: const Text('Anchor'),
            ),
          ),
        ),
      );

      controller.show();
      await tester.pump();
      await tester.pump();

      expect(find.text('Coach mark'), findsOneWidget);

      await tester.tapAt(const Offset(10, 10));
      await tester.pump();

      expect(controller.isOpen, isFalse);

      controller.dispose();
    });
  });

  group('UITourProgressIndicator', () {
    testWidgets('renders compact text progress', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: UITourProgressIndicator(
              currentStep: 1,
              totalSteps: 4,
              style: UITourProgressStyle.textCompact,
            ),
          ),
        ),
      );

      expect(find.text('2 / 4'), findsOneWidget);
    });
  });

  group('UISpotlightOverlay', () {
    testWidgets('renders spotlight painter', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 300,
              height: 400,
              child: UISpotlightOverlay(
                targetRect: Rect.fromLTWH(80, 120, 100, 48),
              ),
            ),
          ),
        ),
      );

      expect(find.byType(UISpotlightOverlay), findsOneWidget);
      expect(find.byType(CustomPaint), findsWidgets);
    });
  });

  group('UITourController', () {
    testWidgets('shows first step overlay', (tester) async {
      final targetKey = GlobalKey();

      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) => Scaffold(
              body: Column(
                children: [
                  ElevatedButton(
                    key: targetKey,
                    onPressed: () {},
                    child: const Text('Target'),
                  ),
                  TextButton(
                    onPressed: () {
                      UITourController.fromTheme(
                        context,
                        steps: const [
                          UITourStep(
                            title: 'Welcome',
                            description: 'This is step one.',
                          ),
                        ],
                      ).start();
                    },
                    child: const Text('Start tour'),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Start tour'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 450));

      expect(find.text('Welcome'), findsOneWidget);
      expect(find.text('This is step one.'), findsOneWidget);
    });

    testWidgets('advances to next step', (tester) async {
      final firstKey = GlobalKey();
      final secondKey = GlobalKey();
      late UITourController tour;

      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              return Scaffold(
                body: Column(
                  children: [
                    ElevatedButton(
                      key: firstKey,
                      onPressed: () {},
                      child: const Text('First'),
                    ),
                    ElevatedButton(
                      key: secondKey,
                      onPressed: () {},
                      child: const Text('Second'),
                    ),
                    TextButton(
                      onPressed: () {
                        tour = UITourController.fromTheme(
                          context,
                          steps: [
                            UITourStep(
                              key: firstKey,
                              title: 'Step 1',
                              description: 'First target',
                            ),
                            UITourStep(
                              key: secondKey,
                              title: 'Step 2',
                              description: 'Second target',
                              isLast: true,
                            ),
                          ],
                        );
                        tour.start();
                      },
                      child: const Text('Start tour'),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      );

      await tester.tap(find.text('Start tour'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 450));
      expect(find.text('Step 1'), findsOneWidget);

      await tester.tap(find.byIcon(Icons.chevron_right));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 450));
      expect(find.text('Step 2'), findsOneWidget);
    });
  });

  group('UIBadge', () {
    testWidgets('renders primary variant', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: UIBadge.primary(child: Text('New'))),
        ),
      );

      expect(find.text('New'), findsOneWidget);
    });

    testWidgets('live variant renders dot', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: UIBadge.live(child: Text('LIVE'))),
        ),
      );

      expect(find.text('LIVE'), findsOneWidget);
      expect(find.byType(Container), findsWidgets);
    });
  });

  group('UIAlert', () {
    testWidgets('renders title and description', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: UIAlert(title: 'Heads up', description: 'Something changed.'),
          ),
        ),
      );

      expect(find.text('Heads up'), findsOneWidget);
      expect(find.text('Something changed.'), findsOneWidget);
    });
  });

  group('UITooltip', () {
    testWidgets('shows tooltip when visible', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: UITooltip(
              message: 'Help text',
              visible: true,
              child: Text('Anchor'),
            ),
          ),
        ),
      );

      await tester.pump();
      expect(find.text('Help text'), findsOneWidget);
    });
  });

  group('UISnackbar', () {
    const style = UISnackbarStyle(
      backgroundColor: Colors.white,
      textStyle: TextStyle(color: Colors.black),
      successColor: Colors.green,
      errorColor: Colors.red,
      closeIconColor: Colors.grey,
    );

    testWidgets('shows and dismisses top snackbar', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) => Scaffold(
              body: ElevatedButton(
                onPressed: () => UISnackbar.show(
                  context: context,
                  message: 'Saved successfully',
                  style: style,
                ),
                child: const Text('Show'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Show'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));

      expect(find.text('Saved successfully'), findsOneWidget);

      await tester.tap(find.byIcon(Icons.close));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 600));
      await tester.pump();

      expect(find.text('Saved successfully'), findsNothing);
    });
  });

  group('UISkeletonPlaceholder', () {
    testWidgets('renders correctly', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: UISkeletonPlaceholder(width: 100, height: 20)),
      );

      expect(find.byType(SizedBox), findsOneWidget);
    });
  });

  group('UILiveBadge', () {
    testWidgets('renders with label and style', (tester) async {
      const style = UILiveBadgeStyle(
        backgroundColor: Colors.red,
        textStyle: TextStyle(color: Colors.white),
        dotColor: Colors.white,
      );

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: UILiveBadge(style: style, label: 'LIVE'),
          ),
        ),
      );

      expect(find.text('LIVE'), findsOneWidget);
    });
  });

  group('UINoteList', () {
    testWidgets('renders title and notes', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: UINoteList(
              title: 'Notes',
              notes: [Text('Line 1'), Text('Line 2')],
            ),
          ),
        ),
      );

      expect(find.text('Notes'), findsOneWidget);
      expect(find.text('Line 1'), findsOneWidget);
      expect(find.text('Line 2'), findsOneWidget);
    });
  });

  group('UITourTooltipCard', () {
    testWidgets('renders step title and description', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 400,
              height: 600,
              child: UITourTooltipCard(
                step: const UITourStep(
                  title: 'Welcome',
                  description: 'This is step one.',
                ),
                targetRect: const Rect.fromLTWH(100, 200, 80, 40),
                currentStepIndex: 0,
                totalSteps: 3,
                onNext: () {},
                onPrevious: () {},
                onSkip: () {},
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(find.text('Welcome'), findsOneWidget);
      expect(find.text('This is step one.'), findsOneWidget);
    });
  });
}
