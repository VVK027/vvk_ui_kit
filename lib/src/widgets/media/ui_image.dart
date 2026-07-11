import 'dart:convert';

import 'package:flutter/material.dart';
import '../../icons/ui_svg_image.dart';
import '../feedback/ui_skeleton_placeholder.dart';
import 'ui_image_scope.dart';

/// Unified image widget for assets, network URLs, SVG, and base64 sources.
class UIImage extends StatelessWidget {
  static final RegExp _imageExtRegExp = RegExp(
    r'\.(svg|png|jpe?g|webp|gif)(\?.*)?$',
    caseSensitive: false,
  );

  const UIImage(
    this.source, {
    super.key,
    this.isAsset,
    this.width,
    this.height,
    this.fit = BoxFit.contain,
    this.color,
    this.alignment = Alignment.center,
    this.borderRadius,
    this.placeholder,
    this.fallback,
    this.urlTransformer,
    this.placeholderPath,
    this.placeholderColor,
    this.showPlaceholder = false,
    this.allowExtensionlessUrl = false,
    this.networkImageBuilder,
    this.svgBuilder,
  });

  final String source;
  final bool? isAsset;
  final double? width;
  final double? height;
  final BoxFit fit;
  final Color? color;
  final Alignment alignment;
  final BorderRadius? borderRadius;
  final Widget? placeholder;
  final Widget? fallback;
  final String Function(String url)? urlTransformer;
  final String? placeholderPath;
  final Color? placeholderColor;
  final bool showPlaceholder;

  /// When `true`, network URLs without a recognized image file extension are
  /// still treated as raster images (e.g. API/CDN URLs like
  /// `https://cdn.example.com/media/abc123`). Defaults to `false`, which only
  /// accepts URLs matching a known image extension.
  final bool allowExtensionlessUrl;

  /// Optional per-widget override for [UIImageScope.networkImageBuilder].
  final UIImageNetworkBuilder? networkImageBuilder;

  /// Optional per-widget override for [UIImageScope.svgBuilder].
  final UIImageSvgBuilder? svgBuilder;

  UIImage copyWith({
    Key? key,
    String? source,
    bool? isAsset,
    double? width,
    double? height,
    BoxFit? fit,
    Color? color,
    Alignment? alignment,
    BorderRadius? borderRadius,
    Widget? placeholder,
    Widget? fallback,
    String Function(String url)? urlTransformer,
    String? placeholderPath,
    Color? placeholderColor,
    bool? showPlaceholder,
    bool? allowExtensionlessUrl,
    UIImageNetworkBuilder? networkImageBuilder,
    UIImageSvgBuilder? svgBuilder,
  }) {
    return UIImage(
      source ?? this.source,
      key: key ?? this.key,
      isAsset: isAsset ?? this.isAsset,
      width: width ?? this.width,
      height: height ?? this.height,
      fit: fit ?? this.fit,
      color: color ?? this.color,
      alignment: alignment ?? this.alignment,
      borderRadius: borderRadius ?? this.borderRadius,
      placeholder: placeholder ?? this.placeholder,
      fallback: fallback ?? this.fallback,
      urlTransformer: urlTransformer ?? this.urlTransformer,
      placeholderPath: placeholderPath ?? this.placeholderPath,
      placeholderColor: placeholderColor ?? this.placeholderColor,
      showPlaceholder: showPlaceholder ?? this.showPlaceholder,
      allowExtensionlessUrl: allowExtensionlessUrl ?? this.allowExtensionlessUrl,
      networkImageBuilder: networkImageBuilder ?? this.networkImageBuilder,
      svgBuilder: svgBuilder ?? this.svgBuilder,
    );
  }

  bool get _trimmedEmpty => source.trim().isEmpty;
  bool get _isAssetSource => isAsset ?? source.trim().startsWith('assets/');
  bool get _isSvg => source.toLowerCase().endsWith('.svg');
  bool get _isBase64 => source.startsWith('data:image');
  bool get _isValidNetworkFormat =>
      allowExtensionlessUrl || _imageExtRegExp.hasMatch(source);

  ColorFilter? get _colorFilter =>
      color != null ? ColorFilter.mode(color!, BlendMode.srcIn) : null;

  UIImageNetworkBuilder? _resolveNetworkBuilder(BuildContext context) {
    return networkImageBuilder ??
        UIImageScope.maybeOf(context)?.networkImageBuilder;
  }

  UIImageSvgBuilder? _resolveSvgBuilder(BuildContext context) {
    return svgBuilder ?? UIImageScope.maybeOf(context)?.svgBuilder;
  }

  @override
  Widget build(BuildContext context) {
    if (_trimmedEmpty) {
      return _wrap(_fallbackWidget());
    }

    if (_isBase64) {
      return _wrap(_buildBase64Image(source));
    }

    if (_isAssetSource) {
      return _wrap(
        _isSvg
            ? _buildAssetSvg(context, source)
            : _buildAssetImage(source, context),
      );
    }

    if (_isSvg) {
      return _wrap(_buildNetworkSvg(context, source));
    }

    if (!_isValidNetworkFormat) {
      return _wrap(_fallbackWidget());
    }

    final url = urlTransformer?.call(source.trim()) ?? source.trim();
    final uri = Uri.tryParse(url);
    if (uri == null || !uri.isAbsolute) {
      return _wrap(_fallbackWidget());
    }

    final dpr = MediaQuery.devicePixelRatioOf(context);
    return _wrap(_buildNetworkImage(context, url, dpr));
  }

