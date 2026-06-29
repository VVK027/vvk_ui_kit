import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vvk_ui_kit/vvk_ui_kit.dart';

void main() {
  const buttonStyle = UIStyledButtonStyle(
    height: 48,
    borderRadius: 8,
    textStyle: TextStyle(fontSize: 16),
    textColor: Colors.white,
    loadingIndicatorSize: 20,
    loadingIndicatorColor: Colors.white,
    backgroundColor: Colors.blue,
    foregroundColor: Colors.white,
    disabledBackgroundColor: Colors.grey,
    disabledForegroundColor: Colors.black,
    outlineBorderColor: Colors.blue,
  );

  group('UIStyledButton', () {
    testWidgets('renders child and responds to tap', (tester) async {
      bool pressed = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: UIStyledButton(
              style: buttonStyle,
              onPressed: () => pressed = true,
              child: const Text('Click Me'),
            ),
          ),
        ),
      );

      expect(find.text('Click Me'), findsOneWidget);
      await tester.tap(find.byType(UIStyledButton));
      expect(pressed, isTrue);
    });

    testWidgets('shows loading indicator when isLoading is true', (
      tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: UIStyledButton(
              style: buttonStyle,
              isLoading: true,
              child: Text('Click Me'),
            ),
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('is disabled when isDisabled is true', (tester) async {
      bool pressed = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: UIStyledButton(
              style: buttonStyle,
              isDisabled: true,
              onPressed: () => pressed = true,
              child: const Text('Click Me'),
            ),
          ),
        ),
      );

      await tester.tap(find.byType(UIStyledButton));
      expect(pressed, isFalse);
    });
  });

  group('UIIconButton', () {
    testWidgets('renders icon and responds to tap', (tester) async {
      bool pressed = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: UIIconButton(Icons.add, onPressed: () => pressed = true),
          ),
        ),
      );

      expect(find.byIcon(Icons.add), findsOneWidget);
      await tester.tap(find.byIcon(Icons.add));
      expect(pressed, isTrue);
    });
  });

  group('UIImageButton', () {
    testWidgets('renders image and responds to tap', (tester) async {
      bool pressed = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: UIImageButton(
              image: const Icon(
                Icons.image,
              ), // Using Icon as a placeholder for image widget
              onPressed: () => pressed = true,
            ),
          ),
        ),
      );

      expect(find.byType(Icon), findsOneWidget);
      await tester.tap(find.byType(Icon));
      expect(pressed, isTrue);
    });
  });

  group('UITextButton', () {
    testWidgets('renders text and responds to tap', (tester) async {
      bool pressed = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: UITextButton(
              text: 'Button Text',
              onPressed: () => pressed = true,
            ),
          ),
        ),
      );

      expect(find.text('Button Text'), findsOneWidget);
      await tester.tap(find.text('Button Text'));
      expect(pressed, isTrue);
    });
  });

  group('UISliderButton', () {
    testWidgets('renders slide label', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: UISliderButton(
              width: 280,
              shimmerLabel: false,
              onConfirm: () async => false,
            ),
          ),
        ),
      );

      expect(find.text('Slide to confirm'), findsOneWidget);
    });
  });

  group('UISplitButton', () {
    testWidgets('fires onPressed and opens menu items', (tester) async {
      var primaryPressed = false;
      var menuPressed = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) => Scaffold(
              body: UISplitButton.fromTheme(
                context,
                label: 'Save',
                onPressed: () => primaryPressed = true,
                menuItems: [
                  UISplitButtonMenuItem(
                    label: 'Save copy',
                    onTap: () => menuPressed = true,
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Save'));
      expect(primaryPressed, isTrue);

      await tester.tap(find.byIcon(Icons.expand_more));
      await tester.pump();
      await tester.pump();

      expect(find.text('Save copy'), findsOneWidget);
      await tester.tap(find.text('Save copy'));
      await tester.pump();
      expect(menuPressed, isTrue);
    });
  });

  group('UIGlassButton', () {
    testWidgets('renders label and fires onPressed', (tester) async {
      var pressed = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: UIGlassButton(
              label: 'Glass',
              onPressed: () => pressed = true,
            ),
          ),
        ),
      );

      expect(find.text('Glass'), findsOneWidget);
      await tester.tap(find.text('Glass'));
      expect(pressed, isTrue);
    });

    testWidgets('wraps content in AnimatedBuilder when enablePressScale is true',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: UIGlassButton(
              label: 'Scale',
              onPressed: () {},
            ),
          ),
        ),
      );

      expect(
        find.descendant(
          of: find.byType(UIGlassButton),
          matching: find.byType(AnimatedBuilder),
        ),
        findsOneWidget,
      );
    });

    testWidgets('skips AnimatedBuilder when enablePressScale is false',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: UIGlassButton(
              label: 'Flat',
              enablePressScale: false,
              onPressed: () {},
            ),
          ),
        ),
      );

      expect(
        find.descendant(
          of: find.byType(UIGlassButton),
          matching: find.byType(AnimatedBuilder),
        ),
        findsNothing,
      );
    });
  });

  group('UICustomOutlinedButton', () {
    testWidgets('renders and responds to tap', (tester) async {
      var pressed = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: UICustomOutlinedButton(
              label: 'Outlined',
              icon: Icons.add,
              onPressed: () => pressed = true,
            ),
          ),
        ),
      );

      expect(find.text('Outlined'), findsOneWidget);
      await tester.tap(find.byType(OutlinedButton));
      expect(pressed, isTrue);
    });
  });

  group('UIElevatedButton', () {
    testWidgets('renders and responds to tap', (tester) async {
      var pressed = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: UIElevatedButton(
              text: 'Elevated',
              onPressed: () => pressed = true,
            ),
          ),
        ),
      );

      expect(find.text('Elevated'), findsOneWidget);
      await tester.tap(find.text('Elevated'));
      expect(pressed, isTrue);
    });
  });

  group('UIElevatedIconButton', () {
    testWidgets('renders and responds to tap', (tester) async {
      var pressed = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: UIElevatedIconButton(
              label: 'Add Item',
              foregroundColor: Colors.white,
              icon: Icons.add,
              onPressed: () => pressed = true,
            ),
          ),
        ),
      );

      expect(find.text('Add Item'), findsOneWidget);
      await tester.tap(find.text('Add Item'));
      expect(pressed, isTrue);
    });
  });

  group('UICupertinoTextButton', () {
    testWidgets('renders title and responds to tap', (tester) async {
      var pressed = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: UICupertinoTextButton(
              title: 'Cupertino Text',
              onPressed: () => pressed = true,
            ),
          ),
        ),
      );

      expect(find.text('Cupertino Text'), findsOneWidget);
      await tester.tap(find.text('Cupertino Text'));
      expect(pressed, isTrue);
    });
  });

  group('UIPrimaryTextButton', () {
    testWidgets('renders text and responds to tap', (tester) async {
      var pressed = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: UIPrimaryTextButton(
              text: 'Primary Action',
              onPressed: () => pressed = true,
            ),
          ),
        ),
      );

      expect(find.text('Primary Action'), findsOneWidget);
      await tester.tap(find.text('Primary Action'));
      expect(pressed, isTrue);
    });
  });

  group('UIImageTextButton', () {
    testWidgets('renders text and image', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: UIImageTextButton(
              text: 'Image Button',
              imagePath: 'assets/image.png',
            ),
          ),
        ),
      );

      expect(find.text('Image Button'), findsOneWidget);
      expect(find.byType(UIImage), findsOneWidget);
    });
  });

  group('UIStyledButton variants', () {
    testWidgets('outline variant renders', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: UIStyledButton(
              style: buttonStyle,
              variant: UIStyledButtonVariant.outline,
              child: Text('Outline'),
            ),
          ),
        ),
      );

      expect(find.text('Outline'), findsOneWidget);
      expect(find.byType(OutlinedButton), findsOneWidget);
    });

    testWidgets('renders leading icon', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: UIStyledButton(
              style: buttonStyle,
              icon: Icon(Icons.add),
              child: Text('Add'),
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.add), findsOneWidget);
      expect(find.text('Add'), findsOneWidget);
    });
  });

  group('UITabTextButton', () {
    testWidgets('renders title and responds to tap', (tester) async {
      var pressed = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: UITabTextButton(
              title: 'Tab Label',
              value: 'tab',
              isActive: true,
              onPressed: () => pressed = true,
            ),
          ),
        ),
      );

      expect(find.text('Tab Label'), findsOneWidget);
      await tester.tap(find.text('Tab Label'));
      expect(pressed, isTrue);
    });
  });
}
