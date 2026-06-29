import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Controller for [UIAnimatedCounter].
class UIAnimatedCounterController extends ValueNotifier<num> {
  UIAnimatedCounterController(super.value);

  void addValue(num delta) => value = value + delta;
  void resetValue(num newValue) => value = newValue;
}

/// Animated numeric display with optional grouping and decimal digits.
class UIAnimatedCounter extends StatefulWidget {
  const UIAnimatedCounter({
    super.key,
    this.controller,
    this.value = 0,
    this.style,
    this.duration = const Duration(milliseconds: 350),
    this.curve = Curves.easeOutCubic,
    this.fractionDigits = 0,
    this.enableGrouping = false,
    this.locale,
    this.prefix,
    this.suffix,
    this.rollDigits = false,
  });

  final UIAnimatedCounterController? controller;
  final num value;
  final TextStyle? style;
  final Duration duration;
  final Curve curve;
  final int fractionDigits;
  final bool enableGrouping;
  final String? locale;
  final String? prefix;
  final String? suffix;
  final bool rollDigits;

  @override
  State<UIAnimatedCounter> createState() => _UIAnimatedCounterState();
}

class _UIAnimatedCounterState extends State<UIAnimatedCounter> {
  late num _from;
  late num _to;

  @override
  void initState() {
    super.initState();
    _to = _currentValue;
    _from = _to;
    widget.controller?.addListener(_onControllerChanged);
  }

  @override
  void didUpdateWidget(UIAnimatedCounter oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller?.removeListener(_onControllerChanged);
      widget.controller?.addListener(_onControllerChanged);
    }
    if (widget.controller == null && oldWidget.value != widget.value) {
      _beginAnimationTo(widget.value);
    }
  }

  @override
  void dispose() {
    widget.controller?.removeListener(_onControllerChanged);
    super.dispose();
  }

  num get _currentValue => widget.controller?.value ?? widget.value;

  void _onControllerChanged() => _beginAnimationTo(_currentValue);

  void _beginAnimationTo(num next) {
    if (next == _to) return;
    setState(() {
      _from = _to;
      _to = next;
    });
  }

  String _format(num value) {
    final formatter = NumberFormat.decimalPattern(widget.locale)
      ..minimumFractionDigits = widget.fractionDigits
      ..maximumFractionDigits = widget.fractionDigits;
    if (!widget.enableGrouping) {
      formatter.turnOffGrouping();
    }
    return formatter.format(value);
  }

  @override
  Widget build(BuildContext context) {
    final style =
        widget.style ??
        Theme.of(context).textTheme.headlineMedium ??
        const TextStyle();

    return TweenAnimationBuilder<double>(
      key: ValueKey('$_from-$_to'),
      tween: Tween<double>(begin: _from.toDouble(), end: _to.toDouble()),
      duration: widget.duration,
      curve: widget.curve,
      builder: (context, animatedValue, child) {
        final text =
            '${widget.prefix ?? ''}${_format(animatedValue)}${widget.suffix ?? ''}';
        if (!widget.rollDigits) {
          return Text(text, style: style);
        }
        return _RollingNumberText(text: text, style: style);
      },
    );
  }
}

class _RollingNumberText extends StatelessWidget {
  const _RollingNumberText({required this.text, required this.style});

  final String text;
  final TextStyle style;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var i = 0; i < text.length; i++)
          _RollingChar(
            key: ValueKey('rolling-$i'),
            char: text[i],
            style: style,
          ),
      ],
    );
  }
}

class _RollingChar extends StatelessWidget {
  const _RollingChar({super.key, required this.char, required this.style});

  final String char;
  final TextStyle style;

  @override
  Widget build(BuildContext context) {
    final parsed = int.tryParse(char);
    if (parsed == null) return Text(char, style: style);

    final height = (style.fontSize ?? 24) * (style.height ?? 1.2);
    final width = _measureDigitWidth(style);

    return ClipRect(
      child: SizedBox(
        width: width,
        height: height,
        child: Transform.translate(
          offset: Offset(0, -parsed * height),
          child: Column(
            children: List.generate(
              10,
              (index) => SizedBox(
                height: height,
                child: Center(child: Text('$index', style: style)),
              ),
            ),
          ),
        ),
      ),
    );
  }

  double _measureDigitWidth(TextStyle style) {
    final painter = TextPainter(
      text: TextSpan(text: '0', style: style),
      textDirection: ui.TextDirection.ltr,
    )..layout();
    return painter.width;
  }
}
