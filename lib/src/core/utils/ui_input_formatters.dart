import 'package:flutter/services.dart';

/// Ready-made [TextInputFormatter]s for common form fields.
///
/// ```dart
/// TextField(inputFormatters: [UIInputFormatters.phone]);
/// TextField(inputFormatters: [UIInputFormatters.denySpecialChars]);
/// ```
abstract final class UIInputFormatters {
  /// Allows letters, digits, and spaces (names, titles).
  static final FilteringTextInputFormatter name =
      FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9 ]'));

  /// Allows letters and digits only (no spaces or symbols).
  static final FilteringTextInputFormatter alphanumeric =
      FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9]'));

  /// Allows digits only (phone numbers, PINs).
  static final TextInputFormatter phone =
      FilteringTextInputFormatter.digitsOnly;

  /// Allows digits and a leading `+` (phone with country code).
  static final FilteringTextInputFormatter phoneWithCountryCode =
      FilteringTextInputFormatter.allow(RegExp(r'[0-9+]'));

  /// Blocks common special characters.
  static final FilteringTextInputFormatter denySpecialChars =
      FilteringTextInputFormatter.deny(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));

  /// Allows a decimal number with up to [decimalRange] fraction digits.
  static TextInputFormatter decimal({int decimalRange = 2}) {
    assert(decimalRange >= 0);
    return FilteringTextInputFormatter.allow(
      RegExp(r'^\d*\.?\d{0,' '$decimalRange' r'}'),
    );
  }
}
