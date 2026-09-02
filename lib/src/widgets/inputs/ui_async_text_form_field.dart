import 'dart:async';

import 'package:flutter/material.dart';

import 'ui_labeled_field.dart';

/// Text form field that performs debounced asynchronous validation (e.g. checking
/// email or username availability against a backend API) with a suffix spinner.
class UIAsyncTextFormField extends StatefulWidget {
  const UIAsyncTextFormField({
    super.key,
    required this.asyncValidator,
    this.label,
    this.hintText = '',
    this.initialValue,
    this.controller,
    this.debounceDuration = const Duration(milliseconds: 500),
    this.onChanged,
    this.enabled = true,
  });

  /// Async validation callback. Returns error message or null if valid.
  final Future<String?> Function(String value) asyncValidator;

  /// Label text.
  final String? label;

  /// Hint text.
  final String hintText;

  /// Initial field value.
  final String? initialValue;

  /// Text controller.
  final TextEditingController? controller;

  /// Debounce duration before running [asyncValidator].
  final Duration debounceDuration;

  /// On changed callback.
  final ValueChanged<String>? onChanged;

  /// Whether the field is enabled.
  final bool enabled;

  @override
  State<UIAsyncTextFormField> createState() => _UIAsyncTextFormFieldState();
}

class _UIAsyncTextFormFieldState extends State<UIAsyncTextFormField> {
  Timer? _debounceTimer;
  bool _isValidating = false;
  String? _asyncError;

  void _onTextChanged(String value) {
    widget.onChanged?.call(value);
    _debounceTimer?.cancel();

    if (value.isEmpty) {
      setState(() {
        _isValidating = false;
        _asyncError = null;
      });
      return;
    }

    setState(() {
      _isValidating = true;
    });

    _debounceTimer = Timer(widget.debounceDuration, () async {
      final error = await widget.asyncValidator(value);
      if (mounted) {
        setState(() {
          _isValidating = false;
          _asyncError = error;
        });
      }
    });
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final field = TextFormField(
      enabled: widget.enabled,
      controller: widget.controller,
      initialValue: widget.controller == null ? widget.initialValue : null,
      onChanged: _onTextChanged,
      decoration: InputDecoration(
        hintText: widget.hintText,
        border: const OutlineInputBorder(),
        errorText: _asyncError,
        suffixIcon: _isValidating
            ? const UnconstrainedBox(
                child: SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              )
            : null,
      ),
    );

    if (widget.label != null) {
      return UILabeledField(
        label: widget.label,
        gap: 8,
        child: field,
      );
    }

    return field;
  }
}