  Widget _wrap(Widget child) {
    final Widget aligned = Container(
      width: width,
      height: height,
      alignment: alignment,
      child: child,
    );
    if (borderRadius != null) {
      return ClipRRect(borderRadius: borderRadius!, child: aligned);
    }
    return aligned;
  }

  Widget _fallbackWidget() {
    return fallback ??
        placeholder ??
        SizedBox(
          width: width,
          height: height,
          child: const Icon(Icons.broken_image_outlined),
        );
  }

  Widget _loadingPlaceholder() {
    return placeholder ?? UISkeletonPlaceholder(width: width, height: height);
  }

  int? _cacheDimension(double? logicalPx, double dpr) {
    if (logicalPx == null || !logicalPx.isFinite) return null;
    final value = (logicalPx * dpr).round();
    return value > 0 ? value : null;
  }

  UIImageSvgParams _svgParams({
    required String source,
    required bool isAsset,
    Widget Function()? placeholderBuilder,
  }) {
    return UIImageSvgParams(
      source: source,
      isAsset: isAsset,
      width: width,
      height: height,
      fit: fit,
      colorFilter: _colorFilter,
      placeholder: placeholderBuilder,
    );
  }

  Widget _buildAssetSvg(BuildContext context, String path) {
    final builder = _resolveSvgBuilder(context);
    if (builder != null) {
      return builder(
        context,
        _svgParams(
          source: path,
          isAsset: true,
          placeholderBuilder: () => _loadingPlaceholder(),
        ),
      );
    }

    return UISvgImage.asset(
      source: path,
      width: width,
      height: height,
      fit: fit,
      alignment: alignment,
      color: color,
      colorFilter: _colorFilter,
      placeholder: () => _loadingPlaceholder(),
    );
  }

  Widget _buildAssetImage(String path, BuildContext context) {
    final dpr = MediaQuery.devicePixelRatioOf(context);
    return Image.asset(
      path,
      width: width,
      height: height,
      fit: fit,
      color: color,
      cacheWidth: _cacheDimension(width, dpr),
      cacheHeight: _cacheDimension(height, dpr),
      errorBuilder: (_, _, _) => _buildPlaceholder(path: path),
    );
  }

  Widget _buildNetworkSvg(BuildContext context, String url) {
    final builder = _resolveSvgBuilder(context);
    if (builder != null) {
      return builder(
        context,
        _svgParams(
          source: url,
          isAsset: false,
          placeholderBuilder: () =>
              showPlaceholder ? _loadingPlaceholder() : const SizedBox.shrink(),
        ),
      );
    }

    return UISvgImage.network(
      source: url,
      width: width,
      height: height,
      fit: fit,
      alignment: alignment,
      color: color,
      colorFilter: _colorFilter,
      showPlaceholder: showPlaceholder,
      placeholder: () =>
          showPlaceholder ? _loadingPlaceholder() : _fallbackWidget(),
    );
  }

  Widget _buildNetworkImage(BuildContext context, String url, double dpr) {
    final params = UIImageNetworkParams(
      url: url,
      width: width,
      height: height,
      fit: fit,
      color: color,
      memCacheWidth: _cacheDimension(width, dpr),
      memCacheHeight: _cacheDimension(height, dpr),
      placeholder: _loadingPlaceholder,
      errorWidget: () => _buildPlaceholder(),
    );

    final builder = _resolveNetworkBuilder(context);
    if (builder != null) {
      return builder(context, params);
    }

    return Image.network(
      url,
      width: width,
      height: height,
      fit: fit,
      color: color,
      cacheWidth: params.memCacheWidth,
      cacheHeight: params.memCacheHeight,
      loadingBuilder: (_, child, progress) {
        if (progress == null) return child;
        return _loadingPlaceholder();
      },
      errorBuilder: (_, _, _) => params.errorWidget(),
    );
  }

  Widget _buildBase64Image(String base64Url) {
    try {
      final base64Str = base64Url.split(',').last;
      final bytes = base64Decode(base64Str);
      return Image.memory(
        bytes,
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (_, _, _) => _fallbackWidget(),
      );
    } catch (_) {
      return _fallbackWidget();
    }
  }

  Widget _buildPlaceholder({String? path}) {
    final resolvedPath = placeholderPath ?? path;
    if (resolvedPath == null || resolvedPath.isEmpty) {
      return _fallbackWidget();
    }

    final Widget child = _isSvgPath(resolvedPath)
        ? UISvgImage.asset(
            source: resolvedPath,
            width: width,
            height: height,
            fit: fit,
            color: color,
            colorFilter: _colorFilter,
          )
        : Image.asset(
            resolvedPath,
            width: width,
            height: height,
            fit: fit,
            color: color,
          );

    if (placeholderColor == null) {
      return child;
    }

    return Container(
      alignment: Alignment.center,
      color: placeholderColor,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: child,
    );
  }

  bool _isSvgPath(String value) => value.toLowerCase().endsWith('.svg');
}
