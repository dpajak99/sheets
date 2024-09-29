import 'package:flutter/material.dart';

extension OffsetExtension on Offset {
  Offset reverse() {
    return Offset(dy, dx);
  }

  Offset limit(Offset x, Offset y) {
    return Offset(
      dx.clamp(x.dx, x.dy),
      dy.clamp(y.dx, y.dy),
    );
  }

  Offset limitMin(double x, double y) {
    return Offset(
      dx.clamp(x, double.infinity),
      dy.clamp(y, double.infinity),
    );
  }
}