import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../core/utils/adaptive_platform_util.dart';

/// A selectable action in [showUIAdaptiveAlertDialog].
class UIAdaptiveDialogAction<T> {
  const UIAdaptiveDialogAction({
    required this.label,
    required this.value,
    this.isDefault = false,
    this.isDestructive = false,
  });

  final String label;
  final T value;
  final bool isDefault;
  final bool isDestructive;
}

/// Shows a platform-appropriate alert dialog.
///
/// Uses [CupertinoAlertDialog] on iOS and macOS, [AlertDialog] elsewhere.
/// Returns the selected action [T] value, or `null` when dismissed.
Future<T?> showUIAdaptiveAlertDialog<T>({
  required BuildContext context,
  String? title,
  String? message,
  required List<UIAdaptiveDialogAction<T>> actions,
  bool barrierDismissible = true,
  bool forceCupertino = false,
  bool forceMaterial = false,
}) {
  assert(actions.isNotEmpty, 'actions must not be empty.');
  assert(
    !(forceCupertino && forceMaterial),
    'forceCupertino and forceMaterial cannot both be true.',
  );

  final useCupertino = useAdaptiveCupertino(
    forceCupertino: forceCupertino,
    forceMaterial: forceMaterial,
  );

  return showDialog<T>(
    context: context,
    barrierDismissible: barrierDismissible,
    builder: (dialogContext) {
      if (useCupertino) {
        return CupertinoAlertDialog(
          title: title == null ? null : Text(title),
          content: message == null ? null : Text(message),
          actions: [
            for (final action in actions)
              CupertinoDialogAction(
                onPressed: () =>
                    Navigator.of(dialogContext).pop(action.value),
                isDefaultAction: action.isDefault,
                isDestructiveAction: action.isDestructive,
                child: Text(action.label),
              ),
          ],
        );
      }

      final theme = Theme.of(dialogContext);
      return AlertDialog(
        title: title == null ? null : Text(title),
        content: message == null ? null : Text(message),
        actions: [
          for (final action in actions)
            TextButton(
              onPressed: () =>
                  Navigator.of(dialogContext).pop(action.value),
              style: action.isDestructive
                  ? TextButton.styleFrom(
                      foregroundColor: theme.colorScheme.error,
                    )
                  : null,
              child: Text(action.label),
            ),
        ],
      );
    },
  );
}

