/// Safe casts for JSON and platform channel payloads under [strict-casts].
class JsonUtils {
  JsonUtils._();

  /// Safely casts [value] to a [Map<String, dynamic>].
  static Map<String, dynamic> asMap(dynamic value) {
    if (value is Map<String, dynamic>) {
      return value;
    }
    if (value is Map) {
      return Map<String, dynamic>.from(value);
    }
    return <String, dynamic>{};
  }

  /// Safely casts [value] to a [List].
  static List<dynamic> asList(dynamic value) {
    if (value is List) {
      return List<dynamic>.from(value);
    }
    return <dynamic>[];
  }

  /// Safely converts [value] to a [bool].
  static bool asBool(dynamic value) {
    if (value is bool) {
      return value;
    }
    if (value is num) {
      return value != 0;
    }
    if (value is String) {
      return value == 'true' || value == '1';
    }
    return false;
  }

  /// Safely converts [value] to a [String].
  static String asString(dynamic value, [String fallback = '']) {
    if (value == null) {
      return fallback;
    }
    return value.toString();
  }

  /// Safely converts [value] to an [int].
  static int asInt(dynamic value, [int fallback = 0]) {
    if (value is int) {
      return value;
    }
    if (value is num) {
      return value.toInt();
    }
    return int.tryParse(value.toString()) ?? fallback;
  }

  /// Safely converts [value] to a [double].
  static double asDouble(dynamic value, [double fallback = 0]) {
    if (value is double) {
      return value;
    }
    if (value is num) {
      return value.toDouble();
    }
    return double.tryParse(value.toString()) ?? fallback;
  }
}
