import 'package:flutter/material.dart';
import '../../core/theme/ui_component_themes.dart';
import 'ui_button_props.dart';
import '../ui_button_helpers.dart';

/// Visual configuration for [UIStyledButton].
///
/// Defines colors, text styles, and layout properties that are applied
/// to the button based on its state.
class UIStyledButtonStyle {
  const UIStyledButtonStyle({
    required this.height,
    required this.borderRadius,
    required this.textStyle,
    required this.textColor,
    required this.loadingIndicatorSize,
    required this.loadingIndicatorColor,
    required this.backgroundColor,
    required this.foregroundColor,
    required this.disabledBackgroundColor,
    required this.disabledForegroundColor,
    required this.outlineBorderColor,
  });

  /// Total height of the button.
  final double height;

  /// Corner radius for the button.
  final double borderRadius;

  /// Base text style for the button's text child.
  final TextStyle textStyle;

  /// Default text color.
  final Color textColor;

  /// Size of the loading spinner.
  final double loadingIndicatorSize;

  /// Color of the loading spinner.
  final Color loadingIndicatorColor;

  /// Default background color.
  final Color backgroundColor;

  /// Default foreground (text/icon) color.
  final Color foregroundColor;

  /// Background color when [UIStyledButton.isDisabled] is true.
  final Color disabledBackgroundColor;

  /// Foreground color when [UIStyledButton.isDisabled] is true.
  final Color disabledForegroundColor;

  /// Border color for [UIStyledButtonVariant.outline].
  final Color outlineBorderColor;

  factory UIStyledButtonStyle.text(
    BuildContext context, {
    double? height,
    double? borderRadius,
    Color? foregroundColor,
    TextStyle? textStyle,
  }) {
    final theme = Theme.of(context);
    final metrics = context.uiButtonMetrics;
    final onSurface = foregroundColor ?? theme.colorScheme.primary;
    return UIStyledButtonStyle(
      height: height ?? metrics.textHeight,
      borderRadius: borderRadius ?? metrics.textRadius,
      textStyle: textStyle ?? theme.textTheme.labelLarge ?? const TextStyle(),
      textColor: onSurface,
      loadingIndicatorSize: 16,
      loadingIndicatorColor: onSurface,
      backgroundColor: Colors.transparent,
      foregroundColor: onSurface,
      disabledBackgroundColor: Colors.transparent,
      disabledForegroundColor: theme.disabledColor,
      outlineBorderColor: Colors.transparent,
    );
  }

  factory UIStyledButtonStyle.primary(
    BuildContext context, {
    double? height,
    double? borderRadius,
    Color? backgroundColor,
    Color? foregroundColor,
    Color? disabledBackgroundColor,
    Color? disabledForegroundColor,
    TextStyle? textStyle,
    double fontSize = 16,
    FontWeight fontWeight = FontWeight.w600,
  }) {
    final theme = Theme.of(context);
    final metrics = context.uiButtonMetrics;
    final primary = backgroundColor ?? theme.colorScheme.primary;
    final onPrimary = foregroundColor ?? theme.colorScheme.onPrimary;
    return UIStyledButtonStyle(
      height: height ?? metrics.primaryHeight,
      borderRadius: borderRadius ?? metrics.primaryRadius,
      textStyle:
          textStyle ?? TextStyle(fontSize: fontSize, fontWeight: fontWeight),
      textColor: onPrimary,
      loadingIndicatorSize: 18,
      loadingIndicatorColor: onPrimary,
      backgroundColor: primary,
      foregroundColor: onPrimary,
      disabledBackgroundColor:
          disabledBackgroundColor ??
          theme.disabledColor.withValues(alpha: 0.12),
      disabledForegroundColor: disabledForegroundColor ?? theme.disabledColor,
      outlineBorderColor: primary,
    );
  }

