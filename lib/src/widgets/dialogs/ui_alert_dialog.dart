import 'package:flutter/material.dart';

import 'package:vvk_ui_kit/src/widgets/buttons/ui_styled_button.dart';
import 'package:vvk_ui_kit/src/widgets/text/ui_text.dart';
import 'package:vvk_ui_kit/src/widgets/ui_widget_props.dart';

import 'ui_shell_dialog.dart';

/// Single-action card-style alert dialog built on [UIShellDialog].
class UIAlertDialog extends StatelessWidget {
  const UIAlertDialog({
    super.key,
    required this.title,
    required this.message,
    this.confirmLabel = 'OK',
    this.onConfirm,
    this.showCloseButton = true,
    this.style,
    this.confirmButtonStyle,
    this.dialog = const UIDialogProps(
      insetPadding: EdgeInsets.symmetric(horizontal: 40),
    ),
  });

  final String title;
  final String message;
  final String confirmLabel;
  final VoidCallback? onConfirm;
  final bool showCloseButton;
  final UIShellDialogStyle? style;
  final UIStyledButtonStyle? confirmButtonStyle;
  final UIDialogProps dialog;

  /// Shows an [UIAlertDialog] and returns when it is dismissed.
  static Future<void> show(
    BuildContext context, {
    required String title,
    required String message,
    String confirmLabel = 'OK',
    VoidCallback? onConfirm,
    bool showCloseButton = true,
    bool barrierDismissible = false,
    UIShellDialogStyle? style,
    UIStyledButtonStyle? confirmButtonStyle,
    UIDialogProps dialog = const UIDialogProps(
      insetPadding: EdgeInsets.symmetric(horizontal: 40),
    ),
  }) {
    return showDialog<void>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (context) => UIAlertDialog(
        title: title,
        message: message,
        confirmLabel: confirmLabel,
        onConfirm: onConfirm,
        showCloseButton: showCloseButton,
        style: style,
        confirmButtonStyle: confirmButtonStyle,
        dialog: dialog,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final resolvedStyle = style ?? UIShellDialogStyle.fromTheme(context);
    final buttonStyle =
        confirmButtonStyle ??
        UIStyledButtonStyle.primary(
          context,
          height: 48,
          borderRadius: 12,
          fontSize: 14,
          fontWeight: FontWeight.w600,
        );

    return UIShellDialog(
      style: resolvedStyle,
      title: title,
      contentChild: UIText(
        message,
        style: resolvedStyle.contentStyle,
        textAlign: TextAlign.start,
      ),
      crossAxisAlignment: CrossAxisAlignment.start,
      showCloseButton: showCloseButton,
      dialog: dialog,
      actions: [
        UIShellDialogAction(
          child: UIStyledButton(
            style: buttonStyle,
            width: double.infinity,
            onPressed: () {
              Navigator.of(context).pop();
              onConfirm?.call();
            },
            child: Text(confirmLabel),
          ),
        ),
      ],
    );
  }
}
