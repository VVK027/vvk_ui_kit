import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vvk_ui_kit/src/widgets/text/ui_text.dart';

/// Multiline text field with optional label, character count, and resize grip.
class UITextarea extends StatefulWidget {
  const UITextarea({
    super.key,
    this.controller,
    this.focusNode,
    this.label,
    this.hintText,
    this.errorText,
    this.onChanged,
    this.minLines = 3,
    this.maxLines = 6,
    this.maxLength,
    this.showCharacterCount = false,
    this.enabled = true,
    this.readOnly = false,
    this.borderRadius = 12,
    this.contentPadding = const EdgeInsets.all(14),
    this.backgroundColor,
    this.borderColor,
    this.focusedBorderColor,
    this.textStyle,
    this.hintStyle,
    this.labelStyle,
    this.inputFormatters,
  });

  factory UITextarea.fromTheme(
    BuildContext context, {
    Key? key,
    TextEditingController? controller,
    FocusNode? focusNode,
    String? label,
    String? hintText,
    String? errorText,
    ValueChanged<String>? onChanged,
    int minLines = 3,
    int maxLines = 6,
    int? maxLength,
    bool showCharacterCount = false,
    bool enabled = true,
    bool readOnly = false,
  }) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return UITextarea(
      key: key,
      controller: controller,
      focusNode: focusNode,
      label: label,
      hintText: hintText,
      errorText: errorText,
      onChanged: onChanged,
      minLines: minLines,
      maxLines: maxLines,
      maxLength: maxLength,
      showCharacterCount: showCharacterCount,
      enabled: enabled,
      readOnly: readOnly,
      backgroundColor: scheme.surface,
      borderColor: scheme.outlineVariant,
      focusedBorderColor: scheme.primary,
      textStyle: theme.textTheme.bodyMedium?.copyWith(color: scheme.onSurface),
      hintStyle: theme.textTheme.bodyMedium?.copyWith(color: scheme.outline),
      labelStyle: theme.textTheme.labelLarge?.copyWith(
        color: scheme.onSurface,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  final TextEditingController? controller;
  final FocusNode? focusNode;
  final String? label;
  final String? hintText;
  final String? errorText;
  final ValueChanged<String>? onChanged;
  final int minLines;
  final int maxLines;
  final int? maxLength;
  final bool showCharacterCount;
  final bool enabled;
  final bool readOnly;
  final double borderRadius;
  final EdgeInsetsGeometry contentPadding;
  final Color? backgroundColor;
  final Color? borderColor;
  final Color? focusedBorderColor;
  final TextStyle? textStyle;
  final TextStyle? hintStyle;
  final TextStyle? labelStyle;
  final List<TextInputFormatter>? inputFormatters;

  @override
  State<UITextarea> createState() => _UITextareaState();
}

class _UITextareaState extends State<UITextarea> {
  late final TextEditingController _controller;
  late final FocusNode _focusNode;
  late bool _ownsController;
  late bool _ownsFocusNode;

  @override
  void initState() {
    super.initState();
    _ownsController = widget.controller == null;
    _ownsFocusNode = widget.focusNode == null;
    _controller = widget.controller ?? TextEditingController();
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(_onFocusChanged);
  }

  @override
  void didUpdateWidget(UITextarea oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      if (_ownsController) _controller.dispose();
      _ownsController = widget.controller == null;
      if (_ownsController) {
        _controller = TextEditingController();
      } else {
        _controller = widget.controller!;
      }
    }
    if (oldWidget.focusNode != widget.focusNode) {
      oldWidget.focusNode?.removeListener(_onFocusChanged);
      if (_ownsFocusNode) _focusNode.dispose();
      _ownsFocusNode = widget.focusNode == null;
      _focusNode = widget.focusNode ?? FocusNode();
      _focusNode.addListener(_onFocusChanged);
    }
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChanged);
    if (_ownsController) _controller.dispose();
    if (_ownsFocusNode) _focusNode.dispose();
    super.dispose();
  }

  void _onFocusChanged() => setState(() {});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final hasError = widget.errorText != null && widget.errorText!.isNotEmpty;
    final border = hasError
        ? scheme.error
        : (_focusNode.hasFocus
              ? (widget.focusedBorderColor ?? scheme.primary)
              : (widget.borderColor ?? scheme.outlineVariant));

    final field = TextField(
      controller: _controller,
      focusNode: _focusNode,
      enabled: widget.enabled,
      readOnly: widget.readOnly,
      minLines: widget.minLines,
      maxLines: widget.maxLines,
      maxLength: widget.maxLength,
      onChanged: widget.onChanged,
      inputFormatters: widget.inputFormatters,
      style: widget.textStyle,
      decoration: InputDecoration(
        hintText: widget.hintText,
        hintStyle: widget.hintStyle,
        counterText: widget.showCharacterCount ? null : '',
        filled: true,
        fillColor: widget.backgroundColor ?? scheme.surface,
        contentPadding: widget.contentPadding,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(widget.borderRadius),
          borderSide: BorderSide(color: border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(widget.borderRadius),
          borderSide: BorderSide(color: border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(widget.borderRadius),
          borderSide: BorderSide(color: border, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(widget.borderRadius),
          borderSide: BorderSide(color: scheme.error),
        ),
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null) ...[
          UIText(widget.label!, style: widget.labelStyle),
          const SizedBox(height: 8),
        ],
        field,
        if (hasError) ...[
          const SizedBox(height: 6),
          UIText(
            widget.errorText!,
            style: theme.textTheme.bodySmall?.copyWith(color: scheme.error),
          ),
        ],
      ],
    );
  }
}
