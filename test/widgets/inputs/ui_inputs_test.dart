import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vvk_ui_kit/vvk_ui_kit.dart';

void main() {
  group('UITextFormField', () {
    testWidgets('renders label and hint, and accepts input', (tester) async {
      String? changedValue;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: UITextFormField(
              label: 'User Name',
              hintText: 'Enter name',
              onChanged: (val) => changedValue = val,
            ),
          ),
        ),
      );

      expect(find.text('User Name'), findsOneWidget);
      expect(find.text('Enter name'), findsOneWidget);

      await tester.enterText(find.byType(TextFormField), 'Viivek');
      expect(changedValue, 'Viivek');
    });

    testWidgets('toggles password visibility', (tester) async {
      bool toggled = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: UITextFormField(
              label: 'Password',
              hintText: 'Enter password',
              isPassword: true,
              obscureText: true,
              onToggleObscure: () => toggled = true,
            ),
          ),
        ),
      );

      await tester.tap(find.byType(IconButton));
      expect(toggled, isTrue);
    });
  });

  group('UILabeledField', () {
    testWidgets('renders label and child', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: UILabeledField(
              label: 'Labeled Child',
              child: Text('Child Content'),
            ),
          ),
        ),
      );

      expect(find.text('Labeled Child'), findsOneWidget);
      expect(find.text('Child Content'), findsOneWidget);
    });
  });

  group('UIPasswordStrengthIndicator', () {
    testWidgets('updates rule checklist as user types', (tester) async {
      final controller = TextEditingController();

      addTearDown(controller.dispose);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                TextField(controller: controller),
                UIPasswordStrengthIndicator(
                  controller: controller,
                  rules: const [
                    UIPasswordRule.length,
                    UIPasswordRule.uppercase,
                  ],
                  minLength: 8,
                ),
              ],
            ),
          ),
        ),
      );

      expect(find.text('At least 8 characters'), findsOneWidget);
      expect(find.byIcon(Icons.close), findsNWidgets(2));

      controller.text = 'Password1';
      await tester.pump();

      expect(find.byIcon(Icons.check), findsNWidgets(2));
    });
  });

  group('UIDropdown', () {
    testWidgets('fromTheme renders title and items', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => UIDropdown.fromTheme(
                context,
                title: 'Status',
                items: const ['A', 'B'],
              ),
            ),
          ),
        ),
      );

      expect(find.byType(UIDropdown), findsOneWidget);
      expect(find.byType(DropdownButton<String>), findsOneWidget);
    });
  });

  group('UISearchBar', () {
    testWidgets('fires onChanged and clears text', (tester) async {
      var query = '';

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: UISearchBar(
              hintText: 'Search',
              onChanged: (value) => query = value,
            ),
          ),
        ),
      );

      await tester.enterText(find.byType(TextField), 'flutter');
      await tester.pump();
      expect(query, 'flutter');
      expect(find.byKey(const Key('ui_search_bar_clear')), findsOneWidget);

      await tester.tap(find.byKey(const Key('ui_search_bar_clear')));
      expect(query, '');
    });

    testWidgets('sort button reports direction', (tester) async {
      bool? ascending;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: UISearchBar(
              onChanged: (_) {},
              onSortDirectionChanged: (value) => ascending = value,
            ),
          ),
        ),
      );

      await tester.tap(find.byKey(const Key('ui_search_bar_sort')));
      expect(ascending, isFalse);
    });
  });

  group('UITagInput', () {
    testWidgets('adds and removes tags', (tester) async {
      var tags = <String>['alpha'];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: UITagInput(
              initialTags: tags,
              onTagsChanged: (value) => tags = value,
            ),
          ),
        ),
      );

      expect(find.text('alpha'), findsOneWidget);

      await tester.enterText(find.byKey(const Key('ui_tag_input_field')), 'beta');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pump();

      expect(tags, ['alpha', 'beta']);

      await tester.tap(find.byIcon(Icons.close).first);
      await tester.pump();

      expect(tags, ['beta']);
    });
  });

  group('UINumberField', () {
    testWidgets('increments value with plus button', (tester) async {
      num value = 2;

      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) => Scaffold(
              body: UINumberField.fromTheme(
                context,
                value: value,
                min: 0,
                max: 10,
                onChanged: (v) => value = v,
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.byIcon(Icons.add));
      await tester.pump();

      expect(value, 3);
      expect(find.text('3'), findsOneWidget);
    });
  });

  group('UIColorPicker', () {
    testWidgets('renders spectrum and palette swatches', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) => Scaffold(
              body: UIColorPicker.fromTheme(
                context,
                value: Colors.blue,
                onChanged: (_) {},
              ),
            ),
          ),
        ),
      );

      expect(find.byType(UIColorPicker), findsOneWidget);
      expect(find.byType(CustomPaint), findsWidgets);
    });
  });

  group('UISlider', () {
    testWidgets('updates value on drag', (tester) async {
      double value = 0.3;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: UISlider(value: value, onChanged: (v) => value = v),
          ),
        ),
      );

      await tester.drag(find.byType(Slider), const Offset(80, 0));
      expect(value, greaterThan(0.3));
    });
  });

  group('UITextarea', () {
    testWidgets('accepts multiline input', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) => Scaffold(
              body: UITextarea.fromTheme(
                context,
                label: 'Notes',
                hintText: 'Write here',
              ),
            ),
          ),
        ),
      );

      expect(find.text('Notes'), findsOneWidget);
      await tester.enterText(find.byType(TextField), 'Line one\nLine two');
      expect(find.text('Line one\nLine two'), findsOneWidget);
    });
  });

  group('UIInputOTP', () {
    testWidgets('advances focus between slots', (tester) async {
      String? completed;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: UIInputOTP(length: 4, onCompleted: (v) => completed = v),
          ),
        ),
      );

      await tester.enterText(find.byType(TextField).first, '1');
      await tester.pump();
      await tester.enterText(find.byType(TextField).at(1), '2');
      await tester.pump();
      await tester.enterText(find.byType(TextField).at(2), '3');
      await tester.pump();
      await tester.enterText(find.byType(TextField).at(3), '4');
      await tester.pump();
      expect(completed, '1234');
    });
  });

  group('UIForm', () {
    testWidgets('tracks field values and validates', (tester) async {
      final formKey = GlobalKey<UIFormState>();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: UIForm(
              key: formKey,
              child: Column(
                children: [
                  UIFormTextField(
                    name: 'email',
                    label: 'Email',
                    validator: (v) =>
                        v == null || v.isEmpty ? 'Required' : null,
                  ),
                  UIFormCheckboxField(
                    name: 'terms',
                    label: 'Accept terms',
                    validator: (v) => v == true ? null : 'Required',
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      expect(formKey.currentState?.validate(), isFalse);
      await tester.pump();
      expect(find.text('Required'), findsWidgets);

      await tester.enterText(find.byType(TextFormField), 'user@test.com');
      await tester.tap(find.text('Accept terms'));
      await tester.pumpAndSettle();

      expect(formKey.currentState?.validate(), isTrue);
      expect(formKey.currentState?.values['email'], 'user@test.com');
      expect(formKey.currentState?.values['terms'], isTrue);
    });
  });

  group('UICalendar', () {
    testWidgets('selects a day', (tester) async {
      DateTime? selected;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: UICalendar(onDateSelected: (date) => selected = date),
            ),
          ),
        ),
      );

      await tester.tap(find.text('15').first);
      await tester.pump();
      expect(selected?.day, 15);
    });
  });

  group('UIDatePickerField', () {
    testWidgets('renders formatted value', (tester) async {
      final date = DateTime(2026, 6, 15);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: UIDatePickerField(
              label: 'Birthday',
              value: date,
              onChanged: (_) {},
            ),
          ),
        ),
      );

      expect(find.text('Birthday'), findsOneWidget);
      expect(find.textContaining('2026'), findsOneWidget);
    });
  });

  group('UITimePickerField', () {
    testWidgets('renders label and hint', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: UITimePickerField(label: 'Reminder', onChanged: (_) {}),
          ),
        ),
      );

      expect(find.text('Reminder'), findsOneWidget);
      expect(find.text('Select time'), findsOneWidget);
    });

    testWidgets('bottom sheet picker shows hour and minute wheels', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: UITimePickerField(
              useBottomSheet: true,
              onChanged: (_) {},
            ),
          ),
        ),
      );

      await tester.tap(find.text('Select time'));
      await tester.pumpAndSettle();

      expect(find.byType(ListWheelScrollView), findsNWidgets(2));
    });
  });

  group('UIReadOnlyField', () {
    testWidgets('renders read-only value', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: UIReadOnlyField(label: 'Name', value: 'John'),
          ),
        ),
      );

      expect(find.text('Name'), findsOneWidget);
      expect(find.text('John'), findsOneWidget);
    });
  });

  group('UISettingsTiles', () {
    testWidgets('UISettingsStatusChip renders correctly', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: UISettingsStatusChip(isOn: true, onLabel: 'ON', offLabel: 'OFF'),
        ),
      );
      expect(find.text('(ON)'), findsOneWidget);

      await tester.pumpWidget(
        const MaterialApp(
          home: UISettingsStatusChip(isOn: false, onLabel: 'ON', offLabel: 'OFF'),
        ),
      );
      expect(find.text('(OFF)'), findsOneWidget);
    });

    testWidgets('UISettingsNavigationTile renders and responds to tap', (
      tester,
    ) async {
      var tapped = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: UISettingsNavigationTile(
              title: 'Settings Title',
              subtitle: 'Settings Subtitle',
              onTap: () => tapped = true,
            ),
          ),
        ),
      );

      expect(find.text('Settings Title'), findsOneWidget);
      expect(find.text('Settings Subtitle'), findsOneWidget);
      await tester.tap(find.text('Settings Title'));
      expect(tapped, isTrue);
    });

    testWidgets('UISettingsSwitchTile renders and responds to change', (
      tester,
    ) async {
      var value = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) {
                return UISettingsSwitchTile(
                  title: 'Switch Title',
                  value: value,
                  onChanged: (val) => setState(() => value = val),
                );
              },
            ),
          ),
        ),
      );

      expect(find.text('Switch Title'), findsOneWidget);
      await tester.tap(find.byType(Switch));
      await tester.pumpAndSettle();
      expect(value, isTrue);
    });
  });

  group('UIOverlayDropdown', () {
    const style = UIOverlayDropdownStyle(
      backgroundColor: Colors.white,
      borderColor: Colors.grey,
      focusedBorderColor: Colors.blue,
      labelStyle: TextStyle(color: Colors.black),
      itemStyle: TextStyle(color: Colors.black),
      selectedBackgroundColor: Colors.blue,
      selectedBorderColor: Colors.blue,
      menuBackgroundColor: Colors.white,
      menuBorderColor: Colors.grey,
    );

    testWidgets('renders and opens overlay on tap', (tester) async {
      String? changedValue;
      final items = [
        const UIOverlayDropdownItem(value: '1', label: 'Item 1'),
        const UIOverlayDropdownItem(value: '2', label: 'Item 2'),
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: UIOverlayDropdown(
              items: items,
              style: style,
              onChanged: (val) => changedValue = val,
            ),
          ),
        ),
      );

      expect(find.text('Item 1'), findsOneWidget);
      await tester.tap(find.text('Item 1'));
      await tester.pumpAndSettle();

      expect(find.text('Item 2'), findsOneWidget);
      await tester.tap(find.text('Item 2').last);
      await tester.pumpAndSettle();

      expect(changedValue, '2');
    });
  });

  group('UIPickerBottomSheet', () {
    testWidgets('UIPickerSheetHeader renders and responds to actions', (
      tester,
    ) async {
      var cancelled = false;
      var done = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: UIPickerSheetHeader(
              onCancel: () => cancelled = true,
              onDone: () => done = true,
              cancelLabel: 'Cancel',
              doneLabel: 'Done',
            ),
          ),
        ),
      );

      await tester.tap(find.text('Cancel'));
      expect(cancelled, isTrue);
      await tester.tap(find.text('Done'));
      expect(done, isTrue);
    });

    testWidgets('showPickerBottomSheet displays content', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () => showPickerBottomSheet(
                  context: context,
                  builder: (_) => const Text('Picker Content'),
                ),
                child: const Text('Open Picker'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Open Picker'));
      await tester.pumpAndSettle();
      expect(find.text('Picker Content'), findsOneWidget);
    });
  });

  group('UILabeledTextFormField', () {
    testWidgets('renders all components and handles input', (tester) async {
      String? changedValue;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: UILabeledTextFormField(
              headerText: 'Field Header',
              placeholderText: 'Placeholder',
              requiredMarkColor: Colors.red,
              hintTextColor: Colors.grey,
              inputTextColor: Colors.black,
              errorTextColor: Colors.red,
              onChange: (val) => changedValue = val,
              isToShowCount: true,
              maxLength: 10,
            ),
          ),
        ),
      );

      expect(
        find.textContaining('Field Header', findRichText: true),
        findsOneWidget,
      );
      expect(find.text('Placeholder'), findsOneWidget);
      expect(find.textContaining('0/10', findRichText: true), findsOneWidget);

      await tester.enterText(find.byType(TextFormField), 'Hello');
      await tester.pump();
      expect(changedValue, 'Hello');
      expect(find.textContaining('5/10', findRichText: true), findsOneWidget);
    });

    testWidgets('shows error text', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: UILabeledTextFormField(
              errorText: 'Error occurred',
              requiredMarkColor: Colors.red,
              hintTextColor: Colors.grey,
              inputTextColor: Colors.black,
              errorTextColor: Colors.red,
            ),
          ),
        ),
      );

      expect(find.text('Error occurred'), findsOneWidget);
    });
  });

  group('UIRangeSlider', () {
    testWidgets('renders range slider', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: UIRangeSlider(
              values: const RangeValues(0.2, 0.8),
              onChanged: (_) {},
            ),
          ),
        ),
      );

      expect(find.byType(RangeSlider), findsOneWidget);
    });
  });

  group('UISingleValueDropdown', () {
    testWidgets('renders label and selected value', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: UISingleValueDropdown(
              label: 'Status',
              value: 'Active',
            ),
          ),
        ),
      );

      expect(find.text('Status'), findsOneWidget);
      expect(find.text('Active'), findsOneWidget);
    });

    testWidgets('changes value when items provided', (tester) async {
      String? selected = 'A';

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: UISingleValueDropdown(
              label: 'Pick',
              value: selected,
              items: const ['A', 'B'],
              onChanged: (v) => selected = v,
            ),
          ),
        ),
      );

      await tester.tap(find.text('A'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('B').last);
      await tester.pumpAndSettle();
      expect(selected, 'B');
    });
  });

  group('UIFormDateField', () {
    testWidgets('registers with UIForm', (tester) async {
      final formKey = GlobalKey<UIFormState>();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: UIForm(
              key: formKey,
              child: UIFormDateField(
                name: 'birthday',
                label: 'Birthday',
                initialValue: DateTime(2020, 1, 15),
              ),
            ),
          ),
        ),
      );

      expect(find.text('Birthday'), findsOneWidget);
      expect(formKey.currentState?.values['birthday'], isA<DateTime>());
    });
  });

  group('UIFormTimeField', () {
    testWidgets('registers with UIForm', (tester) async {
      final formKey = GlobalKey<UIFormState>();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: UIForm(
              key: formKey,
              child: const UIFormTimeField(
                name: 'reminder',
                label: 'Reminder',
                initialValue: TimeOfDay(hour: 9, minute: 30),
              ),
            ),
          ),
        ),
      );

      expect(find.text('Reminder'), findsOneWidget);
      expect(formKey.currentState?.values['reminder'], isA<TimeOfDay>());
    });
  });

  group('UISettingsTimeTile', () {
    testWidgets('renders and responds to tap', (tester) async {
      var tapped = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: UISettingsTimeTile(
              label: 'Alarm',
              enabled: true,
              timeText: '7:30 AM',
              onTap: () => tapped = true,
            ),
          ),
        ),
      );

      expect(find.text('Alarm'), findsOneWidget);
      expect(find.text('7:30 AM'), findsOneWidget);
      await tester.tap(find.text('Alarm'));
      expect(tapped, isTrue);
    });
  });

  group('UISettingsSaveFab', () {
    testWidgets('renders and responds to press', (tester) async {
      var pressed = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            floatingActionButton: UISettingsSaveFab(
              onPressed: () => pressed = true,
              tooltip: 'Save',
            ),
          ),
        ),
      );

      await tester.tap(find.byType(FloatingActionButton));
      expect(pressed, isTrue);
    });
  });

  group('UISettingsSectionLabel', () {
    testWidgets('renders label text', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: UISettingsSectionLabel(label: 'General'),
          ),
        ),
      );

      expect(find.text('General'), findsOneWidget);
    });
  });
}
