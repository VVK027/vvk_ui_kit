import 'package:flutter/material.dart';
import '../text/ui_text.dart';
import 'ui_image.dart';

/// Fixed 16:9 frame for image previews.
///
/// When [backgroundColor] / [borderColor] are omitted they resolve from the
/// ambient [Theme] (surface + divider colors), so previews adapt to light and
/// dark mode without per-call overrides.
class UIImagePreviewFrame extends StatelessWidget {
  static const double aspectRatio = 16 / 9;

  final Widget child;
  final double? height;
  final Color? backgroundColor;
  final Color? borderColor;

  const UIImagePreviewFrame({
    super.key,
    required this.child,
    this.height,
    this.backgroundColor,
    this.borderColor,
  });

  UIImagePreviewFrame copyWith({
    Key? key,
    Widget? child,
    double? height,
    Color? backgroundColor,
    Color? borderColor,
  }) {
    return UIImagePreviewFrame(
      key: key ?? this.key,
      height: height ?? this.height,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      borderColor: borderColor ?? this.borderColor,
      child: child ?? this.child,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final resolvedBackground =
        backgroundColor ?? theme.colorScheme.surfaceContainerHighest;
    final resolvedBorder = borderColor ?? theme.dividerColor;

    final frame = Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: resolvedBackground,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: resolvedBorder),
      ),
      clipBehavior: Clip.antiAlias,
      child: child,
    );

    if (height != null) {
      return SizedBox(height: height, width: double.infinity, child: frame);
    }

    return AspectRatio(aspectRatio: aspectRatio, child: frame);
  }
}

/// Builds a preview image for [imagePath], routed through [UIImage] so it
/// inherits the kit's caching, `UIImageScope` builders, and error handling.
///
/// Falls back to [imagePreviewPlaceholder] for empty paths and load failures.
/// When the color overrides are omitted the placeholder resolves its palette
/// from the ambient [Theme].
Widget imagePreviewImage(
  String imagePath, {
  required String fallbackTitle,
  BoxFit fit = BoxFit.contain,
  Color? gradientStart,
  Color? gradientEnd,
  Color? accentColor,
  Color? iconColor,
}) {
  final trimmed = imagePath.trim();

  return Builder(
    builder: (context) {
      final placeholder = imagePreviewPlaceholder(
        context,
        fallbackTitle,
        gradientStart: gradientStart,
        gradientEnd: gradientEnd,
        accentColor: accentColor,
        iconColor: iconColor,
      );

      if (trimmed.isEmpty) return placeholder;

      final isNetwork =
          trimmed.startsWith('http://') || trimmed.startsWith('https://');

      return UIImage(
        trimmed,
        isAsset: !isNetwork,
        fit: fit,
        width: double.infinity,
        height: double.infinity,
        alignment: Alignment.center,
        placeholder: placeholder,
        fallback: placeholder,
      );
    },
  );
}

Widget imagePreviewPlaceholder(
  BuildContext context,
  String projectName, {
  Color? gradientStart,
  Color? gradientEnd,
  Color? accentColor,
  Color? iconColor,
}) {
  final scheme = Theme.of(context).colorScheme;
  final resolvedStart = gradientStart ?? scheme.surfaceContainerHigh;
  final resolvedEnd = gradientEnd ?? scheme.surfaceContainerHighest;
  final resolvedAccent = accentColor ?? scheme.primary;
  final resolvedIcon = iconColor ?? scheme.onSurfaceVariant;

  final initials = projectName
      .split(RegExp(r'\s+'))
      .where((w) => w.isNotEmpty && w[0] == w[0].toUpperCase())
      .take(2)
      .map((w) => w[0])
      .join();

  return Container(
    width: double.infinity,
    height: double.infinity,
    decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: [resolvedStart, resolvedEnd],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    ),
    alignment: Alignment.center,
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        UIText(
          initials,
          size: 36,
          fontWeight: FontWeight.w700,
          color: resolvedAccent,
          letterSpacing: 2,
        ),
        const SizedBox(height: 4),
        Icon(Icons.code_rounded, color: resolvedIcon, size: 20),
      ],
    ),
  );
}
