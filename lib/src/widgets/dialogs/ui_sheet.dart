import 'package:flutter/material.dart';
import '../glass/ui_glass_surface.dart';
import '../glass/ui_glass_theme.dart';
import '../text/ui_text.dart';

/// Edge from which a [UISheet] enters the screen.
enum UISheetSide { bottom, top, left, right }

/// Shows a kit-styled sheet from any [UISheetSide].
Future<T?> showUISheet<T>({
  required BuildContext context,
  required Widget child,
  UISheetSide side = UISheetSide.bottom,
  String? title,
  bool showDragHandle = true,
  bool isDismissible = true,
  bool enableDrag = true,
  double? width,
  double? height,
  Color? backgroundColor,
  bool glass = false,
  double blur = UIGlassConstants.defaultBlur,
  double tintOpacity = UIGlassConstants.defaultTintOpacity,
  UIGlassTheme? glassTheme,
  Gradient? gradient,
}) {
  return switch (side) {
    UISheetSide.bottom => showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      backgroundColor: Colors.transparent,
      builder: (ctx) => UISheet(
        side: side,
        title: title,
        showDragHandle: showDragHandle,
        backgroundColor: backgroundColor,
        height: height,
        glass: glass,
        blur: blur,
        tintOpacity: tintOpacity,
        glassTheme: glassTheme,
        gradient: gradient,
        child: child,
      ),
    ),
    UISheetSide.top ||
    UISheetSide.left ||
    UISheetSide.right => showGeneralDialog<T>(
      context: context,
      barrierDismissible: isDismissible,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      pageBuilder: (ctx, animation, secondaryAnimation) {
        return Align(
          alignment: _alignmentFor(side),
          child: UISheet(
            side: side,
            title: title,
            showDragHandle: showDragHandle,
            backgroundColor: backgroundColor,
            width: width,
            height: height,
            glass: glass,
            blur: blur,
            tintOpacity: tintOpacity,
            glassTheme: glassTheme,
            gradient: gradient,
            child: child,
          ),
        );
      },
      transitionBuilder: (ctx, animation, secondaryAnimation, child) {
        final offset = _slideOffset(side);
        return SlideTransition(
          position: Tween<Offset>(begin: offset, end: Offset.zero).animate(
            CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
          ),
          child: child,
        );
      },
    ),
  };
}

Alignment _alignmentFor(UISheetSide side) {
  return switch (side) {
    UISheetSide.bottom => Alignment.bottomCenter,
    UISheetSide.top => Alignment.topCenter,
    UISheetSide.left => Alignment.centerLeft,
    UISheetSide.right => Alignment.centerRight,
  };
}

Offset _slideOffset(UISheetSide side) {
  return switch (side) {
    UISheetSide.bottom => const Offset(0, 1),
    UISheetSide.top => const Offset(0, -1),
    UISheetSide.left => const Offset(-1, 0),
    UISheetSide.right => const Offset(1, 0),
  };
}

/// Styled sheet container used by [showUISheet].
class UISheet extends StatelessWidget {
  const UISheet({
    super.key,
    required this.child,
    this.side = UISheetSide.bottom,
    this.title,
    this.showDragHandle = true,
    this.backgroundColor,
    this.width,
    this.height,
    this.borderRadius = 16,
    this.padding = const EdgeInsets.all(16),
    this.glass = false,
    this.blur = UIGlassConstants.defaultBlur,
    this.tintOpacity = UIGlassConstants.defaultTintOpacity,
    this.glassTheme,
    this.gradient,
  });

  final Widget child;
  final UISheetSide side;
  final String? title;
  final bool showDragHandle;
  final Color? backgroundColor;
  final double? width;
  final double? height;
  final double borderRadius;
  final EdgeInsetsGeometry padding;
  final bool glass;
  final double blur;
  final double tintOpacity;
  final UIGlassTheme? glassTheme;
  final Gradient? gradient;

  BorderRadius get _radius {
    return switch (side) {
      UISheetSide.bottom => BorderRadius.vertical(
        top: Radius.circular(borderRadius),
      ),
      UISheetSide.top => BorderRadius.vertical(
        bottom: Radius.circular(borderRadius),
      ),
      UISheetSide.left => BorderRadius.horizontal(
        right: Radius.circular(borderRadius),
      ),
      UISheetSide.right => BorderRadius.horizontal(
        left: Radius.circular(borderRadius),
      ),
    };
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final bg = backgroundColor ?? scheme.surface;
    final effectiveWidth =
        width ??
        (side == UISheetSide.left || side == UISheetSide.right ? 320.0 : null);
    final effectiveHeight =
        height ??
        (side == UISheetSide.bottom || side == UISheetSide.top ? null : null);

    Widget content = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (showDragHandle && side == UISheetSide.bottom)
          const Center(child: UISheetDragHandle()),
        if (title != null) ...[
          UIText(
            title!,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 12),
        ],
        child,
      ],
    );

    content = Padding(padding: padding, child: content);

    final sizedContent = SafeArea(
      top: side != UISheetSide.top,
      bottom: side != UISheetSide.bottom,
      left: side != UISheetSide.left,
      right: side != UISheetSide.right,
      child: SizedBox(
        width: effectiveWidth,
        height: effectiveHeight,
        child: content,
      ),
    );

    if (glass) {
      return UIGlassSurface(
        theme: glassTheme,
        blur: blur,
        tintOpacity: tintOpacity,
        gradient: gradient,
        borderRadiusGeometry: _radius,
        width: effectiveWidth,
        height: effectiveHeight,
        child: sizedContent,
      );
    }

    return Material(
      color: bg,
      elevation: 8,
      borderRadius: _radius,
      clipBehavior: Clip.antiAlias,
      child: sizedContent,
    );
  }
}

/// Drag handle shown at the top of bottom sheets.
class UISheetDragHandle extends StatelessWidget {
  const UISheetDragHandle({
    super.key,
    this.width = 40,
    this.height = 4,
    this.margin = const EdgeInsets.symmetric(vertical: 10),
    this.color,
  });

  final double width;
  final double height;
  final EdgeInsetsGeometry margin;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      width: width,
      height: height,
      margin: margin,
      decoration: BoxDecoration(
        color: color ?? scheme.outlineVariant,
        borderRadius: BorderRadius.circular(99),
      ),
    );
  }
}
