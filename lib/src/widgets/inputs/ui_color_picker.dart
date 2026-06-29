import 'package:flutter/material.dart';
import 'package:vvk_ui_kit/src/core/extensions/color_extension.dart';
import 'package:vvk_ui_kit/src/widgets/text/ui_text.dart';

/// Material-styled color picker with spectrum, hue slider, and palette swatches.
class UIColorPicker extends StatefulWidget {
  const UIColorPicker({
    super.key,
    required this.value,
    required this.onChanged,
    this.palette = _defaultPalette,
    this.spectrumHeight = 160,
    this.hueHeight = 16,
    this.swatchSize = 28,
    this.showHexField = true,
    this.enabled = true,
    this.spacing = 12,
    this.borderRadius = 12,
    this.backgroundColor,
    this.borderColor,
  });

  final Color value;
  final ValueChanged<Color> onChanged;
  final List<Color> palette;
  final double spectrumHeight;
  final double hueHeight;
  final double swatchSize;
  final bool showHexField;
  final bool enabled;
  final double spacing;
  final double borderRadius;
  final Color? backgroundColor;
  final Color? borderColor;

  static const List<Color> _defaultPalette = [
    Color(0xFFF44336),
    Color(0xFFE91E63),
    Color(0xFF9C27B0),
    Color(0xFF673AB7),
    Color(0xFF3F51B5),
    Color(0xFF2196F3),
    Color(0xFF03A9F4),
    Color(0xFF00BCD4),
    Color(0xFF009688),
    Color(0xFF4CAF50),
    Color(0xFF8BC34A),
    Color(0xFFFFEB3B),
    Color(0xFFFFC107),
    Color(0xFFFF9800),
    Color(0xFFFF5722),
    Color(0xFF795548),
    Color(0xFF9E9E9E),
    Color(0xFF607D8B),
    Color(0xFF000000),
    Color(0xFFFFFFFF),
  ];

  factory UIColorPicker.fromTheme(
    BuildContext context, {
    Key? key,
    required Color value,
    required ValueChanged<Color> onChanged,
    List<Color>? palette,
    double spectrumHeight = 160,
    double hueHeight = 16,
    double swatchSize = 28,
    bool showHexField = true,
    bool enabled = true,
    double spacing = 12,
    double borderRadius = 12,
    Color? backgroundColor,
    Color? borderColor,
  }) {
    final scheme = Theme.of(context).colorScheme;
    return UIColorPicker(
      key: key,
      value: value,
      onChanged: onChanged,
      palette: palette ?? _defaultPalette,
      spectrumHeight: spectrumHeight,
      hueHeight: hueHeight,
      swatchSize: swatchSize,
      showHexField: showHexField,
      enabled: enabled,
      spacing: spacing,
      borderRadius: borderRadius,
      backgroundColor: backgroundColor ?? scheme.surfaceContainerLow,
      borderColor: borderColor ?? scheme.outlineVariant,
    );
  }

  @override
  State<UIColorPicker> createState() => _UIColorPickerState();
}

class _UIColorPickerState extends State<UIColorPicker> {
  late HSVColor _hsv;

  @override
  void initState() {
    super.initState();
    _hsv = HSVColor.fromColor(widget.value);
  }

