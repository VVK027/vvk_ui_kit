import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// One character slot inside [UIInputOTP].
class UIInputOTPSlot extends StatelessWidget {
  const UIInputOTPSlot({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.onChanged,
    required this.onBackspace,
    this.size = 48,
    this.borderRadius = 12,
    this.borderColor,
    this.focusedBorderColor,
    this.backgroundColor,
    this.textStyle,
    this.obscureText = false,
    this.enabled = true,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final ValueChanged<String> onChanged;
  final VoidCallback onBackspace;
  final double size;
  final double borderRadius;
  final Color? borderColor;
  final Color? focusedBorderColor;
  final Color? backgroundColor;
  final TextStyle? textStyle;
  final bool obscureText;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final border = focusNode.hasFocus
        ? (focusedBorderColor ?? scheme.primary)
        : (borderColor ?? scheme.outlineVariant);

    return SizedBox(
      width: size,
      height: size,
      child: Focus(
        onKeyEvent: (node, event) {
          if (event is KeyDownEvent &&
              event.logicalKey == LogicalKeyboardKey.backspace &&
              controller.text.isEmpty) {
            onBackspace();
            return KeyEventResult.handled;
          }
          return KeyEventResult.ignored;
        },
        child: TextField(
          controller: controller,
          focusNode: focusNode,
          enabled: enabled,
          textAlign: TextAlign.center,
          keyboardType: TextInputType.number,
          obscureText: obscureText,
          maxLength: 1,
          style:
              textStyle ??
              theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
                color: scheme.onSurface,
              ),
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          decoration: InputDecoration(
            counterText: '',
            filled: true,
            fillColor: backgroundColor ?? scheme.surface,
            contentPadding: EdgeInsets.zero,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius),
              borderSide: BorderSide(color: border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius),
              borderSide: BorderSide(color: border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius),
              borderSide: BorderSide(color: border, width: 1.5),
            ),
          ),
          onChanged: onChanged,
        ),
      ),
    );
  }
}

/// OTP input composed of individual digit slots with auto-advance focus.
class UIInputOTP extends StatefulWidget {
  const UIInputOTP({
    super.key,
    this.length = 6,
    this.onCompleted,
    this.onChanged,
    this.obscureText = false,
    this.enabled = true,
    this.spacing = 8,
    this.slotSize = 48,
    this.borderRadius = 12,
    this.borderColor,
    this.focusedBorderColor,
    this.backgroundColor,
    this.textStyle,
  });

  final int length;
  final ValueChanged<String>? onCompleted;
  final ValueChanged<String>? onChanged;
  final bool obscureText;
  final bool enabled;
  final double spacing;
  final double slotSize;
  final double borderRadius;
  final Color? borderColor;
  final Color? focusedBorderColor;
  final Color? backgroundColor;
  final TextStyle? textStyle;

  @override
  State<UIInputOTP> createState() => UIInputOTPState();
}

class UIInputOTPState extends State<UIInputOTP> {
  late final List<TextEditingController> _controllers;
  late final List<FocusNode> _focusNodes;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(widget.length, (_) => TextEditingController());
    _focusNodes = List.generate(
      widget.length,
      (_) => FocusNode()..addListener(_rebuild),
    );
  }

  @override
  void didUpdateWidget(UIInputOTP oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.length != widget.length) {
      for (final c in _controllers) {
        c.dispose();
      }
      for (final f in _focusNodes) {
        f.removeListener(_rebuild);
        f.dispose();
      }
      _controllers = List.generate(
        widget.length,
        (_) => TextEditingController(),
      );
      _focusNodes = List.generate(
        widget.length,
        (_) => FocusNode()..addListener(_rebuild),
      );
    }
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    for (final f in _focusNodes) {
      f.removeListener(_rebuild);
      f.dispose();
    }
    super.dispose();
  }

  void _rebuild() => setState(() {});

  String get value => _controllers.map((c) => c.text).join();

  void clear() {
    for (final c in _controllers) {
      c.clear();
    }
    _focusNodes.first.requestFocus();
    _notifyChanged();
  }

  void _notifyChanged() {
    final current = value;
    widget.onChanged?.call(current);
    if (_controllers.every((c) => c.text.isNotEmpty)) {
      widget.onCompleted?.call(current);
    }
  }

  void _handleChanged(int index, String text) {
    if (text.length > 1) {
      _pasteAt(index, text);
      return;
    }

    if (text.isNotEmpty && index < widget.length - 1) {
      _focusNodes[index + 1].requestFocus();
    }
    _notifyChanged();
  }

  void _pasteAt(int startIndex, String raw) {
    final digits = raw.replaceAll(RegExp(r'\D'), '');
    if (digits.isEmpty) return;

    var index = startIndex;
    for (var i = 0; i < digits.length; i++) {
      if (index >= widget.length) break;
      _controllers[index].text = digits[i];
      index++;
    }

    if (index < widget.length) {
      _focusNodes[index].requestFocus();
    } else {
      _focusNodes.last.unfocus();
    }
    _notifyChanged();
  }

  void _handleBackspace(int index) {
    if (index > 0) {
      final previous = index - 1;
      _controllers[previous].clear();
      _focusNodes[previous].requestFocus();
      _notifyChanged();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var i = 0; i < widget.length; i++) ...[
          if (i > 0) SizedBox(width: widget.spacing),
          UIInputOTPSlot(
            controller: _controllers[i],
            focusNode: _focusNodes[i],
            enabled: widget.enabled,
            obscureText: widget.obscureText,
            size: widget.slotSize,
            borderRadius: widget.borderRadius,
            borderColor: widget.borderColor,
            focusedBorderColor: widget.focusedBorderColor,
            backgroundColor: widget.backgroundColor,
            textStyle: widget.textStyle,
            onChanged: (text) => _handleChanged(i, text),
            onBackspace: () => _handleBackspace(i),
          ),
        ],
      ],
    );
  }
}
