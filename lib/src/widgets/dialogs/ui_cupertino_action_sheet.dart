import 'package:flutter/cupertino.dart';

/// A selectable action in [showUICupertinoActionSheet].
class UICupertinoActionSheetAction<T> {
  const UICupertinoActionSheetAction({
    required this.label,
    required this.value,
    this.isDestructive = false,
    this.isDefaultAction = false,
  });

  final String label;
  final T value;
  final bool isDestructive;
  final bool isDefaultAction;
}

/// Shows a Cupertino-style action sheet and returns the selected [T] value.
///
/// Returns `null` when the sheet is dismissed via cancel or drag.
Future<T?> showUICupertinoActionSheet<T>({
  required BuildContext context,
  String? title,
  String? message,
  required List<UICupertinoActionSheetAction<T>> actions,
  String cancelLabel = 'Cancel',
}) {
  assert(actions.isNotEmpty, 'actions must not be empty.');

  return showCupertinoModalPopup<T>(
    context: context,
    builder: (sheetContext) {
      return CupertinoActionSheet(
        title: title == null ? null : Text(title),
        message: message == null ? null : Text(message),
        actions: [
          for (final action in actions)
            CupertinoActionSheetAction(
              onPressed: () => Navigator.of(sheetContext).pop(action.value),
              isDestructiveAction: action.isDestructive,
              isDefaultAction: action.isDefaultAction,
              child: Text(action.label),
            ),
        ],
        cancelButton: CupertinoActionSheetAction(
          onPressed: () => Navigator.of(sheetContext).pop(),
          child: Text(cancelLabel),
        ),
      );
    },
  );
}
