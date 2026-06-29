import 'package:flutter/material.dart';

/// Themed value [Slider] with kit defaults.
class UISlider extends StatelessWidget {
  const UISlider({
    super.key,
    required this.value,
    required this.onChanged,
    this.min = 0,
    this.max = 1,
    this.divisions,
    this.label,
    this.activeColor,
    this.inactiveColor,
    this.thumbColor,
    this.overlayColor,
    this.enabled = true,
  });

  final double value;
  final ValueChanged<double>? onChanged;
  final double min;
  final double max;
  final int? divisions;
  final String? label;
  final Color? activeColor;
  final Color? inactiveColor;
  final Color? thumbColor;
  final Color? overlayColor;
  final bool enabled;

  UISlider copyWith({
    Key? key,
    double? value,
    ValueChanged<double>? onChanged,
    double? min,
    double? max,
    int? divisions,
    String? label,
    Color? activeColor,
    Color? inactiveColor,
    Color? thumbColor,
    Color? overlayColor,
    bool? enabled,
  }) {
    return UISlider(
      key: key ?? this.key,
      value: value ?? this.value,
      onChanged: onChanged ?? this.onChanged,
      min: min ?? this.min,
      max: max ?? this.max,
      divisions: divisions ?? this.divisions,
      label: label ?? this.label,
      activeColor: activeColor ?? this.activeColor,
      inactiveColor: inactiveColor ?? this.inactiveColor,
      thumbColor: thumbColor ?? this.thumbColor,
      overlayColor: overlayColor ?? this.overlayColor,
      enabled: enabled ?? this.enabled,
    );
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final effectiveOnChanged = enabled ? onChanged : null;

    return SliderTheme(
      data: SliderTheme.of(context).copyWith(
        activeTrackColor: activeColor ?? scheme.primary,
        inactiveTrackColor: inactiveColor ?? scheme.surfaceContainerHighest,
        thumbColor: thumbColor ?? scheme.primary,
        overlayColor: (overlayColor ?? scheme.primary).withValues(alpha: 0.12),
        valueIndicatorColor: scheme.inverseSurface,
        valueIndicatorTextStyle: TextStyle(color: scheme.onInverseSurface),
      ),
      child: Slider(
        value: value.clamp(min, max),
        min: min,
        max: max,
        divisions: divisions,
        label: label,
        onChanged: effectiveOnChanged,
      ),
    );
  }
}

/// Themed [RangeSlider] with kit defaults.
class UIRangeSlider extends StatelessWidget {
  const UIRangeSlider({
    super.key,
    required this.values,
    required this.onChanged,
    this.min = 0,
    this.max = 1,
    this.divisions,
    this.activeColor,
    this.inactiveColor,
    this.enabled = true,
  });

  final RangeValues values;
  final ValueChanged<RangeValues>? onChanged;
  final double min;
  final double max;
  final int? divisions;
  final Color? activeColor;
  final Color? inactiveColor;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final effectiveOnChanged = enabled ? onChanged : null;

    return SliderTheme(
      data: SliderTheme.of(context).copyWith(
        activeTrackColor: activeColor ?? scheme.primary,
        inactiveTrackColor: inactiveColor ?? scheme.surfaceContainerHighest,
        rangeThumbShape: const RoundRangeSliderThumbShape(),
      ),
      child: RangeSlider(
        values: RangeValues(
          values.start.clamp(min, max),
          values.end.clamp(min, max),
        ),
        min: min,
        max: max,
        divisions: divisions,
        onChanged: effectiveOnChanged,
      ),
    );
  }
}
