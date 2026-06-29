import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vvk_ui_kit/vvk_ui_kit.dart';

void main() {
  group('UIListTileSelect', () {
    testWidgets('renders title and selection, handles tap', (tester) async {
      var tapped = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: UIListTileSelect(
              title: 'Language',
              titleSelection: 'English',
              titleColor: Colors.black,
              subtitleColor: Colors.grey,
              selectedTitleColor: Colors.blue,
              unselectedTitleColor: Colors.black,
              arrowColor: Colors.grey,
              showArrow: true,
              onSelectTap: () => tapped = true,
            ),
          ),
        ),
      );

      expect(find.text('Language'), findsOneWidget);
      expect(find.text('English'), findsOneWidget);
      expect(find.byIcon(Icons.arrow_forward_ios_rounded), findsOneWidget);

      await tester.tap(find.text('English'));
      expect(tapped, isTrue);
    });
  });

  group('UIPillSwitch', () {
    testWidgets('toggles value on tap', (tester) async {
      var value = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: UIPillSwitch.fromTheme(
              value: value,
              onChanged: (v) => value = v,
            ),
          ),
        ),
      );

      await tester.tap(find.byType(UIPillSwitch));
      await tester.pumpAndSettle();
      expect(value, isTrue);
    });
  });

  group('UIRadioGroup', () {
    testWidgets('selects radio option', (tester) async {
      String? selected = 'a';

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: UIRadioGroup<String>(
              value: selected,
              onChanged: (v) => selected = v,
              children: const [
                UIRadio<String>(value: 'a', label: 'A'),
                UIRadio<String>(value: 'b', label: 'B'),
              ],
            ),
          ),
        ),
      );

      await tester.tap(find.text('B'));
      await tester.pumpAndSettle();
      expect(selected, 'b');
    });
  });

  group('UIRoundedCheckbox', () {
    testWidgets('toggles value when tapped', (tester) async {
      bool? latest;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: UIRoundedCheckbox(
              value: false,
              label: 'Accept terms',
              onChanged: (value) => latest = value,
            ),
          ),
        ),
      );

      await tester.tap(find.text('Accept terms'));
      expect(latest, isTrue);
    });
  });
}
