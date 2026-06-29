import 'package:flutter/material.dart';
import 'package:vvk_ui_kit/src/widgets/display/ui_icon_badge.dart';
import 'package:vvk_ui_kit/src/widgets/text/ui_text.dart';

/// List tile with icon badge, title, value line, and optional trailing text.
class UIMetricListTile extends StatelessWidget {
  const UIMetricListTile({
    super.key,
    this.title,
    this.valueLine,
    this.trailingText,
    this.titleChild,
    this.valueLineChild,
    this.trailingTextChild,
    required this.icon,
    this.accentColor,
    this.onTap,
  }) : assert(
         titleChild != null || title != null,
         'Either title or titleChild must be provided.',
       ),
       assert(
         valueLineChild != null || valueLine != null,
         'Either valueLine or valueLineChild must be provided.',
       );

  final Widget icon;
  final String? title;
  final String? valueLine;
  final String? trailingText;
  final Widget? titleChild;
  final Widget? valueLineChild;
  final Widget? trailingTextChild;
  final Color? accentColor;
  final VoidCallback? onTap;

  UIMetricListTile copyWith({
    Key? key,
    Widget? icon,
    String? title,
    String? valueLine,
    String? trailingText,
    Widget? titleChild,
    Widget? valueLineChild,
    Widget? trailingTextChild,
    Color? accentColor,
    VoidCallback? onTap,
  }) {
    return UIMetricListTile(
      key: key ?? this.key,
      icon: icon ?? this.icon,
      title: title ?? this.title,
      valueLine: valueLine ?? this.valueLine,
      trailingText: trailingText ?? this.trailingText,
      titleChild: titleChild ?? this.titleChild,
      valueLineChild: valueLineChild ?? this.valueLineChild,
      trailingTextChild: trailingTextChild ?? this.trailingTextChild,
      accentColor: accentColor ?? this.accentColor,
      onTap: onTap ?? this.onTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final accent = accentColor ?? theme.colorScheme.primary;
    final titleWidget =
        titleChild ??
        UIText(
          title!,
          maxLines: 1,
          textOverflow: TextOverflow.ellipsis,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        );
    final valueWidget =
        valueLineChild ??
        UIText(
          valueLine!,
          maxLines: 1,
          textOverflow: TextOverflow.ellipsis,
          style: theme.textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        );
    final trailingWidget =
        trailingTextChild ??
        (trailingText != null && trailingText!.isNotEmpty
            ? UIText(
                trailingText!,
                maxLines: 1,
                textOverflow: TextOverflow.ellipsis,
                textAlign: TextAlign.end,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.55),
                ),
              )
            : null);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Row(
            children: [
              UIIconBadge(icon: icon, accentColor: accent, size: 48),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(child: titleWidget),
                        Icon(
                          Icons.chevron_right_rounded,
                          color: theme.colorScheme.onSurface.withValues(
                            alpha: 0.45,
                          ),
                          size: 22,
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Expanded(child: valueWidget),
                        if (trailingWidget != null) ...[
                          const SizedBox(width: 8),
                          ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 108),
                            child: trailingWidget,
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
