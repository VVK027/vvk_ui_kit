import 'package:flutter/material.dart';
import 'package:vvk_ui_kit/src/widgets/display/ui_icon_badge.dart';
import 'package:vvk_ui_kit/src/widgets/text/ui_text.dart';

/// On/off status chip for settings rows.
class UISettingsStatusChip extends StatelessWidget {
  const UISettingsStatusChip({
    super.key,
    required this.isOn,
    required this.onLabel,
    required this.offLabel,
  });

  final bool isOn;
  final String onLabel;
  final String offLabel;

  UISettingsStatusChip copyWith({
    Key? key,
    bool? isOn,
    String? onLabel,
    String? offLabel,
  }) {
    return UISettingsStatusChip(
      key: key ?? this.key,
      isOn: isOn ?? this.isOn,
      onLabel: onLabel ?? this.onLabel,
      offLabel: offLabel ?? this.offLabel,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = isOn ? theme.colorScheme.primary : theme.colorScheme.outline;
    return UIText(
      '(${isOn ? onLabel : offLabel})',
      style: theme.textTheme.labelLarge?.copyWith(
        fontWeight: FontWeight.w700,
        color: color,
      ),
    );
  }
}

/// Settings row that navigates to a sub-screen when tapped.
class UISettingsNavigationTile extends StatelessWidget {
  const UISettingsNavigationTile({
    super.key,
    this.title,
    this.titleChild,
    this.subtitle,
    this.subtitleChild,
    this.leading,
    this.trailing,
    this.statusChip,
    this.onTap,
    this.enabled = true,
  }) : assert(
         titleChild != null || title != null,
         'Either title or titleChild must be provided.',
       );

  final String? title;
  final Widget? titleChild;
  final String? subtitle;
  final Widget? subtitleChild;
  final Widget? leading;
  final Widget? trailing;
  final Widget? statusChip;
  final VoidCallback? onTap;
  final bool enabled;

