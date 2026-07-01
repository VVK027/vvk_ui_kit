import 'package:flutter/material.dart';
import '../../core/theme/ui_theme.dart';
import '../text/ui_text.dart';

/// Centered info banner for detail screens.
class UIDetailInfoBanner extends StatelessWidget {
  const UIDetailInfoBanner({super.key, this.text, this.textChild})
    : assert(
        textChild != null || text != null,
        'Either text or textChild must be provided.',
      );

  final String? text;
  final Widget? textChild;

  UIDetailInfoBanner copyWith({Key? key, String? text, Widget? textChild}) {
    return UIDetailInfoBanner(
      key: key ?? this.key,
      text: text ?? this.text,
      textChild: textChild ?? this.textChild,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ext = context.uiTheme;
    final textWidget =
        textChild ??
        UIText(
          text!,
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: ext.subtitleColor,
            height: 1.4,
          ),
        );

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 4),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.primary.withValues(alpha: 0.12),
        ),
      ),
      child: textWidget,
    );
  }
}

/// Rounded card grouping settings rows with consistent padding.
class UISettingsSectionCard extends StatelessWidget {
  const UISettingsSectionCard({
    super.key,
    required this.children,
    this.margin = const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
  });

  final List<Widget> children;
  final EdgeInsetsGeometry margin;

  UISettingsSectionCard copyWith({
    Key? key,
    List<Widget>? children,
    EdgeInsetsGeometry? margin,
  }) {
    return UISettingsSectionCard(
      key: key ?? this.key,
      margin: margin ?? this.margin,
      children: children ?? this.children,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      margin: margin,
      elevation: theme.brightness == Brightness.dark ? 0 : 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: theme.dividerColor.withValues(alpha: 0.5)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var i = 0; i < children.length; i++) ...[
            if (i > 0) Divider(height: 1, color: theme.dividerColor),
            children[i],
          ],
        ],
      ),
    );
  }
}
