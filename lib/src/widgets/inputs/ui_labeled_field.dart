import 'package:flutter/material.dart';
import '../text/ui_text.dart';

/// A labeled form field that wraps an arbitrary input [child].
class UILabeledField extends StatelessWidget {
  final String? label;
  final Widget? labelChild;
  final Widget child;
  final double gap;
  final TextStyle? labelStyle;

  const UILabeledField({
    super.key,
    this.label,
    this.labelChild,
    required this.child,
    this.gap = 6,
    this.labelStyle,
  }) : assert(
         labelChild != null || label != null,
         'Either label or labelChild must be provided.',
       );

  UILabeledField copyWith({
    Key? key,
    String? label,
    Widget? labelChild,
    Widget? child,
    double? gap,
    TextStyle? labelStyle,
  }) {
    return UILabeledField(
      key: key ?? this.key,
      label: label ?? this.label,
      labelChild: labelChild ?? this.labelChild,
      gap: gap ?? this.gap,
      labelStyle: labelStyle ?? this.labelStyle,
      child: child ?? this.child,
    );
  }

  @override
  Widget build(BuildContext context) {
    final labelWidget =
        labelChild ??
        UIText(
          label!,
          style: labelStyle ?? const TextStyle(fontWeight: FontWeight.w500),
        );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        labelWidget,
        SizedBox(height: gap),
        child,
      ],
    );
  }
}

/// Read-only labeled value row for forms and detail screens.
class UIReadOnlyField extends StatelessWidget {
  final String? label;
  final String? value;
  final Widget? labelChild;
  final Widget? valueChild;

  const UIReadOnlyField({
    super.key,
    this.label,
    this.value,
    this.labelChild,
    this.valueChild,
  }) : assert(
         labelChild != null || label != null,
         'Either label or labelChild must be provided.',
       ),
       assert(
         valueChild != null || value != null,
         'Either value or valueChild must be provided.',
       );

  UIReadOnlyField copyWith({
    Key? key,
    String? label,
    String? value,
    Widget? labelChild,
    Widget? valueChild,
  }) {
    return UIReadOnlyField(
      key: key ?? this.key,
      label: label ?? this.label,
      value: value ?? this.value,
      labelChild: labelChild ?? this.labelChild,
      valueChild: valueChild ?? this.valueChild,
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final OutlineInputBorder border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: colorScheme.outline.withValues(alpha: 0.3)),
    );

    return UILabeledField(
      label: label,
      labelChild: labelChild,
      child:
          valueChild ??
          TextFormField(
            initialValue: value,
            readOnly: true,
            decoration: InputDecoration(
              filled: true,
              fillColor: colorScheme.surface,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 14,
              ),
              border: border,
              enabledBorder: border,
            ),
          ),
    );
  }
}

/// Read-only dropdown-style field showing a single selected value.
class UISingleValueDropdown extends StatelessWidget {
  final String? label;
  final String? value;
  final Widget? labelChild;
  final List<String>? items;
  final ValueChanged<String?>? onChanged;

  const UISingleValueDropdown({
    super.key,
    this.label,
    this.value,
    this.labelChild,
    this.items,
    this.onChanged,
  }) : assert(
         labelChild != null || label != null,
         'Either label or labelChild must be provided.',
       ),
       assert(value != null, 'value must be provided.');

  UISingleValueDropdown copyWith({
    Key? key,
    String? label,
    String? value,
    Widget? labelChild,
    List<String>? items,
    ValueChanged<String?>? onChanged,
  }) {
    return UISingleValueDropdown(
      key: key ?? this.key,
      label: label ?? this.label,
      value: value ?? this.value,
      labelChild: labelChild ?? this.labelChild,
      items: items ?? this.items,
      onChanged: onChanged ?? this.onChanged,
    );
  }

  bool get _isReadOnly =>
      onChanged == null || items == null || items!.length <= 1;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final List<String> resolvedItems = items ?? [value!];

    return UILabeledField(
      label: label,
      labelChild: labelChild,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          border: Border.all(color: colorScheme.outline.withValues(alpha: 0.3)),
          borderRadius: BorderRadius.circular(8),
          color: colorScheme.surface,
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: value,
            isExpanded: true,
            icon: Icon(Icons.keyboard_arrow_down, color: colorScheme.onSurface),
            dropdownColor: colorScheme.surface,
            items: resolvedItems
                .map(
                  (item) => DropdownMenuItem<String>(
                    value: item,
                    child: UIText(item),
                  ),
                )
                .toList(growable: false),
            onChanged: _isReadOnly ? null : onChanged,
          ),
        ),
      ),
    );
  }
}
