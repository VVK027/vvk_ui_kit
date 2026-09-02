import 'package:flutter/material.dart';

import '../../core/theme/ui_component_themes.dart';
import '../anim/ui_tap_guard.dart';

/// Reusable primitive wrapper for all kit buttons.
///
/// Encapsulates touch ripple feedback, debounced taps ([UITapGuard]),
/// accessibility semantics, progress loader states, and disabled styling.
class UIButtonBase extends StatelessWidget {
  const UIButtonBase({
    super.key,
    required this.child,
    this.onPressed,
    this.isLoading = false,
    this.isDisabled = false,
    this.backgroundColor,
    this.foregroundColor,
    this.borderColor,
    this.borderWidth,
    this.borderRadius,
    this.padding,
    this.width,
    this.height,
    this.elevation = 0,
    this.semanticLabel,
    this.semanticHint,
  });

  /// Button label or content widget.
  final Widget child;

  /// Callback when the button is tapped.
  final VoidCallback? onPressed;

  /// Whether a circular progress indicator should replace the content.
  final bool isLoading;

  /// Whether the button is interactable.
  final bool isDisabled;

  /// Container background color.
  final Color? backgroundColor;

  /// Default text and icon color.
  final Color? foregroundColor;

  /// Border color.
  final Color? borderColor;

  /// Border line width.
  final double? borderWidth;

  /// Corner radius.
  final double? borderRadius;

  /// Padding around [child].
  final EdgeInsetsGeometry? padding;

  /// Optional fixed width.
  final double? width;

  /// Optional fixed height.
  final double? height;

  /// Material elevation.
  final double elevation;

  /// Accessibility semantic label for screen readers.
  final String? semanticLabel;

  /// Accessibility semantic hint describing action.
  final String? semanticHint;

  @override
  Widget build(BuildContext context) {
    final buttonTheme =
        Theme.of(context).extension<UIButtonTheme>() ?? const UIButtonTheme();
    final colorScheme = Theme.of(context).colorScheme;

    final effectiveDisabled = isDisabled || isLoading || onPressed == null;
    final effectiveRadius = borderRadius ?? buttonTheme.borderRadius;
    final effectivePadding = padding ??
        EdgeInsets.symmetric(
          horizontal: buttonTheme.horizontalPadding,
          vertical: 12,
        );

    final bg = effectiveDisabled
        ? colorScheme.onSurface.withValues(alpha: 0.12)
        : (backgroundColor ?? colorScheme.primary);

    final fg = effectiveDisabled
        ? colorScheme.onSurface.withValues(alpha: 0.38)
        : (foregroundColor ?? colorScheme.onPrimary);

    return Semantics(
      container: true,
      button: true,
      enabled: !effectiveDisabled,
      label: semanticLabel,
      hint: semanticHint,
      excludeSemantics: semanticLabel != null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: width,
        height: height,
        child: Material(
          color: bg,
          elevation: elevation,
          borderRadius: BorderRadius.circular(effectiveRadius),
          child: UITapGuard(
            onTap: effectiveDisabled
                ? null
                : () async {
                    onPressed?.call();
                  },
            builder: (context, guardedOnTap) {
              return InkWell(
                borderRadius: BorderRadius.circular(effectiveRadius),
                onTap: guardedOnTap == null
                    ? null
                    : () {
                        guardedOnTap();
                      },
                child: Container(
                  padding: effectivePadding,
                  decoration: borderColor != null
                      ? BoxDecoration(
                          borderRadius: BorderRadius.circular(effectiveRadius),
                          border: Border.all(
                            color: effectiveDisabled
                                ? colorScheme.onSurface.withValues(alpha: 0.12)
                                : borderColor!,
                            width: borderWidth ?? 1.0,
                          ),
                        )
                      : null,
                  child: Center(
                    child: isLoading
                        ? SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              valueColor: AlwaysStoppedAnimation<Color>(fg),
                            ),
                          )
                        : DefaultTextStyle(
                            style: TextStyle(
                              color: fg,
                              fontWeight: FontWeight.w600,
                            ),
                            child: IconTheme(
                              data: IconThemeData(color: fg, size: 20),
                              child: child,
                            ),
                          ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
