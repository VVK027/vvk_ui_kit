import 'package:flutter/material.dart';
import 'ui_loading_indicator.dart';
import '../text/ui_text.dart';

/// Full-screen scrim with a centered loading card while [visible] is true.
class UILoadingOverlay extends StatelessWidget {
  const UILoadingOverlay({
    super.key,
    required this.visible,
    required this.child,
    this.message,
    this.subtitle,
    this.preserveChild = false,
    this.horizontalPadding = 32,
  });

  final bool visible;
  final Widget child;
  final String? message;
  final String? subtitle;

  /// When true, wraps [child] in a [RepaintBoundary] to reduce rebuild impact.
  final bool preserveChild;

  /// Outer horizontal padding around the loading card.
  final double horizontalPadding;

  UILoadingOverlay copyWith({
    Key? key,
    bool? visible,
    Widget? child,
    String? message,
    String? subtitle,
    bool? preserveChild,
    double? horizontalPadding,
  }) {
    return UILoadingOverlay(
      key: key ?? this.key,
      visible: visible ?? this.visible,
      message: message ?? this.message,
      subtitle: subtitle ?? this.subtitle,
      preserveChild: preserveChild ?? this.preserveChild,
      horizontalPadding: horizontalPadding ?? this.horizontalPadding,
      child: child ?? this.child,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final wrappedChild = preserveChild ? RepaintBoundary(child: child) : child;

    return Stack(
      fit: StackFit.expand,
      children: [
        wrappedChild,
        if (visible)
          Positioned.fill(
            child: Semantics(
              liveRegion: true,
              container: true,
              label: message,
              child: AbsorbPointer(
                child: ColoredBox(
                  color: theme.colorScheme.scrim.withValues(alpha: 0.52),
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: horizontalPadding,
                      ),
                      child: Material(
                        color: theme.cardColor,
                        elevation: 8,
                        shadowColor: theme.shadowColor.withValues(alpha: 0.35),
                        borderRadius: BorderRadius.circular(16),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 28,
                            vertical: 28,
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const RepaintBoundary(
                                child: UILoadingIndicator.compact(),
                              ),
                              if (message != null) ...[
                                const SizedBox(height: 20),
                                UIText(
                                  message!,
                                  textAlign: TextAlign.center,
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: theme.colorScheme.onSurface,
                                    decoration: TextDecoration.none,
                                  ),
                                ),
                              ],
                              if (subtitle != null) ...[
                                const SizedBox(height: 8),
                                UIText(
                                  subtitle!,
                                  textAlign: TextAlign.center,
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: theme.colorScheme.onSurface
                                        .withValues(alpha: 0.65),
                                    decoration: TextDecoration.none,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
