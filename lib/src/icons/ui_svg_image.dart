import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'ui_svg_network_loader.dart';
import 'ui_svg_path_parser.dart';

/// Parsed SVG path data with its coordinate bounds.
class UISvgParsedData {
  const UISvgParsedData({required this.paths, required this.viewBox});

  final List<Path> paths;
  final Rect viewBox;
}

/// Extracts path data and view box from a simple SVG document.
UISvgParsedData? parseSvgDocument(String svg) {
  final pathMatches = RegExp(r'd="([^"]+)"', caseSensitive: false)
      .allMatches(svg)
      .map((match) => match.group(1))
      .whereType<String>()
      .toList(growable: false);
  if (pathMatches.isEmpty) return null;

  final paths = <Path>[];
  for (final pathData in pathMatches) {
    try {
      paths.add(parseSvgPathData(pathData));
    } on UnsupportedError {
      return null;
    }
  }

  final viewBox = _parseViewBox(svg) ?? _defaultViewBox;
  return UISvgParsedData(paths: paths, viewBox: viewBox);
}

Rect? _parseViewBox(String svg) {
  final match = RegExp(
    r'''viewBox=["']([^"']+)["']''',
    caseSensitive: false,
  ).firstMatch(svg);
  if (match == null) return null;

  final parts = match.group(1)!.trim().split(RegExp(r'[\s,]+'));
  if (parts.length != 4) return null;

  final left = double.tryParse(parts[0]);
  final top = double.tryParse(parts[1]);
  final width = double.tryParse(parts[2]);
  final height = double.tryParse(parts[3]);
  if (left == null ||
      top == null ||
      width == null ||
      height == null ||
      width <= 0 ||
      height <= 0) {
    return null;
  }

  return Rect.fromLTWH(left, top, width, height);
}

const Rect _defaultViewBox = Rect.fromLTWH(0, 0, 640, 640);

/// Renders simple SVG sources using a lightweight custom painter.
///
/// Supports single- and multi-path SVGs with a subset of path commands.
/// For complex SVGs or full spec coverage, provide `UIImageScope.svgBuilder`.
class UISvgImage extends StatefulWidget {
  const UISvgImage.asset({
    required this.source,
    super.key,
    this.width,
    this.height,
    this.fit = BoxFit.contain,
    this.alignment = Alignment.center,
    this.color,
    this.colorFilter,
    this.placeholder,
    this.showPlaceholder = false,
  }) : _isAsset = true;

  const UISvgImage.network({
    required this.source,
    super.key,
    this.width,
    this.height,
    this.fit = BoxFit.contain,
    this.alignment = Alignment.center,
    this.color,
    this.colorFilter,
    this.placeholder,
    this.showPlaceholder = false,
  }) : _isAsset = false;

  final String source;
  final double? width;
  final double? height;
  final BoxFit fit;
  final Alignment alignment;
  final Color? color;
  final ColorFilter? colorFilter;
  final Widget Function()? placeholder;
  final bool showPlaceholder;

  final bool _isAsset;

  @override
  State<UISvgImage> createState() => _UISvgImageState();
}

class _UISvgImageState extends State<UISvgImage> {
  UISvgParsedData? _data;
  Object? _loadToken;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void didUpdateWidget(covariant UISvgImage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.source != widget.source ||
        oldWidget._isAsset != widget._isAsset) {
      _load();
    }
  }

  Future<void> _load() async {
    final token = Object();
    _loadToken = token;

    try {
      final svg = widget._isAsset
          ? await rootBundle.loadString(widget.source)
          : await fetchSvgFromNetwork(widget.source);
      if (!mounted || _loadToken != token) return;

      setState(() {
        _data = svg == null ? null : parseSvgDocument(svg);
      });
    } catch (_) {
      if (!mounted || _loadToken != token) return;
      setState(() => _data = null);
    }
  }

  @override
  Widget build(BuildContext context) {
    final data = _data;
    if (data == null) {
      return widget.placeholder?.call() ?? const SizedBox.shrink();
    }

    final resolvedColorFilter =
        widget.colorFilter ??
        (widget.color != null
            ? ColorFilter.mode(widget.color!, BlendMode.srcIn)
            : null);

    return CustomPaint(
      size: Size(
        widget.width ?? data.viewBox.width,
        widget.height ?? data.viewBox.height,
      ),
      painter: _UISvgImagePainter(
        data: data,
        fit: widget.fit,
        alignment: widget.alignment,
        colorFilter: resolvedColorFilter,
      ),
    );
  }
}

class _UISvgImagePainter extends CustomPainter {
  const _UISvgImagePainter({
    required this.data,
    required this.fit,
    required this.alignment,
    this.colorFilter,
  });

  final UISvgParsedData data;
  final BoxFit fit;
  final Alignment alignment;
  final ColorFilter? colorFilter;

  @override
  void paint(Canvas canvas, Size size) {
    if (size.isEmpty) return;

    final fittedSizes = applyBoxFit(fit, data.viewBox.size, size);
    final destination = alignment.inscribe(
      fittedSizes.destination,
      Offset.zero & size,
    );
    final scale = fittedSizes.destination.width / data.viewBox.width;

    final paint = Paint()..style = PaintingStyle.fill;
    if (colorFilter != null) {
      paint.colorFilter = colorFilter;
    } else {
      paint.color = const Color(0xFF000000);
    }

    canvas.save();
    canvas.translate(destination.left, destination.top);
    canvas.scale(scale);
    canvas.translate(-data.viewBox.left, -data.viewBox.top);
    for (final path in data.paths) {
      canvas.drawPath(path, paint);
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _UISvgImagePainter oldDelegate) {
    return oldDelegate.data != data ||
        oldDelegate.fit != fit ||
        oldDelegate.alignment != alignment ||
        oldDelegate.colorFilter != colorFilter;
  }
}
