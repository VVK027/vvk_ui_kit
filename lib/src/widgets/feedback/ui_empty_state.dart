import 'package:flutter/material.dart';
import 'package:vvk_ui_kit/src/widgets/media/ui_image.dart';
import 'package:vvk_ui_kit/src/widgets/text/ui_text.dart';

/// Empty-state placeholder with optional icon, image, message, and child.
class UIEmptyState extends StatelessWidget {
  const UIEmptyState({
    super.key,
    this.icon,
    this.imageUrl,
    this.message,
    this.messageChild,
    this.descriptionStyle,
    this.padding = const EdgeInsets.all(16),
    this.iconSize = 64,
    this.iconColor,
    this.textColor,
    this.textSize = 18,
    this.imageSize = 100,
    this.imageColor,
    this.imageFallback,
    this.urlTransformer,
    this.child,
  }) : assert(
         icon != null ||
             imageUrl != null ||
             message != null ||
             messageChild != null ||
             child != null,
         'Provide at least one of icon, imageUrl, message, messageChild, or child.',
       );

  final IconData? icon;
  final String? imageUrl;
  final String? message;
  final Widget? messageChild;
  final TextStyle? descriptionStyle;
  final Widget? child;
  final EdgeInsetsGeometry padding;
  final double iconSize;
  final Color? iconColor;
  final Color? textColor;
  final double textSize;
  final double imageSize;
  final Color? imageColor;
  final Widget? imageFallback;
  final String Function(String url)? urlTransformer;

  UIEmptyState copyWith({
    Key? key,
    IconData? icon,
    String? imageUrl,
    String? message,
    Widget? messageChild,
    TextStyle? descriptionStyle,
    Widget? child,
    EdgeInsetsGeometry? padding,
    double? iconSize,
    Color? iconColor,
    Color? textColor,
    double? textSize,
    double? imageSize,
    Color? imageColor,
    Widget? imageFallback,
    String Function(String url)? urlTransformer,
  }) {
    return UIEmptyState(
      key: key ?? this.key,
      icon: icon ?? this.icon,
      imageUrl: imageUrl ?? this.imageUrl,
      message: message ?? this.message,
      messageChild: messageChild ?? this.messageChild,
      descriptionStyle: descriptionStyle ?? this.descriptionStyle,
      padding: padding ?? this.padding,
      iconSize: iconSize ?? this.iconSize,
      iconColor: iconColor ?? this.iconColor,
      textColor: textColor ?? this.textColor,
      textSize: textSize ?? this.textSize,
      imageSize: imageSize ?? this.imageSize,
      imageColor: imageColor ?? this.imageColor,
      imageFallback: imageFallback ?? this.imageFallback,
      urlTransformer: urlTransformer ?? this.urlTransformer,
      child: child ?? this.child,
    );
  }

  @override
  Widget build(BuildContext context) {
    final Color resolvedIconColor = iconColor ?? Colors.grey;
    final Color resolvedTextColor = textColor ?? Colors.grey.shade600;
    final hasMessage = message != null || messageChild != null;
    final messageWidget =
        messageChild ??
        (message != null
            ? (descriptionStyle != null
                  ? UIText(
                      message!,
                      textAlign: TextAlign.center,
                      style: descriptionStyle,
                    )
                  : UIText(
                      message!,
                      size: textSize,
                      color: resolvedTextColor,
                      fontWeight: FontWeight.w500,
                      textAlign: TextAlign.center,
                    ))
            : null);

    return Padding(
      padding: padding,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (icon != null) ...[
            Icon(icon, size: iconSize, color: resolvedIconColor),
            if (hasMessage) const SizedBox(height: 10),
          ],
          if (imageUrl != null && imageUrl!.isNotEmpty) ...[
            UIImage(
              imageUrl!,
              width: imageSize,
              height: imageSize,
              color: imageColor,
              fallback: imageFallback,
              urlTransformer: urlTransformer,
            ),
            if (hasMessage) const SizedBox(height: 16),
          ],
          ?messageWidget,
          if (child != null) ...[const SizedBox(height: 12), child!],
        ],
      ),
    );
  }
}
