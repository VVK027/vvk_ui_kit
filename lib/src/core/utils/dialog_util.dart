import 'package:flutter/material.dart';
import 'package:vvk_ui_kit/src/widgets/text/ui_text.dart';
import 'package:vvk_ui_kit/src/widgets/dialogs/ui_custom_message_dialog.dart';
import 'package:vvk_ui_kit/src/widgets/dialogs/ui_list_dialog.dart';

/// Utility class for showing common dialogs and overlays.
class DialogUtil {
  /// Shows a generic [widget] as a dialog.
  static Future<T?> showWidgetAsDialog<T>(
    BuildContext context,
    Widget widget, {
    bool barrierDismissible = false,
    Color? barrierColor = const Color(0x66000000),
  }) {
    return showDialog<T>(
      context: context,
      barrierDismissible: barrierDismissible,
      barrierColor: barrierColor,
      builder: (ctx) => widget,
    );
  }

  /// Shows a [widget] as a modal bottom sheet.
  static Future<T?> showWidgetAsBottomSheet<T>(
    BuildContext context, {
    required Widget? widget,
    bool barrierDismissible = false,
    bool scrollControlled = false,
    Color? barrierColor = const Color(0x66000000),
    RoundedRectangleBorder? shape,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      backgroundColor: barrierColor,
      isScrollControlled: scrollControlled,
      isDismissible: barrierDismissible,
      barrierColor: barrierColor,
      shape: shape,
      builder: (BuildContext ctx) => widget ?? const SizedBox.shrink(),
    );
  }

  /// Shows a standard message dialog with one or two buttons.
  static Future<dynamic> showMsgDialog({
    required BuildContext context,
    String? title,
    required String msg,
    required String positiveBtn,
    String? negativeBtn,
    VoidCallback? onPositiveClick,
    VoidCallback? onNegativeClick,
  }) {
    return showWidgetAsDialog(
      context,
      UICustomMessageDialog.simple(
        title: title,
        msg: msg,
        positiveBtn: positiveBtn,
        negativeBtn: negativeBtn,
        onPositiveClick: onPositiveClick,
        onNegativeClick: onNegativeClick,
      ),
      barrierDismissible: false,
    );
  }

  /// Shows a highly customizable message dialog.
  static Future<dynamic> showCustomMsgDialog({
    required BuildContext context,
    String? title,
    Widget? titleWidget,
    String? msg,
    Widget? msgWidget,
    String? positiveBtn,
    String? negativeBtn,
    VoidCallback? onPositiveClick,
    VoidCallback? onNegativeClick,
    Color? positiveBtnTextColor,
    Color? negativeBtnTextColor,
    int? titleFontSize,
    FontWeight? titleFontWeight,
    int? msgFontSize,
    FontWeight? msgFontWeight,
    int? positiveBtnFontSize,
    FontWeight? positiveBtnFontWeight,
    int? negativeBtnFontSize,
    bool barrierDismissible = false,
    Color? dividerColor,
    FontWeight? negativeBtnFontWeight,
  }) {
    return showWidgetAsDialog(
      context,
      UICustomMessageDialog(
        title: title,
        titleWidget: titleWidget,
        msg: msg,
        msgWidget: msgWidget,
        negativeBtnTextColor: negativeBtnTextColor,
        positiveBtnTextColor: positiveBtnTextColor,
        positiveBtn: positiveBtn,
        negativeBtn: negativeBtn,
        onPositiveClick: onPositiveClick,
        onNegativeClick: onNegativeClick,
        titleFontWeight: titleFontWeight,
        titleFontSize: titleFontSize,
        msgFontWeight: msgFontWeight,
        msgFontSize: msgFontSize,
        positiveBtnFontWeight: positiveBtnFontWeight,
        positiveBtnFontSize: positiveBtnFontSize,
        negativeBtnFontWeight: negativeBtnFontWeight,
        negativeBtnFontSize: negativeBtnFontSize,
        dividerColor: dividerColor,
      ),
      barrierDismissible: barrierDismissible,
    );
  }

  /// Shows a standard [SnackBar].
  static void showSnackBar(
    BuildContext context,
    String msg, {
    Duration duration = const Duration(seconds: 2),
  }) {
    final snackBar = SnackBar(
      content: UIText(msg, size: 14),
      duration: duration,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  /// Shows a custom snackbar at the top of the screen.
  ///
  /// [msgType]: 0 = success, 1 = warning, 2 = failure.
  static void showCustomTopSnackBar(
    BuildContext context,
    String msg, {
    Duration duration = const Duration(seconds: 2),
    int msgType = 0,
    Color? backgroundColor,
    Color? messageColor,
    IconData? icon,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    Color bgColor = backgroundColor ?? colorScheme.inverseSurface;
    Color msgColor = messageColor ?? colorScheme.onInverseSurface;
    IconData resolvedIcon = icon ?? Icons.check_circle_rounded;

    if (msgType == 1) {
      resolvedIcon = icon ?? Icons.priority_high_rounded;
    } else if (msgType == 2) {
      resolvedIcon = icon ?? Icons.error;
    }

    final snackBar = SnackBar(
      behavior: SnackBarBehavior.floating,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(0.0)),
      ),
      backgroundColor: bgColor,
      margin: EdgeInsets.only(
        bottom: MediaQuery.sizeOf(context).height - 140,
        left: 0,
      ),
      content: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: Icon(resolvedIcon, color: msgColor),
          ),
          Expanded(
            child: UIText(
              msg,
              size: 14,
              fontWeight: FontWeight.w700,
              color: msgColor,
              maxLines: 1,
              textOverflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
      duration: duration,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  /// Shows a simple full-screen loader.
  static void showLoader(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    showWidgetAsDialog(
      context,
      Center(
        child: Container(
          height: 100,
          width: 100,
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(10.0),
          ),
          alignment: Alignment.center,
          child: CircularProgressIndicator(color: colorScheme.primary),
        ),
      ),
    );
  }

  /// Hides a previously shown loader.
  static void hideLoader(BuildContext context) {
    Navigator.pop(context);
  }

  /// Shows a dialog containing a list of selectable items.
  static void showListDialog<T>({
    required BuildContext context,
    required List<T> items,
    required ValueChanged<T> onItemSelected,
    String? heading,
    String Function(T)? getTextFromItem,
    Widget Function(T, int, bool)? displayBuilder,
    Widget Function(T, int, bool)? separatorBuilder,
    int initialSelectedIndex = 0,
    String? confirmBtnText,
    String? cancelBtnText,
    double? width,
    double? height,
    EdgeInsets? padding,
    double? posLeft,
    double? posRight,
    double? posTop,
    double? posBottom,
    double? headingTextSize,
  }) {
    showWidgetAsDialog(
      context,
      UIListDialog<T>(
        items: items,
        onItemSelected: onItemSelected,
        heading: heading,
        getTextFromItem: getTextFromItem,
        displayBuilder: displayBuilder,
        separatorBuilder: separatorBuilder,
        initialSelectedIndex: initialSelectedIndex,
        confirmBtnText: confirmBtnText,
        cancelBtnText: cancelBtnText,
        padding: padding ?? EdgeInsets.zero,
        width: width,
        height: height,
        posLeft: posLeft,
        posRight: posRight,
        posTop: posTop,
        posBottom: posBottom,
        headingTextSize: headingTextSize ?? 17.0,
      ),
    );
  }
}
