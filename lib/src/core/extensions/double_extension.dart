import 'dart:math' show pow;

/// Rounding helpers for [double] values.
extension DoubleExtension on double {
  /// Rounds to [places] decimal places.
  double roundToDecimal({int places = 8}) {
    if (places <= 0) return roundToDouble();
    final mod = pow(10.0, places);
    return ((this * mod).round().toDouble() / mod);
  }
}
