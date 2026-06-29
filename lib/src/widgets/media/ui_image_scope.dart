import 'package:flutter/material.dart';

/// Parameters passed to [UIImageScope.networkImageBuilder].
class UIImageNetworkParams {
  const UIImageNetworkParams({
    required this.url,
    this.width,
    this.height,
    this.fit = BoxFit.contain,
    this.color,
    this.memCacheWidth,
    this.memCacheHeight,
    required this.placeholder,
    required this.errorWidget,
  });

  final String url;
  final double? width;
  final double? height;
  final BoxFit fit;
  final Color? color;
  final int? memCacheWidth;
  final int? memCacheHeight;
  final Widget Function() placeholder;
  final Widget Function() errorWidget;

  UIImageNetworkParams copyWith({
    String? url,
    double? width,
    double? height,
    BoxFit? fit,
    Color? color,
    int? memCacheWidth,
    int? memCacheHeight,
    Widget Function()? placeholder,
    Widget Function()? errorWidget,
  }) {
    return UIImageNetworkParams(
      url: url ?? this.url,
      width: width ?? this.width,
      height: height ?? this.height,
      fit: fit ?? this.fit,
      color: color ?? this.color,
      memCacheWidth: memCacheWidth ?? this.memCacheWidth,
      memCacheHeight: memCacheHeight ?? this.memCacheHeight,
      placeholder: placeholder ?? this.placeholder,
      errorWidget: errorWidget ?? this.errorWidget,
    );
  }
}

/// Parameters passed to [UIImageScope.svgBuilder].
class UIImageSvgParams {
  const UIImageSvgParams({
    required this.source,
    required this.isAsset,
    this.width,
    this.height,
    this.fit = BoxFit.contain,
    this.colorFilter,
    this.placeholder,
  });

  final String source;
  final bool isAsset;
  final double? width;
  final double? height;
  final BoxFit fit;
  final ColorFilter? colorFilter;
  final Widget Function()? placeholder;

  UIImageSvgParams copyWith({
    String? source,
    bool? isAsset,
    double? width,
    double? height,
    BoxFit? fit,
    ColorFilter? colorFilter,
    Widget Function()? placeholder,
  }) {
    return UIImageSvgParams(
      source: source ?? this.source,
      isAsset: isAsset ?? this.isAsset,
      width: width ?? this.width,
      height: height ?? this.height,
      fit: fit ?? this.fit,
      colorFilter: colorFilter ?? this.colorFilter,
      placeholder: placeholder ?? this.placeholder,
    );
  }
}

/// Builder for network images supplied through [UIImageScope].
typedef UIImageNetworkBuilder =
    Widget Function(BuildContext context, UIImageNetworkParams params);

/// Builder for SVG images supplied through [UIImageScope].
typedef UIImageSvgBuilder =
    Widget Function(BuildContext context, UIImageSvgParams params);

/// Supplies optional image and SVG builders for `UIImage` and related widgets.
///
/// Wrap the app root to configure once:
/// ```dart
/// UIImageScope(
///   networkImageBuilder: (context, params) => CachedNetworkImage(
///     imageUrl: params.url,
///     width: params.width,
///     height: params.height,
///     fit: params.fit,
///     color: params.color,
///     memCacheWidth: params.memCacheWidth,
///     memCacheHeight: params.memCacheHeight,
///     placeholder: (_, _) => params.placeholder(),
///     errorWidget: (_, _, _) => params.errorWidget(),
///   ),
///   svgBuilder: (context, params) => params.isAsset
///       ? SvgPicture.asset(params.source, ...)
///       : SvgPicture.network(params.source, ...),
///   child: MaterialApp(...),
/// )
/// ```
///
/// When builders are omitted, `UIImage` falls back to `Image.network` and
/// `UISvgImage` for simple SVG sources.
class UIImageScope extends InheritedWidget {
  const UIImageScope({
    required super.child,
    this.networkImageBuilder,
    this.svgBuilder,
    super.key,
  });

  final UIImageNetworkBuilder? networkImageBuilder;
  final UIImageSvgBuilder? svgBuilder;

  static UIImageScope? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<UIImageScope>();
  }

  static UIImageScope of(BuildContext context) {
    final scope = maybeOf(context);
    assert(scope != null, 'UIImageScope not found in context');
    return scope!;
  }

  @override
  bool updateShouldNotify(UIImageScope oldWidget) {
    return networkImageBuilder != oldWidget.networkImageBuilder ||
        svgBuilder != oldWidget.svgBuilder;
  }
}
