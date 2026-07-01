import 'package:flutter/material.dart';
import '../loading/ui_shimmer.dart';

/// Swipe-to-confirm button for destructive or high-friction actions.
class UISliderButton extends StatefulWidget {
  const UISliderButton({
    super.key,
    required this.onConfirm,
    this.label,
    this.icon,
    this.thumb,
    this.width,
    this.height = 56,
    this.borderRadius = 28,
    this.thumbSize,
    this.backgroundColor,
    this.thumbColor,
    this.labelColor,
    this.shimmerLabel = true,
    this.shimmerBaseColor,
    this.shimmerHighlightColor,
    this.dismissThreshold = 0.75,
    this.disabled = false,
    this.rtl = false,
    this.dismissKey,
    this.hideAfterConfirm = true,
  });

  final Future<bool?> Function() onConfirm;
  final Widget? label;
  final Widget? icon;
  final Widget? thumb;
  final double? width;
  final double height;
  final double borderRadius;
  final double? thumbSize;
  final Color? backgroundColor;
  final Color? thumbColor;
  final Color? labelColor;
  final bool shimmerLabel;
  final Color? shimmerBaseColor;
  final Color? shimmerHighlightColor;
  final double dismissThreshold;
  final bool disabled;
  final bool rtl;
  final Key? dismissKey;
  final bool hideAfterConfirm;

  @override
  State<UISliderButton> createState() => _UISliderButtonState();
}

class _UISliderButtonState extends State<UISliderButton> {
  bool _visible = true;

  @override
  Widget build(BuildContext context) {
    if (!_visible) return const SizedBox.shrink();

    final theme = Theme.of(context);
    final trackColor =
        widget.backgroundColor ?? theme.colorScheme.surfaceContainerHighest;
    final thumbColor = widget.thumbColor ?? theme.colorScheme.primary;
    final onThumbColor = theme.colorScheme.onPrimary;
    final labelColor = widget.labelColor ?? theme.colorScheme.onSurfaceVariant;

    return LayoutBuilder(
      builder: (context, constraints) {
        final trackWidth =
            widget.width ??
            (constraints.maxWidth.isFinite ? constraints.maxWidth : 320);
        final thumbSize = widget.thumbSize ?? widget.height * 0.82;
        final thumbPadding = (widget.height - thumbSize) / 2;
        final dragWidth = trackWidth - widget.height;

        Widget label =
            widget.label ??
            Text(
              'Slide to confirm',
              style: theme.textTheme.titleSmall?.copyWith(color: labelColor),
            );

        if (widget.shimmerLabel && !widget.disabled) {
          label = UIShimmer.fromColors(
            baseColor:
                widget.shimmerBaseColor ?? labelColor.withValues(alpha: 0.5),
            highlightColor:
                widget.shimmerHighlightColor ??
                labelColor.withValues(alpha: 0.2),
            child: label,
          );
        }

        final thumb =
            widget.thumb ??
            Container(
              width: thumbSize,
              height: thumbSize,
              decoration: BoxDecoration(
                color: widget.disabled ? theme.disabledColor : thumbColor,
                borderRadius: BorderRadius.circular(widget.borderRadius),
              ),
              child: IconTheme(
                data: IconThemeData(
                  color: onThumbColor,
                  size: thumbSize * 0.45,
                ),
                child: widget.icon ?? const Icon(Icons.chevron_right),
              ),
            );

        final dismissible = Dismissible(
          key: widget.dismissKey ?? UniqueKey(),
          direction: widget.rtl
              ? DismissDirection.endToStart
              : DismissDirection.startToEnd,
          dismissThresholds: {
            widget.rtl
                    ? DismissDirection.endToStart
                    : DismissDirection.startToEnd:
                widget.dismissThreshold,
          },
          confirmDismiss: (_) async {
            if (widget.disabled) return false;
            final result = await widget.onConfirm();
            final confirmed = result ?? true;
            if (confirmed && widget.hideAfterConfirm && mounted) {
              setState(() => _visible = false);
            }
            return confirmed;
          },
          child: SizedBox(
            width: dragWidth,
            height: widget.height,
            child: Align(
              alignment: widget.rtl
                  ? Alignment.centerRight
                  : Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.all(thumbPadding),
                child: thumb,
              ),
            ),
          ),
        );

        return SizedBox(
          width: trackWidth,
          height: widget.height,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: widget.disabled
                  ? theme.disabledColor.withValues(alpha: 0.2)
                  : trackColor,
              borderRadius: BorderRadius.circular(widget.borderRadius),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Align(
                  alignment: widget.rtl
                      ? Alignment.centerLeft
                      : Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: label,
                  ),
                ),
                if (widget.disabled)
                  Padding(padding: EdgeInsets.all(thumbPadding), child: thumb)
                else
                  dismissible,
              ],
            ),
          ),
        );
      },
    );
  }
}
