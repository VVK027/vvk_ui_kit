import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vvk_ui_kit/vvk_ui_kit.dart';

void main() {
  group('UISharedAxisPageRoute', () {
    testWidgets('navigates with shared axis transition', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () => Navigator.of(context).push<void>(
                  UISharedAxisPageRoute(
                    builder: (context) => const Scaffold(
                      body: Text('Shared Axis Next Page'),
                    ),
                  ),
                ),
                child: const Text('Next'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Next'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.text('Shared Axis Next Page'), findsOneWidget);
    });
  });
}
