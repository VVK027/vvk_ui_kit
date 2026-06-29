/// Safe type-coercion helpers for dynamic values.
extension ObjectExtension on Object? {
  static const _trueStrings = {'true', 'yes', '1', 'on'};
  static const _falseStrings = {'false', 'no', '0', 'off'};

  /// Converts to [num], or returns [defaultValue] on failure.
  num? toNum({num? defaultValue}) {
    if (this == null) return defaultValue;
    if (this is num) return this as num;
    if (this is String) return num.tryParse(this as String) ?? defaultValue;
    if (this is bool) return (this as bool) ? 1 : 0;
    return defaultValue;
  }

  /// Converts to [int], or returns [defaultValue] on failure.
  int? toInt({int? defaultValue}) {
    if (this == null) return defaultValue;
    if (this is int) return this as int;
    if (this is double) return (this as double).toInt();
    if (this is String) return int.tryParse(this as String) ?? defaultValue;
    if (this is bool) return (this as bool) ? 1 : 0;
    return defaultValue;
  }

  /// Converts to [double], or returns [defaultValue] on failure.
  double? toDouble({double? defaultValue}) {
    if (this == null) return defaultValue;
    if (this is double) return this as double;
    if (this is int) return (this as int).toDouble();
    if (this is String) {
      return double.tryParse(this as String) ?? defaultValue;
    }
    if (this is bool) return (this as bool) ? 1.0 : 0.0;
    return defaultValue;
  }

  /// Converts to trimmed [String], or returns [defaultValue] when `null`.
  String? toStr({String? defaultValue}) {
    if (this == null) return defaultValue;
    return toString().trim();
  }

  /// Converts to [bool] using common string/numeric conventions.
  bool? toBool({bool? defaultValue}) {
    if (this == null) return defaultValue;
    if (this is bool) return this as bool;
    if (this is String) {
      final lowerValue = (this as String).trim().toLowerCase();
      if (_trueStrings.contains(lowerValue)) return true;
      if (_falseStrings.contains(lowerValue)) return false;
    }
    if (this is num) return (this as num) != 0;
    return defaultValue;
  }
}
