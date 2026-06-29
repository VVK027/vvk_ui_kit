/// Null-safe helpers and typed accessors for [Map] values.
library;

import 'object_extension.dart';
import 'string_extension.dart';

/// Extensions for nullable [Map] values.
extension MapExtension<K, V> on Map<K, V>? {
  /// `true` when the map is `null` or has no entries.
  bool get isNullOrEmpty => this == null || this!.isEmpty;

  /// `true` when the map is non-null and contains at least one entry.
  bool get isNotNullOrEmpty => !isNullOrEmpty;

  /// Adds [key]: [value] only when [value] is non-null and [key] is absent.
  Map<K, V>? addIfNotNull(K key, V value) {
    if (value != null) this?.putIfAbsent(key, () => value);
    return this;
  }

  /// Returns a copy with each key's first character capitalized.
  Map<String, V> capitalizeKeysFirstCharacter() {
    if (isNullOrEmpty) return {};
    final map = <String, V>{};
    for (final entry in this!.entries) {
      map[entry.key.toString().capitalizeFirstLetter()] = entry.value;
    }
    return map;
  }

  /// Returns entries that satisfy [predicate].
  Map<K, V> filter(bool Function(K key, V value) predicate) {
    if (isNullOrEmpty) return {};
    final map = <K, V>{};
    for (final entry in this!.entries) {
      if (predicate(entry.key, entry.value)) {
        map[entry.key] = entry.value;
      }
    }
    return map;
  }

  /// Merges [map] into this map; overlapping keys use [map]'s values.
  Map<K, V> updateAndJoin(Map<K, V>? map) {
    if (isNullOrEmpty) return map ?? {};
    if (map == null || map.isEmpty) return Map<K, V>.from(this!);
    return {...this!, ...map};
  }
}

/// Key-transformation helpers for `Map<String, V>`.
extension MapStringKeyExtension<V> on Map<String, V>? {
  /// Returns a copy with keys transformed by [newKey].
  Map<String, V> updateKeys(String Function(String key) newKey) {
    if (isNullOrEmpty) return {};
    return {for (final entry in this!.entries) newKey(entry.key): entry.value};
  }
}

/// Typed default-value accessors for non-nullable maps.
extension MapGetOrDefault<K, V> on Map<K, V> {
  /// Value for [key], or [defaultValue] when the key is missing.
  V? getOrDefault(K key, V? defaultValue) =>
      containsKey(key) ? this[key] : defaultValue;

  /// Integer value for [key], with parsing for [String] and [num] values.
  int? getIntOrDefault(K key, int? defaultValue) {
    if (!containsKey(key)) return defaultValue;
    return this[key].toInt(defaultValue: defaultValue);
  }

  /// Numeric value for [key], with parsing for [String] values.
  num? getNumOrDefault(K key, num? defaultValue) {
    if (!containsKey(key)) return defaultValue;
    return this[key].toNum(defaultValue: defaultValue);
  }

  /// Double value for [key], with parsing for [String] and [num] values.
  double? getDoubleOrDefault(K key, double? defaultValue) {
    if (!containsKey(key)) return defaultValue;
    return this[key].toDouble(defaultValue: defaultValue);
  }

  /// String value for [key], or [defaultValue] when missing/null.
  String? getStringOrDefault(K key, String? defaultValue) {
    if (!containsKey(key)) return defaultValue;
    return this[key]?.toString() ?? defaultValue;
  }
}
