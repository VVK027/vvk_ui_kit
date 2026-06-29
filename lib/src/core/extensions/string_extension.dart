import 'dart:convert';
import 'dart:math' as math;
import '../utils/log_util.dart';
import '../utils/string_util.dart';

/// Extensions on [String] for validation, parsing, and case conversion.
extension StringExtension on String {
  static final _alphabetLetterRegExp = RegExp(r'[A-Za-z]');
  static final _alphabetOnlyRegExp = RegExp(r'^[a-zA-Z]+$');
  static final _whitespaceRegExp = RegExp(r'\s+');
  static final _wordBoundaryRegExp = RegExp(r'([a-z0-9])([A-Z])');
  static final _wordSplitRegExp = RegExp(r'[_\-\s]+');

  /// `true` when empty or the literal `"null"`.
  bool get isEmptyOrNull => isEmpty || this == 'null';

  /// `true` when neither empty nor the literal `"null"`.
  bool get isNotEmptyOrNull => !isEmptyOrNull;

  /// Returns this string when non-empty; otherwise [value].
  String validate([String value = '']) {
    final trimmed = trim();
    if (trimmed.isEmpty || trimmed == 'null') return value;
    return this;
  }

  /// Returns an empty string when empty or the literal `"null"`.
  String defaultBlank() => isEmptyOrNull ? '' : this;

  /// Length of the trimmed, validated string.
  int get validatedLength => validate().length;

  /// `true` when the value parses as an [int].
  bool isInt() => isNotEmptyOrNull && int.tryParse(this) != null;

  /// Parses as [int], or `null` on failure.
  int? toInt() => isNotEmptyOrNull ? int.tryParse(this) : null;

  /// `true` when the value parses as a [num].
  bool isNum() => isNotEmptyOrNull && num.tryParse(this) != null;

  /// Parses as [num], or `null` on failure.
  num? toNum() => isNotEmptyOrNull ? num.tryParse(this) : null;

  /// `true` when the value parses as a [DateTime].
  bool isDateTime() => isNotEmptyOrNull && DateTime.tryParse(this) != null;

  /// Parses as [DateTime], or `null` on failure.
  DateTime? toDateTime() => isNotEmptyOrNull ? DateTime.tryParse(this) : null;

  /// `true` when the value parses as a [double].
  bool isDouble() => isNotEmptyOrNull && double.tryParse(this) != null;

  /// Parses as [double], or `null` on failure.
  double? toDoubleOrNull() => isNotEmptyOrNull ? double.tryParse(this) : null;

  /// Case- and whitespace-insensitive equality with [text].
  bool equalsIgnoreCase(String? text) {
    return toLowerCase().trim() == text?.toLowerCase().trim();
  }

  /// Case-insensitive containment check for [text].
  bool containsIgnoreCase(String? text) {
    return text != null && toLowerCase().contains(text.toLowerCase());
  }

