import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vvk_ui_kit/vvk_ui_kit.dart';

Widget _wrap(Widget child) => MaterialApp(
  theme: UIAppTheme.light,
  home: Scaffold(body: Center(child: child)),
);

void main() {
  group('accessibility', () {
    testWidgets('UIStyledButton exposes semanticsLabel and hint', (
      tester,
    ) async {
      final handle = tester.ensureSemantics();
      await tester.pumpWidget(
        _wrap(
          Builder(
            builder: (context) => UIStyledButton(
              style: UIStyledButtonStyle.primary(context),
              onPressed: () {},
              semanticsLabel: 'Submit form',
              semanticsHint: 'Sends the registration form',
              child: const Text('Submit'),
            ),
          ),
        ),
      );

      expect(find.bySemanticsLabel('Submit form'), findsOneWidget);
      handle.dispose();
    });

    testWidgets('UIIconButton exposes label from semanticsLabel', (
      tester,
    ) async {
      final handle = tester.ensureSemantics();
      await tester.pumpWidget(
        _wrap(
          UIIconButton(
            Icons.delete,
            onPressed: () {},
            semanticsLabel: 'Delete item',
          ),
        ),
      );

      expect(find.bySemanticsLabel('Delete item'), findsOneWidget);
      handle.dispose();
    });

    testWidgets('UISplitButton labels primary action and menu toggle', (
      tester,
    ) async {
      final handle = tester.ensureSemantics();
      await tester.pumpWidget(
        _wrap(
          Builder(
            builder: (context) => UISplitButton.fromTheme(
              context,
              label: 'Save',
              onPressed: () {},
              menuItems: const [UISplitButtonMenuItem(label: 'Save as draft')],
            ),
          ),
        ),
      );

      expect(find.bySemanticsLabel('Save'), findsOneWidget);
      expect(find.bySemanticsLabel('More actions'), findsOneWidget);
      handle.dispose();
    });

    testWidgets('UILoadingOverlay marks its scrim as a live region', (
      tester,
    ) async {
      final handle = tester.ensureSemantics();
      await tester.pumpWidget(
        _wrap(
          const UILoadingOverlay(
            visible: true,
            message: 'Loading data',
            child: SizedBox.expand(),
          ),
        ),
      );
      await tester.pump();

      expect(
        find.byWidgetPredicate(
          (w) =>
              w is Semantics &&
              w.properties.liveRegion == true &&
              w.properties.label == 'Loading data',
        ),
        findsOneWidget,
      );
      handle.dispose();
    });

    testWidgets('UIRatingBar exposes a custom semantics label', (tester) async {
      final handle = tester.ensureSemantics();
      await tester.pumpWidget(
        _wrap(
          const UIRatingBar(initialRating: 3, semanticsLabel: 'Product rating'),
        ),
      );

      expect(find.bySemanticsLabel('Product rating'), findsOneWidget);
      handle.dispose();
    });
  });
}
