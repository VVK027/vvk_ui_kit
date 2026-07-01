import 'package:vvk_ui_kit/src/widgets/feedback/ui_tour_progress_indicator.dart'
    show UITourProgressIndicator;

/// Animation applied when a tour tooltip appears.
enum UITourStepAnimation {
  fadeSlideUp,
  fadeSlideDown,
  fadeSlideLeft,
  fadeSlideRight,
  scale,
  bounce,
  rotate,
  fade,
  none,
}

/// Shape of the spotlight cutout around a tour target.
enum UISpotlightShape { rounded, circle, pill, rectangle }

/// Preferred placement of a tour tooltip relative to its target.
enum UITourTooltipPosition { auto, top, bottom, left, right, center }

/// Style for [UITourProgressIndicator].
enum UITourProgressStyle { dots, text, textCompact, none }
