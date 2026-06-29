import 'package:flutter/material.dart';

import 'package:vvk_ui_kit/src/widgets/buttons/ui_styled_button.dart';
import 'package:vvk_ui_kit/src/widgets/text/ui_text.dart';
import 'package:vvk_ui_kit/src/widgets/ui_widget_props.dart';

import 'ui_shell_dialog.dart';

/// Two-action confirm dialog with side-by-side cancel and confirm buttons.
class UIConfirmDialog extends StatelessWidget {
  const UIConfirmDialog({
    super.key,
    required this.title,
    required this.message,
    required this.onConfirm,
    this.confirmLabel = 'Confirm',
    this.cancelLabel = 'Cancel',
    this.onCancel,
    this.style,
    this.confirmButtonStyle,
    this.cancelButtonStyle,
    this.dialog = const UIDialogProps(
      insetPadding: EdgeInsets.symmetric(horizontal: 40),
    ),
  });

  final String title;
  final String message;
  final String confirmLabel;
  final String cancelLabel;
  final VoidCallback onConfirm;
  final VoidCallback? onCancel;
  final UIShellDialogStyle? style;
  final UIStyledButtonStyle? confirmButtonStyle;
  final UIStyledButtonStyle? cancelButtonStyle;
  final UIDialogProps dialog;

  /// Shows a [UIConfirmDialog] and returns when it is dismissed.
  static Future<void> show(
    BuildContext context, {
    required String title,
    required String message,
    required VoidCallback onConfirm,
    String confirmLabel = 'Confirm',
    String cancelLabel = 'Cancel',
    VoidCallback? onCancel,
    bool barrierDismissible = false,
    UIShellDialogStyle? style,
    UIStyledButtonStyle? confirmButtonStyle,
    UIStyledButtonStyle? cancelButtonStyle,
    UIDialogProps dialog = const UIDialogProps(
      insetPadding: EdgeInsets.symmetric(horizontal: 40),
    ),
  }) {
    return showDialog<void>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (context) => UIConfirmDialog(
        title: title,
        message: message,
        confirmLabel: confirmLabel,
        cancelLabel: cancelLabel,
        onConfirm: onConfirm,
        onCancel: onCancel,
        style: style,
        confirmButtonStyle: confirmButtonStyle,
        cancelButtonStyle: cancelButtonStyle,
        dialog: dialog,
      ),
    );
  }

  static UIStyledButtonStyle _defaultCancelStyle(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return UIStyledButtonStyle.elevated(
      context,
      height: 44,
      borderRadius: 12,
      backgroundColor: scheme.surfaceContainerHighest,
      foregroundColor: scheme.onSurface,
      fontSize: 14,
      fontWeight: FontWeight.w500,
    );
  }

  static UIStyledButtonStyle _defaultConfirmStyle(BuildContext context) {
    return UIStyledButtonStyle.primary(
      context,
      height: 44,
      borderRadius: 12,
      fontSize: 14,
      fontWeight: FontWeight.w600,
    );
  }

  @override
  Widget build(BuildContext context) {
    final resolvedStyle = style ?? UIShellDialogStyle.fromTheme(context);
    final cancelStyle = cancelButtonStyle ?? _defaultCancelStyle(context);
    final confirmStyle = confirmButtonStyle ?? _defaultConfirmStyle(context);

    return UIShellDialog(
      style: resolvedStyle,
      title: title,
      contentChild: UIText(
        message,
        style: resolvedStyle.contentStyle,
        textAlign: TextAlign.start,
      ),
      crossAxisAlignment: CrossAxisAlignment.start,
      showCloseButton: false,
      dialog: dialog,
      actions: [
        UIShellDialogAction(
          child: UIStyledButton(
            style: cancelStyle,
            width: double.infinity,
            onPressed: () {
              Navigator.of(context).pop();
              onCancel?.call();
            },
            child: Text(cancelLabel),
          ),
        ),
        UIShellDialogAction(
          child: UIStyledButton(
            style: confirmStyle,
            width: double.infinity,
            onPressed: () {
              Navigator.of(context).pop();
              onConfirm();
            },
            child: Text(confirmLabel),
          ),
        ),
      ],
    );
  }
}
