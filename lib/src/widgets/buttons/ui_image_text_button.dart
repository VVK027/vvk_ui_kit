import 'package:flutter/material.dart';
import 'ui_button_props.dart';
import 'ui_styled_button.dart';
import '../media/ui_image.dart';
import '../text/ui_text.dart';
import '../ui_button_helpers.dart';

/// Outlined button with leading image — thin wrapper over Material [OutlinedButton].
class UIImageTextButton extends StatelessWidget {
  const UIImageTextButton({
    super.key,
    this.text,
    this.child,
    this.onPressed,
    this.size = 16,
    this.fontWeight = FontWeight.w600,
    this.style,
    this.maxLines,
    this.textAlign = TextAlign.center,
    this.enableButton = true,
    this.cornerRadius = 5,
    this.width = double.maxFinite,
    this.height = 61,
    this.imagePath,
    this.icon,
    this.hideIcon = false,
    this.enableBgColor,
    this.disableBgColor,
    this.enableTextColor,
    this.disableTextColor,
    this.enableBorderColor,
    this.disableBorderColor,
    this.enableIconColor,
    this.disableIconColor,
    this.material = const UIMaterialButtonProps(),
  }) : assert(
         child != null || text != null,
         'Either text or child must be provided.',
       ),
       assert(
         hideIcon || icon != null || imagePath != null,
         'Either imagePath or icon must be provided when hideIcon is false.',
       );

  final VoidCallback? onPressed;
  final String? text;
  final Widget? child;
  final double size;
  final FontWeight fontWeight;
  final int? maxLines;
  final TextStyle? style;
  final TextAlign textAlign;
  final bool enableButton;
  final double cornerRadius;
  final double? width;
  final double? height;
  final String? imagePath;
  final Widget? icon;
  final bool hideIcon;
  final Color? enableTextColor;
  final Color? disableTextColor;
  final Color? enableBgColor;
  final Color? disableBgColor;
  final Color? enableBorderColor;
  final Color? disableBorderColor;
  final Color? enableIconColor;
  final Color? disableIconColor;
  final UIMaterialButtonProps material;

  UIImageTextButton copyWith({
    Key? key,
    String? text,
    Widget? child,
    VoidCallback? onPressed,
    double? size,
    FontWeight? fontWeight,
    TextStyle? style,
    int? maxLines,
    TextAlign? textAlign,
    bool? enableButton,
    double? cornerRadius,
    double? width,
    double? height,
    String? imagePath,
    Widget? icon,
    bool? hideIcon,
    Color? enableTextColor,
    Color? disableTextColor,
    Color? enableBgColor,
    Color? disableBgColor,
    Color? enableBorderColor,
    Color? disableBorderColor,
    Color? enableIconColor,
    Color? disableIconColor,
    UIMaterialButtonProps? material,
  }) {
    return UIImageTextButton(
      key: key ?? this.key,
      text: text ?? this.text,
      onPressed: onPressed ?? this.onPressed,
      size: size ?? this.size,
      fontWeight: fontWeight ?? this.fontWeight,
      style: style ?? this.style,
      maxLines: maxLines ?? this.maxLines,
      textAlign: textAlign ?? this.textAlign,
      enableButton: enableButton ?? this.enableButton,
      cornerRadius: cornerRadius ?? this.cornerRadius,
      width: width ?? this.width,
      height: height ?? this.height,
      imagePath: imagePath ?? this.imagePath,
      icon: icon ?? this.icon,
      hideIcon: hideIcon ?? this.hideIcon,
      enableTextColor: enableTextColor ?? this.enableTextColor,
      disableTextColor: disableTextColor ?? this.disableTextColor,
      enableBgColor: enableBgColor ?? this.enableBgColor,
      disableBgColor: disableBgColor ?? this.disableBgColor,
      enableBorderColor: enableBorderColor ?? this.enableBorderColor,
      disableBorderColor: disableBorderColor ?? this.disableBorderColor,
      enableIconColor: enableIconColor ?? this.enableIconColor,
      disableIconColor: disableIconColor ?? this.disableIconColor,
      material: material ?? this.material,
      child: child ?? this.child,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;
    final border = enableButton
        ? (enableBorderColor ?? primary)
        : (disableBorderColor ?? theme.disabledColor);
    final buttonStyleConfig = UIStyledButtonStyle.outlined(
      context,
      height: height ?? 61,
      borderRadius: cornerRadius,
      borderColor: border,
      foregroundColor: enableButton
          ? (enableTextColor ?? primary)
          : (disableTextColor ?? theme.disabledColor),
      backgroundColor: enableButton
          ? (enableBgColor ?? theme.colorScheme.surface)
          : (disableBgColor ?? theme.disabledColor.withValues(alpha: 0.12)),
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
    final leadingIcon = hideIcon
        ? null
        : icon ??
              UIImage(
                imagePath!,
                width: 18,
                height: 20,
                fit: BoxFit.fill,
                color: enableButton
                    ? (enableIconColor ?? primary)
                    : (disableIconColor ?? theme.disabledColor),
              );
    final hasFixedWidth = width != null;

    return SizedBox(
      height: buttonStyleConfig.height,
      width: width,
      child: material.outlined(
        onPressed: isDisabled ? null : onPressed,
        baseStyle: OutlinedButton.styleFrom(
          foregroundColor: buttonStyleConfig.foregroundColor,
          backgroundColor: buttonStyleConfig.backgroundColor,
          side: BorderSide(color: buttonStyleConfig.outlineBorderColor),
          padding: hasFixedWidth
              ? EdgeInsets.zero
              : const EdgeInsets.symmetric(horizontal: 16),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          shape: buttonShape(buttonStyleConfig),
          overlayColor: Colors.transparent,
          disabledForegroundColor: buttonStyleConfig.disabledForegroundColor,
        ),
        child: buildButtonChildRow(label: styledLabel, icon: leadingIcon),
      ),
    );
  }
}
