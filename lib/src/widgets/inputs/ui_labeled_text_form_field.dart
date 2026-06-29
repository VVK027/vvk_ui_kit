import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vvk_ui_kit/src/widgets/text/ui_rich_text.dart';
import 'package:vvk_ui_kit/src/widgets/text/ui_text.dart';
import 'package:vvk_ui_kit/src/widgets/media/ui_image.dart';
import '../ui_widget_helpers.dart';

/// Stateful labeled text field with optional password toggle and validation.
class UILabeledTextFormField extends StatefulWidget {
  final String? headerText;
  final String? text;
  final String? errorText;
  final String? placeholderText;
  final String? validationText;
  final int? maxLength;
  final bool? isToShowCount;
  final bool? isRequired;
  final bool? enabled;
  final Color? borderColor;
  final bool? isToShowDecoration;
  final TextEditingController? controller;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final TextInputType? textInputType;
  final bool? obscureText;
  final Color? headerTextColor;
  final double? height;
  final FontWeight? headerFontWeight;
  final double? headerFontSize;
  final double? paddingBetweenHeaderAndTextField;
  final EdgeInsetsGeometry? contentPadding;
  final TextStyle? textStyle;
  final ValueChanged<String>? onChange;
  final ValueChanged<String>? onFieldSubmitted;
  final VoidCallback? onTap;
  final bool showClearIcon;
  final bool showDivider;
  final int? minLines;
  final int? maxLines;
  final List<TextInputFormatter>? inputFormatters;
  final Color? backgroundColor;
  final FocusNode? focusNode;
  final Color requiredMarkColor;
  final Color hintTextColor;
  final Color inputTextColor;
  final Color errorTextColor;
  final String? clearIconPath;
  final String? errorIconPath;

  const UILabeledTextFormField({
    super.key,
    this.headerText,
    this.text,
    this.errorText,
    this.height,
    this.placeholderText,
    this.validationText,
    this.maxLength,
    this.isToShowCount,
    this.isRequired = false,
    this.enabled,
    this.onChange,
    this.suffixIcon,
    this.textInputType,
    this.controller,
    this.obscureText,
    this.contentPadding,
    this.headerFontWeight,
    this.headerFontSize,
    this.headerTextColor,
    this.onFieldSubmitted,
    this.textStyle,
    this.prefixIcon,
    this.isToShowDecoration = true,
    this.borderColor,
    this.onTap,
    this.showClearIcon = false,
    this.showDivider = false,
    this.paddingBetweenHeaderAndTextField,
    this.minLines,
    this.maxLines = 1,
    this.inputFormatters,
    this.backgroundColor,
    this.focusNode,
    required this.requiredMarkColor,
    required this.hintTextColor,
    required this.inputTextColor,
    required this.errorTextColor,
    this.clearIconPath,
    this.errorIconPath,
  });

  UILabeledTextFormField copyWith({
    Key? key,
    String? headerText,
    String? text,
    String? errorText,
    String? placeholderText,
    String? validationText,
    int? maxLength,
    bool? isToShowCount,
    bool? isRequired,
    bool? enabled,
    Color? borderColor,
    bool? isToShowDecoration,
    TextEditingController? controller,
    Widget? suffixIcon,
    Widget? prefixIcon,
    TextInputType? textInputType,
    bool? obscureText,
    Color? headerTextColor,
    double? height,
    FontWeight? headerFontWeight,
    double? headerFontSize,
    double? paddingBetweenHeaderAndTextField,
    EdgeInsetsGeometry? contentPadding,
    TextStyle? textStyle,
    ValueChanged<String>? onChange,
    ValueChanged<String>? onFieldSubmitted,
    VoidCallback? onTap,
    bool? showClearIcon,
    bool? showDivider,
    int? minLines,
    int? maxLines,
    List<TextInputFormatter>? inputFormatters,
    Color? backgroundColor,
    FocusNode? focusNode,
    Color? requiredMarkColor,
    Color? hintTextColor,
    Color? inputTextColor,
    Color? errorTextColor,
    String? clearIconPath,
    String? errorIconPath,
  }) {
    return UILabeledTextFormField(
      key: key ?? this.key,
      headerText: headerText ?? this.headerText,
      text: text ?? this.text,
      errorText: errorText ?? this.errorText,
      placeholderText: placeholderText ?? this.placeholderText,
      validationText: validationText ?? this.validationText,
      maxLength: maxLength ?? this.maxLength,
      isToShowCount: isToShowCount ?? this.isToShowCount,
      isRequired: isRequired ?? this.isRequired,
      enabled: enabled ?? this.enabled,
      borderColor: borderColor ?? this.borderColor,
      isToShowDecoration: isToShowDecoration ?? this.isToShowDecoration,
      controller: controller ?? this.controller,
      suffixIcon: suffixIcon ?? this.suffixIcon,
      prefixIcon: prefixIcon ?? this.prefixIcon,
      textInputType: textInputType ?? this.textInputType,
      obscureText: obscureText ?? this.obscureText,
      headerTextColor: headerTextColor ?? this.headerTextColor,
      height: height ?? this.height,
      headerFontWeight: headerFontWeight ?? this.headerFontWeight,
      headerFontSize: headerFontSize ?? this.headerFontSize,
      paddingBetweenHeaderAndTextField:
          paddingBetweenHeaderAndTextField ??
          this.paddingBetweenHeaderAndTextField,
      contentPadding: contentPadding ?? this.contentPadding,
      textStyle: textStyle ?? this.textStyle,
      onChange: onChange ?? this.onChange,
      onFieldSubmitted: onFieldSubmitted ?? this.onFieldSubmitted,
      onTap: onTap ?? this.onTap,
      showClearIcon: showClearIcon ?? this.showClearIcon,
      showDivider: showDivider ?? this.showDivider,
      minLines: minLines ?? this.minLines,
      maxLines: maxLines ?? this.maxLines,
      inputFormatters: inputFormatters ?? this.inputFormatters,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      focusNode: focusNode ?? this.focusNode,
      requiredMarkColor: requiredMarkColor ?? this.requiredMarkColor,
      hintTextColor: hintTextColor ?? this.hintTextColor,
      inputTextColor: inputTextColor ?? this.inputTextColor,
      errorTextColor: errorTextColor ?? this.errorTextColor,
      clearIconPath: clearIconPath ?? this.clearIconPath,
      errorIconPath: errorIconPath ?? this.errorIconPath,
    );
  }

