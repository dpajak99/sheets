import 'package:flutter/material.dart';

class ViewportOffsetTransformer {
  final Rect globalRect;

  ViewportOffsetTransformer(this.globalRect);

  Offset globalToLocal(Offset globalOffset) {
    Offset localOffset = Offset(globalOffset.dx - globalRect.left, globalOffset.dy - globalRect.top);

    return Offset(
      localOffset.dx.clamp(0, globalRect.width),
      localOffset.dy.clamp(0, globalRect.height),
    );
  }
}
