import 'package:flutter/material.dart';
import 'package:vvk_ui_kit/src/widgets/text/ui_text.dart';

/// Controller for a [UIRadioGroup].
class UIRadioGroupController<T> extends ValueNotifier<T?> {
  UIRadioGroupController([super.value]);
}

/// Groups [UIRadio] widgets and manages the selected value.
class UIRadioGroup<T> extends StatelessWidget {
  const UIRadioGroup({
    super.key,
    required this.value,
    required this.onChanged,
    required this.children,
    this.axis = Axis.vertical,
    this.spacing = 8,
    this.enabled = true,
  }) : controller = null;

  const UIRadioGroup.controller({
    super.key,
    required this.controller,
    required this.children,
    this.axis = Axis.vertical,
    this.spacing = 8,
    this.enabled = true,
  }) : value = null,
       onChanged = null;

  final T? value;
  final ValueChanged<T?>? onChanged;
  final UIRadioGroupController<T>? controller;
  final List<Widget> children;
  final Axis axis;
  final double spacing;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    if (controller != null) {
      return ValueListenableBuilder<T?>(
        valueListenable: controller!,
        builder: (context, selected, _) {
          return _UIRadioGroupScope<T>(
            groupValue: selected,
            onChanged: enabled ? (value) => controller!.value = value : null,
            enabled: enabled,
            child: _buildFlex(),
          );
        },
      );
    }

    return _UIRadioGroupScope<T>(
      groupValue: value,
      onChanged: enabled ? onChanged : null,
      enabled: enabled,
      child: _buildFlex(),
    );
  }

  Widget _buildFlex() {
    final separated = <Widget>[];
    for (var i = 0; i < children.length; i++) {
      separated.add(children[i]);
      if (i < children.length - 1) {
        separated.add(
          axis == Axis.vertical
              ? SizedBox(height: spacing)
              : SizedBox(width: spacing),
        );
      }
    }

    return Flex(
      direction: axis,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: separated,
    );
  }
}

class _UIRadioGroupScope<T> extends InheritedWidget {
  const _UIRadioGroupScope({
    required this.groupValue,
    required this.onChanged,
    required this.enabled,
    required super.child,
  });

  final T? groupValue;
  final ValueChanged<T?>? onChanged;
  final bool enabled;

  static _UIRadioGroupScope<T>? maybeOf<T>(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<_UIRadioGroupScope<T>>();
  }

  @override
  bool updateShouldNotify(_UIRadioGroupScope<T> oldWidget) {
    return groupValue != oldWidget.groupValue ||
        onChanged != oldWidget.onChanged ||
        enabled != oldWidget.enabled;
  }
}

/// A single radio option, typically used inside [UIRadioGroup].
class UIRadio<T> extends StatelessWidget {
  const UIRadio({
    super.key,
    required this.value,
    this.label,
    this.labelChild,
    this.groupValue,
    this.onChanged,
    this.enabled = true,
    this.activeColor,
    this.labelStyle,
    this.spacing = 8,
    this.size = 20,
  }) : assert(
         label == null || labelChild == null,
         'Provide only one of label or labelChild.',
       );

  final T value;
  final String? label;
  final Widget? labelChild;
  final T? groupValue;
  final ValueChanged<T?>? onChanged;
  final bool enabled;
  final Color? activeColor;
  final TextStyle? labelStyle;
  final double spacing;
  final double size;

  @override
  Widget build(BuildContext context) {
    final scope = _UIRadioGroupScope.maybeOf<T>(context);
    final effectiveGroupValue = groupValue ?? scope?.groupValue;
    final effectiveOnChanged = onChanged ?? scope?.onChanged;
    final isEnabled = enabled && (scope?.enabled ?? true);
    final selected = effectiveGroupValue == value;
    final theme = Theme.of(context);
    final color = activeColor ?? theme.colorScheme.primary;

    Widget radio = _UIRadioIndicator(
      selected: selected,
      enabled: isEnabled,
      activeColor: color,
      size: size,
      onTap: isEnabled && effectiveOnChanged != null
          ? () => effectiveOnChanged(value)
          : null,
    );

    final labelWidget =
        labelChild ??
        (label == null
            ? null
            : UIText(label!, style: labelStyle ?? theme.textTheme.bodyMedium));

    if (labelWidget == null) return radio;

    return InkWell(
      onTap: isEnabled && effectiveOnChanged != null
          ? () => effectiveOnChanged(value)
          : null,
      borderRadius: BorderRadius.circular(8),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          radio,
          SizedBox(width: spacing),
          Flexible(child: labelWidget),
        ],
      ),
    );
  }
}

class _UIRadioIndicator extends StatelessWidget {
  const _UIRadioIndicator({
    required this.selected,
    required this.enabled,
    required this.activeColor,
    required this.size,
    this.onTap,
  });

  final bool selected;
  final bool enabled;
  final Color activeColor;
  final double size;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final borderColor = enabled
        ? (selected ? activeColor : theme.colorScheme.outline)
        : theme.colorScheme.outline.withValues(alpha: 0.4);

    final indicator = AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: borderColor, width: 2),
      ),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        width: selected ? size * 0.5 : 0,
        height: selected ? size * 0.5 : 0,
        decoration: BoxDecoration(
          color: enabled ? activeColor : activeColor.withValues(alpha: 0.4),
          shape: BoxShape.circle,
        ),
      ),
    );

    if (onTap == null) return indicator;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: indicator,
    );
  }
}
