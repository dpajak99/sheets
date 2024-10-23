import 'package:flutter/material.dart';

class ViewportOffsetTransformer {
  ViewportOffsetTransformer(this.globalRect);

  final Rect globalRect;

  Offset globalToLocal(Offset globalOffset) {
    Offset localOffset = Offset(globalOffset.dx - globalRect.left, globalOffset.dy - globalRect.top);

    return Offset(
      localOffset.dx.clamp(0, globalRect.width),
      localOffset.dy.clamp(0, globalRect.height),
    );
  }
}
