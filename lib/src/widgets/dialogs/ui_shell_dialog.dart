import 'package:flutter/material.dart';
import 'package:vvk_ui_kit/src/widgets/text/ui_text.dart';
import 'package:vvk_ui_kit/src/widgets/ui_widget_props.dart';

/// Visual styling for [UIShellDialog].
class UIShellDialogStyle {
  const UIShellDialogStyle({
    required this.backgroundColor,
    required this.titleStyle,
    required this.contentStyle,
    required this.closeButtonColor,
    required this.closeIconColor,
  });

  final Color backgroundColor;
  final TextStyle titleStyle;
  final TextStyle contentStyle;
  final Color closeButtonColor;
  final Color closeIconColor;

  UIShellDialogStyle copyWith({
    Color? backgroundColor,
    TextStyle? titleStyle,
    TextStyle? contentStyle,
    Color? closeButtonColor,
    Color? closeIconColor,
  }) {
    return UIShellDialogStyle(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      titleStyle: titleStyle ?? this.titleStyle,
      contentStyle: contentStyle ?? this.contentStyle,
      closeButtonColor: closeButtonColor ?? this.closeButtonColor,
      closeIconColor: closeIconColor ?? this.closeIconColor,
    );
  }

  /// Creates a [UIShellDialogStyle] from [Theme.of(context)].
  factory UIShellDialogStyle.fromTheme(
    BuildContext context, {
    Color? backgroundColor,
    TextStyle? titleStyle,
    TextStyle? contentStyle,
    Color? closeButtonColor,
    Color? closeIconColor,
  }) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return UIShellDialogStyle(
      backgroundColor: backgroundColor ?? scheme.surface,
      titleStyle:
          titleStyle ??
          theme.textTheme.titleLarge!.copyWith(
            fontWeight: FontWeight.w600,
            color: scheme.onSurface,
          ),
      contentStyle:
          contentStyle ??
          theme.textTheme.bodyMedium!.copyWith(color: scheme.onSurface),
      closeButtonColor: closeButtonColor ?? scheme.surfaceContainerHighest,
      closeIconColor: closeIconColor ?? scheme.onSurfaceVariant,
    );
  }
}

/// Action slot for a button row in [UIShellDialog].
class UIShellDialogAction {
  const UIShellDialogAction({required this.child, this.isExpanded = true});

  final Widget child;
  final bool isExpanded;
}

/// A customizable dialog shell with title, content, and action buttons.
class UIShellDialog extends StatelessWidget {
  const UIShellDialog({
    super.key,
    required this.style,
    this.title,
    this.titleChild,
    this.content,
    this.contentChild,
    this.contentWidget,
    this.timerCountdown,
    this.imageHeader,
    this.body,
    this.actions = const [],
    this.showCloseButton = true,
    this.showActionButtons = true,
    this.onClose,
    this.crossAxisAlignment = CrossAxisAlignment.start,
    this.titleStyle,
    this.dialog = const UIDialogProps(),
  });

  final UIShellDialogStyle style;
  final String? title;
  final Widget? titleChild;
  final TextStyle? titleStyle;
  final String? content;
  final Widget? contentChild;
  final Widget? contentWidget;
  final Widget? timerCountdown;
  final Widget? imageHeader;
  final Widget? body;
  final List<UIShellDialogAction> actions;
  final bool showCloseButton;
  final bool showActionButtons;
  final VoidCallback? onClose;
  final CrossAxisAlignment crossAxisAlignment;
  final UIDialogProps dialog;

  UIShellDialog copyWith({
    Key? key,
    UIShellDialogStyle? style,
    String? title,
    Widget? titleChild,
    TextStyle? titleStyle,
    String? content,
    Widget? contentChild,
    Widget? contentWidget,
    Widget? timerCountdown,
    Widget? imageHeader,
    Widget? body,
    List<UIShellDialogAction>? actions,
    bool? showCloseButton,
    bool? showActionButtons,
    VoidCallback? onClose,
    CrossAxisAlignment? crossAxisAlignment,
    UIDialogProps? dialog,
  }) {
    return UIShellDialog(
      key: key ?? this.key,
      style: style ?? this.style,
      title: title ?? this.title,
      titleChild: titleChild ?? this.titleChild,
      titleStyle: titleStyle ?? this.titleStyle,
      content: content ?? this.content,
      contentChild: contentChild ?? this.contentChild,
      contentWidget: contentWidget ?? this.contentWidget,
      timerCountdown: timerCountdown ?? this.timerCountdown,
      imageHeader: imageHeader ?? this.imageHeader,
      body: body ?? this.body,
      actions: actions ?? this.actions,
      showCloseButton: showCloseButton ?? this.showCloseButton,
      showActionButtons: showActionButtons ?? this.showActionButtons,
      onClose: onClose ?? this.onClose,
      crossAxisAlignment: crossAxisAlignment ?? this.crossAxisAlignment,
      dialog: dialog ?? this.dialog,
    );
  }

  @override
  Widget build(BuildContext context) {
    final titleWidget =
        titleChild ??
        (title != null
            ? UIText(title!, style: titleStyle ?? style.titleStyle)
            : null);
    final contentTextWidget =
        contentChild ??
        (content != null
            ? UIText(
                content!,
                style: style.contentStyle,
                textAlign: TextAlign.center,
              )
            : null);

    return dialog.build(
      defaultShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: style.backgroundColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child:
            body ??
            Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: crossAxisAlignment,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (imageHeader != null) ...[
                        imageHeader!,
                        const SizedBox(height: 16),
                      ],
                      if (titleWidget != null) ...[
                        titleWidget,
                        const SizedBox(height: 8),
                      ],
                      if (contentTextWidget != null) ...[
                        contentTextWidget,
                        const SizedBox(height: 16),
                      ],
                      if (contentWidget != null) ...[
                        contentWidget!,
                        const SizedBox(height: 16),
                      ],
                      if (showActionButtons && actions.isNotEmpty)
                        _buildActionButtons(),
                      timerCountdown ?? const SizedBox.shrink(),
                    ],
                  ),
                ),
                if (showCloseButton)
                  Positioned(
                    top: 0,
                    right: 0,
                    child: InkWell(
                      onTap: onClose ?? () => Navigator.pop(context),
                      child: Material(
                        color: style.closeButtonColor,
                        borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(16),
                          bottomLeft: Radius.circular(8),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(5),
                          child: Icon(
                            Icons.close,
                            color: style.closeIconColor,
                            size: 24,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
      ),
    );
  }

  Widget _buildActionButtons() {
    if (actions.length == 1) {
      return SizedBox(width: double.infinity, child: actions.first.child);
    }

    if (actions.length == 2) {
      return Row(
        children: [
          if (actions[0].isExpanded)
            Expanded(child: actions[0].child)
          else
            actions[0].child,
          const SizedBox(width: 8),
          if (actions[1].isExpanded)
            Expanded(child: actions[1].child)
          else
            actions[1].child,
        ],
      );
    }

    return Column(
      children: actions
          .map(
            (action) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: SizedBox(width: double.infinity, child: action.child),
            ),
          )
          .toList(),
    );
  }
}
