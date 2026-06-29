import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:vvk_ui_kit/src/widgets/layout/ui_portal.dart';

/// Where the popover panel opens relative to its anchor.
enum UIPopoverDirection { above, below, left, right }

/// Rich anchored popover with arrow, optional scrim, and custom content.
///
/// Uses [UIPortal] for positioning and an optional full-screen scrim for
/// coach-mark / onboarding flows. Control visibility with
/// [UIAnchoredOverlayController].
///
/// ```dart
/// final _coach = UIAnchoredOverlayController();
///
/// UIPopover(
///   controller: _coach,
///   showScrim: true,
///   showCloseButton: true,
///   content: const Text('Tap here to start'),
///   child: IconButton(
///     icon: const Icon(Icons.help_outline),
///     onPressed: _coach.show,
///   ),
/// );
/// ```
class UIPopover extends StatefulWidget {
  const UIPopover({
    super.key,
    required this.child,
    required this.content,
    this.controller,
    this.direction = UIPopoverDirection.below,
    this.showScrim = false,
    this.scrimColor,
    this.dismissOnTapOutside = true,
    this.showCloseButton = false,
    this.backgroundColor,
    this.borderRadius = 12,
    this.padding = const EdgeInsets.all(12),
    this.arrowLength = 8,
    this.arrowBaseWidth = 16,
    this.gap = 4,
    this.maxWidth = 280,
    this.rootOverlay = true,
  });

  final Widget child;
  final Widget content;
  final UIAnchoredOverlayController? controller;
  final UIPopoverDirection direction;
  final bool showScrim;
  final Color? scrimColor;
  final bool dismissOnTapOutside;
  final bool showCloseButton;
  final Color? backgroundColor;
  final double borderRadius;
  final EdgeInsetsGeometry padding;
  final double arrowLength;
  final double arrowBaseWidth;
  final double gap;
  final double maxWidth;
  final bool rootOverlay;

  /// Theme-aware defaults for background and scrim colors.
  factory UIPopover.fromTheme(
    BuildContext context, {
    Key? key,
    required Widget child,
    required Widget content,
    UIAnchoredOverlayController? controller,
    UIPopoverDirection direction = UIPopoverDirection.below,
    bool showScrim = false,
    Color? scrimColor,
    bool dismissOnTapOutside = true,
    bool showCloseButton = false,
    Color? backgroundColor,
    double borderRadius = 12,
    EdgeInsetsGeometry padding = const EdgeInsets.all(12),
    double arrowLength = 8,
    double arrowBaseWidth = 16,
    double gap = 4,
    double maxWidth = 280,
    bool rootOverlay = true,
  }) {
    final scheme = Theme.of(context).colorScheme;
    return UIPopover(
      key: key,
      content: content,
      controller: controller,
      direction: direction,
      showScrim: showScrim,
      scrimColor: scrimColor ?? scheme.scrim.withValues(alpha: 0.45),
      dismissOnTapOutside: dismissOnTapOutside,
      showCloseButton: showCloseButton,
      backgroundColor: backgroundColor ?? scheme.surfaceContainerHigh,
      borderRadius: borderRadius,
      padding: padding,
      arrowLength: arrowLength,
      arrowBaseWidth: arrowBaseWidth,
      gap: gap,
      maxWidth: maxWidth,
      rootOverlay: rootOverlay,
      child: child,
    );
  }

  @override
  State<UIPopover> createState() => _UIPopoverState();
}

