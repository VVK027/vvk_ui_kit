/// Null-safe boolean helpers and conversions.
library;

/// Extensions for nullable [bool] values.
extension BoolOrNullExtension on bool? {
  /// Returns this value, or [value] when `null`.
  bool validate({bool value = false}) => this ?? value;

  /// `true` when the resolved value is `true` (`null` → `false`).
  bool isTrue() => validate().isTrue();

  /// `true` when the resolved value is `false` (`null` → `false`).
  bool isFalse() => validate().isFalse();

  /// `true` when the resolved value is not `true`.
  bool isNotTrue() => validate().isNotTrue();

  /// `true` when the resolved value is not `false`.
  bool isNotFalse() => validate().isNotFalse();

  /// `1` for `true`, `0` for `false` or `null`.
  int toInt() => validate().toInt();

  /// Flips the value (`null` is treated as `false` → `true`).
  bool toggle() => validate().toggle();
}

/// Extensions for non-nullable [bool] values.
extension BoolExtension on bool {
  /// `true` when this value is `true`.
  bool isTrue() => this;

  /// `true` when this value is `false`.
  bool isFalse() => !this;

  /// `true` when this value is not `true`.
  bool isNotTrue() => !this;

  /// `true` when this value is not `false`.
  bool isNotFalse() => this;

  /// `1` for `true`, `0` for `false`.
  int toInt() => this ? 1 : 0;

  /// Returns the opposite value.
  bool toggle() => !this;
}
