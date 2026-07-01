/// Utility class for common string operations and validations.
class StringUtils {
  StringUtils._();

  /// Standard email validation pattern.
  static final RegExp emailRegExp = RegExp(
    r'^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,64}$',
  );

  /// Lightweight email validation for simple forms.
  static final RegExp basicEmailRegExp = RegExp(
    r'^[\w-.]+@([\w-.]+\.)+[\w-]{2,4}$',
  );

  /// RFC 5322–inspired email validation for stricter checks.
  static final RegExp enhancedEmailRegExp = RegExp(
    r"(?:[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'"
    r'*+/=?^_`{|}~-]+)*|"(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-'
    r'\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])*")@(?:(?:[a-z0-9](?:[a-z0-9-]*'
    r'[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\[(?:(?:(2(5[0-5]|[0-4]'
    r'[0-9])|1[0-9][0-9]|[1-9]?[0-9]))\.){3}(?:(2(5[0-5]|[0-4][0-9])|1[0-9]'
    r'[0-9]|[1-9]?[0-9])|[a-z0-9-]*[a-z0-9]:(?:[\x01-\x08\x0b\x0c\x0e-\x1f\'
    r'x21-\x5a\x53-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])+)\])',
  );

  /// URL validation pattern.
  static final RegExp urlRegExp = RegExp(
    r'^((?:.|\n)*?)((http:\/\/www\.|https:\/\/www\.|http:\/\/|https:\/\/)?'
    r'[a-z0-9]+([\-\.]{1}[a-z0-9]+)([-A-Z0-9.]+)(/[-A-Z0-9+&@#/%=~_|!:,.;]*)?'
    r'(\?[A-Z0-9+&@#/%=~_|!:,.;]*)?)',
  );

  /// Matches alphanumeric characters and spaces (used for name checks).
  static final RegExp nameRegExp = RegExp(r'[a-zA-Z0-9 ]');

  /// Matches common special characters.
  static final RegExp specialCharRegExp = RegExp(r'[!@#$%^&*(),.?":;~`{}|<>]');

  /// Digits-only phone number (8–13 digits).
  static final RegExp phoneRegExp = RegExp(r'^[0-9]{8,13}$');

  /// Phone number with optional `+` country code prefix.
  static final RegExp phoneWithCountryCodeRegExp = RegExp(
    r'^(\+?\d{1,3})?([\d]{10,15})$',
  );

  /// Username: letters, digits, underscores; minimum 3 characters.
  static final RegExp usernameRegExp = RegExp(r'^[a-zA-Z0-9_]{3,}$');

  /// Collapses consecutive whitespace and newlines.
  static final RegExp removeWhiteSpacesRegExp = RegExp(r'[\s\n]+');

  /// Characters invalid in banners or filenames.
  static final RegExp bannerCharRegExp = RegExp(r'[<>:"/\\|?*]');

  /// Trailing dots at the end of a string.
  static final RegExp dotRegExp = RegExp(r'[.]+$');

  /// Leading whitespace check.
  static final RegExp _leadingWhitespaceRegExp = RegExp(r'^\s');

  /// Trailing whitespace check.
  static final RegExp _trailingWhitespaceRegExp = RegExp(r'\s$');