  @override
  State<UILabeledTextFormField> createState() => _UILabeledTextFormFieldState();
}

class _UILabeledTextFormFieldState extends State<UILabeledTextFormField> {
  late TextEditingController _controller;
  int _textCount = 0;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController(text: widget.text);
    _textCount = _controller.text.length;
    _controller.addListener(_handleTextChanged);
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    } else {
      _controller.removeListener(_handleTextChanged);
    }
    super.dispose();
  }

  void _handleTextChanged() {
    if (!mounted) return;
    setState(() => _textCount = _controller.text.length);
  }

  @override
  Widget build(BuildContext context) {
    final headerColor =
        widget.headerTextColor ?? Theme.of(context).colorScheme.onSurface;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            UIRichText(
              listTextSpan: [
                textSpan(
                  widget.headerText ?? '',
                  headerColor,
                  widget.headerFontWeight ?? FontWeight.w700,
                  widget.headerFontSize ?? 16,
                ),
                textSpan(
                  widget.isRequired == true ? ' *' : '',
                  widget.requiredMarkColor,
                  FontWeight.w700,
                  16,
                ),
              ],
            ),
            if (widget.isToShowCount ?? false)
              UIRichText(
                listTextSpan: [
                  textSpan(
                    '$_textCount/${widget.maxLength}',
                    headerColor,
                    FontWeight.w600,
                    11,
                  ),
                  textSpan(
                    widget.validationText ?? '',
                    headerColor,
                    FontWeight.w600,
                    11,
                  ),
                ],
              ),
          ],
        ),
        SizedBox(height: widget.paddingBetweenHeaderAndTextField ?? 10),
        Container(
          height: widget.height ?? 58,
          width: MediaQuery.of(context).size.width,
          decoration: widget.isToShowDecoration == true
              ? BoxDecoration(
                  color: widget.backgroundColor ?? Colors.transparent,
                  border: Border.all(
                    color: widget.borderColor ?? Theme.of(context).dividerColor,
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(4),
                )
              : null,
          child: Center(
            child: TextFormField(
              onChanged: widget.onChange,
              onFieldSubmitted: widget.onFieldSubmitted,
              onTap: widget.onTap,
              focusNode: widget.focusNode,
              textInputAction: TextInputAction.done,
              inputFormatters: widget.inputFormatters,
              enabled: widget.enabled ?? true,
              controller: _controller,
              obscureText: widget.obscureText ?? false,
              keyboardType: widget.textInputType ?? TextInputType.text,
              minLines: widget.minLines,
              maxLines: widget.maxLines,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: widget.placeholderText,
                hintStyle: textStyle(
                  color: widget.hintTextColor,
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                ),
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                contentPadding:
                    widget.contentPadding ??
                    const EdgeInsetsDirectional.only(
                      start: 10,
                      top: 10,
                      bottom: 10,
                      end: 10,
                    ),
                counterText: '',
                suffixIconConstraints: const BoxConstraints(
                  minWidth: 2,
                  minHeight: 2,
                ),
                suffixIcon:
                    widget.suffixIcon ??
                    (widget.showClearIcon && _textCount > 0
                        ? _clearWidget(() {
                            _controller.clear();
                            widget.onChange?.call('');
                          })
                        : null),
                prefixIcon: widget.prefixIcon,
              ),
              maxLength: widget.maxLength,
              style:
                  widget.textStyle ??
                  textStyle(
                    color: widget.inputTextColor,
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                  ),
            ),
          ),
        ),
        if (widget.showDivider) const Divider(thickness: 1),
        if (widget.errorText != null)
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Row(
              children: [
                if (widget.errorIconPath != null)
                  UIImage(widget.errorIconPath!, width: 17, height: 17),
                if (widget.errorIconPath != null) const SizedBox(width: 5),
                Expanded(
                  child: UIText(
                    widget.errorText ?? '',
                    size: 10,
                    color: widget.errorTextColor,
                    fontWeight: FontWeight.w400,
                    textAlign: TextAlign.left,
                    maxLines: 3,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _clearWidget(VoidCallback onClear) {
    return InkWell(
      onTap: onClear,
      child: SizedBox(
        width: 50,
        height: 50,
        child: widget.clearIconPath != null
            ? UIImage(widget.clearIconPath!, width: 15, height: 15)
            : const Icon(Icons.clear, size: 15),
      ),
    );
  }
}