  /// Capitalizes only the first character.
  String capitalizeFirstLetter() {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1).toLowerCase()}';
  }

  /// Capitalizes the first letter of each whitespace-separated word.
  String capitalizeAllFirstLetters() {
    return split(
      ' ',
    ).map((word) => word.capitalizeFirstLetter()).join(' ').trim();
  }

  /// `true` when the string starts with whitespace.
  bool checkLeadingWhiteSpace() => StringUtils.hasLeadingWhitespace(this);

  /// `true` when the string ends with whitespace.
  bool checkTrailingWhiteSpace() => StringUtils.hasTrailingWhitespace(this);

  /// Parses as [double], returning `0.0` on failure.
  double toDouble() {
    final parsed = double.tryParse(this);
    if (parsed != null) return parsed;
    LogUtil.logDefaultMsg(
      'StringExtension',
      'toDouble: parsing failed for "$this"',
    );
    return 0.0;
  }

  /// `true` when the string contains at least one letter.
  bool isContainsAlphabetLetter() => _alphabetLetterRegExp.hasMatch(this);

  /// `true` when the string contains only letters.
  bool isAlphabetOnly() => _alphabetOnlyRegExp.hasMatch(this);

  /// Removes all whitespace characters.
  String removeAllWhiteSpace() => replaceAll(_whitespaceRegExp, '');

  /// Returns the string reversed (Unicode-aware via runes).
  String reversed() => String.fromCharCodes(runes.toList().reversed);

  /// `true` when the string starts with [characters].
  bool startsWithCharacters(String characters, {bool matchCase = false}) {
    if (characters.isEmpty || isEmpty) return false;
    if (matchCase) return startsWith(characters);
    return toLowerCase().startsWith(characters.toLowerCase());
  }

  /// `true` when the string is a valid URL.
  bool validateURL() => StringUtils.isValidUrl(this);

  /// Last [n] characters after trim; shorter strings are returned whole.
  String lastChars(int n) {
    if (isEmpty) return '';
    final trimmed = trim();
    if (n >= trimmed.length) return trimmed;
    return trimmed.substring(trimmed.length - n);
  }

  /// `true` when the string decodes to a JSON object/map.
  bool isJsonDecodable() {
    if (isEmpty) return false;
    try {
      final decoded = jsonDecode(this);
      return decoded is Map<String, dynamic>;
    } on FormatException {
      return false;
    }
  }

  /// Initials from each word, limited by [numberOfCharacters].
  String toWordsFirstCharacters({
    int? numberOfCharacters,
    String splitBy = r'\s+',
  }) {
    final trimmed = trim();
    if (trimmed.isEmpty) return '';
    final nameParts = trimmed.toUpperCase().split(RegExp(splitBy));
    final count = math.min(
      nameParts.length,
      numberOfCharacters ?? nameParts.length,
    );
    final buffer = StringBuffer();
    for (var i = 0; i < count; i++) {
      final part = nameParts[i];
      if (part.isNotEmpty) buffer.write(part[0]);
    }
    return buffer.toString();
  }

  /// Counts non-empty whitespace-separated words.
  int countWords() {
    final trimmed = trim();
    if (trimmed.isEmpty) return 0;
    return trimmed.split(_whitespaceRegExp).where((w) => w.isNotEmpty).length;
  }

  /// `true` for a valid email address.
  bool isValidateEmail() => StringUtils.validEmail(this);

  /// `true` for a valid email using the enhanced pattern.
  bool validateEmailEnhanced() => StringUtils.isValidEnhancedEmail(this);

  /// `true` for a digits-only phone number (8–13 digits).
  bool validatePhone() => StringUtils.isValidPhone(this);

  /// `true` for a phone number with optional country code.
  bool validatePhoneWithCountryCode() =>
      StringUtils.isValidPhoneWithCountryCode(this);

  /// Validates password strength with configurable requirements.
  bool isPasswordValidator({
    int minLength = 6,
    int uppercaseCharCount = 0,
    int lowercaseCharCount = 0,
    int numericCharCount = 0,
    int specialCharCount = 0,
  }) {
    return StringUtils.isPasswordValid(
      this,
      minLength: minLength,
      uppercaseCharCount: uppercaseCharCount,
      lowercaseCharCount: lowercaseCharCount,
      numericCharCount: numericCharCount,
      specialCharCount: specialCharCount,
    );
  }

  /// `true` for a valid username.
  bool isValidUsername() => StringUtils.isValidUsername(this);

  /// Returns `Weak`, `Medium`, or `Strong`.
  String passwordStrength() => StringUtils.passwordStrength(this);

  /// Extracts `countryCode` and `number` from a phone string.
  Map<String, String> extractPhoneNumber() =>
      StringUtils.extractPhoneNumber(this);

  /// Converts to `snake_case`.
  String toSnakeCase() {
    return replaceAllMapped(
      _wordBoundaryRegExp,
      (match) => '${match[1]}_${match[2]}',
    ).replaceAll(_whitespaceRegExp, '_').toLowerCase();
  }

  /// Converts to `camelCase`.
  String toCamelCase() {
    final words = _splitWords();
    if (words.isEmpty) return this;
    return words.first.toLowerCase() +
        words.skip(1).map(_capitalizeWord).join();
  }

  /// Converts to `PascalCase`.
  String toPascalCase() => _splitWords().map(_capitalizeWord).join();

  /// Converts to `kebab-case`.
  String toKebabCase() => _splitWords().join('-').toLowerCase();

  /// Converts to `SCREAMING_SNAKE_CASE`.
  String toScreamingSnakeCase() => _splitWords().join('_').toUpperCase();

  /// Converts to Title Case.
  String toTitleCase() => _splitWords().map(_capitalizeWord).join(' ');

  /// Converts to Sentence case.
  String toSentenceCase() {
    final lower = toLowerCase();
    if (lower.isEmpty) return lower;
    return lower[0].toUpperCase() + lower.substring(1);
  }

  List<String> _splitWords() {
    return replaceAllMapped(
          _wordBoundaryRegExp,
          (match) => '${match[1]} ${match[2]}',
        )
        .replaceAll(_wordSplitRegExp, ' ')
        .trim()
        .split(' ')
        .where((word) => word.isNotEmpty)
        .toList();
  }

  String _capitalizeWord(String word) {
    if (word.isEmpty) return word;
    return word[0].toUpperCase() + word.substring(1).toLowerCase();
  }
}
