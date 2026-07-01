import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vvk_ui_kit/vvk_ui_kit.dart';

void main() {
  group('UIDivider', () {
    testWidgets('renders with correct color', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: UIDivider(color: Colors.red)),
        ),
      );

      final divider = tester.widget<Divider>(find.byType(Divider));
      expect(divider.color, Colors.red);
    });
  });

  group('UIFixedSectionListView', () {
    testWidgets('renders all sections', (tester) async {
      final sections = [
        const Text('Section 1'),
        const Text('Section 2'),
        const Text('Section 3'),
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: UIFixedSectionListView(sections: sections)),
        ),
      );

      expect(find.text('Section 1'), findsOneWidget);
      expect(find.text('Section 2'), findsOneWidget);
      expect(find.text('Section 3'), findsOneWidget);
    });
  });

  group('UIScrollableScreen', () {
    testWidgets('renders child content', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: UIScrollableScreen(child: Text('Scrollable Content')),
          ),
        ),
      );

      expect(find.text('Scrollable Content'), findsOneWidget);
      expect(find.byType(SingleChildScrollView), findsOneWidget);
    });

    testWidgets('renders slivers in custom mode', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: UIScrollableScreen(
              type: UIScrollableType.custom,
              slivers: [SliverToBoxAdapter(child: Text('Sliver Content'))],
            ),
          ),
        ),
      );

      expect(find.text('Sliver Content'), findsOneWidget);
      expect(find.byType(CustomScrollView), findsOneWidget);
    });
  });

  group('UIPageScaffold', () {
    testWidgets('renders constrained scrollable body', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: UIPageScaffold(
            maxContentWidth: 300,
            body: Text('Page body'),
          ),
        ),
      );

      expect(find.text('Page body'), findsOneWidget);
      expect(find.byType(SingleChildScrollView), findsOneWidget);
    });
  });

  group('UIExpandableFloatingPanel', () {
    testWidgets('expands and collapses on toggle', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: UIExpandableFloatingPanel(
              title: const Text('Panel title'),
              toggleIconBuilder: (expanded) =>
                  Icon(expanded ? Icons.close : Icons.add),
              child: const Text('Panel content'),
            ),
          ),
        ),
      );

      expect(find.text('Panel content'), findsNothing);

      await tester.tap(find.byKey(const Key('ui_expandable_floating_panel_toggle')));
      await tester.pumpAndSettle();

      expect(find.text('Panel content'), findsOneWidget);
      expect(find.text('Panel title'), findsOneWidget);
    });
  });

  group('UIKeyboardDismissArea', () {
    testWidgets('unfocuses primary focus on tap', (tester) async {
      final focusNode = FocusNode();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              height: 400,
              width: 400,
              child: UIKeyboardDismissArea(
                child: Column(
                  children: [
                    TextField(focusNode: focusNode),
                    const Spacer(),
                  ],
                ),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.byType(TextField));
      await tester.pump();
      expect(focusNode.hasFocus, isTrue);

      await tester.tapAt(const Offset(200, 350));
      await tester.pump();
      expect(focusNode.hasFocus, isFalse);

      focusNode.dispose();
    });
  });

  group('UIDashedDivider', () {
    testWidgets('renders inside bounded width', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 100,
              child: UIDashedDivider(color: Colors.blue),
            ),
          ),
        ),
      );

      expect(find.byType(UIDashedDivider), findsOneWidget);
    });
  });

  group('UISeparatedColumn', () {
    testWidgets('inserts separators between children', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: UISeparatedColumn(
              separatorBuilder: (_, _) => const Divider(height: 1),
              children: const [Text('One'), Text('Two'), Text('Three')],
            ),
          ),
        ),
      );

      expect(find.text('One'), findsOneWidget);
      expect(find.text('Two'), findsOneWidget);
      expect(find.text('Three'), findsOneWidget);
      expect(find.byType(Divider), findsNWidgets(2));
    });
  });

  group('UICenteredTextDivider', () {
    testWidgets('renders centered label between lines', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: UICenteredTextDivider(text: 'OR')),
        ),
      );

      expect(find.text('OR'), findsOneWidget);
      expect(find.byType(UICenteredTextDivider), findsOneWidget);
    });
  });

  group('UIDynamicOverflow', () {
    testWidgets('shows overflow control when children do not fit', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: SizedBox(
                width: 140,
                child: UIDynamicOverflow(
                  children: const [
                    SizedBox(width: 80, child: Text('Alpha')),
                    SizedBox(width: 80, child: Text('Beta')),
                    SizedBox(width: 80, child: Text('Gamma')),
                  ],
                  overflowBuilder: (context, hidden) {
                    return UIDynamicOverflowMenuButton(
                      hiddenIndices: hidden,
                      menuItems: [
                        for (final index in hidden)
                          UIContextMenuItem(
                            label: 'Item $index',
                            onTap: () {},
                          ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      );

      await tester.pump();
      await tester.pump();
      await tester.pump();

      expect(find.byIcon(Icons.more_horiz), findsOneWidget);
      expect(find.text('Alpha'), findsOneWidget);
    });
  });

  group('UIGlassScaffold', () {
    testWidgets('renders body over gradient background', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) => UIGlassScaffold.fromTheme(
              context,
              body: const Text('Glass body'),
            ),
          ),
        ),
      );

      expect(find.text('Glass body'), findsOneWidget);
      expect(find.byType(Scaffold), findsOneWidget);
    });
  });

  group('UIPortal', () {
    testWidgets('shows overlay when visible', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: UIPortal(
              visible: true,
              overlay: Material(child: Text('Overlay')),
              child: Text('Anchor'),
            ),
          ),
        ),
      );

      await tester.pump();
      expect(find.text('Overlay'), findsOneWidget);
      expect(find.text('Anchor'), findsOneWidget);
    });
  });

  group('UIKeyboardToolbar', () {
    testWidgets('renders done button', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: UIKeyboardToolbar())),
      );

      expect(find.text('Done'), findsOneWidget);
    });

    testWidgets('host shows toolbar when keyboard inset is present', (
      tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: MediaQuery(
              data: MediaQueryData(
                viewInsets: EdgeInsets.only(bottom: 300),
              ),
              child: UIKeyboardToolbarHost(child: SizedBox()),
            ),
          ),
        ),
      );

      expect(find.byType(UIKeyboardToolbar), findsOneWidget);
    });
  });

  group('UISeparatedRow', () {
    testWidgets('inserts separators between children', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: UISeparatedRow(
              separatorBuilder: (_, _) => const VerticalDivider(width: 1),
              children: const [Text('One'), Text('Two'), Text('Three')],
            ),
          ),
        ),
      );

      expect(find.text('One'), findsOneWidget);
      expect(find.text('Two'), findsOneWidget);
      expect(find.text('Three'), findsOneWidget);
      expect(find.byType(VerticalDivider), findsNWidgets(2));
    });
  });

  group('UISeparatedFlex', () {
    testWidgets('supports first and last separators', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: UISeparatedFlex(
              direction: Axis.vertical,
              includeFirstSeparator: true,
              includeLastSeparator: true,
              separatorBuilder: (_, _) => const Divider(height: 1),
              children: const [Text('Alpha'), Text('Beta')],
            ),
          ),
        ),
      );

      expect(find.text('Alpha'), findsOneWidget);
      expect(find.text('Beta'), findsOneWidget);
      expect(find.byType(Divider), findsNWidgets(3));
    });
  });

  group('UISpacing', () {
    testWidgets('renders horizontal spacing', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Row(
              children: [
                Text('A'),
                UISpacing.horizontal(16),
                Text('B'),
              ],
            ),
          ),
        ),
      );

      final spacing = tester.widget<SizedBox>(
        find.descendant(
          of: find.byType(Row),
          matching: find.byWidgetPredicate(
            (w) => w is SizedBox && w.width == 16,
          ),
        ),
      );
      expect(spacing.width, 16);
    });
  });
}
