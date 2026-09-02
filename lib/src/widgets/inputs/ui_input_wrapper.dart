import 'package:flutter/material.dart';

import '../../core/theme/ui_component_themes.dart';

/// Reusable input decoration and container wrapper for kit form fields.
///
/// Standardizes outer container borders, focus states, helper/error labels,
/// and theme extension overrides ([UIInputTheme]) across custom form fields.
class UIInputWrapper extends StatelessWidget {
  const UIInputWrapper({
    super.key,
    required this.child,
    this.label,
    this.errorText,
    this.helperText,
    this.prefixIcon,
    this.suffixIcon,
    this.borderRadius,
    this.fillColor,
    this.borderColor,
    this.focusedBorderColor,
    this.contentPadding,
    this.enabled = true,
  });

  /// The inner input field widget.
  final Widget child;

  /// Optional top field label.
  final String? label;

  /// Error message displayed below the field.
  final String? errorText;

  /// Helper message displayed below the field when there is no error.
  final String? helperText;

  /// Icon displayed before [child].
  final Widget? prefixIcon;

  /// Icon displayed after [child].
  final Widget? suffixIcon;

  /// Container corner radius.
  final double? borderRadius;

  /// Container fill background color.
  final Color? fillColor;

  /// Default border color.
  final Color? borderColor;

  /// Border color when focused.
  final Color? focusedBorderColor;

  /// Inner padding around [child].
  final EdgeInsetsGeometry? contentPadding;

  /// Whether the input is interactable.
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final inputTheme =
        Theme.of(context).extension<UIInputTheme>() ?? UIInputTheme.standard;
    final colorScheme = Theme.of(context).colorScheme;

    final effectiveRadius = borderRadius ?? inputTheme.borderRadius;
    final effectivePadding = contentPadding ?? inputTheme.contentPadding;
    final hasError = errorText != null && errorText!.isNotEmpty;

    final effectiveBorderColor = hasError
        ? colorScheme.error
        : (borderColor ?? colorScheme.outlineVariant);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (label != null) ...[
          Text(
            label!,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 6),
        ],
        AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: effectivePadding,
          decoration: BoxDecoration(
            color: fillColor ??
                colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(effectiveRadius),
            border: Border.all(
              color: effectiveBorderColor,
              width: inputTheme.borderWidth,
            ),
          ),
          child: Row(
            children: [
              if (prefixIcon != null) ...[
                prefixIcon!,
                const SizedBox(width: 8),
              ],
              Expanded(child: child),
              if (suffixIcon != null) ...[
                const SizedBox(width: 8),
                suffixIcon!,
              ],
            ],
          ),
        ),
        if (hasError) ...[
          const SizedBox(height: 4),
          Text(
            errorText!,
            style: TextStyle(
              fontSize: 12,
              color: colorScheme.error,
            ),
          ),
        ] else if (helperText != null) ...[
          const SizedBox(height: 4),
          Text(
            helperText!,
            style: TextStyle(
              fontSize: 12,
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ],
    );
  }
}
