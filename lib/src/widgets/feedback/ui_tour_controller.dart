import 'package:flutter/material.dart';
import 'package:vvk_ui_kit/src/widgets/feedback/ui_spotlight_overlay.dart';
import 'package:vvk_ui_kit/src/widgets/feedback/ui_tour_step.dart';
import 'package:vvk_ui_kit/src/widgets/feedback/ui_tour_tooltip_card.dart';

/// Orchestrates a multi-step product tour with spotlight overlays and tooltips.
///
/// ```dart
/// final searchKey = GlobalKey();
/// final tour = UITourController(
///   context: context,
///   steps: [
///     UITourStep(
///       key: searchKey,
///       title: 'Search',
///       description: 'Find anything from here.',
///     ),
///   ],
/// );
/// await tour.start();
/// ```
class UITourController {
  UITourController({
    required this.context,
    required this.steps,
    this.onComplete,
    this.onSkip,
    this.onStepChange,
    this.startDelay,
    this.overlayColor = const Color.fromRGBO(0, 0, 0, 0.7),
    this.dismissOnBarrierTap = false,
    this.dontShowAgainText = "Don't show again",
    this.onDontShowAgain,
    this.dontShowAgainStyle,
    this.backgroundColor,
    this.foregroundColor,
  });

  final BuildContext context;
  final List<UITourStep> steps;
  final VoidCallback? onComplete;
  final VoidCallback? onSkip;
  final void Function(int stepIndex, UITourStep step)? onStepChange;
  final Duration? startDelay;
  final Color overlayColor;
  final bool dismissOnBarrierTap;
  final String dontShowAgainText;
  final VoidCallback? onDontShowAgain;
  final ButtonStyle? dontShowAgainStyle;
  final Color? backgroundColor;
  final Color? foregroundColor;

  factory UITourController.fromTheme(
    BuildContext context, {
    required List<UITourStep> steps,
    VoidCallback? onComplete,
    VoidCallback? onSkip,
    void Function(int stepIndex, UITourStep step)? onStepChange,
    Duration? startDelay,
    Color? overlayColor,
    bool dismissOnBarrierTap = false,
    String dontShowAgainText = "Don't show again",
    VoidCallback? onDontShowAgain,
    ButtonStyle? dontShowAgainStyle,
    Color? backgroundColor,
    Color? foregroundColor,
  }) {
    final scheme = Theme.of(context).colorScheme;
    return UITourController(
      context: context,
      steps: steps,
      onComplete: onComplete,
      onSkip: onSkip,
      onStepChange: onStepChange,
      startDelay: startDelay,
      overlayColor: overlayColor ?? scheme.scrim.withValues(alpha: 0.72),
      dismissOnBarrierTap: dismissOnBarrierTap,
      dontShowAgainText: dontShowAgainText,
      onDontShowAgain: onDontShowAgain,
      dontShowAgainStyle: dontShowAgainStyle,
      backgroundColor: backgroundColor ?? scheme.primaryContainer,
      foregroundColor: foregroundColor ?? scheme.onPrimaryContainer,
    );
  }

  OverlayEntry? _overlayEntry;
  int _currentStepIndex = 0;
  bool _isRunning = false;

  int get currentStepIndex => _currentStepIndex;
  int get totalSteps => steps.length;
  bool get isRunning => _isRunning;
  UITourStep? get currentStep =>
      _isRunning && _currentStepIndex < steps.length
          ? steps[_currentStepIndex]
          : null;

  Future<void> start() async {
    if (steps.isEmpty) return;
    if (startDelay != null) {
      await Future<void>.delayed(startDelay!);
    }
    _currentStepIndex = 0;
    _isRunning = true;
    _showStep(notifyChange: true);
  }

  Future<void> startFrom(int stepIndex) async {
    if (stepIndex < 0 || stepIndex >= steps.length) return;
    if (startDelay != null) {
      await Future<void>.delayed(startDelay!);
    }
    _currentStepIndex = stepIndex;
    _isRunning = true;
    _showStep(notifyChange: true);
  }

  void next() {
    if (!_isRunning) return;
    final step = steps[_currentStepIndex];
    if (step.isLast || _currentStepIndex >= steps.length - 1) {
      _complete();
      return;
    }
    _currentStepIndex++;
    _showStep(notifyChange: true);
  }

  void previous() {
    if (!_isRunning || _currentStepIndex <= 0) return;
    _currentStepIndex--;
    _showStep(notifyChange: true);
  }

  void goToStep(int stepIndex) {
    if (!_isRunning) return;
    if (stepIndex < 0 || stepIndex >= steps.length) return;
    _currentStepIndex = stepIndex;
    _showStep(notifyChange: true);
  }

  void skip() {
    _removeOverlay();
    _isRunning = false;
    onSkip?.call();
  }

  void end() {
    _removeOverlay();
    _isRunning = false;
  }

  void _complete() {
    _removeOverlay();
    _isRunning = false;
    onComplete?.call();
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  void _showStep({required bool notifyChange}) {
    _overlayEntry?.remove();

    final step = steps[_currentStepIndex];
    final overlay = Overlay.maybeOf(context);
    if (overlay == null) return;

    final renderBox =
        step.key?.currentContext?.findRenderObject() as RenderBox?;
    if (step.key != null && renderBox == null) return;

    final target = renderBox != null
        ? renderBox.localToGlobal(Offset.zero) & renderBox.size
        : Rect.zero;

    step.onDisplay?.call();

    _overlayEntry = OverlayEntry(
      builder: (overlayContext) => Stack(
        children: [
          if (renderBox != null)
            UISpotlightOverlay(
              targetRect: target,
              padding: step.spotlightPadding,
              overlayColor: overlayColor,
              shape: step.highlightShape,
              borderRadius: step.spotlightBorderRadius,
              showPulse: step.showPulse,
              onTargetTap: step.allowTargetTap ? next : null,
            )
          else
            GestureDetector(
              onTap: dismissOnBarrierTap ? skip : null,
              child: ColoredBox(
                color: overlayColor,
                child: SizedBox(
                  width: MediaQuery.sizeOf(overlayContext).width,
                  height: MediaQuery.sizeOf(overlayContext).height,
                ),
              ),
            ),
          UITourTooltipCard(
            step: step,
            targetRect: target,
            hasTarget: renderBox != null,
            currentStepIndex: _currentStepIndex,
            totalSteps: steps.length,
            onNext: next,
            onPrevious: previous,
            onSkip: skip,
            dismissOnBarrierTap: dismissOnBarrierTap,
            dontShowAgainText: dontShowAgainText,
            onDontShowAgain: onDontShowAgain,
            dontShowAgainStyle: dontShowAgainStyle,
            backgroundColor: backgroundColor,
            foregroundColor: foregroundColor,
          ),
        ],
      ),
    );

    overlay.insert(_overlayEntry!);
    if (notifyChange) {
      onStepChange?.call(_currentStepIndex, step);
    }
  }
}