  @override
  void didUpdateWidget(UIColorPicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      _hsv = HSVColor.fromColor(widget.value);
    }
  }

  void _update(HSVColor next) {
    if (!widget.enabled) return;
    setState(() => _hsv = next);
    widget.onChanged(next.toColor());
  }

  void _onSpectrum(Offset local, Size size) {
    final saturation = (local.dx / size.width).clamp(0.0, 1.0);
    final value = 1 - (local.dy / size.height).clamp(0.0, 1.0);
    _update(_hsv.withSaturation(saturation).withValue(value));
  }

  void _onHue(Offset local, Size size) {
    final hue = 360 * (local.dx / size.width).clamp(0.0, 1.0);
    _update(_hsv.withHue(hue));
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final current = _hsv.toColor();

    return DecoratedBox(
      decoration: BoxDecoration(
        color: widget.backgroundColor,
        borderRadius: BorderRadius.circular(widget.borderRadius),
        border: Border.all(color: widget.borderColor!),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: SizedBox(
                height: widget.spectrumHeight,
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final size = Size(
                      constraints.maxWidth,
                      widget.spectrumHeight,
                    );
                    return GestureDetector(
                      onPanDown: (d) => _onSpectrum(d.localPosition, size),
                      onPanUpdate: (d) => _onSpectrum(d.localPosition, size),
                      child: CustomPaint(
                        painter: _SpectrumPainter(hue: _hsv.hue),
                        child: Stack(
                          children: [
                            Positioned(
                              left: (_hsv.saturation * size.width) - 8,
                              top: ((1 - _hsv.value) * size.height) - 8,
                              child: _PickerThumb(
                                color: current,
                                enabled: widget.enabled,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            SizedBox(height: widget.spacing),
            SizedBox(
              height: widget.hueHeight,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final size = Size(constraints.maxWidth, widget.hueHeight);
                  return GestureDetector(
                    onPanDown: (d) => _onHue(d.localPosition, size),
                    onPanUpdate: (d) => _onHue(d.localPosition, size),
                    child: CustomPaint(
                      painter: const _HueBarPainter(),
                      child: Stack(
                        children: [
                          Positioned(
                            left: (_hsv.hue / 360 * size.width) - 6,
                            top: 0,
                            bottom: 0,
                            child: _HueThumb(enabled: widget.enabled),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: widget.spacing),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final color in widget.palette)
                  _PaletteSwatch(
                    color: color,
                    selected: color.value == current.value,
                    size: widget.swatchSize,
                    enabled: widget.enabled,
                    onTap: () => _update(HSVColor.fromColor(color)),
                  ),
              ],
            ),
            if (widget.showHexField) ...[
              SizedBox(height: widget.spacing),
              Row(
                children: [
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: current,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: scheme.outlineVariant),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: UIText(
                      current.toHex(),
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontFeatures: const [FontFeature.tabularFigures()],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _PickerThumb extends StatelessWidget {
  const _PickerThumb({required this.color, required this.enabled});

  final Color color;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: 16,
        height: 16,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color,
          border: Border.all(
            color: Colors.white,
            width: 2,
          ),
          boxShadow: const [
            BoxShadow(
              color: Color(0x66000000),
              blurRadius: 2,
            ),
          ],
        ),
      ),
    );
  }
}

class _HueThumb extends StatelessWidget {
  const _HueThumb({required this.enabled});

  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: 12,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: const Color(0x66000000)),
        ),
      ),
    );
  }
}

class _PaletteSwatch extends StatelessWidget {
  const _PaletteSwatch({
    required this.color,
    required this.selected,
    required this.size,
    required this.enabled,
    required this.onTap,
  });

  final Color color;
  final bool selected;
  final double size;
  final bool enabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: enabled ? onTap : null,
        borderRadius: BorderRadius.circular(size / 2),
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color,
            border: Border.all(
              color: selected ? scheme.primary : scheme.outlineVariant,
              width: selected ? 2.5 : 1,
            ),
          ),
        ),
      ),
    );
  }
}

class _SpectrumPainter extends CustomPainter {
  _SpectrumPainter({required this.hue});

  final double hue;

  @override
  void paint(Canvas canvas, Size size) {
    final hueColor = HSVColor.fromAHSV(1, hue, 1, 1).toColor();
    final black = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Colors.transparent, Colors.black],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    final huePaint = Paint()
      ..shader = LinearGradient(
        colors: [Colors.white, hueColor],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), huePaint);
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), black);
  }

  @override
  bool shouldRepaint(covariant _SpectrumPainter oldDelegate) {
    return oldDelegate.hue != hue;
  }
}

class _HueBarPainter extends CustomPainter {
  const _HueBarPainter();

  @override
  void paint(Canvas canvas, Size size) {
    const colors = [
      Color(0xFFFF0000),
      Color(0xFFFFFF00),
      Color(0xFF00FF00),
      Color(0xFF00FFFF),
      Color(0xFF0000FF),
      Color(0xFFFF00FF),
      Color(0xFFFF0000),
    ];
    final paint = Paint()
      ..shader = LinearGradient(colors: colors).createShader(
        Rect.fromLTWH(0, 0, size.width, size.height),
      );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, size.width, size.height),
        const Radius.circular(8),
      ),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
