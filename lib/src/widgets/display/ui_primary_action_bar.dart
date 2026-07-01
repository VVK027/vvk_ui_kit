import 'package:flutter/material.dart';
import '../text/ui_text.dart';

/// Full-width accent action button pinned to the bottom of a screen or sheet.
class UIPrimaryActionBar extends StatelessWidget {
  const UIPrimaryActionBar({
    super.key,
    required this.accentColor,
    this.label,
    this.labelChild,
    required this.onPressed,
    this.enabled = true,
  }) : assert(
         labelChild != null || label != null,
         'Either label or labelChild must be provided.',
       );

  final Color accentColor;
  final String? label;
  final Widget? labelChild;
  final VoidCallback? onPressed;
  final bool enabled;

  UIPrimaryActionBar copyWith({
    Key? key,
    Color? accentColor,
    String? label,
    Widget? labelChild,
    VoidCallback? onPressed,
    bool? enabled,
  }) {
    return UIPrimaryActionBar(
      key: key ?? this.key,
      accentColor: accentColor ?? this.accentColor,
      label: label ?? this.label,
      labelChild: labelChild ?? this.labelChild,
      onPressed: onPressed ?? this.onPressed,
      enabled: enabled ?? this.enabled,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final onAccent = accentColor.computeLuminance() > 0.4
        ? Colors.black87
        : Colors.white;
    final labelWidget =
        labelChild ??
        UIText(
          label!,
          size: 16,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.2,
        );

    return Material(
      color: theme.scaffoldBackgroundColor,
      elevation: 0,
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
          child: SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: enabled ? onPressed : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: accentColor,
                foregroundColor: onAccent,
                disabledBackgroundColor: accentColor.withValues(alpha: 0.45),
                disabledForegroundColor: onAccent.withValues(alpha: 0.7),
                elevation: enabled ? 2 : 0,
                shadowColor: accentColor.withValues(alpha: 0.35),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(26),
                ),
                textStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.2,
                ),
              ),
              child: labelWidget,
            ),
          ),
        ),
      ),
    );
  }
}
