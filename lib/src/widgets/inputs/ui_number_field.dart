import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vvk_ui_kit/src/widgets/text/ui_text.dart';

/// Numeric input with increment/decrement stepper buttons.
class UINumberField extends StatefulWidget {
  const UINumberField({
    super.key,
    required this.value,
    this.onChanged,
    this.min,
    this.max,
    this.step = 1,
    this.label,
    this.enabled = true,
    this.decimalPlaces = 0,
    this.spacing = 8,
    this.buttonSize = 40,
    this.backgroundColor,
    this.borderColor,
    this.textStyle,
    this.decrementTooltip = 'Decrease',
    this.incrementTooltip = 'Increase',
  }) : assert(step > 0, 'step must be positive');

  final num value;
  final ValueChanged<num>? onChanged;
  final num? min;
  final num? max;
  final num step;
  final String? label;
  final bool enabled;
  final int decimalPlaces;
  final double spacing;
  final double buttonSize;
  final Color? backgroundColor;
  final Color? borderColor;
  final TextStyle? textStyle;

  /// Tooltip / semantic label for the decrement (−) button.
  final String decrementTooltip;

  /// Tooltip / semantic label for the increment (+) button.
  final String incrementTooltip;

  factory UINumberField.fromTheme(
    BuildContext context, {
    Key? key,
    required num value,
    ValueChanged<num>? onChanged,
    num? min,
    num? max,
    num step = 1,
    String? label,
    bool enabled = true,
    int decimalPlaces = 0,
    double spacing = 8,
    double buttonSize = 40,
    Color? backgroundColor,
    Color? borderColor,
    TextStyle? textStyle,
    String decrementTooltip = 'Decrease',
    String incrementTooltip = 'Increase',
  }) {
    final scheme = Theme.of(context).colorScheme;
    final theme = Theme.of(context);
    return UINumberField(
      key: key,
      value: value,
      onChanged: onChanged,
      min: min,
      max: max,
      step: step,
      label: label,
      enabled: enabled,
      decimalPlaces: decimalPlaces,
      spacing: spacing,
      buttonSize: buttonSize,
      backgroundColor: backgroundColor ?? scheme.surfaceContainerHighest,
      borderColor: borderColor ?? scheme.outlineVariant,
      textStyle: textStyle ?? theme.textTheme.bodyLarge,
      decrementTooltip: decrementTooltip,
      incrementTooltip: incrementTooltip,
    );
  }

  @override
  State<UINumberField> createState() => _UINumberFieldState();
}

class _UINumberFieldState extends State<UINumberField> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: _format(widget.value));
  }

  @override
  void didUpdateWidget(UINumberField oldWidget) {
    super.didUpdateWidget(oldWidget);
    final formatted = _format(widget.value);
    if (_controller.text != formatted) {
      _controller.text = formatted;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _format(num value) {
    if (widget.decimalPlaces <= 0) {
      return value.round().toString();
    }
    return value.toStringAsFixed(widget.decimalPlaces);
  }

  num _parse(String text) {
    final parsed = num.tryParse(text.trim());
    return parsed ?? widget.value;
  }

  num _clamp(num value) {
    var result = value;
    if (widget.min != null) {
      result = result < widget.min! ? widget.min! : result;
    }
    if (widget.max != null) {
      result = result > widget.max! ? widget.max! : result;
    }
    return result;
  }

  void _commit(num next) {
    final clamped = _clamp(next);
    final formatted = _format(clamped);
    if (_controller.text != formatted) {
      _controller.text = formatted;
    }
    if (clamped != widget.value) {
      widget.onChanged?.call(clamped);
    }
  }

  void _step(num delta) {
    if (!widget.enabled) return;
    _commit(widget.value + delta);
  }

  void _onSubmitted(String text) {
    _commit(_parse(text));
  }

  bool get _canDecrement {
    if (!widget.enabled) return false;
    if (widget.min == null) return true;
    return widget.value - widget.step >= widget.min!;
  }

  bool get _canIncrement {
    if (!widget.enabled) return false;
    if (widget.max == null) return true;
    return widget.value + widget.step <= widget.max!;
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    final field = DecoratedBox(
      decoration: BoxDecoration(
        color: widget.backgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: widget.borderColor!),
      ),
      child: Row(
        children: [
          _StepperButton(
            icon: Icons.remove,
            tooltip: widget.decrementTooltip,
            size: widget.buttonSize,
            enabled: _canDecrement,
            onPressed: () => _step(-widget.step),
          ),
          Expanded(
            child: TextField(
              controller: _controller,
              enabled: widget.enabled,
              keyboardType: TextInputType.numberWithOptions(
                decimal: widget.decimalPlaces > 0,
              ),
              textAlign: TextAlign.center,
              style: widget.textStyle,
              inputFormatters: [
                FilteringTextInputFormatter.allow(
                  RegExp(
                    widget.decimalPlaces > 0 ? r'^\d*\.?\d*$' : r'^\d*$',
                  ),
                ),
              ],
              decoration: const InputDecoration(
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.symmetric(horizontal: 8),
              ),
              onSubmitted: _onSubmitted,
              onEditingComplete: () => _onSubmitted(_controller.text),
            ),
          ),
          _StepperButton(
            icon: Icons.add,
            tooltip: widget.incrementTooltip,
            size: widget.buttonSize,
            enabled: _canIncrement,
            onPressed: () => _step(widget.step),
          ),
        ],
      ),
    );

    if (widget.label == null) {
      return field;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        UIText(
          widget.label!,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
            color: scheme.onSurfaceVariant,
          ),
        ),
        SizedBox(height: widget.spacing),
        field,
      ],
    );
  }
}

class _StepperButton extends StatelessWidget {
  const _StepperButton({
    required this.icon,
    required this.size,
    required this.enabled,
    required this.onPressed,
    this.tooltip,
  });

  final IconData icon;
  final double size;
  final bool enabled;
  final VoidCallback onPressed;
  final String? tooltip;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return SizedBox(
      width: size,
      height: size,
      child: IconButton(
        padding: EdgeInsets.zero,
        tooltip: tooltip,
        onPressed: enabled ? onPressed : null,
        icon: Icon(
          icon,
          color: enabled ? scheme.onSurface : scheme.onSurface.withValues(
            alpha: 0.38,
          ),
        ),
      ),
    );
  }
}
