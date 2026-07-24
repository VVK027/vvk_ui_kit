import 'package:flutter/material.dart';
import '../../core/theme/ui_component_themes.dart';
import 'ui_button_props.dart';
import 'ui_styled_button.dart';
import '../text/ui_text.dart';
import '../ui_button_helpers.dart';

/// Full-width elevated action — thin wrapper over Material [ElevatedButton].
class UIElevatedButton extends StatelessWidget {
  const UIElevatedButton({
    super.key,
    this.text,
    this.child,
    required this.onPressed,
    this.backgroundColor,
    this.textColor,
    this.fontSize = 18,
    this.fontWeight = FontWeight.w500,
    this.padding,
    this.borderRadius,
    this.isFullWidth = true,
    this.material = const UIMaterialButtonProps(),
  }) : assert(
         child != null || text != null,
         'Either text or child must be provided.',
       );

  final String? text;
  final Widget? child;
  final VoidCallback onPressed;
  final Color? backgroundColor;
  final Color? textColor;
  final double fontSize;
  final FontWeight fontWeight;
  final EdgeInsetsGeometry? padding;
  final double? borderRadius;
  final bool isFullWidth;
  final UIMaterialButtonProps material;

  UIElevatedButton copyWith({
    Key? key,
    String? text,
    Widget? child,
    VoidCallback? onPressed,
    Color? backgroundColor,
    Color? textColor,
    double? fontSize,
    FontWeight? fontWeight,
    EdgeInsetsGeometry? padding,
    double? borderRadius,
    bool? isFullWidth,
    UIMaterialButtonProps? material,
  }) {
    return UIElevatedButton(
      key: key ?? this.key,
      text: text ?? this.text,
      onPressed: onPressed ?? this.onPressed,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      textColor: textColor ?? this.textColor,
      fontSize: fontSize ?? this.fontSize,
      fontWeight: fontWeight ?? this.fontWeight,
      padding: padding ?? this.padding,
      borderRadius: borderRadius ?? this.borderRadius,
      isFullWidth: isFullWidth ?? this.isFullWidth,
      material: material ?? this.material,
      child: child ?? this.child,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final metrics = context.uiButtonMetrics;
    
    final buttonStyleConfig = UIStyledButtonStyle.elevated(
      context,
      height: metrics.elevatedHeight,
      borderRadius: borderRadius ?? metrics.elevatedRadius,
      backgroundColor: backgroundColor,
      foregroundColor: textColor ?? theme.colorScheme.onPrimary,
      fontSize: fontSize,
      fontWeight: fontWeight,
    );

    final resolvedTextColor = buttonStyleConfig.foregroundColor;

    final label =
        child ??
        UIText(
          text!,
          size: fontSize,
          fontWeight: fontWeight,
          color: resolvedTextColor,
        );
        
    final styledLabel = applyButtonLabelStyle(label, buttonStyleConfig, false);

    return SizedBox(
      height: buttonStyleConfig.height,
      width: isFullWidth ? double.infinity : null,
      child: material.elevated(
        onPressed: onPressed,
        baseStyle: ElevatedButton.styleFrom(
          backgroundColor: buttonStyleConfig.backgroundColor,
          foregroundColor: resolvedTextColor,
          padding: padding ?? (isFullWidth
              ? EdgeInsets.zero
              : const EdgeInsets.symmetric(horizontal: 24)),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          shape: buttonShape(buttonStyleConfig),
          disabledBackgroundColor: buttonStyleConfig.disabledBackgroundColor,
          disabledForegroundColor: buttonStyleConfig.disabledForegroundColor,
          elevation: 0,
          overlayColor: Colors.transparent,
        ),
        child: styledLabel,
      ),
    );
  }
}