  static final RegExp _passwordMediumRegExp = RegExp(
    r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d).{6,}$',
  );

  static final RegExp _passwordStrongRegExp = RegExp(
    r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[@$!%*?&]).{8,}$',
  );

  static final RegExp _uppercaseRegExp = RegExp(r'[A-Z]');
  static final RegExp _lowercaseRegExp = RegExp(r'[a-z]');
  static final RegExp _numericRegExp = RegExp(r'[0-9]');
  static final RegExp _specialCharPasswordRegExp = RegExp(
    r"[$&+,:;/=?@#|'<>.^*()_%!-]",
  );

  /// Matches `$` or `'` for Dart string-literal escaping.
  static final RegExp dollarQuoteRegexp = RegExp(r"""(?=[$'])""");

  /// Characters that require escaping in Dart string literals.
  static final RegExp escapeRegExp = RegExp(
    '[\$\'"\\x00-\\x07\\x0E-\\x1F$escapeMapRegexp]',
  );

  static final escapeMapRegexp = _escapeMap.keys.map(getHexLiteral).join();

  /// Whitespace and backslash escape sequences for [escapeDartString].
  static const _escapeMap = {
    '\b': r'\b',
    '\t': r'\t',
    '\n': r'\n',
    '\v': r'\v',
    '\f': r'\f',
    '\r': r'\r',
    '\x7F': r'\x7F',
    r'\': r'\\',
  };

  /// Returns `true` when [value] matches [pattern].
  static bool hasMatch(String? value, RegExp pattern) {
    return value != null && pattern.hasMatch(value);
  }

  /// Returns `true` if [text] contains any special characters.
  static bool containsSpecialCharacters(String text) {
    return specialCharRegExp.hasMatch(text);
  }

  /// Validates [email] against [emailRegExp].
  static bool validEmail(String email) {
    return emailRegExp.hasMatch(email.trim());
  }

  /// Validates [email] against [basicEmailRegExp].
  static bool isValidBasicEmail(String email) {
    return basicEmailRegExp.hasMatch(email.trim());
  }

  /// Validates [email] using the enhanced RFC-inspired pattern.
  static bool isValidEnhancedEmail(String email) {
    return enhancedEmailRegExp.hasMatch(email.trim().toLowerCase());
  }

  /// Validates [url] against [urlRegExp].
  static bool isValidUrl(String url) {
    return urlRegExp.hasMatch(url);
  }

  /// Validates a digits-only phone number (8–13 digits).
  static bool isValidPhone(String phone) {
    return phoneRegExp.hasMatch(phone);
  }

  /// Validates a phone number with an optional country code.
  static bool isValidPhoneWithCountryCode(String phone) {
    return phoneWithCountryCodeRegExp.hasMatch(phone);
  }

  /// Validates [username] (letters, digits, underscores; min 3 chars).
  static bool isValidUsername(String username) {
    return usernameRegExp.hasMatch(username);
  }

  /// Checks if [password] meets minimum length requirements.
  static bool isValidPassword(String password, {int minLength = 8}) {
    return password.length >= minLength;
  }

  /// Validates configurable password strength requirements.
  static bool isPasswordValid(
    String password, {
    int minLength = 6,
    int uppercaseCharCount = 0,
    int lowercaseCharCount = 0,
    int numericCharCount = 0,
    int specialCharCount = 0,
  }) {
    if (password.contains(' ')) return false;
    if (minLength > 0 && password.length < minLength) return false;
    if (uppercaseCharCount > 0 &&
        !_hasMinimumMatches(password, _uppercaseRegExp, uppercaseCharCount)) {
      return false;
    }
    if (lowercaseCharCount > 0 &&
        !_hasMinimumMatches(password, _lowercaseRegExp, lowercaseCharCount)) {
      return false;
    }
    if (numericCharCount > 0 &&
        !_hasMinimumMatches(password, _numericRegExp, numericCharCount)) {
      return false;
    }
    if (specialCharCount > 0 &&
        !_hasMinimumMatches(
          password,
          _specialCharPasswordRegExp,
          specialCharCount,
        )) {
      return false;
    }
    return true;
  }

  /// Returns `Weak`, `Medium`, or `Strong` based on password complexity.
  static String passwordStrength(String password) {
    if (password.length < 6) return 'Weak';
    if (_passwordMediumRegExp.hasMatch(password)) {
      return _passwordStrongRegExp.hasMatch(password) ? 'Strong' : 'Medium';
    }
    return 'Weak';
  }

  /// Extracts `countryCode` and `number` from a phone string.
  static Map<String, String> extractPhoneNumber(String phone) {
    final match = phoneWithCountryCodeRegExp.firstMatch(phone);
    if (match == null) return const {};
    return {
      'countryCode': match.group(1) ?? '',
      'number': match.group(2) ?? '',
    };
  }

  /// Validates [phone] number length (legacy helper).
  static bool validPhoneNumber(String phone) {
    final length = phone.length;
    return length >= 7 && length <= 13;
  }

  /// Returns `true` when [text] starts with whitespace.
  static bool hasLeadingWhitespace(String text) {
    return text.isNotEmpty && _leadingWhitespaceRegExp.hasMatch(text);
  }

  /// Returns `true` when [text] ends with whitespace.
  static bool hasTrailingWhitespace(String text) {
    return text.isNotEmpty && _trailingWhitespaceRegExp.hasMatch(text);
  }

  /// Validates [text] as a name (no special chars or edge whitespace).
  static bool isValidName(String text) {
    if (text.isEmpty) return true;
    return !containsSpecialCharacters(text) &&
        !hasLeadingWhitespace(text) &&
        !hasTrailingWhitespace(text);
  }

  /// Returns all parts of [name] except the last word.
  static String getFirstName(String? name) {
    final trimmed = name?.trim();
    if (trimmed == null || trimmed.isEmpty) return '';
    final lastSpace = trimmed.lastIndexOf(' ');
    if (lastSpace == -1) return trimmed;
    return trimmed.substring(0, lastSpace);
  }

  /// Returns the last word of [name].
  static String getLastName(String? name) {
    final trimmed = name?.trim();
    if (trimmed == null || trimmed.isEmpty) return '';
    final lastSpace = trimmed.lastIndexOf(' ');
    if (lastSpace == -1) return '';
    return trimmed.substring(lastSpace + 1);
  }

  /// Returns up to two initials from [name].
  static String getShortNamedString(String? name) {
    final trimmed = name?.trim();
    if (trimmed == null || trimmed.isEmpty) return '';

    final parts = trimmed.split(RegExp(r'\s+'));
    final first = parts.first;
    if (parts.length == 1) {
      return first.isNotEmpty ? first[0].toUpperCase() : '';
    }

    final buffer = StringBuffer();
    if (first.isNotEmpty) buffer.write(first[0].toUpperCase());
    if (parts[1].isNotEmpty) buffer.write(parts[1][0].toUpperCase());
    return buffer.toString();
  }

  /// Collapses multiple whitespaces and newlines into a single space.
  static String collapseWhiteSpaces(String text) {
    return text.replaceAll(removeWhiteSpacesRegExp, ' ').trim();
  }

  /// Appends a dot to [text] if it doesn't already end with one.
  static String ensureEndsWithDot(String text) {
    return text.endsWith('.') ? text : '$text.';
  }

  /// Removes trailing dots from [text].
  static String removeTrailingDots(String text) {
    return text.replaceAll(dotRegExp, '');
  }

  /// Alias for [removeTrailingDots].
  static String doesNotEndWithDot(String text) => removeTrailingDots(text);

  /// Sanitizes [text] by replacing invalid characters with underscores.
  static String sanitizedText(String text) {
    return removeTrailingDots(
      text.replaceAll(bannerCharRegExp, '_').trimRight(),
    );
  }

  /// Escapes [value] as a Dart string literal.
  static String escapeDartString(String value) {
    var hasSingleQuote = false;
    var hasDoubleQuote = false;
    var hasDollar = false;
    var canBeRaw = true;

    value = value.replaceAllMapped(escapeRegExp, (match) {
      final char = match[0]!;
      if (char == "'") {
        hasSingleQuote = true;
        return char;
      } else if (char == '"') {
        hasDoubleQuote = true;
        return char;
      } else if (char == r'$') {
        hasDollar = true;
        return char;
      }

      canBeRaw = false;
      return _escapeMap[char] ?? getHexLiteral(char);
    });

    if (!hasDollar) {
      if (hasSingleQuote) {
        if (!hasDoubleQuote) return '"$value"';
      } else {
        return "'$value'";
      }
    }

    if (hasDollar && canBeRaw) {
      if (hasSingleQuote) {
        if (!hasDoubleQuote) return 'r"$value"';
      } else {
        return "r'$value'";
      }
    }

    final string = value.replaceAll(dollarQuoteRegexp, r'\');
    return "'$string'";
  }

  /// Returns the hex-escaped form of a single-character [input].
  static String getHexLiteral(String input) {
    final rune = input.runes.single;
    final value = rune.toRadixString(16).toUpperCase().padLeft(2, '0');
    return '\\x$value';
  }

  /// Returns `true` when [value] contains at least one uppercase letter.
  static bool hasUppercase(String value) => _uppercaseRegExp.hasMatch(value);

  /// Returns `true` when [value] contains at least one lowercase letter.
  static bool hasLowercase(String value) => _lowercaseRegExp.hasMatch(value);

  /// Returns `true` when [value] contains at least one digit.
  static bool hasDigit(String value) => _numericRegExp.hasMatch(value);

  /// Returns `true` when [value] contains at least one special character.
  static bool hasSpecialCharacter(String value) =>
      _specialCharPasswordRegExp.hasMatch(value);

  static bool _hasMinimumMatches(String value, RegExp pattern, int minimum) {
    if (minimum <= 0) return true;
    var count = 0;
    for (final _ in pattern.allMatches(value)) {
      if (++count >= minimum) return true;
    }
    return false;
  }
}
