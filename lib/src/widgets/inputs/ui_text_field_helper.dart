import 'package:flutter/services.dart';

/// Rejects input that starts with a leading space.
///
/// Useful for username or code fields where leading whitespace is invalid.
class NoLeadingSpaceFormatter extends TextInputFormatter {
  /// Creates a [NoLeadingSpaceFormatter].
  const NoLeadingSpaceFormatter();

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.startsWith(' ')) {
      final trimText = newValue.text.trimLeft();
      return TextEditingValue(
        text: trimText,
        selection: TextSelection(
          baseOffset: trimText.length,
          extentOffset: trimText.length,
        ),
      );
    }
    return newValue;
  }
}

/// Rejects any input that contains spaces.
class NoSpaceFormatter extends TextInputFormatter {
  /// Creates a [NoSpaceFormatter].
  const NoSpaceFormatter();

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.contains(' ')) {
      final trimmedText = newValue.text.replaceAll(' ', '');
      return TextEditingValue(
        text: trimmedText,
        selection: TextSelection(
          baseOffset: trimmedText.length,
          extentOffset: trimmedText.length,
        ),
      );
    }
    return newValue;
  }
}
