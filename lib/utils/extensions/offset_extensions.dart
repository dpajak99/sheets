import 'package:flutter/material.dart';

extension OffsetExtensions on Offset {
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

  Offset moveX(double x) {
    return Offset(dx + x, dy);
  }

  Offset moveY(double y) {
    return Offset(dx, dy + y);
  }

  Offset expandEndX(double x) {
    return Offset(dx + x, dy);
  }

  Offset expandEndY(double y) {
    return Offset(dx, dy + y);
  }
}
