import 'package:flutter/material.dart';

/// Full, half, and empty widgets used by the rating bar widgets.
@immutable
class UIRatingWidget {
  /// Creates a [UIRatingWidget].
  const UIRatingWidget({
    required this.full,
    required this.half,
    required this.empty,
  });

  /// Widget shown when the item is fully rated.
  final Widget full;

  /// Widget shown when the item is half rated.
  final Widget half;

  /// Widget shown when the item is unrated.
  final Widget empty;
}

/// Builds a default star [UIRatingWidget] using theme-aware colors.
UIRatingWidget defaultUIRatingWidget(
  BuildContext context, {
  double size = 24,
  Color? filledColor,
  Color? emptyColor,
}) {
  final theme = Theme.of(context);
  final on = filledColor ?? const Color(0xFFFFB300);
  final off = emptyColor ?? theme.colorScheme.onSurface.withValues(alpha: 0.24);

  Widget star(IconData icon, Color color) {
    return Icon(icon, size: size, color: color);
  }

  return UIRatingWidget(
    full: star(Icons.star_rounded, on),
    half: star(Icons.star_half_rounded, on),
    empty: star(Icons.star_outline_rounded, off),
  );
}
