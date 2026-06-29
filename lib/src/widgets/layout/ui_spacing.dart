import 'package:flutter/material.dart';

/// Convenience [SizedBox] for horizontal and/or vertical spacing.
///
/// Prefer named constructors for single-axis spacing:
///
/// ```dart
/// const Row(
///   children: [
///     Icon(Icons.star),
///     UISpacing.horizontal(8),
///     Text('Rated'),
///   ],
/// )
/// ```
class UISpacing extends StatelessWidget {
  /// Creates spacing with optional [horizontal] and [vertical] dimensions.
  const UISpacing({super.key, this.horizontal = 0, this.vertical = 0});

  /// Horizontal-only spacing.
  const UISpacing.horizontal(double value, {Key? key})
    : this(key: key, horizontal: value);

  /// Vertical-only spacing.
  const UISpacing.vertical(double value, {Key? key})
    : this(key: key, vertical: value);

  /// Width of the spacing box.
  final double horizontal;

  /// Height of the spacing box.
  final double vertical;

  @override
  Widget build(BuildContext context) =>
      SizedBox(width: horizontal, height: vertical);
}
