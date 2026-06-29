import 'dart:math' as math;

/// Null-safe numeric helpers and formatting utilities.
extension NumExtension on num? {
  /// `true` when the value is `null`.
  bool isNull() => this == null;

  /// Returns this value, or [value] when `null`.
  num validate({num value = 0}) => this ?? value;

  /// Pads single-digit numbers with a leading zero (e.g. `5` → `"05"`).
  ///
  /// Returns `null` when the receiver is `null`.
  String? addZeroPrefix() {
    if (this == null) return null;
    final current = this!;
    return current < 10 ? '0$current' : current.toString();
  }

  /// Increases the value by [percentage] percent.
  num? increaseByPercentage(double percentage) {
    if (this == null) return null;
    return this! * (1 + percentage / 100);
  }

  /// Decreases the value by [percentage] percent.
  num? decreaseByPercentage(double percentage) {
    if (this == null) return null;
    return this! * (1 - percentage / 100);
  }

  /// Absolute percent difference relative to this value.
  num? percentageDifference(num other) {
    if (this == null || this == 0) return null;
    return ((this! - other).abs() / this!) * 100;
  }

  /// `true` when the value is within the inclusive [first]–[second] range.
  bool isBetween(num first, num second) {
    final lower = math.min(first, second);
    final upper = math.max(first, second);
    final current = validate();
    return current >= lower && current <= upper;
  }

  /// `true` when the value is within the inclusive [min]–[max] range.
  bool isInRange(num min, num max) {
    final current = this ?? 0;
    return current >= min && current <= max;
  }

  /// First N words of lorem ipsum text, where N is this number.
  String generateLoremIpsumWords() {
    if (this == null || this! <= 0) return '';
    const words = [
      'Lorem',
      'ipsum',
      'dolor',
      'sit',
      'amet,',
      'consectetur',
      'adipiscing',
      'elit,',
      'sed',
      'do',
      'eiusmod',
      'tempor',
      'incididunt',
      'ut',
      'labore',
      'et',
      'dolore',
      'magna',
      'aliqua.',
      'Ut',
      'enim',
      'ad',
      'minim',
      'veniam,',
      'quis',
      'nostrud',
      'exercitation',
      'ullamco',
      'laboris',
      'nisi',
      'ut',
      'aliquip',
      'ex',
      'ea',
      'commodo',
      'consequat.',
    ];
    final count = this!.toInt();
    final buffer = StringBuffer();
    for (var i = 0; i < count; i++) {
      if (i > 0) buffer.write(' ');
      buffer.write(words[i % words.length]);
    }
    return buffer.toString();
  }

  /// Generates random integers between `min` and `max` (exclusive upper bound).
  List<num> randomList({int min = 0, int max = 100, int? seed}) {
    if (this == null || this! <= 0) return [];
    final random = math.Random(seed);
    final count = this!.toInt();
    final range = max - min;
    if (range <= 0) return List<num>.filled(count, min);
    return List<num>.generate(count, (_) => min + random.nextInt(range));
  }

  /// Formats the number, adding [prefix]/[suffix] when above [max].
  String formatWithMax({
    required num max,
    String? prefix,
    String? suffix,
    int decimalPlaces = 0,
    String Function(num value)? customFormat,
  }) {
    if (this == null) return '';
    final current = this!;
    if (customFormat != null) return customFormat(current);

    final roundedValue = decimalPlaces > 0
        ? current.toStringAsFixed(decimalPlaces)
        : current.toString();

    if (current > max) {
      return '${prefix ?? ''}$roundedValue${suffix ?? ''}';
    }
    return roundedValue;
  }
}
