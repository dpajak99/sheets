import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:sheets/core/config/sheet_constants.dart';
import 'package:sheets/core/sheet_data.dart';

class PinnedBorderPainter {
  const PinnedBorderPainter(this.data);

  final WorksheetData data;

  void paint(Canvas canvas, Size size) {
    final Paint borderPaint = Paint()
      ..color = const Color(0xffb7b7b7)
      ..style = PaintingStyle.fill;

    if (data.pinnedColumnsWidth > 0) {
      canvas.drawRect(
        Rect.fromLTWH(
          rowHeadersWidth + data.pinnedColumnsWidth,
          0,
          pinnedBorderWidth,
          size.height,
        ),
        borderPaint,
      );
    }

    if (data.pinnedRowsHeight > 0) {
      canvas.drawRect(
        Rect.fromLTWH(
          0,
          columnHeadersHeight + data.pinnedRowsHeight,
          size.width,
          pinnedBorderWidth,
        ),
        borderPaint,
      );
    }
  }
}
