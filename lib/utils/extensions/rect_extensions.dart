import 'package:flutter/material.dart';

extension RectExtensions on Rect {
  Rect subtract(double value) {
    return Rect.fromLTRB(left + value, top + value, right - value, bottom - value);
  }

  Rect expand(double value) {
    return Rect.fromLTRB(left - value, top - value, right + value, bottom + value);
  }

  bool within(Offset offset) {
    return offset.dx >= left && offset.dx <= right && offset.dy >= top && offset.dy <= bottom;
  }
}