class _UIPopoverState extends State<UIPopover> {
  UIAnchoredOverlayController? _ownedController;
  late UIAnchoredOverlayController _controller;
  OverlayEntry? _scrimEntry;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? UIAnchoredOverlayController();
    if (widget.controller == null) {
      _ownedController = _controller;
    }
    _controller.addListener(_onControllerChanged);
    _scheduleScrimUpdate();
  }

  @override
  void didUpdateWidget(UIPopover oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller?.removeListener(_onControllerChanged);
      _ownedController?.dispose();
      _ownedController = null;
      _controller = widget.controller ?? UIAnchoredOverlayController();
      if (widget.controller == null) {
        _ownedController = _controller;
      }
      _controller.addListener(_onControllerChanged);
      _scheduleScrimUpdate();
    } else if (oldWidget.showScrim != widget.showScrim ||
        oldWidget.scrimColor != widget.scrimColor ||
        oldWidget.dismissOnTapOutside != widget.dismissOnTapOutside) {
      _scheduleScrimUpdate();
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_onControllerChanged);
    _ownedController?.dispose();
    _removeScrim();
    super.dispose();
  }

  void _onControllerChanged() {
    setState(() {});
    _scheduleScrimUpdate();
  }

  void _scheduleScrimUpdate() {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      if (_controller.isOpen && widget.showScrim) {
        _insertScrim();
      } else {
        _removeScrim();
      }
    });
  }

  void _insertScrim() {
    final overlay = Overlay.maybeOf(context, rootOverlay: widget.rootOverlay);
    if (overlay == null) return;

    _scrimEntry ??= OverlayEntry(
      builder: (context) {
        final color = widget.scrimColor ??
            Theme.of(context).colorScheme.scrim.withValues(alpha: 0.45);
        return Positioned.fill(
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: widget.dismissOnTapOutside ? _controller.hide : null,
            child: ColoredBox(color: color),
          ),
        );
      },
    );

    if (!_scrimEntry!.mounted) {
      overlay.insert(_scrimEntry!);
    } else {
      _scrimEntry!.markNeedsBuild();
    }
  }

  void _removeScrim() {
    _scrimEntry?.remove();
    _scrimEntry = null;
  }

  UIPortalAnchor get _anchor {
    final gap = widget.gap;
    switch (widget.direction) {
      case UIPopoverDirection.below:
        return UIPortalAnchor(
          targetAnchor: Alignment.bottomCenter,
          followerAnchor: Alignment.topCenter,
          offset: Offset(0, gap),
        );
      case UIPopoverDirection.above:
        return UIPortalAnchor(
          targetAnchor: Alignment.topCenter,
          followerAnchor: Alignment.bottomCenter,
          offset: Offset(0, -gap),
        );
      case UIPopoverDirection.left:
        return UIPortalAnchor(
          targetAnchor: Alignment.centerLeft,
          followerAnchor: Alignment.centerRight,
          offset: Offset(-gap, 0),
        );
      case UIPopoverDirection.right:
        return UIPortalAnchor(
          targetAnchor: Alignment.centerRight,
          followerAnchor: Alignment.centerLeft,
          offset: Offset(gap, 0),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final background = widget.backgroundColor ?? scheme.surfaceContainerHigh;

    final panel = Material(
      color: Colors.transparent,
      elevation: 6,
      shadowColor: scheme.shadow.withValues(alpha: 0.2),
      child: _UIPopoverPanel(
        direction: widget.direction,
        backgroundColor: background,
        borderRadius: widget.borderRadius,
        padding: widget.padding,
        arrowLength: widget.arrowLength,
        arrowBaseWidth: widget.arrowBaseWidth,
        maxWidth: widget.maxWidth,
        showCloseButton: widget.showCloseButton,
        onClose: _controller.hide,
        child: widget.content,
      ),
    );

    return UIPortal(
      visible: _controller.isOpen,
      anchor: _anchor,
      rootOverlay: widget.rootOverlay,
      overlay: TapRegion(
        groupId: 'ui_popover_${identityHashCode(this)}',
        child: panel,
      ),
      child: widget.child,
    );
  }
}

class _UIPopoverPanel extends StatelessWidget {
  const _UIPopoverPanel({
    required this.direction,
    required this.backgroundColor,
    required this.borderRadius,
    required this.padding,
    required this.arrowLength,
    required this.arrowBaseWidth,
    required this.maxWidth,
    required this.showCloseButton,
    required this.onClose,
    required this.child,
  });

  final UIPopoverDirection direction;
  final Color backgroundColor;
  final double borderRadius;
  final EdgeInsetsGeometry padding;
  final double arrowLength;
  final double arrowBaseWidth;
  final double maxWidth;
  final bool showCloseButton;
  final VoidCallback onClose;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final bubble = _buildBubble(context);

    final arrow = _UIPopoverArrow(
      color: backgroundColor,
      direction: direction,
      width: arrowBaseWidth,
      height: arrowLength,
    );

    switch (direction) {
      case UIPopoverDirection.below:
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [arrow, bubble],
        );
      case UIPopoverDirection.above:
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [bubble, arrow],
        );
      case UIPopoverDirection.left:
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [bubble, arrow],
        );
      case UIPopoverDirection.right:
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [arrow, bubble],
        );
    }
  }

  Widget _buildBubble(BuildContext context) {
    final content = ConstrainedBox(
      constraints: BoxConstraints(maxWidth: maxWidth),
      child: Padding(
        padding: padding,
        child: child,
      ),
    );

    final body = showCloseButton
        ? Stack(
            clipBehavior: Clip.none,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 4, right: 4),
                child: content,
              ),
              Positioned(
                top: -4,
                right: -4,
                child: IconButton(
                  key: const Key('ui_popover_close'),
                  visualDensity: VisualDensity.compact,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints.tightFor(width: 28, height: 28),
                  icon: Icon(
                    Icons.close,
                    size: 16,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                  onPressed: onClose,
                ),
              ),
            ],
          )
        : content;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: body,
    );
  }
}

class _UIPopoverArrow extends StatelessWidget {
  const _UIPopoverArrow({
    required this.color,
    required this.direction,
    required this.width,
    required this.height,
  });

  final Color color;
  final UIPopoverDirection direction;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    final size = switch (direction) {
      UIPopoverDirection.above || UIPopoverDirection.below =>
        Size(width, height),
      UIPopoverDirection.left || UIPopoverDirection.right =>
        Size(height, width),
    };

    return CustomPaint(
      size: size,
      painter: _UIPopoverArrowPainter(color: color, direction: direction),
    );
  }
}

class _UIPopoverArrowPainter extends CustomPainter {
  const _UIPopoverArrowPainter({
    required this.color,
    required this.direction,
  });

  final Color color;
  final UIPopoverDirection direction;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path();
    switch (direction) {
      case UIPopoverDirection.below:
        path
          ..moveTo(size.width / 2, 0)
          ..lineTo(0, size.height)
          ..lineTo(size.width, size.height)
          ..close();
      case UIPopoverDirection.above:
        path
          ..moveTo(0, 0)
          ..lineTo(size.width, 0)
          ..lineTo(size.width / 2, size.height)
          ..close();
      case UIPopoverDirection.left:
        path
          ..moveTo(size.width, 0)
          ..lineTo(0, size.height / 2)
          ..lineTo(size.width, size.height)
          ..close();
      case UIPopoverDirection.right:
        path
          ..moveTo(0, 0)
          ..lineTo(size.width, size.height / 2)
          ..lineTo(0, size.height)
          ..close();
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _UIPopoverArrowPainter oldDelegate) {
    return oldDelegate.color != color || oldDelegate.direction != direction;
  }
}
