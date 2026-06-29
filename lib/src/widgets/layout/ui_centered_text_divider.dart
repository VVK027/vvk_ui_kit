import 'package:flutter/material.dart';
import 'package:vvk_ui_kit/src/widgets/text/ui_text.dart';

/// Horizontal divider with centered label and lines on both sides.
///
/// Complements dashed dividers and title-with-line layouts for "OR" / section breaks.
class UICenteredTextDivider extends StatelessWidget {
  const UICenteredTextDivider({
    super.key,
    this.text,
    this.child,
    this.lineColor,
    this.lineThickness = 1,
    this.gap = 12,
    this.textStyle,
    this.padding = EdgeInsets.zero,
  }) : assert(
         child != null || text != null,
         'Either text or child must be provided.',
       );

  final String? text;
  final Widget? child;
  final Color? lineColor;
  final double lineThickness;
  final double gap;
  final TextStyle? textStyle;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveLineColor = lineColor ?? theme.dividerColor;
    final label =
        child ??
        UIText(
          text!,
          style:
              textStyle ??
              theme.textTheme.labelMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              ),
        );

    return Padding(
      padding: padding,
      child: Row(
        children: [
          Expanded(
            child: _DividerLine(
              color: effectiveLineColor,
              thickness: lineThickness,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: gap),
            child: label,
          ),
          Expanded(
            child: _DividerLine(
              color: effectiveLineColor,
              thickness: lineThickness,
            ),
          ),
        ],
      ),
    );
  }
}

class _DividerLine extends StatelessWidget {
  const _DividerLine({required this.color, required this.thickness});

  final Color color;
  final double thickness;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: thickness,
      child: DecoratedBox(decoration: BoxDecoration(color: color)),
    );
  }
}
