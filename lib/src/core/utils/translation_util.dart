import 'dart:convert';

import 'package:flutter/services.dart';

import 'log_util.dart';

/// In-memory translation lookup with placeholder replacement.
///
/// Load strings from ARB/JSON assets via `TranslationCache.preload` or construct
/// directly from a map for tests and simple apps.
///
/// ```dart
/// final t = Translations({'greeting': 'Hello, {name}!'});
/// t.tr('greeting', namedArgs: {'name': 'Ada'}); // Hello, Ada!
/// ```
class Translations {
  /// Creates a [Translations] instance backed by the given string map.
  Translations(this._map);

  final Map<String, String> _map;

  /// Translates [key] and replaces placeholders with [args] or [namedArgs].
  ///
  /// * [args]: positional placeholders like `{0}`, `{1}`.
  /// * [namedArgs]: named placeholders like `{name}`, `{count}`.
  ///
  /// Returns [key] unchanged when no translation exists.
  String tr(String key, {Map<String, String>? namedArgs, List<String>? args}) {
    var value = _map[key] ?? key;

    if (args != null) {
      for (var i = 0; i < args.length; i++) {
        value = value.replaceAll('{$i}', args[i]);
      }
    }

    if (namedArgs != null) {
      namedArgs.forEach((placeholder, replacement) {
        value = value.replaceAll('{$placeholder}', replacement);
      });
    }

    return value;
  }

  /// Loads translations for [localeCode] from
  /// `assets/translations/{localeCode}.arb`.
  static Future<Translations> load(String localeCode) async {
    final jsonStr = await rootBundle.loadString(
      'assets/translations/$localeCode.arb',
    );
    final data = jsonDecode(jsonStr) as Map<String, dynamic>;
    final values = <String, String>{};

    data.forEach((key, value) {
      if (value is String) values[key] = value;
    });

    return Translations(values);
  }
}

/// Static cache for preloaded locale translation maps.
@Deprecated(
  'Non-UI utility outside the scope of a UI kit. Scheduled for removal in '
  'v3.0.0. Use flutter_localizations with intl/slang for localization instead. '
  'See doc/MIGRATION.md.',
)
class TranslationCache {
  TranslationCache._();

  static final Map<String, Map<String, String>> _cache = {};

  /// Preloads [supportedLocales] from `assets/translations/{locale}.arb`.
  ///
  /// Skips locales already present in the cache. Failures are logged via
  /// [LogUtil] and do not throw.
  static Future<void> preload(List<String> supportedLocales) async {
    try {
      await Future.wait(
        supportedLocales.map((locale) async {
          if (_cache.containsKey(locale)) return;
          final jsonStr = await rootBundle.loadString(
            'assets/translations/$locale.arb',
          );
          final data = jsonDecode(jsonStr) as Map<String, dynamic>;
          _cache[locale] = data.map((k, v) => MapEntry(k, v.toString()));
        }),
      );
    } catch (e) {
      LogUtil.logDefaultMsg('Error preloading translations:', e.toString());
    }
  }

  /// Returns cached translations for [localeCode], or an empty map.
  static Map<String, String> get(String localeCode) {
    return _cache[localeCode] ?? {};
  }

  /// Clears all cached locale maps (useful in tests).
  static void clear() => _cache.clear();
}
