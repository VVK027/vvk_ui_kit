/// Extensions on [int] for durations, formatting, and word conversion.
extension IntExtension on int {
  /// Adds a zero prefix to a single-digit number.
  ///
  /// ```dart
  /// print(5.addZeroPrefix()); // "05"
  /// print(10.addZeroPrefix()); // "10"
  /// ```
  String addZeroPrefix() {
    if (this < 10) return '0$this';
    return toString();
  }

  /// Returns a [Duration] representing microseconds.
  Duration microseconds() => Duration(microseconds: this);

  /// Returns a [Duration] representing milliseconds.
  Duration milliseconds() => Duration(milliseconds: this);

  /// Returns a [Duration] representing seconds.
  Duration seconds() => Duration(seconds: this);

  /// Returns a [Duration] representing minutes.
  Duration minutes() => Duration(minutes: this);

  /// Returns a [Duration] representing hours.
  Duration hours() => Duration(hours: this);

  /// Returns a [Duration] representing days.
  Duration days() => Duration(days: this);

  /// Returns a [Duration] representing weeks (7 days per week).
  Duration weeks() => Duration(days: this * 7);

  /// Returns a [Duration] approximating months (30 days per month).
  Duration months() => Duration(days: this * 30);

  /// Returns a [Duration] approximating years (365 days per year).
  Duration years() => Duration(days: this * 365);

  /// Converts the integer to a boolean.
  ///
  /// Returns `true` if the value matches [value], otherwise `false`.
  ///
  /// ```dart
  /// print(1.toBool()); // true
  /// print(0.toBool()); // false
  /// print(5.toBool(5)); // true
  /// ```
  bool toBool([int value = 1]) => this == value;

  /// Retrieves the last [n] digits of the integer.
  ///
  /// ```dart
  /// print(123456.lastDigits(3)); // 456
  /// print(45.lastDigits(5)); // 45
  /// ```
  int lastDigits(int n) {
    final text = toString().trim();
    final charCount = text.length < n ? text.length : n;
    return int.tryParse(text.substring(text.length - charCount)) ?? 0;
  }

  /// Converts [int] into English ordinal representation.
  ///
  /// ```dart
  /// print(1.ordinal); // 1st
  /// print(22.ordinal); // 22nd
  /// print(143.ordinal); // 143rd
  /// print(0.ordinal); // 0th
  /// print(12.ordinal); // 12th
  /// ```
  String get ordinal {
    return switch (this % 100) {
      11 || 12 || 13 => '${this}th',
      _ => switch (this % 10) {
        1 => '${this}st',
        2 => '${this}nd',
        3 => '${this}rd',
        _ => '${this}th',
      },
    };
  }

  /// Converts an integer to an ordinal representation (e.g. 1st, 2nd, 3rd).
  ///
  /// Use [space] to insert a separator between the number and suffix.
  ///
  /// ```dart
  /// print(1.toOrdinal()); // 1st
  /// print(22.toOrdinal(' ')); // 22 nd
  /// ```
  String toOrdinal([String space = '']) {
    if (this >= 11 && this <= 13) return '$this${space}th';

    return switch (this % 10) {
      1 => '$this${space}st',
      2 => '$this${space}nd',
      3 => '$this${space}rd',
      _ => '$this${space}th',
    };
  }

  /// Returns roman number representation of [int] from 1 to 3999.
  ///
  /// ```dart
  /// print(12.roman); // XII
  /// print(455.roman); // CDLV
  /// print(3999.roman); // MMMCMXCIX
  /// ```
  String get roman {
    if (this < 1 || this > 3999) {
      throw RangeError.range(
        this,
        1,
        3999,
        'roman',
        'Value must be between 1 and 3999',
      );
    }

    const romanTable = {
      'M': 1000,
      'CM': 900,
      'D': 500,
      'CD': 400,
      'C': 100,
      'XC': 90,
      'L': 50,
      'XL': 40,
      'X': 10,
      'IX': 9,
      'V': 5,
      'IV': 4,
      'I': 1,
    };

    final result = StringBuffer();
    var n = this;
    for (final entry in romanTable.entries) {
      final numeral = entry.key;
      final value = entry.value;
      while (n >= value) {
        result.write(numeral);
        n -= value;
      }
    }
    return result.toString();
  }

  /// Converts the integer to Roman numerals (supports values from 1 to 3999).
  ///
  /// ```dart
  /// print(2023.toRoman()); // MMXXIII
  /// ```
  String toRoman() => roman;

  /// Converts the integer to words (supports up to 999,999,999,999).
  ///
  /// ```dart
  /// print(123.toWords()); // one hundred and twenty-three
  /// ```
  String toWords() {
    if (this == 0) return 'zero';

    const units = [
      '',
      'one',
      'two',
      'three',
      'four',
      'five',
      'six',
      'seven',
      'eight',
      'nine',
      'ten',
      'eleven',
      'twelve',
      'thirteen',
      'fourteen',
      'fifteen',
      'sixteen',
      'seventeen',
      'eighteen',
      'nineteen',
    ];
    const tens = [
      '',
      '',
      'twenty',
      'thirty',
      'forty',
      'fifty',
      'sixty',
      'seventy',
      'eighty',
      'ninety',
    ];
    const scales = ['', 'thousand', 'million', 'billion'];

    String convertLessThanThousand(int num) {
      if (num == 0) return '';
      if (num < 20) return units[num];
      if (num < 100) {
        return tens[num ~/ 10] + (num % 10 != 0 ? '-${units[num % 10]}' : '');
      }
      return '${units[num ~/ 100]} hundred'
          '${num % 100 != 0 ? ' and ${convertLessThanThousand(num % 100)}' : ''}';
    }

    var absNum = abs();
    var result = '';
    var scaleIndex = 0;

    while (absNum > 0) {
      final chunk = absNum % 1000;
      if (chunk > 0) {
        var chunkWords = convertLessThanThousand(chunk);
        if (scaleIndex > 0 && chunkWords.isNotEmpty) {
          chunkWords += ' ${scales[scaleIndex]}';
        }
        result = '$chunkWords ${result.trim()}';
      }
      absNum ~/= 1000;
      scaleIndex++;
    }

    return (this < 0 ? 'negative ' : '') + result.trim();
  }
}
