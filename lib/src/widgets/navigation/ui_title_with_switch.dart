import 'package:flutter/material.dart';
import 'package:vvk_ui_kit/src/widgets/text/ui_text.dart';

/// Settings row with a title and trailing [Switch].
class UITitleWithSwitch extends StatefulWidget {
  final String? title;
  final Widget? titleChild;
  final Color? textColor;
  final bool? isSwitchEnabled;
  final Widget? subTitleWidget;
  final EdgeInsets? padding;
  final ValueChanged<bool>? handleSwitchState;
  final bool maintainState;
  final Color? borderColor;
  final Color activeSwitchColor;
  final Color inactiveSwitchColor;
  final Color titleColor;

  const UITitleWithSwitch(
    this.title, {
    super.key,
    this.titleChild,
    this.padding,
    this.isSwitchEnabled,
    this.handleSwitchState,
    this.subTitleWidget,
    this.textColor,
    this.maintainState = true,
    this.borderColor,
    required this.activeSwitchColor,
    required this.inactiveSwitchColor,
    required this.titleColor,
  }) : assert(
         titleChild != null || title != null,
         'Either title or titleChild must be provided.',
       );

  /// Creates a [UITitleWithSwitch] with colors derived from [Theme.of(context)].
  factory UITitleWithSwitch.fromTheme(
    BuildContext context,
    String title, {
    Key? key,
    Widget? titleChild,
    EdgeInsets? padding,
    bool? isSwitchEnabled,
    Widget? subTitleWidget,
    Color? textColor,
    ValueChanged<bool>? handleSwitchState,
    bool maintainState = true,
    Color? borderColor,
    Color? activeSwitchColor,
    Color? inactiveSwitchColor,
    Color? titleColor,
  }) {
    final scheme = Theme.of(context).colorScheme;
    return UITitleWithSwitch(
      title,
      key: key,
      titleChild: titleChild,
      padding: padding,
      isSwitchEnabled: isSwitchEnabled,
      handleSwitchState: handleSwitchState,
      subTitleWidget: subTitleWidget,
      textColor: textColor,
      maintainState: maintainState,
      borderColor: borderColor,
      activeSwitchColor: activeSwitchColor ?? scheme.primary,
      inactiveSwitchColor: inactiveSwitchColor ?? scheme.outlineVariant,
      titleColor: titleColor ?? scheme.onSurface,
    );
  }

  UITitleWithSwitch copyWith({
    Key? key,
    String? title,
    Widget? titleChild,
    Color? textColor,
    bool? isSwitchEnabled,
    Widget? subTitleWidget,
    EdgeInsets? padding,
    ValueChanged<bool>? handleSwitchState,
    bool? maintainState,
    Color? borderColor,
    Color? activeSwitchColor,
    Color? inactiveSwitchColor,
    Color? titleColor,
  }) {
    return UITitleWithSwitch(
      title ?? this.title,
      key: key ?? this.key,
      titleChild: titleChild ?? this.titleChild,
      textColor: textColor ?? this.textColor,
      isSwitchEnabled: isSwitchEnabled ?? this.isSwitchEnabled,
      subTitleWidget: subTitleWidget ?? this.subTitleWidget,
      padding: padding ?? this.padding,
      handleSwitchState: handleSwitchState ?? this.handleSwitchState,
      maintainState: maintainState ?? this.maintainState,
      borderColor: borderColor ?? this.borderColor,
      activeSwitchColor: activeSwitchColor ?? this.activeSwitchColor,
      inactiveSwitchColor: inactiveSwitchColor ?? this.inactiveSwitchColor,
      titleColor: titleColor ?? this.titleColor,
    );
  }

  @override
  State<UITitleWithSwitch> createState() => _UITitleWithSwitchState();
}

class _UITitleWithSwitchState extends State<UITitleWithSwitch> {
  late bool _switchState;

  @override
  void initState() {
    super.initState();
    _switchState = widget.isSwitchEnabled ?? false;
  }

  @override
  void didUpdateWidget(covariant UITitleWithSwitch oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!widget.maintainState &&
        widget.isSwitchEnabled != oldWidget.isSwitchEnabled) {
      _switchState = widget.isSwitchEnabled ?? false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final value = widget.maintainState
        ? _switchState
        : (widget.isSwitchEnabled ?? false);
    final titleWidget =
        widget.titleChild ??
        UIText(
          widget.title!,
          size: 16,
          color: widget.textColor ?? widget.titleColor,
          fontWeight: FontWeight.w600,
          textAlign: TextAlign.left,
          maxLines: 10,
        );

    return Container(
      padding: widget.padding ?? EdgeInsets.zero,
      decoration: BoxDecoration(
        border: widget.borderColor != null
            ? Border(bottom: BorderSide(color: widget.borderColor!))
            : null,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: titleWidget),
              Transform.scale(
                scale: 0.8,
                child: Switch.adaptive(
                  value: value,
                  activeTrackColor: widget.activeSwitchColor,
                  inactiveTrackColor: widget.inactiveSwitchColor,
                  onChanged: (nextValue) {
                    if (widget.maintainState) {
                      setState(() => _switchState = nextValue);
                    }
                    widget.handleSwitchState?.call(nextValue);
                  },
                ),
              ),
            ],
          ),
          widget.subTitleWidget ?? const SizedBox(),
        ],
      ),
    );
  }
}
