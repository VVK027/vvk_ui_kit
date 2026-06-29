import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:vvk_ui_kit/src/widgets/text/ui_text.dart';
import 'package:vvk_ui_kit/src/widgets/ui_widget_props.dart';

/// Visual styling for [UIAlertPanel].
class UIAlertPanelStyle {
  const UIAlertPanelStyle({
    required this.backgroundColor,
    required this.titleStyle,
    required this.descriptionStyle,
    required this.closeButtonColor,
    required this.closeIconColor,
    required this.scrimColor,
  });

  final Color backgroundColor;
  final TextStyle titleStyle;
  final TextStyle descriptionStyle;
  final Color closeButtonColor;
  final Color closeIconColor;
  final Color scrimColor;

  UIAlertPanelStyle copyWith({
    Color? backgroundColor,
    TextStyle? titleStyle,
    TextStyle? descriptionStyle,
    Color? closeButtonColor,
    Color? closeIconColor,
    Color? scrimColor,
  }) {
    return UIAlertPanelStyle(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      titleStyle: titleStyle ?? this.titleStyle,
      descriptionStyle: descriptionStyle ?? this.descriptionStyle,
      closeButtonColor: closeButtonColor ?? this.closeButtonColor,
      closeIconColor: closeIconColor ?? this.closeIconColor,
      scrimColor: scrimColor ?? this.scrimColor,
    );
  }
}

/// Inline alert panel with icon, title, description, and optional actions.
class UIAlertPanel extends StatelessWidget {
  const UIAlertPanel({
    this.title,
    this.description,
    required this.style,
    super.key,
    this.icon,
    this.titleChild,
    this.descriptionChild,
    this.onClose,
    this.primaryAction,
    this.secondaryAction,
    this.showCloseButton = true,
    this.customContent,
    this.dialog = const UIDialogProps(),
  }) : assert(
         titleChild != null || title != null,
         'Either title or titleChild must be provided.',
       ),
       assert(
         customContent != null ||
             descriptionChild != null ||
             description != null,
         'Provide description, descriptionChild, or customContent.',
       );

  final UIAlertPanelStyle style;
  final Widget? icon;
  final String? title;
  final String? description;
  final Widget? titleChild;
  final Widget? descriptionChild;
  final Widget? primaryAction;
  final Widget? secondaryAction;
  final VoidCallback? onClose;
  final bool showCloseButton;
  final Widget? customContent;
  final UIDialogProps dialog;

  UIAlertPanel copyWith({
    Key? key,
    String? title,
    String? description,
    UIAlertPanelStyle? style,
    Widget? icon,
    Widget? titleChild,
    Widget? descriptionChild,
    Widget? primaryAction,
    Widget? secondaryAction,
    VoidCallback? onClose,
    bool? showCloseButton,
    Widget? customContent,
    UIDialogProps? dialog,
  }) {
    return UIAlertPanel(
      key: key ?? this.key,
      title: title ?? this.title,
      description: description ?? this.description,
      style: style ?? this.style,
      icon: icon ?? this.icon,
      titleChild: titleChild ?? this.titleChild,
      descriptionChild: descriptionChild ?? this.descriptionChild,
      primaryAction: primaryAction ?? this.primaryAction,
      secondaryAction: secondaryAction ?? this.secondaryAction,
      onClose: onClose ?? this.onClose,
      showCloseButton: showCloseButton ?? this.showCloseButton,
      customContent: customContent ?? this.customContent,
      dialog: dialog ?? this.dialog,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 0, sigmaY: 0),
          child: Container(color: style.scrimColor),
        ),
        Center(
          child: dialog.build(
            defaultInsetPadding: const EdgeInsets.all(24),
            defaultShape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            defaultBackgroundColor: style.backgroundColor,
            child: _buildDialogContent(context),
          ),
        ),
      ],
    );
  }

  Widget _buildDialogContent(BuildContext context) {
    final titleWidget =
        titleChild ??
        UIText(title!, style: style.titleStyle, textAlign: TextAlign.center);
    final descriptionWidget =
        descriptionChild ??
        UIText(
          description!,
          style: style.descriptionStyle,
          textAlign: TextAlign.center,
        );

    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null)
                Center(child: SizedBox(width: 80, height: 80, child: icon!)),
              if (icon != null) const SizedBox(height: 16),
              titleWidget,
              const SizedBox(height: 8),
              if (customContent != null) customContent! else descriptionWidget,
              const SizedBox(height: 16),
              if (primaryAction != null || secondaryAction != null)
                Row(
                  children: [
                    if (secondaryAction != null)
                      Expanded(child: secondaryAction!),
                    if (primaryAction != null && secondaryAction != null)
                      const SizedBox(width: 8),
                    if (primaryAction != null) Expanded(child: primaryAction!),
                  ],
                ),
            ],
          ),
        ),
        if (showCloseButton)
          Positioned(
            top: 0,
            right: 0,
            child: GestureDetector(
              onTap: onClose,
              child: Container(
                height: 32,
                width: 32,
                decoration: BoxDecoration(
                  color: style.closeButtonColor,
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(16),
                    bottomLeft: Radius.circular(8),
                  ),
                ),
                child: Icon(Icons.close, color: style.closeIconColor, size: 24),
              ),
            ),
          ),
      ],
    );
  }
}
