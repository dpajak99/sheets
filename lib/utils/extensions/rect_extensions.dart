import 'package:flutter/material.dart';

extension RectExtensions on Rect {
  Rect subtract(double value) {
    return Rect.fromLTRB(left + value, top + value, right - value, bottom - value);
  }
}