  UISettingsNavigationTile copyWith({
    Key? key,
    String? title,
    Widget? titleChild,
    String? subtitle,
    Widget? subtitleChild,
    Widget? leading,
    Widget? trailing,
    Widget? statusChip,
    VoidCallback? onTap,
    bool? enabled,
  }) {
    return UISettingsNavigationTile(
      key: key ?? this.key,
      title: title ?? this.title,
      titleChild: titleChild ?? this.titleChild,
      subtitle: subtitle ?? this.subtitle,
      subtitleChild: subtitleChild ?? this.subtitleChild,
      leading: leading ?? this.leading,
      trailing: trailing ?? this.trailing,
      statusChip: statusChip ?? this.statusChip,
      onTap: onTap ?? this.onTap,
      enabled: enabled ?? this.enabled,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final onSurface = theme.colorScheme.onSurface;
    final muted = onSurface.withValues(alpha: 0.62);
    final leadingWidget = leading ?? const SizedBox.shrink();
    final titleWidget =
        titleChild ??
        UIText(
          title!,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: enabled ? onSurface : theme.disabledColor,
          ),
        );

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: enabled ? onTap : null,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              leadingWidget,
              if (leading != null) const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(child: titleWidget),
                        if (statusChip != null) ...[
                          const SizedBox(width: 6),
                          statusChip!,
                        ],
                      ],
                    ),
                    if (subtitleChild != null ||
                        (subtitle != null && subtitle!.isNotEmpty)) ...[
                      const SizedBox(height: 4),
                      subtitleChild ??
                          UIText(
                            subtitle!,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: enabled ? muted : theme.disabledColor,
                              height: 1.35,
                            ),
                          ),
                    ],
                  ],
                ),
              ),
              trailing ??
                  Icon(
                    Icons.chevron_right_rounded,
                    size: 22,
                    color: onSurface.withValues(alpha: 0.38),
                  ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Settings row with a trailing switch for boolean preferences.
class UISettingsSwitchTile extends StatelessWidget {
  const UISettingsSwitchTile({
    super.key,
    this.title,
    this.titleChild,
    this.subtitle,
    this.subtitleChild,
    this.leading,
    required this.value,
    required this.onChanged,
    this.onTap,
    this.enabled = true,
  }) : assert(
         titleChild != null || title != null,
         'Either title or titleChild must be provided.',
       );

  final String? title;
  final Widget? titleChild;
  final String? subtitle;
  final Widget? subtitleChild;
  final Widget? leading;
  final bool value;
  final ValueChanged<bool>? onChanged;
  final VoidCallback? onTap;
  final bool enabled;

  UISettingsSwitchTile copyWith({
    Key? key,
    String? title,
    Widget? titleChild,
    String? subtitle,
    Widget? subtitleChild,
    Widget? leading,
    bool? value,
    ValueChanged<bool>? onChanged,
    VoidCallback? onTap,
    bool? enabled,
  }) {
    return UISettingsSwitchTile(
      key: key ?? this.key,
      title: title ?? this.title,
      titleChild: titleChild ?? this.titleChild,
      subtitle: subtitle ?? this.subtitle,
      subtitleChild: subtitleChild ?? this.subtitleChild,
      leading: leading ?? this.leading,
      value: value ?? this.value,
      onChanged: onChanged ?? this.onChanged,
      onTap: onTap ?? this.onTap,
      enabled: enabled ?? this.enabled,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final onSurface = theme.colorScheme.onSurface;
    final muted = onSurface.withValues(alpha: 0.62);
    final lead = leading;
    final titleWidget =
        titleChild ??
        UIText(
          title!,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: enabled ? onSurface : theme.disabledColor,
          ),
        );

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: enabled ? onTap : null,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (lead != null) ...[lead, const SizedBox(width: 12)],
                  Expanded(child: titleWidget),
                  Switch.adaptive(
                    value: value,
                    onChanged: enabled ? onChanged : null,
                  ),
                ],
              ),
              if (subtitleChild != null ||
                  (subtitle != null && subtitle!.isNotEmpty)) ...[
                const SizedBox(height: 6),
                Padding(
                  padding: EdgeInsets.only(left: lead != null ? 52 : 0),
                  child:
                      subtitleChild ??
                      UIText(
                        subtitle!,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: enabled ? muted : theme.disabledColor,
                          height: 1.35,
                        ),
                      ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// Settings row that displays a time value and opens a picker on tap.
class UISettingsTimeTile extends StatelessWidget {
  const UISettingsTimeTile({
    super.key,
    required this.label,
    this.labelChild,
    required this.enabled,
    required this.timeText,
    this.timeChild,
    required this.onTap,
  }) : assert(
         labelChild != null || label != null,
         'Either label or labelChild must be provided.',
       ),
       assert(
         timeChild != null || timeText != null,
         'Either timeText or timeChild must be provided.',
       );

  final String? label;
  final Widget? labelChild;
  final bool enabled;
  final String? timeText;
  final Widget? timeChild;
  final VoidCallback onTap;

  UISettingsTimeTile copyWith({
    Key? key,
    String? label,
    Widget? labelChild,
    bool? enabled,
    String? timeText,
    Widget? timeChild,
    VoidCallback? onTap,
  }) {
    return UISettingsTimeTile(
      key: key ?? this.key,
      label: label ?? this.label,
      labelChild: labelChild ?? this.labelChild,
      enabled: enabled ?? this.enabled,
      timeText: timeText ?? this.timeText,
      timeChild: timeChild ?? this.timeChild,
      onTap: onTap ?? this.onTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final labelWidget =
        labelChild ??
        UIText(
          label!,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: enabled ? theme.colorScheme.onSurface : theme.disabledColor,
          ),
        );
    final timeWidget =
        timeChild ??
        UIText(
          timeText!,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w700,
            color: enabled ? theme.colorScheme.primary : theme.disabledColor,
          ),
        );

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: enabled ? onTap : null,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          child: Row(
            children: [
              Expanded(child: labelWidget),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: enabled
                      ? theme.colorScheme.primary.withValues(alpha: 0.1)
                      : theme.disabledColor.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: timeWidget,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Checkmark floating action button for saving settings changes.
class UISettingsSaveFab extends StatelessWidget {
  const UISettingsSaveFab({
    super.key,
    required this.onPressed,
    required this.tooltip,
  });

  final VoidCallback onPressed;
  final String tooltip;

  UISettingsSaveFab copyWith({
    Key? key,
    VoidCallback? onPressed,
    String? tooltip,
  }) {
    return UISettingsSaveFab(
      key: key ?? this.key,
      onPressed: onPressed ?? this.onPressed,
      tooltip: tooltip ?? this.tooltip,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return FloatingActionButton(
      onPressed: onPressed,
      tooltip: tooltip,
      backgroundColor: theme.colorScheme.primary,
      foregroundColor: theme.colorScheme.onPrimary,
      elevation: 4,
      child: const Icon(Icons.check_rounded),
    );
  }
}

/// Uppercase-style section heading for grouped settings rows.
class UISettingsSectionLabel extends StatelessWidget {
  const UISettingsSectionLabel({
    super.key,
    required this.label,
    this.labelChild,
  }) : assert(
         labelChild != null || label != null,
         'Either label or labelChild must be provided.',
       );

  final String? label;
  final Widget? labelChild;

  UISettingsSectionLabel copyWith({
    Key? key,
    String? label,
    Widget? labelChild,
  }) {
    return UISettingsSectionLabel(
      key: key ?? this.key,
      label: label ?? this.label,
      labelChild: labelChild ?? this.labelChild,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final labelWidget =
        labelChild ??
        UIText(
          label!,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w700,
            color: theme.colorScheme.primary,
            letterSpacing: 0.2,
          ),
        );

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
      child: labelWidget,
    );
  }
}

/// Builds a leading icon badge for settings navigation and switch tiles.
Widget settingsIconLeading(
  BuildContext context, {
  required Widget icon,
  double size = 44,
}) {
  return UIIconBadge(
    icon: icon,
    accentColor: Theme.of(context).colorScheme.primary,
    size: size,
  );
}

/// Builds a leading icon container from [IconData].
Widget settingsMaterialIconLeading(
  BuildContext context, {
  required IconData icon,
  Color? iconColor,
}) {
  final theme = Theme.of(context);
  final color = iconColor ?? theme.colorScheme.primary;
  return Container(
    width: 40,
    height: 40,
    decoration: BoxDecoration(
      color: color.withValues(alpha: 0.12),
      borderRadius: BorderRadius.circular(12),
    ),
    alignment: Alignment.center,
    child: Icon(icon, size: 22, color: color),
  );
}
