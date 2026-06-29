import 'package:flutter/material.dart';

/// Semantic typography scale for kit widgets.
abstract final class UITypography {
  static TextStyle h1(Color color, {String? fontFamily}) => TextStyle(
    fontSize: 36,
    fontWeight: FontWeight.w800,
    height: 40 / 36,
    letterSpacing: -0.4,
    color: color,
    fontFamily: fontFamily,
  );

  static TextStyle h2(Color color, {String? fontFamily}) => TextStyle(
    fontSize: 30,
    fontWeight: FontWeight.w700,
    height: 36 / 30,
    letterSpacing: -0.3,
    color: color,
    fontFamily: fontFamily,
  );

  static TextStyle h3(Color color, {String? fontFamily}) => TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    height: 32 / 24,
    letterSpacing: -0.2,
    color: color,
    fontFamily: fontFamily,
  );

  static TextStyle h4(Color color, {String? fontFamily}) => TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    height: 28 / 20,
    color: color,
    fontFamily: fontFamily,
  );

  static TextStyle body(Color color, {String? fontFamily}) => TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.5,
    color: color,
    fontFamily: fontFamily,
  );

  static TextStyle small(Color color, {String? fontFamily}) => TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    height: 1.43,
    color: color,
    fontFamily: fontFamily,
  );

  static TextStyle muted(Color color, {String? fontFamily}) => TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.43,
    color: color,
    fontFamily: fontFamily,
  );

  static TextStyle label(Color color, {String? fontFamily}) => TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.4,
    color: color,
    fontFamily: fontFamily,
  );
}
