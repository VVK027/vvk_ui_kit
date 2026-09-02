import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vvk_ui_kit/vvk_ui_kit.dart';

void main() {
  group('UIToastManager', () {
    testWidgets('shows and dismisses toast overlay', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () => UIToastManager.show(
                  context,
                  message: 'Saved successfully',
                ),
                child: const Text('Toast'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Toast'));
      await tester.pump();

      expect(find.text('Saved successfully'), findsOneWidget);

      UIToastManager.dismiss();
      await tester.pump();

      expect(find.text('Saved successfully'), findsNothing);
    });
  });
}
