import 'package:flutter/material.dart';

/// Box-shadow presets inspired by shadcn/ui elevation tokens.
abstract final class UIShadows {
  static const List<BoxShadow> sm = [
    BoxShadow(color: Color(0x1A000000), blurRadius: 2, offset: Offset(0, 1)),
  ];

  static const List<BoxShadow> md = [
    BoxShadow(color: Color(0x1F000000), blurRadius: 6, offset: Offset(0, 4)),
    BoxShadow(color: Color(0x0F000000), blurRadius: 2, offset: Offset(0, 2)),
  ];

  static const List<BoxShadow> lg = [
    BoxShadow(color: Color(0x26000000), blurRadius: 15, offset: Offset(0, 10)),
    BoxShadow(color: Color(0x0D000000), blurRadius: 6, offset: Offset(0, 4)),
  ];
}
