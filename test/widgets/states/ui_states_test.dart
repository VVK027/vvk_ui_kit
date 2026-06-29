import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vvk_ui_kit/vvk_ui_kit.dart';

void main() {
  group('UIErrorInfo', () {
    testWidgets('renders title, description and handles button press', (
      tester,
    ) async {
      var pressed = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: UIErrorInfo(
              title: 'Error',
              description: 'Something went wrong',
              btnText: 'Retry',
              onPressed: () => pressed = true,
            ),
          ),
        ),
      );

      expect(find.text('Error'), findsOneWidget);
      expect(find.text('Something went wrong'), findsOneWidget);
      expect(find.text('Retry'), findsOneWidget);

      await tester.tap(find.text('Retry'));
      expect(pressed, isTrue);
    });
  });
}
