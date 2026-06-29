import 'package:flutter/material.dart';
import 'package:vvk_ui_kit/src/widgets/inputs/ui_form.dart';
import 'package:vvk_ui_kit/src/widgets/inputs/ui_calendar.dart';
import 'package:vvk_ui_kit/src/widgets/inputs/ui_picker_bottom_sheet.dart';
import 'package:vvk_ui_kit/src/widgets/text/ui_text.dart';
import 'package:intl/intl.dart';

/// Tappable date field that opens a calendar picker.
class UIDatePickerField extends StatelessWidget {
  const UIDatePickerField({
    super.key,
    this.label,
    this.value,
    this.onChanged,
    this.firstDate,
    this.lastDate,
    this.hintText = 'Select date',
    this.enabled = true,
    this.useBottomSheet = false,
    this.dateFormat,
  });

  final String? label;
  final DateTime? value;
  final ValueChanged<DateTime>? onChanged;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final String hintText;
  final bool enabled;
  final bool useBottomSheet;
  final DateFormat? dateFormat;

  Future<void> _openPicker(BuildContext context) async {
    if (!enabled || onChanged == null) return;

    if (useBottomSheet) {
      await showPickerBottomSheet<void>(
        context: context,
        height: 380,
        builder: (sheetContext) {
          return Column(
            children: [
              UIPickerSheetHeader(
                cancelLabel: 'Cancel',
                doneLabel: 'Done',
                onCancel: () => Navigator.pop(sheetContext),
                onDone: () => Navigator.pop(sheetContext),
              ),
              Expanded(
                child: UICalendar(
                  selectedDate: value,
                  firstDate: firstDate,
                  lastDate: lastDate,
                  onDateSelected: (date) {
                    onChanged!(date);
                    Navigator.pop(sheetContext);
                  },
                ),
              ),
            ],
          );
        },
      );
      return;
    }

    final picked = await showDatePicker(
      context: context,
      initialDate: value ?? DateTime.now(),
      firstDate: firstDate ?? DateTime(1900),
      lastDate: lastDate ?? DateTime(2100),
    );
    if (picked != null) onChanged!(picked);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final formatter = dateFormat ?? DateFormat.yMMMd();
    final display = value == null ? hintText : formatter.format(value!);

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
              suffixIcon: const Icon(Icons.calendar_today_outlined),
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

/// Form-integrated date field.
class UIFormDateField extends StatelessWidget {
  const UIFormDateField({
    super.key,
    required this.name,
    this.label,
    this.initialValue,
    this.validator,
    this.firstDate,
    this.lastDate,
    this.enabled = true,
    this.useBottomSheet = false,
    this.onChanged,
  });

  final String name;
  final String? label;
  final DateTime? initialValue;
  final String? Function(DateTime?)? validator;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final bool enabled;
  final bool useBottomSheet;
  final ValueChanged<DateTime?>? onChanged;

  @override
  Widget build(BuildContext context) {
    return UIFormField<DateTime>(
      name: name,
      initialValue: initialValue,
      validator: validator,
      enabled: enabled,
      builder: (state) {
        return UIDatePickerField(
          label: label,
          value: state.value,
          enabled: enabled,
          firstDate: firstDate,
          lastDate: lastDate,
          useBottomSheet: useBottomSheet,
          onChanged: (date) {
            state.didChange(date);
            onChanged?.call(date);
          },
        );
      },
    );
  }
}
