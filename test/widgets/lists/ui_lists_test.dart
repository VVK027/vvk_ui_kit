import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vvk_ui_kit/vvk_ui_kit.dart';

void main() {
  group('UISwipeActionTile', () {
    testWidgets('reveals actions on swipe and fires onTap', (tester) async {
      var deleted = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: UISwipeActionTile(
              actions: [
                UISwipeAction(
                  icon: Icons.delete_outline,
                  backgroundColor: Colors.red,
                  onTap: () => deleted = true,
                ),
              ],
              child: const ListTile(title: Text('Swipe me')),
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.delete_outline), findsOneWidget);

      await tester.drag(find.text('Swipe me'), const Offset(-120, 0));
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.delete_outline));
      await tester.pumpAndSettle();

      expect(deleted, isTrue);
    });
  });
}
