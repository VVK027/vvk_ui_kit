import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vvk_ui_kit/src/widgets/feedback/ui_tour_enums.dart';
import 'package:vvk_ui_kit/src/widgets/feedback/ui_tour_progress_indicator.dart';
import 'package:vvk_ui_kit/src/widgets/feedback/ui_tour_step.dart';
import 'package:vvk_ui_kit/src/widgets/text/ui_text.dart';

enum _UITourArrowDirection { up, down, left, right }

/// Tooltip card for a single [UITourStep] inside a product tour.
class UITourTooltipCard extends StatefulWidget {
  const UITourTooltipCard({
    super.key,
    required this.step,
    required this.targetRect,
    required this.currentStepIndex,
    required this.totalSteps,
    required this.onNext,
    required this.onPrevious,
    required this.onSkip,
    this.hasTarget = true,
    this.dismissOnBarrierTap = true,
    this.dontShowAgainText = "Don't show again",
    this.onDontShowAgain,
    this.dontShowAgainStyle,
    this.animationDuration = const Duration(milliseconds: 400),
    this.animationCurve = Curves.easeOutCubic,
    this.backgroundColor,
    this.foregroundColor,
  });

  final UITourStep step;
  final Rect targetRect;
  final bool hasTarget;
  final int currentStepIndex;
  final int totalSteps;
  final VoidCallback onNext;
  final VoidCallback onPrevious;
  final VoidCallback onSkip;
  final bool dismissOnBarrierTap;
  final String dontShowAgainText;
  final VoidCallback? onDontShowAgain;
  final ButtonStyle? dontShowAgainStyle;
  final Duration animationDuration;
  final Curve animationCurve;
  final Color? backgroundColor;
  final Color? foregroundColor;

  factory UITourTooltipCard.fromTheme(
    BuildContext context, {
    Key? key,
    required UITourStep step,
    required Rect targetRect,
    required int currentStepIndex,
    required int totalSteps,
    required VoidCallback onNext,
    required VoidCallback onPrevious,
    required VoidCallback onSkip,
    bool hasTarget = true,
    bool dismissOnBarrierTap = true,
    String dontShowAgainText = "Don't show again",
    VoidCallback? onDontShowAgain,
    ButtonStyle? dontShowAgainStyle,
    Duration animationDuration = const Duration(milliseconds: 400),
    Curve animationCurve = Curves.easeOutCubic,
    Color? backgroundColor,
    Color? foregroundColor,
  }) {
    final scheme = Theme.of(context).colorScheme;
    final bg = backgroundColor ?? scheme.primaryContainer;
    final fg = foregroundColor ?? scheme.onPrimaryContainer;
    return UITourTooltipCard(
      key: key,
      step: step,
      targetRect: targetRect,
      currentStepIndex: currentStepIndex,
      totalSteps: totalSteps,
      onNext: onNext,
      onPrevious: onPrevious,
      onSkip: onSkip,
      hasTarget: hasTarget,
      dismissOnBarrierTap: dismissOnBarrierTap,
      dontShowAgainText: dontShowAgainText,
      onDontShowAgain: onDontShowAgain,
      dontShowAgainStyle: dontShowAgainStyle,
      animationDuration: animationDuration,
      animationCurve: animationCurve,
      backgroundColor: bg,
      foregroundColor: fg,
    );
  }

  @override
  State<UITourTooltipCard> createState() => _UITourTooltipCardState();
}

