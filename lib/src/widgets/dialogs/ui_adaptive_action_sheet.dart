import 'package:flutter/material.dart';

import '../../core/utils/adaptive_platform_util.dart';
import 'ui_cupertino_action_sheet.dart';

/// Shows a platform-appropriate action sheet.
///
/// Uses [showUICupertinoActionSheet] on iOS and macOS, and a Material bottom
/// sheet with action rows elsewhere.
Future<T?> showUIAdaptiveActionSheet<T>({
  required BuildContext context,
  String? title,
  String? message,
  required List<UICupertinoActionSheetAction<T>> actions,
  String cancelLabel = 'Cancel',
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

  if (useCupertino) {
    return showUICupertinoActionSheet<T>(
      context: context,
      title: title,
      message: message,
      actions: actions,
      cancelLabel: cancelLabel,
    );
  }

  return showModalBottomSheet<T>(
    context: context,
    showDragHandle: true,
    builder: (sheetContext) {
      final theme = Theme.of(sheetContext);
      final scheme = theme.colorScheme;

      return SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (title != null || message != null)
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 8, 24, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (title != null)
                      Text(
                        title,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    if (message != null) ...[
                      if (title != null) const SizedBox(height: 4),
                      Text(
                        message,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: scheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            for (final action in actions)
              ListTile(
                title: Text(
                  action.label,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: action.isDestructive
                        ? scheme.error
                        : scheme.primary,
                    fontWeight: action.isDefaultAction
                        ? FontWeight.w700
                        : FontWeight.w500,
                  ),
                ),
                onTap: () => Navigator.of(sheetContext).pop(action.value),
              ),
            const Divider(height: 1),
            ListTile(
              title: Text(
                cancelLabel,
                textAlign: TextAlign.center,
                style: theme.textTheme.titleMedium,
              ),
              onTap: () => Navigator.of(sheetContext).pop(),
            ),
            const SizedBox(height: 8),
          ],
        ),
      );
    },
  );
}

