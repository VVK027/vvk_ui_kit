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

  /// Loads translations for [localeCode].
  ///
  /// By default reads `assets/translations/{localeCode}.arb`. Override the
  /// resolved asset path with [pathBuilder] (takes precedence) or tweak the
  /// default with [basePath], [assetPrefix], and [fileExtension].
  ///
  /// ```dart
  /// // App ships app_en.arb / app_es.arb under assets/translations/
  /// await Translations.load('en', assetPrefix: 'app_');
  /// // or fully custom:
  /// await Translations.load('en', pathBuilder: (l) => 'lang/$l.json');
  /// ```
  static Future<Translations> load(
    String localeCode, {
    String Function(String locale)? pathBuilder,
    String basePath = 'assets/translations',
    String assetPrefix = '',
    String fileExtension = 'arb',
  }) async {
    final path = resolveAssetPath(
      localeCode,
      pathBuilder: pathBuilder,
      basePath: basePath,
      assetPrefix: assetPrefix,
      fileExtension: fileExtension,
    );
    final jsonStr = await rootBundle.loadString(path);
    final data = jsonDecode(jsonStr) as Map<String, dynamic>;
    final values = <String, String>{};

    data.forEach((key, value) {
      if (value is String) values[key] = value;
    });

    return Translations(values);
  }

  /// Builds the asset path for [localeCode].
  ///
  /// Returns `pathBuilder(localeCode)` when provided; otherwise
  /// `{basePath}/{assetPrefix}{localeCode}.{fileExtension}`.
  static String resolveAssetPath(
    String localeCode, {
    String Function(String locale)? pathBuilder,
    String basePath = 'assets/translations',
    String assetPrefix = '',
    String fileExtension = 'arb',
  }) {
    if (pathBuilder != null) return pathBuilder(localeCode);
    return '$basePath/$assetPrefix$localeCode.$fileExtension';
  }
}

/// Static cache for preloaded locale translation maps.
///
/// This is a static-only utility — [TranslationCache._] prevents instantiation
/// so callers use [preload], [get], and [translationsFor] directly.
class TranslationCache {
  TranslationCache._();

  static final Map<String, Map<String, String>> _cache = {};

  /// Preloads [supportedLocales].
  ///
  /// By default reads `assets/translations/{locale}.arb`. Customize the
  /// resolved asset path with [pathBuilder] (takes precedence) or the default
  /// with [basePath], [assetPrefix], and [fileExtension] — mirroring
  /// [Translations.load].
  ///
  /// ```dart
  /// // App ships app_en.arb / app_es.arb
  /// await TranslationCache.preload(['en', 'es'], assetPrefix: 'app_');
  /// ```
  ///
  /// Skips locales already present in the cache. Failures are logged via
  /// [LogUtil] and do not throw.
  static Future<void> preload(
    List<String> supportedLocales, {
    String Function(String locale)? pathBuilder,
    String basePath = 'assets/translations',
    String assetPrefix = '',
    String fileExtension = 'arb',
  }) async {
    try {
      await Future.wait(
        supportedLocales.map((locale) async {
          if (_cache.containsKey(locale)) return;
          final path = Translations.resolveAssetPath(
            locale,
            pathBuilder: pathBuilder,
            basePath: basePath,
            assetPrefix: assetPrefix,
            fileExtension: fileExtension,
          );
          final jsonStr = await rootBundle.loadString(path);
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

  /// Returns a [Translations] instance backed by the cached map for [localeCode].
  static Translations translationsFor(String localeCode) {
    return Translations(get(localeCode));
  }

  /// Clears all cached locale maps (useful in tests).
  static void clear() => _cache.clear();
}
