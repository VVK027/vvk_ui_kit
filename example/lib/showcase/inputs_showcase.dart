import 'package:flutter/material.dart';
import 'package:vvk_ui_kit/vvk_ui_kit.dart';

import 'common.dart';
import 'showcase_scaffold.dart';

class InputsShowcase extends StatefulWidget {
  const InputsShowcase({super.key});

  @override
  State<InputsShowcase> createState() => _InputsShowcaseState();
}

class _InputsShowcaseState extends State<InputsShowcase> {
  String? _dropdownValue;
  String? _overlayValue;
  bool _switchValue = true;
  double _sliderValue = 0.4;
  num _numberValue = 4;
  Color _pickerColor = const Color(0xFF2196F3);
  final _passwordController = TextEditingController();
  DateTime? _formDate = DateTime.now();
  TimeOfDay? _formTime = TimeOfDay.now();

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ShowcaseScaffold(
      title: 'Inputs',
      child: Column(
        children: [
          ShowcaseTile(name: 'UISearchBar', child: _SearchBarDemo()),
          ShowcaseTile(name: 'UITagInput', child: _TagInputDemo()),
          ShowcaseTile(
            name: 'UITextFormField',
            child: UITextFormField(
              label: 'Email',
              hintText: 'you@example.com',
              trimLeadingSpace: true,
            ),
          ),
          ShowcaseTile(
            name: 'UILabeledTextFormField',
            child: UILabeledTextFormField(
              headerText: 'Username',
              placeholderText: 'Enter username',
              requiredMarkColor: theme.colorScheme.error,
              hintTextColor: theme.colorScheme.outline,
              inputTextColor: theme.colorScheme.onSurface,
              errorTextColor: theme.colorScheme.error,
            ),
          ),
          ShowcaseTile(
            name: 'UILabeledField',
            child: UILabeledField(
              label: 'Custom field',
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Wrapped input',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          ),
          ShowcaseTile(
            name: 'UIForm',
            child: UIForm(
              child: Column(
                children: [
                  UIFormTextField(
                    name: 'name',
                    label: 'Name',
                    hintText: 'Your name',
                  ),
                  const SizedBox(height: 12),
                  UIFormCheckboxField(name: 'terms', label: 'Accept terms'),
                  const SizedBox(height: 12),
                  UIFormSwitchField(name: 'newsletter', label: 'Newsletter'),
                ],
              ),
            ),
          ),
          ShowcaseTile(
            name: 'UICalendar',
            child: UICalendar(onDateSelected: (_) {}),
          ),
          ShowcaseTile(
            name: 'UIDatePickerField',
            child: UIDatePickerField(
              label: 'Event date',
              value: DateTime.now(),
              onChanged: (_) {},
            ),
          ),
          ShowcaseTile(
            name: 'UITimePickerField',
            child: UITimePickerField(
              label: 'Event time',
              value: TimeOfDay.now(),
              onChanged: (_) {},
            ),
          ),
          ShowcaseTile(
            name: 'UINumberField',
            child: UINumberField.fromTheme(
              context,
              label: 'Quantity',
              value: _numberValue,
              min: 0,
              max: 10,
              step: 1,
              onChanged: (v) => setState(() => _numberValue = v),
            ),
          ),
          ShowcaseTile(
            name: 'UIColorPicker',
            child: UIColorPicker.fromTheme(
              context,
              value: _pickerColor,
              onChanged: (c) => setState(() => _pickerColor = c),
            ),
          ),
          ShowcaseTile(
            name: 'UIKeyboardToolbarHost',
            child: const UIKeyboardToolbarHost(
              child: Padding(
                padding: EdgeInsets.all(8),
                child: TextField(
                  decoration: InputDecoration(
                    labelText: 'Focus to see toolbar (on device)',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            ),
          ),
          ShowcaseTile(
            name: 'UITextarea',
            child: UITextarea.fromTheme(
              context,
              label: 'Description',
              hintText: 'Write a short bio',
              minLines: 3,
              maxLines: 5,
            ),
          ),
          ShowcaseTile(
            name: 'UIInputOTP',
            child: UIInputOTP(length: 6, onCompleted: (_) {}),
          ),
          ShowcaseTile(
            name: 'UISlider + UIRangeSlider',
            child: Column(
              children: [
                UISlider(
                  value: _sliderValue,
                  onChanged: (v) => setState(() => _sliderValue = v),
                ),
                const SizedBox(height: 12),
                UIRangeSlider(values: RangeValues(0.2, 0.8), onChanged: (_) {}),
              ],
            ),
          ),
          ShowcaseTile(
            name: 'UIPasswordStrengthIndicator',
            child: Column(
              children: [
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (_) => setState(() {}),
                ),
                const SizedBox(height: 8),
                UIPasswordStrengthIndicator(controller: _passwordController),
              ],
            ),
          ),
          ShowcaseTile(
            name: 'UIForm date/time/textarea fields',
            child: UIForm(
              child: Column(
                children: [
                  UIFormDateField(
                    name: 'eventDate',
                    label: 'Event date',
                    initialValue: _formDate,
                    onChanged: (v) => setState(() => _formDate = v),
                  ),
                  const SizedBox(height: 12),
                  UIFormTimeField(
                    name: 'eventTime',
                    label: 'Event time',
                    initialValue: _formTime,
                    onChanged: (v) => setState(() => _formTime = v),
                  ),
                  const SizedBox(height: 12),
                  UIFormTextareaField(
                    name: 'notes',
                    label: 'Notes',
                    hintText: 'Optional notes',
                    minLines: 2,
                    maxLines: 4,
                  ),
                ],
              ),
            ),
          ),
          ShowcaseTile(
            name: 'UIReadOnlyField',
            child: const UIReadOnlyField(
              label: 'Read only',
              value: 'Fixed value',
            ),
          ),
          ShowcaseTile(
            name: 'UIDropdown',
            child: UIDropdown.fromTheme(
              context,
              title: 'Category',
              items: const ['Work', 'Personal', 'Other'],
              selectedValue: _dropdownValue,
              onChanged: (v) => setState(() => _dropdownValue = v),
            ),
          ),
          ShowcaseTile(
            name: 'UISingleValueDropdown',
            child: const UISingleValueDropdown(
              label: 'Status',
              value: 'Active',
              items: ['Active'],
            ),
          ),
          ShowcaseTile(
            name: 'UIHierarchySearchableDropdown',
            child: UIHierarchySearchableDropdown(
              items: const [
                UIHierarchyItem(
                  title: 'Fruits',
                  subItems: [
                    UIHierarchyItem(title: 'Apple'),
                    UIHierarchyItem(title: 'Banana'),
                  ],
                ),
                UIHierarchyItem(
                  title: 'Vegetables',
                  subItems: [
                    UIHierarchyItem(title: 'Carrot'),
                    UIHierarchyItem(title: 'Broccoli'),
                  ],
                ),
              ],
              isMultiSelect: true,
              showChips: true,
              onChanged: (_) {},
            ),
          ),
          ShowcaseTile(
            name: 'UIPillSwitch',
            child: UIPillSwitch.fromTheme(
              value: _switchValue,
              onChanged: (v) => setState(() => _switchValue = v),
              width: 80,
            ),
          ),
          ShowcaseTile(
            name: 'UIOverlayDropdown',
            child: UIOverlayDropdown(
              style: overlayDropdownStyle(context),
              value: _overlayValue,
              placeholder: 'Select option',
              items: const [
                UIOverlayDropdownItem(value: 'a', label: 'Option A'),
                UIOverlayDropdownItem(value: 'b', label: 'Option B'),
              ],
              onChanged: (v) => setState(() => _overlayValue = v),
            ),
          ),
          ShowcaseTile(
            name: 'showPickerBottomSheet',
            child: UIPrimaryTextButton(
              text: 'Open picker sheet',
              onPressed: () => showPickerBottomSheet<void>(
                context: context,
                builder: (ctx) => UIPickerSheetHeader(
                  cancelLabel: 'Cancel',
                  doneLabel: 'Done',
                  onCancel: () => Navigator.pop(ctx),
                  onDone: () => Navigator.pop(ctx),
                ),
              ),
            ),
          ),
          ShowcaseTile(
            name: 'UISettingsStatusChip',
            child: UISettingsStatusChip(
              isOn: _switchValue,
              onLabel: 'On',
              offLabel: 'Off',
            ),
          ),
          ShowcaseTile(
            name: 'UISettingsNavigationTile',
            child: UISettingsNavigationTile(
              title: 'Account',
              onTap: () {},
              leading: UISettingsTiles.materialIconLeading(context, icon: Icons.person),
            ),
          ),
          ShowcaseTile(
            name: 'UISettingsSwitchTile',
            child: UISettingsSwitchTile(
              title: 'Notifications',
              value: _switchValue,
              onChanged: (v) => setState(() => _switchValue = v),
            ),
          ),
          ShowcaseTile(
            name: 'UISettingsTimeTile',
            child: UISettingsTimeTile(
              label: 'Reminder',
              enabled: true,
              timeText: '09:30',
              onTap: () {},
            ),
          ),
          ShowcaseTile(
            name: 'UISettingsSectionLabel',
            child: const UISettingsSectionLabel(label: 'General'),
          ),
          ShowcaseTile(
            name: 'UISettingsSaveFab',
            child: Align(
              alignment: Alignment.centerRight,
              child: UISettingsSaveFab(tooltip: 'Save', onPressed: () {}),
            ),
          ),
        ],
      ),
    );
  }
}

class _TagInputDemo extends StatefulWidget {
  @override
  State<_TagInputDemo> createState() => _TagInputDemoState();
}

class _TagInputDemoState extends State<_TagInputDemo> {
  List<String> _tags = const ['flutter', 'ui'];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        UITagInput(
          initialTags: _tags,
          onTagsChanged: (tags) => setState(() => _tags = tags),
          hint: 'Add a tag',
        ),
        const SizedBox(height: 8),
        UIText('Tags: ${_tags.join(', ')}'),
      ],
    );
  }
}

class _SearchBarDemo extends StatefulWidget {
  @override
  State<_SearchBarDemo> createState() => _SearchBarDemoState();
}

class _SearchBarDemoState extends State<_SearchBarDemo> {
  String _query = '';
  bool _ascending = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        UISearchBar.fromTheme(
          context,
          hintText: 'Search items',
          onChanged: (value) => setState(() => _query = value),
          onSortDirectionChanged: (ascending) =>
              setState(() => _ascending = ascending),
          onFilterTap: () {},
        ),
        const SizedBox(height: 8),
        UIText('Query: $_query | Sort: ${_ascending ? 'asc' : 'desc'}'),
      ],
    );
  }
}