  factory UIStyledButtonStyle.outlined(
    BuildContext context, {
    double? height,
    double? borderRadius,
    Color? borderColor,
    Color? foregroundColor,
    Color? backgroundColor,
    TextStyle? textStyle,
    double fontSize = 16,
    FontWeight fontWeight = FontWeight.w600,
  }) {
    final theme = Theme.of(context);
    final metrics = context.uiButtonMetrics;
    final primary = borderColor ?? theme.colorScheme.primary;
    final fg = foregroundColor ?? primary;
    return UIStyledButtonStyle(
      height: height ?? metrics.outlinedHeight,
      borderRadius: borderRadius ?? metrics.outlinedRadius,
      textStyle:
          textStyle ?? TextStyle(fontSize: fontSize, fontWeight: fontWeight),
      textColor: fg,
      loadingIndicatorSize: 18,
      loadingIndicatorColor: fg,
      backgroundColor: backgroundColor ?? theme.colorScheme.surface,
      foregroundColor: fg,
      disabledBackgroundColor: theme.disabledColor.withValues(alpha: 0.12),
      disabledForegroundColor: theme.disabledColor,
      outlineBorderColor: primary,
    );
  }

  factory UIStyledButtonStyle.elevated(
    BuildContext context, {
    double? height,
    double? borderRadius,
    Color? backgroundColor,
    Color? foregroundColor,
    TextStyle? textStyle,
    double fontSize = 18,
    FontWeight fontWeight = FontWeight.w500,
  }) {
    final theme = Theme.of(context);
    final metrics = context.uiButtonMetrics;
    final bg = backgroundColor ?? theme.colorScheme.primary;
    final fg = foregroundColor ?? Colors.white;
    return UIStyledButtonStyle(
      height: height ?? metrics.elevatedHeight,
      borderRadius: borderRadius ?? metrics.elevatedRadius,
      textStyle:
          textStyle ?? TextStyle(fontSize: fontSize, fontWeight: fontWeight),
      textColor: fg,
      loadingIndicatorSize: 20,
      loadingIndicatorColor: fg,
      backgroundColor: bg,
      foregroundColor: fg,
      disabledBackgroundColor: theme.disabledColor.withValues(alpha: 0.12),
      disabledForegroundColor: theme.disabledColor,
      outlineBorderColor: bg,
    );
  }
}

/// Visual variant for [UIStyledButton] (filled, outlined, or text).
enum UIStyledButtonVariant { primary, secondary, outline, text }

/// Size presets for [UIStyledButton] padding and typography.
enum UIStyledButtonSize { extraSmall, small, medium, large, extraLarge }

/// A highly customizable button widget that supports different variants,
/// loading states, and custom styling.
///
/// Use [UIStyledButton] when you need a button that adheres to the project's
/// design system but requires flexible configuration for size, state, and appearance.
///
/// Example:
/// ```dart
/// UIStyledButton(
///   style: myStyle,
///   onPressed: () => print('Tapped'),
///   isLoading: _loading,
///   child: Text('Submit'),
/// )
/// ```
class UIStyledButton extends StatelessWidget {
  const UIStyledButton({
    required this.child,
    required this.style,
    super.key,
    this.variant = UIStyledButtonVariant.primary,
    this.onPressed,
    this.isLoading = false,
    this.isDisabled = false,
    this.width,
    this.icon,
    this.backgroundColor,
    this.buttonStyle,
    this.material = const UIMaterialButtonProps(),
    this.semanticsLabel,
    this.semanticsHint,
  });

  /// The main content of the button, typically a [Text] or [Icon].
  final Widget child;

  /// Configuration for the button's appearance.
  final UIStyledButtonStyle style;

  /// The visual variant of the button (primary, secondary, or outline).
  final UIStyledButtonVariant variant;

  /// Callback when the button is pressed. If null, the button is disabled.
  final VoidCallback? onPressed;

  /// Whether to show a loading indicator instead of the child.
  final bool isLoading;

  /// Whether the button is interactable.
  final bool isDisabled;

  /// Optional fixed width for the button.
  final double? width;

  /// Optional icon to display before the [child].
  final Widget? icon;

  /// Optional override for the background color.
  final Color? backgroundColor;

