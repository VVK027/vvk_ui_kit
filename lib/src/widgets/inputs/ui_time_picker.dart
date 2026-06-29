import 'package:flutter/material.dart';
import 'package:vvk_ui_kit/src/widgets/inputs/ui_form.dart';
import 'package:vvk_ui_kit/src/widgets/inputs/ui_picker_bottom_sheet.dart';
import 'package:vvk_ui_kit/src/widgets/text/ui_text.dart';
import 'package:intl/intl.dart';

/// Tappable time field that opens a time picker.
class UITimePickerField extends StatelessWidget {
  const UITimePickerField({
    super.key,
    this.label,
    this.value,
    this.onChanged,
    this.hintText = 'Select time',
    this.enabled = true,
    this.useBottomSheet = false,
    this.timeFormat,
  });

  final String? label;
  final TimeOfDay? value;
  final ValueChanged<TimeOfDay>? onChanged;
  final String hintText;
  final bool enabled;
  final bool useBottomSheet;
  final DateFormat? timeFormat;

  String _formatTime(BuildContext context, TimeOfDay time) {
    if (timeFormat != null) {
      final now = DateTime.now();
      final dt = DateTime(now.year, now.month, now.day, time.hour, time.minute);
      return timeFormat!.format(dt);
    }
    return time.format(context);
  }

  Future<void> _openPicker(BuildContext context) async {
    if (!enabled || onChanged == null) return;

    if (useBottomSheet) {
      TimeOfDay temp = value ?? TimeOfDay.now();
      await showPickerBottomSheet<void>(
        context: context,
        height: 280,
        builder: (sheetContext) {
          return Column(
            children: [
              UIPickerSheetHeader(
                cancelLabel: 'Cancel',
                doneLabel: 'Done',
                onCancel: () => Navigator.pop(sheetContext),
                onDone: () {
                  onChanged!(temp);
                  Navigator.pop(sheetContext);
                },
              ),
              Expanded(
                child: CupertinoTimePickerWrapper(
                  initialTime: temp,
                  onChanged: (time) => temp = time,
                ),
              ),
            ],
          );
        },
      );
      return;
    }

    final picked = await showTimePicker(
      context: context,
      initialTime: value ?? TimeOfDay.now(),
    );
    if (picked != null) onChanged!(picked);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final display = value == null ? hintText : _formatTime(context, value!);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          UIText(label!, style: theme.textTheme.labelLarge),
          const SizedBox(height: 8),
        ],
        InkWell(
          onTap: enabled ? () => _openPicker(context) : null,
          borderRadius: BorderRadius.circular(12),
          child: InputDecorator(
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              suffixIcon: const Icon(Icons.schedule_outlined),
            ),
            child: Text(
              display,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: value == null
                    ? theme.colorScheme.outline
                    : theme.colorScheme.onSurface,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// Dual-wheel hour/minute picker for bottom sheets and inline use.
class CupertinoTimePickerWrapper extends StatefulWidget {
  const CupertinoTimePickerWrapper({
    super.key,
    required this.initialTime,
    required this.onChanged,
    this.itemExtent = 44,
    this.diameterRatio = 1.4,
  });

  final TimeOfDay initialTime;
  final ValueChanged<TimeOfDay> onChanged;
  final double itemExtent;
  final double diameterRatio;

  @override
  State<CupertinoTimePickerWrapper> createState() =>
      _CupertinoTimePickerWrapperState();
}

class _CupertinoTimePickerWrapperState
    extends State<CupertinoTimePickerWrapper> {
  late FixedExtentScrollController _hourController;
  late FixedExtentScrollController _minuteController;
  late int _hour;
  late int _minute;

  @override
  void initState() {
    super.initState();
    _hour = widget.initialTime.hour;
    _minute = widget.initialTime.minute;
    _hourController = FixedExtentScrollController(initialItem: _hour);
    _minuteController = FixedExtentScrollController(initialItem: _minute);
  }

  @override
  void dispose() {
    _hourController.dispose();
    _minuteController.dispose();
    super.dispose();
  }

  void _updateTime({int? hour, int? minute}) {
    setState(() {
      _hour = hour ?? _hour;
      _minute = minute ?? _minute;
    });
    widget.onChanged(TimeOfDay(hour: _hour, minute: _minute));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme.titleMedium;
    final selectedStyle = theme.textTheme.titleLarge?.copyWith(
      fontWeight: FontWeight.w700,
      color: theme.colorScheme.primary,
    );

    return Center(
      child: SizedBox(
        height: 180,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _TimeWheel(
              controller: _hourController,
              itemCount: 24,
              selectedIndex: _hour,
              itemExtent: widget.itemExtent,
              diameterRatio: widget.diameterRatio,
              style: style,
              selectedStyle: selectedStyle,
              labelBuilder: (index) => index.toString().padLeft(2, '0'),
              onSelected: (index) => _updateTime(hour: index),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Text(':', style: selectedStyle),
            ),
            _TimeWheel(
              controller: _minuteController,
              itemCount: 60,
              selectedIndex: _minute,
              itemExtent: widget.itemExtent,
              diameterRatio: widget.diameterRatio,
              style: style,
              selectedStyle: selectedStyle,
              labelBuilder: (index) => index.toString().padLeft(2, '0'),
              onSelected: (index) => _updateTime(minute: index),
            ),
          ],
        ),
      ),
    );
  }
}

class _TimeWheel extends StatelessWidget {
  const _TimeWheel({
    required this.controller,
    required this.itemCount,
    required this.selectedIndex,
    required this.itemExtent,
    required this.diameterRatio,
    required this.style,
    required this.selectedStyle,
    required this.labelBuilder,
    required this.onSelected,
  });

  final FixedExtentScrollController controller;
  final int itemCount;
  final int selectedIndex;
  final double itemExtent;
  final double diameterRatio;
  final TextStyle? style;
  final TextStyle? selectedStyle;
  final String Function(int index) labelBuilder;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListWheelScrollView.useDelegate(
        controller: controller,
        itemExtent: itemExtent,
        diameterRatio: diameterRatio,
        physics: const FixedExtentScrollPhysics(),
        onSelectedItemChanged: onSelected,
        childDelegate: ListWheelChildBuilderDelegate(
          childCount: itemCount,
          builder: (context, index) {
            final isSelected = index == selectedIndex;
            return Center(
              child: Text(
                labelBuilder(index),
                style: isSelected ? selectedStyle : style,
              ),
            );
          },
        ),
      ),
    );
  }
}

/// Form-integrated time field.
class UIFormTimeField extends StatelessWidget {
  const UIFormTimeField({
    super.key,
    required this.name,
    this.label,
    this.initialValue,
    this.enabled = true,
    this.useBottomSheet = false,
    this.onChanged,
  });

  final String name;
  final String? label;
  final TimeOfDay? initialValue;
  final bool enabled;
  final bool useBottomSheet;
  final ValueChanged<TimeOfDay?>? onChanged;

  @override
  Widget build(BuildContext context) {
    return UIFormField<TimeOfDay>(
      name: name,
      initialValue: initialValue,
      enabled: enabled,
      builder: (state) {
        return UITimePickerField(
          label: label,
          value: state.value,
          enabled: enabled,
          useBottomSheet: useBottomSheet,
          onChanged: (time) {
            state.didChange(time);
            onChanged?.call(time);
          },
        );
      },
    );
  }
}
