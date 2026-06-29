/// Contract for models that can serialize to JSON maps.
///
/// Implement on DTOs, API response models, or form state objects that need
/// to be encoded for storage or network transport.
///
/// ```dart
/// class UserDto implements JsonHelper {
///   UserDto({required this.name, required this.email});
///
///   final String name;
///   final String email;
///
///   @override
///   Map<String, dynamic>? toJson() => {'name': name, 'email': email};
/// }
/// ```
abstract class JsonHelper {
  /// Converts this object to a JSON-compatible map.
  ///
  /// Returns `null` when the object cannot or should not be serialized.
  Map<String, dynamic>? toJson();
}