  /// Optional Material [ButtonStyle] for [UIStyledButtonVariant.text].
  final ButtonStyle? buttonStyle;

  /// Forwarded Material button interaction and style overrides.
  final UIMaterialButtonProps material;

  /// Accessibility label announced by screen readers. Defaults to the visible
  /// [child] text when null.
  final String? semanticsLabel;

  /// Optional accessibility hint describing the button's action.
  final String? semanticsHint;

  UIStyledButton copyWith({
    Key? key,
    Widget? child,
    UIStyledButtonStyle? style,
    UIStyledButtonVariant? variant,
    VoidCallback? onPressed,
    bool? isLoading,
    bool? isDisabled,
    double? width,
    Widget? icon,
    Color? backgroundColor,
    ButtonStyle? buttonStyle,
    UIMaterialButtonProps? material,
    String? semanticsLabel,
    String? semanticsHint,
  }) {
    return UIStyledButton(
      key: key ?? this.key,
      style: style ?? this.style,
      variant: variant ?? this.variant,
      onPressed: onPressed ?? this.onPressed,
      isLoading: isLoading ?? this.isLoading,
      isDisabled: isDisabled ?? this.isDisabled,
      width: width ?? this.width,
      icon: icon ?? this.icon,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      buttonStyle: buttonStyle ?? this.buttonStyle,
      material: material ?? this.material,
      semanticsLabel: semanticsLabel ?? this.semanticsLabel,
      semanticsHint: semanticsHint ?? this.semanticsHint,
      child: child ?? this.child,
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isButtonDisabled = isDisabled || isLoading;
    final content = _buildButtonContent(isButtonDisabled);
    final buttonWidget = _buildButtonWidget(content, isButtonDisabled);

    Widget result = SizedBox(
      height: style.height,
      width: width,
      child: buttonWidget,
    );

    if (semanticsLabel != null || semanticsHint != null) {
      result = Semantics(
        button: true,
        enabled: !isButtonDisabled,
        label: semanticsLabel,
        hint: semanticsHint,
        child: result,
      );
    }

    return result;
  }

  Widget _buildButtonContent(bool isButtonDisabled) {
    final styledChild = applyButtonLabelStyle(child, style, isButtonDisabled);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(child: styledChild),
        if (isLoading)
          Padding(
            padding: const EdgeInsets.only(left: 8),
            child: SizedBox(
              height: style.loadingIndicatorSize,
              width: style.loadingIndicatorSize,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: style.loadingIndicatorColor,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildButtonWidget(Widget content, bool isButtonDisabled) {
    final VoidCallback? finalOnPressed = isButtonDisabled
        ? null
        : (onPressed ?? () {});

    final childContent = buildButtonChildRow(label: content, icon: icon);

    final shape = buttonShape(style);

    if (variant == UIStyledButtonVariant.text) {
      return material.text(
        onPressed: finalOnPressed,
        baseStyle: material.mergeStyle(buttonStyle),
        child: childContent,
      );
    }

    if (variant == UIStyledButtonVariant.outline) {
      return material.outlined(
        onPressed: finalOnPressed,
        baseStyle: OutlinedButton.styleFrom(
          foregroundColor: style.foregroundColor,
          side: BorderSide(color: style.outlineBorderColor),
          padding: width != null
              ? EdgeInsets.zero
              : const EdgeInsets.symmetric(horizontal: 16),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          shape: shape,
          overlayColor: Colors.transparent,
          disabledForegroundColor: style.disabledForegroundColor,
        ),
        child: childContent,
      );
    }

    return material.elevated(
      onPressed: finalOnPressed,
      baseStyle: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor ?? style.backgroundColor,
        foregroundColor: style.foregroundColor,
        padding: width != null
            ? EdgeInsets.zero
            : const EdgeInsets.symmetric(horizontal: 16),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        shape: shape,
        disabledBackgroundColor: style.disabledBackgroundColor,
        disabledForegroundColor: style.disabledForegroundColor,
        elevation: 0,
        overlayColor: Colors.transparent,
      ),
      child: childContent,
    );
  }
}
