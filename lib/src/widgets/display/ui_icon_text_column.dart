import 'package:flutter/material.dart';
import 'package:vvk_ui_kit/src/widgets/text/ui_text.dart';

/// Vertically stacked icon with primary and secondary text labels.
class UIIconTextColumn extends StatelessWidget {
  const UIIconTextColumn({
    super.key,
    required this.icon,
    this.mainTitle,
    this.titleChild,
    this.subTitle,
    this.subtitleChild,
  }) : assert(
         titleChild != null || mainTitle != null,
         'Either mainTitle or titleChild must be provided.',
       ),
       assert(
         subtitleChild != null || subTitle != null,
         'Either subTitle or subtitleChild must be provided.',
       );

  final Widget icon;
  final String? mainTitle;
  final Widget? titleChild;
  final String? subTitle;
  final Widget? subtitleChild;

  UIIconTextColumn copyWith({
    Key? key,
    Widget? icon,
    String? mainTitle,
    Widget? titleChild,
    String? subTitle,
    Widget? subtitleChild,
  }) {
    return UIIconTextColumn(
      key: key ?? this.key,
      icon: icon ?? this.icon,
      mainTitle: mainTitle ?? this.mainTitle,
      titleChild: titleChild ?? this.titleChild,
      subTitle: subTitle ?? this.subTitle,
      subtitleChild: subtitleChild ?? this.subtitleChild,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;
    final titleWidget =
        titleChild ??
        UIText(
          mainTitle!,
          maxLines: 1,
          textOverflow: TextOverflow.ellipsis,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        );
    final subtitleWidget =
        subtitleChild ??
        UIText(
          subTitle!,
          style: theme.textTheme.labelSmall?.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.55),
          ),
        );

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          alignment: Alignment.center,
          child: icon,
        ),
        const SizedBox(height: 6),
        titleWidget,
        subtitleWidget,
      ],
    );
  }
}
