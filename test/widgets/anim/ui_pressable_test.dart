import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vvk_ui_kit/vvk_ui_kit.dart';

void main() {
  group('UIPressable', () {
    testWidgets('renders child and scales on tap down', (tester) async {
      bool tapped = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: UIPressable(
              onTap: () => tapped = true,
              child: const Text('Pressable Card'),
            ),
          ),
        ),
      );

      expect(find.text('Pressable Card'), findsOneWidget);

      final gesture = await tester.startGesture(tester.getCenter(find.text('Pressable Card')));
      await tester.pump(const Duration(milliseconds: 50));

      final animatedScale = tester.widget<AnimatedScale>(find.byType(AnimatedScale));
      expect(animatedScale.scale, 0.96);

      await gesture.up();
      await tester.pumpAndSettle();

      expect(tapped, isTrue);
    });
  });
}
