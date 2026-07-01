import 'package:flutter/material.dart';
import 'package:vvk_ui_kit/src/widgets/buttons/ui_primary_text_button.dart';
import 'package:vvk_ui_kit/src/widgets/buttons/ui_text_button.dart';
import 'package:vvk_ui_kit/src/widgets/text/ui_text.dart';

/// Message dialog with title, body, and positive/negative action buttons.
class UICustomMessageDialog extends StatelessWidget {
  const UICustomMessageDialog({
    super.key,
    this.msg,
    this.msgWidget,
    this.title,
    this.titleWidget,
    this.positiveBtn,
    this.onPositiveClick,
    this.negativeBtn,
    this.onNegativeClick,
    this.negativeBtnTextColor,
    this.positiveBtnTextColor,
    this.positiveBtnBgColor,
    this.titleFontSize,
    this.titleFontWeight,
    this.msgFontSize,
    this.msgFontWeight,
    this.positiveBtnFontSize,
    this.positiveBtnFontWeight,
    this.negativeBtnFontSize,
    this.negativeBtnFontWeight,
    this.dividerColor,
    this.dialogTextColor,
    this.useSimpleActions = false,
    this.negativeButtonColor,
  });

  /// Simple alert-style dialog (legacy alias: `UIMessageDialog`).
  const UICustomMessageDialog.simple({
    super.key,
    required this.msg,
    this.title,
    required this.positiveBtn,
    this.onPositiveClick,
    this.negativeBtn,
    this.onNegativeClick,
    this.negativeButtonColor,
  }) : titleWidget = null,
       msgWidget = null,
       negativeBtnTextColor = negativeButtonColor,
       positiveBtnTextColor = null,
       positiveBtnBgColor = null,
       titleFontSize = 16,
       titleFontWeight = null,
       msgFontSize = 14,
       msgFontWeight = null,
       positiveBtnFontSize = 14,
       positiveBtnFontWeight = null,
       negativeBtnFontSize = 14,
       negativeBtnFontWeight = null,
       dividerColor = null,
       dialogTextColor = null,
       useSimpleActions = true;

  final String? title;
  final Widget? titleWidget;
  final String? msg;
  final Widget? msgWidget;
  final String? positiveBtn;
  final String? negativeBtn;
  final VoidCallback? onPositiveClick;
  final VoidCallback? onNegativeClick;
  final Color? negativeBtnTextColor;
  final Color? positiveBtnTextColor;
  final Color? positiveBtnBgColor;
  final int? titleFontSize;
  final FontWeight? titleFontWeight;
  final int? msgFontSize;
  final FontWeight? msgFontWeight;
  final int? positiveBtnFontSize;
  final FontWeight? positiveBtnFontWeight;
  final int? negativeBtnFontSize;
  final FontWeight? negativeBtnFontWeight;
  final Color? dividerColor;
  final Color? dialogTextColor;
  final bool useSimpleActions;
  final Color? negativeButtonColor;

