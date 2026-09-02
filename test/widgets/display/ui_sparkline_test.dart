import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vvk_ui_kit/vvk_ui_kit.dart';

void main() {
  group('UISparkline', () {
    testWidgets('renders CustomPaint with dataset', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: UISparkline(
              data: [10, 25, 15, 40, 30, 50],
            ),
          ),
        ),
      );

      expect(find.byType(UISparkline), findsOneWidget);
    });
  });
}
