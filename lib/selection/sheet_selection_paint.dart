import 'package:flutter/material.dart';
import 'package:sheets/core/config/sheet_constants.dart';
import 'package:sheets/core/sheet_viewport.dart';
import 'package:sheets/utils/extensions/rect_extensions.dart';

abstract class SheetSelectionPaint {
  bool mainCellVisible = true;
  bool backgroundVisible = true;

  SheetSelectionPaint({
    this.mainCellVisible = true,
    this.backgroundVisible = true,
  });

  void paint(SheetViewport paintConfig, Canvas canvas, Size size);

  void paintMainCell(Canvas canvas, Rect rect) {
    Paint mainCellPaint = Paint()
      ..color = const Color(0xff3572e3)
      ..strokeWidth = borderWidth * 2
      ..isAntiAlias = false
      ..style = PaintingStyle.stroke;

    canvas.drawRect(rect.subtract(borderWidth / 2), mainCellPaint);
  }

  void paintSelectionBackground(Canvas canvas, Rect rect) {
    Paint backgroundPaint = Paint()
      ..color = const Color(0x203572e3)
      ..color = const Color(0x203572e3)
      ..style = PaintingStyle.fill;

    canvas.drawRect(rect, backgroundPaint);
  }

  void paintSelectionBorder(Canvas canvas, Rect rect, {top = true, right = true, bottom = true, left = true}) {
    Paint selectionPaint = Paint()
      ..color = const Color(0xff3572e3)
      ..strokeWidth = borderWidth
      ..isAntiAlias = false
      ..strokeCap = StrokeCap.square
      ..style = PaintingStyle.stroke;

    if (top) canvas.drawLine(rect.topLeft, rect.topRight, selectionPaint);
    if (right) canvas.drawLine(rect.topRight, rect.bottomRight, selectionPaint);
    if (bottom) canvas.drawLine(rect.bottomLeft, rect.bottomRight, selectionPaint);
    if (left) canvas.drawLine(rect.topLeft, rect.bottomLeft, selectionPaint);
  }

  void paintFillBorder(Canvas canvas, Rect rect) {
    Paint selectionPaint = Paint()
      ..color = const Color(0xff818181)
      ..strokeWidth = borderWidth
      ..isAntiAlias = false
      ..strokeCap = StrokeCap.square
      ..style = PaintingStyle.stroke;

    double dashWidth = 4;
    double dashSpace = 4;

    // Draw top dashes
    for (double x = rect.left; x < rect.right; x += dashWidth + dashSpace) {
      canvas.drawLine(Offset(x, rect.top), Offset(x + dashWidth, rect.top), selectionPaint);
    }

    // Draw right dashes
    for (double y = rect.top; y < rect.bottom; y += dashWidth + dashSpace) {
      canvas.drawLine(Offset(rect.right, y), Offset(rect.right, y + dashWidth), selectionPaint);
    }

    // Draw bottom dashes
    for (double x = rect.right; x > rect.left; x -= dashWidth + dashSpace) {
      canvas.drawLine(Offset(x, rect.bottom), Offset(x - dashWidth, rect.bottom), selectionPaint);
    }

    // Draw left dashes
    for (double y = rect.bottom; y > rect.top; y -= dashWidth + dashSpace) {
      canvas.drawLine(Offset(rect.left, y), Offset(rect.left, y - dashWidth), selectionPaint);
    }
  }
}
