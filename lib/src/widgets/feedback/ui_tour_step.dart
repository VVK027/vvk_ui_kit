import 'package:flutter/material.dart';

import 'ui_tour_enums.dart';

/// Configuration for a single step in a [UITourController] walkthrough.
///
/// Attach a [GlobalKey] to the widget you want highlighted. When [key] is
/// null the tooltip is centered (or placed via [preferredPosition]) with no
/// spotlight cutout.
class UITourStep {
  const UITourStep({
    this.key,
    required this.title,
    required this.description,
    this.backgroundColor,
    this.duration,
    this.buttonLabel,
    this.previousButtonLabel,
    this.skipButtonLabel,
    this.isLast = false,
    this.animation = UITourStepAnimation.fadeSlideUp,
    this.highlightShape = UISpotlightShape.rounded,
    this.showPulse = false,
    this.customContent,
    this.showProgress = true,
    this.progressStyle = UITourProgressStyle.dots,
    this.showPreviousButton = true,
    this.showSkipButton = true,
    this.spotlightPadding = 8,
    this.spotlightBorderRadius = 12,
    this.allowTargetTap = false,
    this.preferredPosition = UITourTooltipPosition.auto,
    this.titleStyle,
    this.descriptionStyle,
    this.icon,
    this.iconColor,
    this.onDisplay,
    this.showCloseButton = false,
  });

  final GlobalKey? key;
  final String title;
  final String description;
  final Color? backgroundColor;
  final Duration? duration;
  final String? buttonLabel;
  final String? previousButtonLabel;
  final String? skipButtonLabel;
  final bool isLast;
  final UITourStepAnimation animation;
  final UISpotlightShape highlightShape;
  final bool showPulse;
  final Widget? customContent;
  final bool showProgress;
  final UITourProgressStyle progressStyle;
  final bool showPreviousButton;
  final bool showSkipButton;
  final double spotlightPadding;
  final double spotlightBorderRadius;
  final bool allowTargetTap;
  final UITourTooltipPosition preferredPosition;
  final TextStyle? titleStyle;
  final TextStyle? descriptionStyle;
  final IconData? icon;
  final Color? iconColor;
  final VoidCallback? onDisplay;
  final bool showCloseButton;
}
