import 'package:flutter/material.dart';
import 'ui_button_props.dart';
import 'ui_styled_button.dart';
import '../text/ui_text.dart';
import '../ui_button_helpers.dart';

/// Text-only button — thin wrapper over Material [TextButton].
class UITextButton extends StatelessWidget {
  const UITextButton({
    super.key,
    this.text,
    this.child,
    this.onPressed,
    this.size,
    this.color,
    this.fontWeight,
    this.style,
    this.maxLines,
    this.width,
    this.height = 44,
    this.textAlign = TextAlign.left,
    this.buttonStyle,
    this.textOverflow,
    this.lineHeight,
    this.enabled = true,
    this.material = const UIMaterialButtonProps(),
  }) : assert(
         child != null || text != null,
         'Either text or child must be provided.',
       );

  final VoidCallback? onPressed;
  final String? text;
  final Widget? child;
  final double? size;
  final FontWeight? fontWeight;
  final Color? color;
  final int? maxLines;
  final TextStyle? style;
  final TextAlign? textAlign;
  final double? width;
  final double? height;
  final ButtonStyle? buttonStyle;
  final TextOverflow? textOverflow;
  final double? lineHeight;
  final bool enabled;
  final UIMaterialButtonProps material;

  UITextButton copyWith({
    Key? key,
    String? text,
    Widget? child,
    VoidCallback? onPressed,
    double? size,
    Color? color,
    FontWeight? fontWeight,
    TextStyle? style,
    int? maxLines,
    double? width,
    double? height,
    TextAlign? textAlign,
    ButtonStyle? buttonStyle,
    TextOverflow? textOverflow,
    double? lineHeight,
    bool? enabled,
    UIMaterialButtonProps? material,
  }) {
    return UITextButton(
      key: key ?? this.key,
      text: text ?? this.text,
      onPressed: onPressed ?? this.onPressed,
      size: size ?? this.size,
      color: color ?? this.color,
      fontWeight: fontWeight ?? this.fontWeight,
      style: style ?? this.style,
      maxLines: maxLines ?? this.maxLines,
      width: width ?? this.width,
      height: height ?? this.height,
      textAlign: textAlign ?? this.textAlign,
      buttonStyle: buttonStyle ?? this.buttonStyle,
      textOverflow: textOverflow ?? this.textOverflow,
      lineHeight: lineHeight ?? this.lineHeight,
      enabled: enabled ?? this.enabled,
      material: material ?? this.material,
      child: child ?? this.child,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final buttonStyleConfig = UIStyledButtonStyle.text(
      context,
      height: height ?? 44,
      foregroundColor: color,
      textStyle:
          style ??
          theme.textTheme.labelLarge?.copyWith(
            fontSize: size,
            fontWeight: fontWeight,
            height: lineHeight,
          ),
    );
    final label =
        child ??
        UIText(
          text!,
          size: size,
          color: color,
          fontWeight: fontWeight,
          style: style,
          maxLines: maxLines,
          textAlign: textAlign,
          textOverflow: textOverflow,
          lineHeight: lineHeight,
        );
    final isDisabled = !enabled;
    final styledLabel = applyButtonLabelStyle(
      label,
      buttonStyleConfig,
      isDisabled,
    );

    return SizedBox(
      height: buttonStyleConfig.height,
      width: width,
      child: material.text(
        onPressed: isDisabled ? null : onPressed,
        baseStyle: material.mergeStyle(buttonStyle),
        child: styledLabel,
      ),
    );
  }
}
