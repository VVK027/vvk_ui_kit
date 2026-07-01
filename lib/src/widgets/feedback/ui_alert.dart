import 'package:flutter/material.dart';
import '../text/ui_text.dart';
import '../../../vvk_ui_kit.dart' show UIAlertDialog, UIAlertPanel;

/// Visual variants for [UIAlert].
enum UIAlertVariant { primary, destructive, info, warning }

/// Inline alert banner with optional icon, title, and description.
///
/// For modal dialogs use [UIAlertDialog] or [UIAlertPanel] instead.
class UIAlert extends StatelessWidget {
  const UIAlert({
    super.key,
    this.title,
    this.description,
    this.titleChild,
    this.descriptionChild,
    this.icon,
    this.variant = UIAlertVariant.primary,
    this.backgroundColor,
    this.foregroundColor,
    this.borderColor,
    this.iconColor,
    this.padding = const EdgeInsets.all(16),
    this.borderRadius = 12,
    this.trailing,
  }) : assert(
         titleChild != null || title != null,
         'Either title or titleChild must be provided.',
       );

  const UIAlert.destructive({
    super.key,
    this.title,
    this.description,
    this.titleChild,
    this.descriptionChild,
    this.icon,
    this.backgroundColor,
    this.foregroundColor,
    this.borderColor,
    this.iconColor,
    this.padding = const EdgeInsets.all(16),
    this.borderRadius = 12,
    this.trailing,
  }) : variant = UIAlertVariant.destructive,
       assert(
         titleChild != null || title != null,
         'Either title or titleChild must be provided.',
       );

  const UIAlert.info({
    super.key,
    this.title,
    this.description,
    this.titleChild,
    this.descriptionChild,
    this.icon,
    this.backgroundColor,
    this.foregroundColor,
    this.borderColor,
    this.iconColor,
    this.padding = const EdgeInsets.all(16),
    this.borderRadius = 12,
    this.trailing,
  }) : variant = UIAlertVariant.info,
       assert(
         titleChild != null || title != null,
         'Either title or titleChild must be provided.',
       );

  const UIAlert.warning({
    super.key,
    this.title,
    this.description,
    this.titleChild,
    this.descriptionChild,
    this.icon,
    this.backgroundColor,
    this.foregroundColor,
    this.borderColor,
    this.iconColor,
    this.padding = const EdgeInsets.all(16),
    this.borderRadius = 12,
    this.trailing,
  }) : variant = UIAlertVariant.warning,
       assert(
         titleChild != null || title != null,
         'Either title or titleChild must be provided.',
       );

  final String? title;
  final String? description;
  final Widget? titleChild;
  final Widget? descriptionChild;
  final Widget? icon;
  final UIAlertVariant variant;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final Color? borderColor;
  final Color? iconColor;
  final EdgeInsetsGeometry padding;
  final double borderRadius;
  final Widget? trailing;

  UIAlert copyWith({
    Key? key,
    String? title,
    String? description,
    Widget? titleChild,
    Widget? descriptionChild,
    Widget? icon,
    UIAlertVariant? variant,
    Color? backgroundColor,
    Color? foregroundColor,
    Color? borderColor,
    Color? iconColor,
    EdgeInsetsGeometry? padding,
    double? borderRadius,
    Widget? trailing,
  }) {
    return UIAlert(
      key: key ?? this.key,
      title: title ?? this.title,
      description: description ?? this.description,
      titleChild: titleChild ?? this.titleChild,
      descriptionChild: descriptionChild ?? this.descriptionChild,
      icon: icon ?? this.icon,
      variant: variant ?? this.variant,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      foregroundColor: foregroundColor ?? this.foregroundColor,
      borderColor: borderColor ?? this.borderColor,
      iconColor: iconColor ?? this.iconColor,
      padding: padding ?? this.padding,
      borderRadius: borderRadius ?? this.borderRadius,
      trailing: trailing ?? this.trailing,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final colors = _resolveColors(scheme);

    final titleWidget =
        titleChild ??
        UIText(
          title!,
          style: theme.textTheme.titleSmall?.copyWith(
            color: colors.$2,
            fontWeight: FontWeight.w600,
          ),
        );

    final descriptionWidget =
        descriptionChild ??
        (description == null
            ? null
            : UIText(
                description!,
                style: theme.textTheme.bodySmall?.copyWith(color: colors.$2),
              ));

    final effectiveIcon =
        icon ?? Icon(_defaultIcon(), color: iconColor ?? colors.$3, size: 20);

    return Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: colors.$1,
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(color: colors.$4),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(padding: const EdgeInsets.only(top: 2), child: effectiveIcon),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                titleWidget,
                if (descriptionWidget != null) ...[
                  const SizedBox(height: 4),
                  descriptionWidget,
                ],
              ],
            ),
          ),
          if (trailing != null) ...[const SizedBox(width: 8), trailing!],
        ],
      ),
    );
  }

  IconData _defaultIcon() {
    return switch (variant) {
      UIAlertVariant.primary => Icons.info_outline,
      UIAlertVariant.destructive => Icons.error_outline,
      UIAlertVariant.info => Icons.info_outline,
      UIAlertVariant.warning => Icons.warning_amber_outlined,
    };
  }

  (Color bg, Color fg, Color icon, Color border) _resolveColors(
    ColorScheme scheme,
  ) {
    return switch (variant) {
      UIAlertVariant.primary => (
        backgroundColor ?? scheme.primaryContainer.withValues(alpha: 0.45),
        foregroundColor ?? scheme.onSurface,
        iconColor ?? scheme.primary,
        borderColor ?? scheme.primary.withValues(alpha: 0.25),
      ),
      UIAlertVariant.destructive => (
        backgroundColor ?? scheme.errorContainer.withValues(alpha: 0.45),
        foregroundColor ?? scheme.onSurface,
        iconColor ?? scheme.error,
        borderColor ?? scheme.error.withValues(alpha: 0.3),
      ),
      UIAlertVariant.info => (
        backgroundColor ?? scheme.surfaceContainerHighest,
        foregroundColor ?? scheme.onSurface,
        iconColor ?? scheme.primary,
        borderColor ?? scheme.outlineVariant,
      ),
      UIAlertVariant.warning => (
        backgroundColor ?? const Color(0xFFFFF7ED),
        foregroundColor ?? const Color(0xFF9A3412),
        iconColor ?? const Color(0xFFEA580C),
        borderColor ?? const Color(0xFFFDBA74),
      ),
    };
  }
}
