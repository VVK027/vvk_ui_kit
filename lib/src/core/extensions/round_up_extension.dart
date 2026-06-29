/// Smart rounding that trims unnecessary trailing zeros.
library;

final _trailingZerosRegExp = RegExp(r'0+$');
final _trailingDecimalRegExp = RegExp(r'\.$');

String _toSmartString(double value, int maxPrecision) {
  if (maxPrecision <= 0) return value.round().toString();
  var result = value.toStringAsFixed(maxPrecision);
  if (result.contains('.')) {
    result = result
        .replaceFirst(_trailingZerosRegExp, '')
        .replaceFirst(_trailingDecimalRegExp, '');
  }
  return result;
}

/// Rounding helpers for non-nullable [double] values.
extension DoubleRoundUpExtension on double {
  /// Rounded string with trailing zeros removed.
  String toStringAsRoundUp({int maxPrecision = 2}) {
    return _toSmartString(this, maxPrecision);
  }

  /// Rounded numeric value after smart formatting.
  num toNumAsRoundUp({int maxPrecision = 2}) {
    final rounded = toStringAsRoundUp(maxPrecision: maxPrecision);
    return rounded.contains('.') ? double.parse(rounded) : int.parse(rounded);
  }
}

/// Rounding helpers for nullable [double] values.
extension DoubleNullRoundUpExtension on double? {
  /// Rounded string, or `null` when the receiver is `null`.
  String? toStringAsRoundUp({int maxPrecision = 2}) {
    if (this == null) return null;
    return _toSmartString(this!, maxPrecision);
  }

  /// Rounded numeric value, or `null` when the receiver is `null`.
  num? toNumAsRoundUp({int maxPrecision = 2}) {
    return this?.toNumAsRoundUp(maxPrecision: maxPrecision);
  }
}

/// Rounding helpers for [num] values.
extension NumRoundUpExtension on num {
  /// Rounded string with trailing zeros removed.
  String toStringAsRoundUp({int maxPrecision = 2}) {
    return _toSmartString(toDouble(), maxPrecision);
  }

  /// Rounded numeric value after smart formatting.
  num toNumAsRoundUp({int maxPrecision = 2}) {
    return toDouble().toNumAsRoundUp(maxPrecision: maxPrecision);
  }
}

/// Rounding helpers for nullable [num] values.
extension NumNullRoundUpExtension on num? {
  /// Rounded string, or `null` when the receiver is `null`.
  String? toStringAsRoundUp({int maxPrecision = 2}) {
    if (this == null) return null;
    return _toSmartString(this!.toDouble(), maxPrecision);
  }

  /// Rounded numeric value, or `null` when the receiver is `null`.
  num? toNumAsRoundUp({int maxPrecision = 2}) {
    return this?.toDouble().toNumAsRoundUp(maxPrecision: maxPrecision);
  }
}