class _UITourTooltipCardState extends State<UITourTooltipCard>
    with SingleTickerProviderStateMixin {
  static const double _cardWidth = 280;
  static const double _cardPadding = 20;
  static const double _arrowSize = 12;

  late final AnimationController _controller;
  late final Animation<double> _fadeAnimation;
  late final Animation<double> _scaleAnimation;
  late final Animation<Offset> _slideAnimation;
  late final Animation<double> _rotateAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _controller.forward();
    _scheduleAutoAdvance();
  }

  @override
  void didUpdateWidget(UITourTooltipCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.step != widget.step) {
      _controller
        ..reset()
        ..forward();
      _scheduleAutoAdvance();
    }
  }

  void _scheduleAutoAdvance() {
    final duration = widget.step.duration;
    if (!widget.step.isLast && duration != null) {
      Future<void>.delayed(duration, () {
        if (mounted) widget.onNext();
      });
    }
  }

  void _setupAnimations() {
    _controller = AnimationController(
      vsync: this,
      duration: widget.animationDuration,
    );
    final curve = CurvedAnimation(
      parent: _controller,
      curve: widget.animationCurve,
    );
    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(curve);
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );
    _rotateAnimation = Tween<double>(begin: -0.1, end: 0).animate(curve);

    final slideBegin = switch (widget.step.animation) {
      UITourStepAnimation.fadeSlideUp => const Offset(0, 0.3),
      UITourStepAnimation.fadeSlideDown => const Offset(0, -0.3),
      UITourStepAnimation.fadeSlideLeft => const Offset(0.3, 0),
      UITourStepAnimation.fadeSlideRight => const Offset(-0.3, 0),
      _ => Offset.zero,
    };
    _slideAnimation = Tween<Offset>(begin: slideBegin, end: Offset.zero)
        .animate(curve);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  (Offset position, _UITourArrowDirection arrowDir) _position(Size screenSize) {
    if (screenSize.width <= 0 || screenSize.height <= 0) {
      return (Offset.zero, _UITourArrowDirection.up);
    }

    const estimatedHeight = 180.0;
    final wantsCenter =
        widget.step.preferredPosition == UITourTooltipPosition.center ||
            (!widget.hasTarget &&
                widget.step.preferredPosition == UITourTooltipPosition.auto);

    if (wantsCenter) {
      return (
        Offset(
          (screenSize.width - _cardWidth) / 2,
          (screenSize.height - estimatedHeight) / 2,
        ),
        _UITourArrowDirection.up,
      );
    }

    final targetCenter = widget.targetRect.center;
    const gap = 16.0;
    final spaceAbove = widget.targetRect.top;
    final spaceBelow = screenSize.height - widget.targetRect.bottom;
    final spaceRight = screenSize.width - widget.targetRect.right;

    late _UITourArrowDirection arrowDir;
    late double dx;
    late double dy;

    switch (widget.step.preferredPosition) {
      case UITourTooltipPosition.top:
        arrowDir = _UITourArrowDirection.down;
        dy = widget.targetRect.top - estimatedHeight - gap;
        dx = targetCenter.dx - _cardWidth / 2;
      case UITourTooltipPosition.bottom:
        arrowDir = _UITourArrowDirection.up;
        dy = widget.targetRect.bottom + gap;
        dx = targetCenter.dx - _cardWidth / 2;
      case UITourTooltipPosition.left:
        arrowDir = _UITourArrowDirection.right;
        dx = widget.targetRect.left - _cardWidth - gap;
        dy = targetCenter.dy - estimatedHeight / 2;
      case UITourTooltipPosition.right:
        arrowDir = _UITourArrowDirection.left;
        dx = widget.targetRect.right + gap;
        dy = targetCenter.dy - estimatedHeight / 2;
      case UITourTooltipPosition.center:
      case UITourTooltipPosition.auto:
        if (spaceBelow >= estimatedHeight + gap) {
          arrowDir = _UITourArrowDirection.up;
          dy = widget.targetRect.bottom + gap;
          dx = targetCenter.dx - _cardWidth / 2;
        } else if (spaceAbove >= estimatedHeight + gap) {
          arrowDir = _UITourArrowDirection.down;
          dy = widget.targetRect.top - estimatedHeight - gap;
          dx = targetCenter.dx - _cardWidth / 2;
        } else if (spaceRight >= _cardWidth + gap) {
          arrowDir = _UITourArrowDirection.left;
          dx = widget.targetRect.right + gap;
          dy = targetCenter.dy - estimatedHeight / 2;
        } else {
          arrowDir = _UITourArrowDirection.right;
          dx = widget.targetRect.left - _cardWidth - gap;
          dy = targetCenter.dy - estimatedHeight / 2;
        }
    }

    dx = dx.clamp(_cardPadding, screenSize.width - _cardWidth - _cardPadding);
    dy = dy.clamp(
      _cardPadding,
      screenSize.height - estimatedHeight - _cardPadding,
    );
    return (Offset(dx, dy), arrowDir);
  }

  Offset _arrowOffset(Offset cardPosition, _UITourArrowDirection arrowDir) {
    final targetCenter = widget.targetRect.center;
    switch (arrowDir) {
      case _UITourArrowDirection.up:
        final arrowX =
            (targetCenter.dx - cardPosition.dx).clamp(20.0, _cardWidth - 20.0);
        return Offset(arrowX - _arrowSize / 2, -_arrowSize);
      case _UITourArrowDirection.down:
        final arrowX =
            (targetCenter.dx - cardPosition.dx).clamp(20.0, _cardWidth - 20.0);
        return Offset(arrowX - _arrowSize / 2, -1);
      case _UITourArrowDirection.left:
        final arrowY = (targetCenter.dy - cardPosition.dy).clamp(30.0, 150.0);
        return Offset(-_arrowSize, arrowY - _arrowSize / 2);
      case _UITourArrowDirection.right:
        final arrowY = (targetCenter.dy - cardPosition.dy).clamp(30.0, 150.0);
        return Offset(-1, arrowY - _arrowSize / 2);
    }
  }

  Widget _animatedChild(Widget child) {
    return switch (widget.step.animation) {
      UITourStepAnimation.none => child,
      UITourStepAnimation.fade =>
        FadeTransition(opacity: _fadeAnimation, child: child),
      UITourStepAnimation.scale ||
      UITourStepAnimation.bounce =>
        FadeTransition(
          opacity: _fadeAnimation,
          child: ScaleTransition(scale: _scaleAnimation, child: child),
        ),
      UITourStepAnimation.rotate => FadeTransition(
          opacity: _fadeAnimation,
          child: AnimatedBuilder(
            animation: _rotateAnimation,
            builder: (context, ch) => Transform.rotate(
              angle: _rotateAnimation.value,
              child: ch,
            ),
            child: child,
          ),
        ),
      UITourStepAnimation.fadeSlideUp ||
      UITourStepAnimation.fadeSlideDown ||
      UITourStepAnimation.fadeSlideLeft ||
      UITourStepAnimation.fadeSlideRight =>
        FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(position: _slideAnimation, child: child),
        ),
    };
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.sizeOf(context);
    final (cardPosition, arrowDir) = _position(screenSize);
    final arrowOffset = _arrowOffset(cardPosition, arrowDir);
    final cardColor =
        widget.step.backgroundColor ?? widget.backgroundColor ?? Theme.of(context).colorScheme.primaryContainer;
    final textColor = widget.foregroundColor ??
        (cardColor.computeLuminance() > 0.5 ? Colors.black87 : Colors.white);
    final buttonLabel =
        widget.step.buttonLabel ?? (widget.step.isLast ? 'Done' : 'Next');
    final isFirstStep = widget.currentStepIndex == 0;

    return Focus(
      autofocus: true,
      onKeyEvent: (node, event) {
        if (event is! KeyDownEvent) return KeyEventResult.ignored;
        if (event.logicalKey == LogicalKeyboardKey.escape) {
          widget.onSkip();
          return KeyEventResult.handled;
        }
        if (event.logicalKey == LogicalKeyboardKey.enter ||
            event.logicalKey == LogicalKeyboardKey.space) {
          widget.onNext();
          return KeyEventResult.handled;
        }
        if (event.logicalKey == LogicalKeyboardKey.arrowLeft ||
            event.logicalKey == LogicalKeyboardKey.arrowUp) {
          if (!isFirstStep) widget.onPrevious();
          return KeyEventResult.handled;
        }
        return KeyEventResult.ignored;
      },
      child: Stack(
        children: [
          GestureDetector(
            onTap: widget.dismissOnBarrierTap ? widget.onSkip : null,
            behavior: HitTestBehavior.opaque,
            child: SizedBox(
              width: screenSize.width,
              height: screenSize.height,
            ),
          ),
          Positioned(
            top: cardPosition.dy,
            left: cardPosition.dx,
            child: _animatedChild(
              _buildCard(
                cardColor,
                textColor,
                buttonLabel,
                isFirstStep,
                arrowDir,
                arrowOffset,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCard(
    Color cardColor,
    Color textColor,
    String buttonLabel,
    bool isFirstStep,
    _UITourArrowDirection arrowDir,
    Offset arrowOffset,
  ) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: _cardWidth,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.3),
                blurRadius: 16,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  if (widget.step.icon != null) ...[
                    Icon(
                      widget.step.icon,
                      color: widget.step.iconColor ?? textColor,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                  ],
                  Expanded(
                    child: UIText(
                      widget.step.title,
                      style: widget.step.titleStyle ??
                          Theme.of(context).textTheme.titleMedium?.copyWith(
                                color: textColor,
                                fontWeight: FontWeight.w700,
                              ),
                    ),
                  ),
                  if (widget.step.showCloseButton)
                    IconButton(
                      onPressed: widget.onSkip,
                      tooltip: widget.step.skipButtonLabel ?? 'Skip',
                      icon: const Icon(Icons.close),
                      iconSize: 18,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(
                        minWidth: 28,
                        minHeight: 28,
                      ),
                      color: textColor.withValues(alpha: 0.6),
                    ),
                ],
              ),
              const SizedBox(height: 8),
              if (widget.step.customContent != null)
                widget.step.customContent!
              else
                UIText(
                  widget.step.description,
                  style: widget.step.descriptionStyle ??
                      Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: textColor.withValues(alpha: 0.85),
                          ),
                ),
              const SizedBox(height: 16),
              Row(
                children: [
                  if (widget.onDontShowAgain != null)
                    Expanded(
                      child: TextButton(
                        onPressed: widget.onDontShowAgain,
                        style: widget.dontShowAgainStyle ??
                            TextButton.styleFrom(
                              foregroundColor: textColor.withValues(alpha: 0.7),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 4,
                                vertical: 4,
                              ),
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              alignment: Alignment.centerLeft,
                            ),
                        child: Text(
                          widget.dontShowAgainText,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: textColor.withValues(alpha: 0.7),
                                decoration: TextDecoration.underline,
                              ),
                        ),
                      ),
                    )
                  else if (widget.step.showSkipButton)
                    TextButton(
                      onPressed: widget.onSkip,
                      style: TextButton.styleFrom(
                        foregroundColor: textColor.withValues(alpha: 0.7),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 4,
                          vertical: 4,
                        ),
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: Text(widget.step.skipButtonLabel ?? 'Skip'),
                    )
                  else
                    const SizedBox.shrink(),
                  const Spacer(),
                  if (!isFirstStep && widget.step.showPreviousButton)
                    IconButton(
                      onPressed: widget.onPrevious,
                      tooltip: widget.step.previousButtonLabel ?? 'Previous',
                      icon: const Icon(Icons.chevron_left),
                      iconSize: 20,
                      color: textColor,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(
                        minWidth: 32,
                        minHeight: 32,
                      ),
                    ),
                  if (widget.step.showProgress)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: UITourProgressIndicator(
                        currentStep: widget.currentStepIndex,
                        totalSteps: widget.totalSteps,
                        style: widget.step.progressStyle,
                        activeColor: textColor,
                        inactiveColor: textColor.withValues(alpha: 0.3),
                        textStyle: TextStyle(color: textColor, fontSize: 13),
                      ),
                    ),
                  IconButton(
                    onPressed: widget.onNext,
                    tooltip: buttonLabel,
                    icon: Icon(
                      widget.step.isLast
                          ? Icons.check_circle_outline
                          : Icons.chevron_right,
                    ),
                    iconSize: 20,
                    color: textColor,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(
                      minWidth: 32,
                      minHeight: 32,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        if (widget.hasTarget) _buildArrow(arrowDir, arrowOffset, cardColor),
      ],
    );
  }

  Widget _buildArrow(
    _UITourArrowDirection direction,
    Offset offset,
    Color color,
  ) {
    double? top;
    double? left;
    double? bottom;
    double? right;

    switch (direction) {
      case _UITourArrowDirection.up:
        top = offset.dy;
        left = offset.dx;
      case _UITourArrowDirection.down:
        bottom = 0;
        left = offset.dx;
      case _UITourArrowDirection.left:
        top = offset.dy;
        left = offset.dx;
      case _UITourArrowDirection.right:
        top = offset.dy;
        right = 0;
    }

    return Positioned(
      top: top,
      left: left,
      bottom: bottom,
      right: right,
      child: CustomPaint(
        size: const Size(_arrowSize, _arrowSize),
        painter: _UITourArrowPainter(color: color, direction: direction),
      ),
    );
  }
}

class _UITourArrowPainter extends CustomPainter {
  const _UITourArrowPainter({
    required this.color,
    required this.direction,
  });

  final Color color;
  final _UITourArrowDirection direction;

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path();
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;

    switch (direction) {
      case _UITourArrowDirection.up:
        path
          ..moveTo(0, size.height)
          ..lineTo(size.width / 2, 0)
          ..lineTo(size.width, size.height);
      case _UITourArrowDirection.down:
        path
          ..moveTo(0, 0)
          ..lineTo(size.width / 2, size.height)
          ..lineTo(size.width, 0);
      case _UITourArrowDirection.left:
        path
          ..moveTo(size.width, 0)
          ..lineTo(0, size.height / 2)
          ..lineTo(size.width, size.height);
      case _UITourArrowDirection.right:
        path
          ..moveTo(0, 0)
          ..lineTo(size.width, size.height / 2)
          ..lineTo(0, size.height);
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _UITourArrowPainter oldDelegate) => false;
}
