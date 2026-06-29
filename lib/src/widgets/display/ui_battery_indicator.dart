import 'package:flutter/material.dart';
import 'package:vvk_ui_kit/src/widgets/text/ui_text.dart';

/// Visual style for [UIBatteryIndicator].
enum BatteryIndicatorStyle {
  /// Flat fill style.
  flat,

  /// Skeuomorphic style with depth and highlights.
  skeumorphism,
}

/// Custom-painted battery level indicator.
class UIBatteryIndicator extends StatefulWidget {
  final BatteryIndicatorStyle style;
  final double ratio;
  final Color mainColor;
  final bool colorful;
  final bool showPercentSlide;
  final bool showPercentNum;
  final double size;
  final double percentNumSize;
  final int batteryLevel;
  final Widget? percentChild;

  const UIBatteryIndicator({
    super.key,
    this.batteryLevel = 25,
    this.style = BatteryIndicatorStyle.flat,
    this.ratio = 2.5,
    this.mainColor = Colors.black,
    this.colorful = true,
    this.showPercentNum = true,
    this.showPercentSlide = true,
    required this.percentNumSize,
    this.size = 14.0,
    this.percentChild,
  });

  UIBatteryIndicator copyWith({
    Key? key,
    int? batteryLevel,
    BatteryIndicatorStyle? style,
    double? ratio,
    Color? mainColor,
    bool? colorful,
    bool? showPercentNum,
    bool? showPercentSlide,
    double? percentNumSize,
    double? size,
    Widget? percentChild,
  }) {
    return UIBatteryIndicator(
      key: key ?? this.key,
      batteryLevel: batteryLevel ?? this.batteryLevel,
      style: style ?? this.style,
      ratio: ratio ?? this.ratio,
      mainColor: mainColor ?? this.mainColor,
      colorful: colorful ?? this.colorful,
      showPercentNum: showPercentNum ?? this.showPercentNum,
      showPercentSlide: showPercentSlide ?? this.showPercentSlide,
      percentNumSize: percentNumSize ?? this.percentNumSize,
      size: size ?? this.size,
      percentChild: percentChild ?? this.percentChild,
    );
  }

  @override
  State<UIBatteryIndicator> createState() => _BatteryIndicatorState();
}

class _BatteryIndicatorState extends State<UIBatteryIndicator> {
  late int batteryLv;

  @override
  void initState() {
    super.initState();
    batteryLv = widget.batteryLevel;
  }

  @override
  void didUpdateWidget(covariant UIBatteryIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.batteryLevel != widget.batteryLevel) {
      batteryLv = widget.batteryLevel;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.size,
      width: widget.size * widget.ratio,
      child: CustomPaint(
        painter: UIBatteryIndicatorPainter(
          batteryLv,
          widget.style,
          widget.showPercentSlide,
          widget.colorful,
          widget.mainColor,
        ),
        child: Center(
          child: Padding(
            padding: EdgeInsets.only(
              right: widget.style == BatteryIndicatorStyle.flat
                  ? 0.0
                  : widget.size * widget.ratio * 0.04,
            ),
            child: widget.showPercentNum
                ? widget.percentChild ??
                      UIText('$batteryLv%', size: widget.percentNumSize)
                : const SizedBox.shrink(),
          ),
        ),
      ),
    );
  }
}

/// Custom painter that draws the battery body, fill level, and optional percent label.
class UIBatteryIndicatorPainter extends CustomPainter {
  UIBatteryIndicatorPainter(
    this.batteryLv,
    this.style,
    this.showPercentSlide,
    this.colorful,
    this.mainColor,
  );

  int batteryLv;
  BatteryIndicatorStyle style;
  bool colorful;
  bool showPercentSlide;
  Color mainColor;

  @override
  void paint(Canvas canvas, Size size) {
    if (style == BatteryIndicatorStyle.flat) {
      canvas.drawRRect(
        RRect.fromLTRBR(
          0.0,
          size.height * 0.05,
          size.width,
          size.height * 0.95,
          const Radius.circular(100.0),
        ),
        Paint()
          ..color = mainColor
          ..strokeWidth = 0.5
          ..style = PaintingStyle.stroke,
      );

      if (showPercentSlide) {
        canvas.clipRect(
          Rect.fromLTWH(
            0.0,
            size.height * 0.05,
            size.width * fixedBatteryLv / 100,
            size.height * 0.95,
          ),
        );

        final offset = size.height * 0.1;

        canvas.drawRRect(
          RRect.fromLTRBR(
            offset,
            size.height * 0.05 + offset,
            size.width - offset,
            size.height * 0.95 - offset,
            const Radius.circular(100.0),
          ),
          Paint()
            ..color = colorful ? getBatteryLvColor : mainColor
            ..style = PaintingStyle.fill,
        );
      }
    } else {
      canvas.drawRRect(
        RRect.fromLTRBR(
          0.0,
          size.height * 0.05,
          size.width * 0.92,
          size.height * 0.95,
          Radius.circular(size.height * 0.1),
        ),
        Paint()
          ..color = mainColor
          ..strokeWidth = 0.8
          ..style = PaintingStyle.stroke,
      );

      canvas.drawRRect(
        RRect.fromLTRBR(
          size.width * 0.92,
          size.height * 0.25,
          size.width,
          size.height * 0.75,
          Radius.circular(size.height * 0.1),
        ),
        Paint()
          ..color = mainColor
          ..style = PaintingStyle.fill,
      );

      if (showPercentSlide) {
        canvas.clipRect(
          Rect.fromLTWH(
            0.0,
            size.height * 0.05,
            size.width * 0.92 * fixedBatteryLv / 100,
            size.height * 0.95,
          ),
        );

        final offset = size.height * 0.1;

        canvas.drawRRect(
          RRect.fromLTRBR(
            offset,
            size.height * 0.05 + offset,
            size.width * 0.92 - offset,
            size.height * 0.95 - offset,
            Radius.circular(size.height * 0.1),
          ),
          Paint()
            ..color = colorful ? getBatteryLvColor : mainColor
            ..style = PaintingStyle.fill,
        );
      }
    }
  }

  double get fixedBatteryLv => batteryLv.clamp(0, 100).toDouble();

  Color get getBatteryLvColor {
    if (batteryLv >= 60) {
      return Colors.green;
    }
    if (batteryLv >= 20) {
      return Colors.orange;
    }
    return Colors.red;
  }

  @override
  bool shouldRepaint(covariant UIBatteryIndicatorPainter oldDelegate) {
    return oldDelegate.batteryLv != batteryLv ||
        oldDelegate.style != style ||
        oldDelegate.showPercentSlide != showPercentSlide ||
        oldDelegate.colorful != colorful ||
        oldDelegate.mainColor != mainColor;
  }
}
