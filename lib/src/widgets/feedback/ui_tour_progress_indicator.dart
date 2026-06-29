import 'package:flutter/material.dart';

import 'ui_tour_enums.dart';

/// Step progress for tour tooltips (dots or compact text).
class UITourProgressIndicator extends StatelessWidget {
  const UITourProgressIndicator({
    super.key,
    required this.currentStep,
    required this.totalSteps,
    this.style = UITourProgressStyle.dots,
    this.activeColor,
    this.inactiveColor,
    this.dotSize = 8,
    this.dotSpacing = 4,
    this.textStyle,
  });

  final int currentStep;
  final int totalSteps;
  final UITourProgressStyle style;
  final Color? activeColor;
  final Color? inactiveColor;
  final double dotSize;
  final double dotSpacing;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    if (style == UITourProgressStyle.none) {
      return const SizedBox.shrink();
    }

    final scheme = Theme.of(context).colorScheme;
    final active = activeColor ?? scheme.onPrimary;
    final inactive = inactiveColor ?? active.withValues(alpha: 0.35);

    switch (style) {
      case UITourProgressStyle.dots:
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(totalSteps, (index) {
            final isActive = index == currentStep;
            final isPast = index < currentStep;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: EdgeInsets.symmetric(horizontal: dotSpacing / 2),
              width: isActive ? dotSize * 2 : dotSize,
              height: dotSize,
              decoration: BoxDecoration(
                color: isActive || isPast ? active : inactive,
                borderRadius: BorderRadius.circular(dotSize / 2),
              ),
            );
          }),
        );
      case UITourProgressStyle.text:
        return Text(
          'Step ${currentStep + 1} of $totalSteps',
          style: textStyle ?? Theme.of(context).textTheme.labelSmall,
        );
      case UITourProgressStyle.textCompact:
        return Text(
          '${currentStep + 1} / $totalSteps',
          style: textStyle ?? Theme.of(context).textTheme.labelSmall,
        );
      case UITourProgressStyle.none:
        return const SizedBox.shrink();
    }
  }
}
