import 'package:flutter/material.dart';
import 'ui_button_props.dart';
import 'ui_styled_button.dart';
import '../text/ui_text.dart';
import '../ui_button_helpers.dart';

/// Filled or outlined primary action — thin wrapper over Material
/// [ElevatedButton] or [OutlinedButton].
class UIPrimaryTextButton extends StatelessWidget {
  const UIPrimaryTextButton({
    super.key,
    this.text,
    this.child,
    this.onPressed,
    this.size = 16,
    this.enableTextColor,
    this.disableTextColor,
    this.fontWeight = FontWeight.w600,
    this.style,
    this.maxLines,
    this.textAlign = TextAlign.center,
    this.enableButton = true,
    this.hasBorder = false,
    this.enableBgColor,
    this.disableBgColor,
    this.cornerRadius = 5,
    this.width = double.maxFinite,
    this.height = 61,
    this.backgroundColor,
    this.borderColor,
    this.material = const UIMaterialButtonProps(),
  }) : assert(
         child != null || text != null,
         'Either text or child must be provided.',
       );

  final VoidCallback? onPressed;
  final String? text;
  final Widget? child;
  final double size;
  final FontWeight fontWeight;
  final Color? enableTextColor;
  final Color? disableTextColor;
  final Color? enableBgColor;
  final Color? disableBgColor;
  final int? maxLines;
  final TextStyle? style;
  final TextAlign textAlign;
  final bool enableButton;
  final bool hasBorder;
  final double cornerRadius;
  final double? width;
  final double? height;
  final Color? backgroundColor;
  final Color? borderColor;
  final UIMaterialButtonProps material;

  UIPrimaryTextButton copyWith({
    Key? key,
    String? text,
    Widget? child,
    VoidCallback? onPressed,
    double? size,
    Color? enableTextColor,
    Color? disableTextColor,
    FontWeight? fontWeight,
    TextStyle? style,
    int? maxLines,
    TextAlign? textAlign,
    bool? enableButton,
    bool? hasBorder,
    Color? enableBgColor,
    Color? disableBgColor,
    double? cornerRadius,
    double? width,
    double? height,
    Color? backgroundColor,
    Color? borderColor,
    UIMaterialButtonProps? material,
  }) {
    return UIPrimaryTextButton(
      key: key ?? this.key,
      text: text ?? this.text,
      onPressed: onPressed ?? this.onPressed,
      size: size ?? this.size,
      enableTextColor: enableTextColor ?? this.enableTextColor,
      disableTextColor: disableTextColor ?? this.disableTextColor,
      fontWeight: fontWeight ?? this.fontWeight,
      style: style ?? this.style,
      maxLines: maxLines ?? this.maxLines,
      textAlign: textAlign ?? this.textAlign,
      enableButton: enableButton ?? this.enableButton,
      hasBorder: hasBorder ?? this.hasBorder,
      enableBgColor: enableBgColor ?? this.enableBgColor,
      disableBgColor: disableBgColor ?? this.disableBgColor,
      cornerRadius: cornerRadius ?? this.cornerRadius,
      width: width ?? this.width,
      height: height ?? this.height,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      borderColor: borderColor ?? this.borderColor,
      material: material ?? this.material,
      child: child ?? this.child,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;
    final buttonStyleConfig = hasBorder
        ? UIStyledButtonStyle.outlined(
            context,
            height: height ?? 61,
            borderRadius: cornerRadius,
            borderColor: borderColor ?? primary,
            foregroundColor: enableTextColor ?? borderColor ?? primary,
            backgroundColor: backgroundColor ?? theme.colorScheme.surface,
            fontSize: size,
            fontWeight: fontWeight,
            textStyle: style,
          )
        : UIStyledButtonStyle.primary(
            context,
            height: height ?? 61,
            borderRadius: cornerRadius,
            backgroundColor: enableBgColor ?? primary,
            foregroundColor: enableTextColor ?? theme.colorScheme.onPrimary,
            disabledBackgroundColor: disableBgColor,
            disabledForegroundColor: disableTextColor,
            fontSize: size,
            fontWeight: fontWeight,
            textStyle: style,
          );

    final label =
        child ??
        UIText(
          text!,
          size: size,
          fontWeight: fontWeight,
          style: style,
          maxLines: maxLines,
          textAlign: textAlign,
        );
    final isDisabled = !enableButton;
    final styledLabel = applyButtonLabelStyle(
      label,
      buttonStyleConfig,
      isDisabled,
    );
    final shape = buttonShape(buttonStyleConfig);
    final hasFixedWidth = width != null;
    final onTap = isDisabled ? null : onPressed;

    return SizedBox(
      height: buttonStyleConfig.height,
      width: width,
      child: hasBorder
          ? material.outlined(
              onPressed: onTap,
              baseStyle: OutlinedButton.styleFrom(
                foregroundColor: buttonStyleConfig.foregroundColor,
                backgroundColor: buttonStyleConfig.backgroundColor,
                side: BorderSide(color: buttonStyleConfig.outlineBorderColor),
                padding: hasFixedWidth
                    ? EdgeInsets.zero
                    : const EdgeInsets.symmetric(horizontal: 16),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                shape: shape,
                overlayColor: Colors.transparent,
                disabledForegroundColor:
                    buttonStyleConfig.disabledForegroundColor,
              ),
              child: styledLabel,
            )
          : material.elevated(
              onPressed: onTap,
              baseStyle: ElevatedButton.styleFrom(
                backgroundColor:
                    enableBgColor ??
                    backgroundColor ??
                    buttonStyleConfig.backgroundColor,
                foregroundColor: buttonStyleConfig.foregroundColor,
                padding: hasFixedWidth
                    ? EdgeInsets.zero
                    : const EdgeInsets.symmetric(horizontal: 16),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                shape: shape,
                disabledBackgroundColor:
                    buttonStyleConfig.disabledBackgroundColor,
                disabledForegroundColor:
                    buttonStyleConfig.disabledForegroundColor,
                elevation: 0,
                overlayColor: Colors.transparent,
              ),
              child: styledLabel,
            ),
    );
  }
}
