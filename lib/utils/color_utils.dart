import 'package:flutter/material.dart';

class ColorUtils {
  static int colorToInt(Color color) {
    return _floatToInt8(color.a) << 24 |
    _floatToInt8(color.r) << 16 |
    _floatToInt8(color.g) << 8 |
    _floatToInt8(color.b) << 0;
  }

  static int _floatToInt8(double x) {
    return (x * 255.0).round() & 0xff;
  }
}
