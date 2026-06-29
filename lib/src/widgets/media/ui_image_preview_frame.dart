import 'package:flutter/material.dart';
import 'package:vvk_ui_kit/src/widgets/text/ui_text.dart';

/// Fixed 16:9 frame for image previews.
class UIImagePreviewFrame extends StatelessWidget {
  static const double aspectRatio = 16 / 9;

  final Widget child;
  final double? height;
  final Color backgroundColor;
  final Color borderColor;

  const UIImagePreviewFrame({
    super.key,
    required this.child,
    this.height,
    this.backgroundColor = const Color(0xFFEEF2F8),
    this.borderColor = const Color(0xFFD5DEEA),
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
    final frame = Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: borderColor),
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

Widget imagePreviewImage(
  String imagePath, {
  required String fallbackTitle,
  BoxFit fit = BoxFit.contain,
  int? cacheWidth,
  int? cacheHeight,
  Color gradientStart = const Color(0xFFE8EDF5),
  Color gradientEnd = const Color(0xFFDCE4F0),
  Color accentColor = const Color(0xFF4F5D9A),
  Color iconColor = const Color(0xFF94A3B8),
}) {
  final trimmed = imagePath.trim();
  if (trimmed.isEmpty) {
    return Builder(
      builder: (context) => imagePreviewPlaceholder(
        context,
        fallbackTitle,
        gradientStart: gradientStart,
        gradientEnd: gradientEnd,
        accentColor: accentColor,
        iconColor: iconColor,
      ),
    );
  }

  final image = trimmed.startsWith('http://') || trimmed.startsWith('https://')
      ? Image.network(
          trimmed,
          fit: fit,
          width: double.infinity,
          height: double.infinity,
          alignment: Alignment.center,
          filterQuality: FilterQuality.medium,
          cacheWidth: cacheWidth,
          cacheHeight: cacheHeight,
          gaplessPlayback: true,
          errorBuilder: (context, _, _) => imagePreviewPlaceholder(
            context,
            fallbackTitle,
            gradientStart: gradientStart,
            gradientEnd: gradientEnd,
            accentColor: accentColor,
            iconColor: iconColor,
          ),
        )
      : Image.asset(
          trimmed,
          fit: fit,
          width: double.infinity,
          height: double.infinity,
          alignment: Alignment.center,
          filterQuality: FilterQuality.medium,
          cacheWidth: cacheWidth,
          cacheHeight: cacheHeight,
          gaplessPlayback: true,
          errorBuilder: (context, _, _) => imagePreviewPlaceholder(
            context,
            fallbackTitle,
            gradientStart: gradientStart,
            gradientEnd: gradientEnd,
            accentColor: accentColor,
            iconColor: iconColor,
          ),
        );

  return image;
}

Widget imagePreviewPlaceholder(
  BuildContext context,
  String projectName, {
  Color gradientStart = const Color(0xFFE8EDF5),
  Color gradientEnd = const Color(0xFFDCE4F0),
  Color accentColor = const Color(0xFF4F5D9A),
  Color iconColor = const Color(0xFF94A3B8),
}) {
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
        colors: [gradientStart, gradientEnd],
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
          color: accentColor,
          letterSpacing: 2,
        ),
        const SizedBox(height: 4),
        Icon(Icons.code_rounded, color: iconColor, size: 20),
      ],
    ),
  );
}
