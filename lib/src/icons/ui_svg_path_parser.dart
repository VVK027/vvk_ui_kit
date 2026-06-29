import 'dart:ui';

/// Parses an SVG path data string (`d` attribute) into a Flutter [Path].
///
/// This is a minimal parser that supports a subset of SVG commands:
/// * **M/m**: MoveTo
/// * **L/l**: LineTo
/// * **H/h**: Horizontal LineTo
/// * **V/v**: Vertical LineTo
/// * **C/c**: Cubic Bezier CurveTo
/// * **Z/z**: ClosePath
///
/// It is primarily used for single-path brand icons.
///
/// See also `UISvgImage` and `UISvgAssetIcon`.
Path parseSvgPathData(String pathData) {
  final path = Path();
  final tokens = _tokenize(pathData);
  var index = 0;

  double? currentX;
  double? currentY;
  double? startX;
  double? startY;

  double read() => double.parse(tokens[index++]);

  while (index < tokens.length) {
    final command = tokens[index++];
    final isRelative = command == command.toLowerCase();
    final upper = command.toUpperCase();

    switch (upper) {
      case 'M':
        final x = read();
        final y = read();
        currentX = isRelative ? (currentX ?? 0) + x : x;
        currentY = isRelative ? (currentY ?? 0) + y : y;
        startX = currentX;
        startY = currentY;
        path.moveTo(currentX, currentY);
        while (index < tokens.length && !_isCommand(tokens[index])) {
          final lx = read();
          final ly = read();
          currentX = isRelative ? currentX! + lx : lx;
          currentY = isRelative ? currentY! + ly : ly;
          path.lineTo(currentX, currentY);
        }
      case 'L':
        while (index < tokens.length && !_isCommand(tokens[index])) {
          final x = read();
          final y = read();
          currentX = isRelative ? (currentX ?? 0) + x : x;
          currentY = isRelative ? (currentY ?? 0) + y : y;
          path.lineTo(currentX, currentY);
        }
      case 'H':
        while (index < tokens.length && !_isCommand(tokens[index])) {
          final x = read();
          currentX = isRelative ? (currentX ?? 0) + x : x;
          path.lineTo(currentX, currentY!);
        }
      case 'V':
        while (index < tokens.length && !_isCommand(tokens[index])) {
          final y = read();
          currentY = isRelative ? (currentY ?? 0) + y : y;
          path.lineTo(currentX!, currentY);
        }
      case 'C':
        while (index < tokens.length && !_isCommand(tokens[index])) {
          final x1 = read();
          final y1 = read();
          final x2 = read();
          final y2 = read();
          final x = read();
          final y = read();
          final cx1 = isRelative ? (currentX ?? 0) + x1 : x1;
          final cy1 = isRelative ? (currentY ?? 0) + y1 : y1;
          final cx2 = isRelative ? (currentX ?? 0) + x2 : x2;
          final cy2 = isRelative ? (currentY ?? 0) + y2 : y2;
          currentX = isRelative ? (currentX ?? 0) + x : x;
          currentY = isRelative ? (currentY ?? 0) + y : y;
          path.cubicTo(cx1, cy1, cx2, cy2, currentX, currentY);
        }
      case 'Z':
        path.close();
        currentX = startX;
        currentY = startY;
      default:
        throw UnsupportedError('Unsupported SVG path command: $command');
    }
  }

  return path;
}

bool _isCommand(String token) {
  if (token.length != 1) return false;
  final code = token.codeUnitAt(0);
  return (code >= 65 && code <= 90) || (code >= 97 && code <= 122);
}

List<String> _tokenize(String pathData) {
  final buffer = StringBuffer();
  final tokens = <String>[];
  var i = 0;

  void flush() {
    if (buffer.isEmpty) return;
    tokens.add(buffer.toString());
    buffer.clear();
  }

  while (i < pathData.length) {
    final char = pathData[i];
    if (_isCommand(char)) {
      flush();
      tokens.add(char);
      i++;
      continue;
    }
    if (char == ',' || char == ' ' || char == '\n' || char == '\t') {
      flush();
      i++;
      continue;
    }
    if (char == '-' && buffer.isNotEmpty) {
      final last = buffer.toString();
      if (last != 'e' && last != 'E') {
        flush();
      }
    }
    buffer.write(char);
    i++;
  }
  flush();
  return tokens;
}
