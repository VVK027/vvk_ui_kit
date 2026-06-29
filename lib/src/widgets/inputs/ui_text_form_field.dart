import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'ui_labeled_field.dart';
import 'ui_text_field_helper.dart';
import '../text/ui_text.dart';

/// A labeled text form field with optional password toggle, validation, and
/// input formatters.
///
/// Set [trimLeadingSpace] or [disallowSpaces] to apply built-in formatters, or
/// pass custom [inputFormatters].
class UITextFormField extends StatelessWidget {
  /// Creates a [UITextFormField].
  const UITextFormField({
    super.key,
    this.label,
    this.labelChild,
    required this.hintText,
    this.errorText,
    this.keyboardType = TextInputType.text,
    this.isPassword = false,
    this.obscureText = false,
    this.trimLeadingSpace = false,
    this.disallowSpaces = false,
    this.inputFormatters,
    this.onChanged,
    this.validator,
    this.onToggleObscure,
  }) : assert(
         labelChild != null || label != null,
         'Either label or labelChild must be provided.',
       );

  /// Plain-text label shown above the field.
  final String? label;

  /// Custom label widget; takes precedence over [label].
  final Widget? labelChild;

  /// Placeholder shown inside the field.
  final String hintText;

  /// Inline error message below the field.
  final String? errorText;

  /// Keyboard type for the underlying [TextFormField].
  final TextInputType keyboardType;

  /// When true, shows a visibility toggle suffix icon.
  final bool isPassword;

  /// Current obscured state when [isPassword] is true.
  final bool obscureText;

  /// Applies [NoLeadingSpaceFormatter] when true.
  final bool trimLeadingSpace;

  /// Applies [NoSpaceFormatter] when true.
  final bool disallowSpaces;

  /// Additional input formatters applied after built-in formatters.
  final List<TextInputFormatter>? inputFormatters;

  /// Called when the field value changes.
  final void Function(String)? onChanged;

  /// Validation callback for the underlying [TextFormField].
  final String? Function(String?)? validator;

  /// Called when the password visibility toggle is pressed.
  final VoidCallback? onToggleObscure;

  /// Returns a copy with the given fields replaced.
  UITextFormField copyWith({
    Key? key,
    String? label,
    Widget? labelChild,
    String? hintText,
    String? errorText,
    TextInputType? keyboardType,
    bool? isPassword,
    bool? obscureText,
    bool? trimLeadingSpace,
    bool? disallowSpaces,
    List<TextInputFormatter>? inputFormatters,
    void Function(String)? onChanged,
    String? Function(String?)? validator,
    VoidCallback? onToggleObscure,
  }) {
    return UITextFormField(
      key: key ?? this.key,
      label: label ?? this.label,
      labelChild: labelChild ?? this.labelChild,
      hintText: hintText ?? this.hintText,
      errorText: errorText ?? this.errorText,
      keyboardType: keyboardType ?? this.keyboardType,
      isPassword: isPassword ?? this.isPassword,
      obscureText: obscureText ?? this.obscureText,
      trimLeadingSpace: trimLeadingSpace ?? this.trimLeadingSpace,
      disallowSpaces: disallowSpaces ?? this.disallowSpaces,
      inputFormatters: inputFormatters ?? this.inputFormatters,
      onChanged: onChanged ?? this.onChanged,
      validator: validator ?? this.validator,
      onToggleObscure: onToggleObscure ?? this.onToggleObscure,
    );
  }

  List<TextInputFormatter> get _resolvedFormatters {
    return [
      if (trimLeadingSpace) const NoLeadingSpaceFormatter(),
      if (disallowSpaces) const NoSpaceFormatter(),
      ...?inputFormatters,
    ];
  }

  @override
  Widget build(BuildContext context) {
    final labelWidget = labelChild ?? UIText(label!, size: 14);

    return UILabeledField(
      labelChild: labelWidget,
      gap: 8,
      child: TextFormField(
        obscureText: isPassword && obscureText,
        keyboardType: keyboardType,
        validator: validator,
        inputFormatters: _resolvedFormatters.isEmpty
            ? null
            : _resolvedFormatters,
        decoration: InputDecoration(
          hintText: hintText,
          border: const OutlineInputBorder(),
          errorText: errorText,
          suffixIcon: isPassword
              ? IconButton(
                  icon: Icon(
                    obscureText ? Icons.visibility_off : Icons.visibility,
                  ),
                  onPressed: onToggleObscure,
                )
              : null,
        ),
        onChanged: onChanged,
      ),
    );
  }
}
