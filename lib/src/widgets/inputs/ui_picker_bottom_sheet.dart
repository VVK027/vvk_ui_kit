import 'package:flutter/material.dart';
import 'package:vvk_ui_kit/src/widgets/buttons/ui_cupertino_text_button.dart';

/// Shows a fixed-height modal bottom sheet for picker UIs.
Future<T?> showPickerBottomSheet<T>({
  required BuildContext context,
  required Widget Function(BuildContext context) builder,
  double height = 300,
}) {
  final surface = Theme.of(context).colorScheme.surface;
  return showModalBottomSheet<T>(
    context: context,
    backgroundColor: surface,
    isScrollControlled: true,
    builder: (sheetContext) {
      final bottom = MediaQuery.paddingOf(sheetContext).bottom;
      return SafeArea(
        top: false,
        child: Material(
          color: Theme.of(sheetContext).colorScheme.surface,
          child: SizedBox(
            height: height + bottom,
            child: builder(sheetContext),
          ),
        ),
      );
    },
  );
}

/// Cancel/done header row for picker bottom sheets opened via [showPickerBottomSheet].
class UIPickerSheetHeader extends StatelessWidget {
  const UIPickerSheetHeader({
    super.key,
    required this.onCancel,
    required this.onDone,
    required this.cancelLabel,
    required this.doneLabel,
  });

  final VoidCallback onCancel;
  final VoidCallback onDone;
  final String cancelLabel;
  final String doneLabel;

  UIPickerSheetHeader copyWith({
    Key? key,
    VoidCallback? onCancel,
    VoidCallback? onDone,
    String? cancelLabel,
    String? doneLabel,
  }) {
    return UIPickerSheetHeader(
      key: key ?? this.key,
      onCancel: onCancel ?? this.onCancel,
      onDone: onDone ?? this.onDone,
      cancelLabel: cancelLabel ?? this.cancelLabel,
      doneLabel: doneLabel ?? this.doneLabel,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        UICupertinoTextButton(title: cancelLabel, onPressed: onCancel),
        UICupertinoTextButton(title: doneLabel, onPressed: onDone),
      ],
    );
  }
}

Color pickerSheetBackground(BuildContext context) =>
    Theme.of(context).colorScheme.surface;

TextStyle pickerSheetItemStyle(BuildContext context) =>
    Theme.of(context).textTheme.bodyLarge ??
    const TextStyle(fontSize: 16, fontWeight: FontWeight.w500);