  UICustomMessageDialog copyWith({
    Key? key,
    String? title,
    Widget? titleWidget,
    String? msg,
    Widget? msgWidget,
    String? positiveBtn,
    String? negativeBtn,
    VoidCallback? onPositiveClick,
    VoidCallback? onNegativeClick,
    Color? negativeBtnTextColor,
    Color? positiveBtnTextColor,
    Color? positiveBtnBgColor,
    int? titleFontSize,
    FontWeight? titleFontWeight,
    int? msgFontSize,
    FontWeight? msgFontWeight,
    int? positiveBtnFontSize,
    FontWeight? positiveBtnFontWeight,
    int? negativeBtnFontSize,
    FontWeight? negativeBtnFontWeight,
    Color? dividerColor,
    Color? dialogTextColor,
    bool? useSimpleActions,
    Color? negativeButtonColor,
  }) {
    return UICustomMessageDialog(
      key: key ?? this.key,
      title: title ?? this.title,
      titleWidget: titleWidget ?? this.titleWidget,
      msg: msg ?? this.msg,
      msgWidget: msgWidget ?? this.msgWidget,
      positiveBtn: positiveBtn ?? this.positiveBtn,
      negativeBtn: negativeBtn ?? this.negativeBtn,
      onPositiveClick: onPositiveClick ?? this.onPositiveClick,
      onNegativeClick: onNegativeClick ?? this.onNegativeClick,
      negativeBtnTextColor: negativeBtnTextColor ?? this.negativeBtnTextColor,
      positiveBtnTextColor: positiveBtnTextColor ?? this.positiveBtnTextColor,
      positiveBtnBgColor: positiveBtnBgColor ?? this.positiveBtnBgColor,
      titleFontSize: titleFontSize ?? this.titleFontSize,
      titleFontWeight: titleFontWeight ?? this.titleFontWeight,
      msgFontSize: msgFontSize ?? this.msgFontSize,
      msgFontWeight: msgFontWeight ?? this.msgFontWeight,
      positiveBtnFontSize: positiveBtnFontSize ?? this.positiveBtnFontSize,
      positiveBtnFontWeight:
          positiveBtnFontWeight ?? this.positiveBtnFontWeight,
      negativeBtnFontSize: negativeBtnFontSize ?? this.negativeBtnFontSize,
      negativeBtnFontWeight:
          negativeBtnFontWeight ?? this.negativeBtnFontWeight,
      dividerColor: dividerColor ?? this.dividerColor,
      dialogTextColor: dialogTextColor ?? this.dialogTextColor,
      useSimpleActions: useSimpleActions ?? this.useSimpleActions,
      negativeButtonColor: negativeButtonColor ?? this.negativeButtonColor,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (useSimpleActions) {
      return _buildSimpleDialog(context);
    }
    return _buildCustomDialog(context);
  }

  Widget _buildSimpleDialog(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return AlertDialog(
      title: title != null ? UIText(title!, size: 16) : null,
      content: UIText(msg ?? '', size: 14),
      actions: <Widget>[
        UITextButton(
          text: positiveBtn ?? '',
          size: 14,
          onPressed: () {
            Navigator.of(context).pop();
            onPositiveClick?.call();
          },
        ),
        if (negativeBtn != null)
          UITextButton(
            text: negativeBtn!,
            size: 14,
            color: negativeButtonColor ?? colorScheme.onSurface,
            onPressed: () {
              Navigator.of(context).pop();
              onNegativeClick?.call();
            },
          ),
      ],
    );
  }

  Widget _buildCustomDialog(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final Color textColor = dialogTextColor ?? colorScheme.onSurface;

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (title != null)
            UIText(
              title!,
              size: titleFontSize?.toDouble() ?? 15,
              fontWeight: titleFontWeight ?? FontWeight.w700,
              color: textColor,
            )
          else
            titleWidget ?? const SizedBox(),
          SizedBox(height: (title != null || titleWidget != null) ? 20 : 0),
          msgWidget ??
              UIText(
                msg ?? '',
                size: msgFontSize?.toDouble() ?? 13,
                fontWeight: msgFontWeight ?? FontWeight.w400,
                color: textColor,
              ),
          const SizedBox(height: 20),
          if (dividerColor != null) Divider(color: dividerColor),
          if (positiveBtn != null)
            positiveBtnBgColor != null
                ? UIPrimaryTextButton(
                    text: positiveBtn!,
                    enableTextColor: positiveBtnTextColor,
                    height: 40,
                    size: positiveBtnFontSize?.toDouble() ?? 15,
                    enableBgColor: positiveBtnBgColor,
                    fontWeight: positiveBtnFontWeight ?? FontWeight.w400,
                    onPressed: () {
                      Navigator.of(context).pop();
                      onPositiveClick?.call();
                    },
                  )
                : UITextButton(
                    text: positiveBtn!,
                    height: 40,
                    size: positiveBtnFontSize?.toDouble() ?? 15.0,
                    color: positiveBtnTextColor,
                    fontWeight: positiveBtnFontWeight ?? FontWeight.w400,
                    onPressed: () {
                      Navigator.of(context).pop();
                      onPositiveClick?.call();
                    },
                  ),
          if (dividerColor != null)
            Divider(color: dividerColor)
          else
            SizedBox(
              height: positiveBtn != null && negativeBtn != null ? 20 : 0,
            ),
          if (negativeBtn != null)
            UITextButton(
              text: negativeBtn!,
              size: negativeBtnFontSize?.toDouble() ?? 16.0,
              fontWeight: negativeBtnFontWeight ?? FontWeight.w700,
              color: negativeBtnTextColor ?? textColor,
              onPressed: () {
                Navigator.of(context).pop();
                onNegativeClick?.call();
              },
            ),
        ],
      ),
    );
  }
}
