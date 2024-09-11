import 'package:flutter/material.dart';
import 'package:sheets/controller/selection.dart';
import 'package:sheets/sheet_constants.dart';
import 'package:sheets/controller/sheet_controller.dart';

class SelectionPainter extends CustomPainter {
  final SheetController sheetController;

  SelectionPainter({
    required this.sheetController,
  });

  @override
  void paint(Canvas canvas, Size size) {
    canvas.clipRect(Rect.fromLTWH(-borderWidth, -borderWidth, size.width, size.height));

    SheetSelection selection = sheetController.selection;

    SelectionBounds? selectionBounds = selection.getSelectionBounds();
    if (selectionBounds == null) {
      return;
    }

    if (selectionBounds.isStartCellVisible) {
      Paint mainCellPaint = Paint()
        ..color = const Color(0xff3572e3)
        ..strokeWidth = borderWidth * 2
        ..isAntiAlias = false
        ..style = PaintingStyle.stroke;

      canvas.drawRect(Rect.fromLTWH(
          selectionBounds.startCellRect.left,
          selectionBounds.startCellRect.top,
          selectionBounds.startCellRect.width ,
          selectionBounds.startCellRect.height,
      ), mainCellPaint);
    }

    if (selection.hasBackground) {
      Paint backgroundPaint = Paint()
        ..color = const Color(0x203572e3)
        ..color = const Color(0x203572e3)
        ..style = PaintingStyle.fill;

      canvas.drawRect(selectionBounds.selectionRect, backgroundPaint);
    }

    if (selection.isCompleted) {
      Paint selectionPaint = Paint()
        ..color = const Color(0xff3572e3)
        ..strokeWidth = borderWidth
        ..isAntiAlias = false
        ..strokeCap = StrokeCap.square
        ..style = PaintingStyle.stroke;

      Rect selectionRect = selectionBounds.selectionRect;

      if (selectionBounds.isTopBorderVisible) canvas.drawLine(selectionRect.topLeft, selectionRect.topRight, selectionPaint);
      if (selectionBounds.isRightBorderVisible) canvas.drawLine(selectionRect.topRight, selectionRect.bottomRight, selectionPaint);
      if (selectionBounds.isBottomBorderVisible) canvas.drawLine(selectionRect.bottomLeft, selectionRect.bottomRight, selectionPaint);
      if (selectionBounds.isLeftBorderVisible) canvas.drawLine(selectionRect.topLeft, selectionRect.bottomLeft, selectionPaint);
    }

    if (selection.isCompleted && selection.circleVisible) {
      Paint selectionDotBorderPaint = Paint()
        ..color = const Color(0xffffffff)
        ..style = PaintingStyle.fill;

      canvas.drawCircle(selectionBounds.corners.bottomRight.bottomRight, 5, selectionDotBorderPaint);

      Paint selectionDotPaint = Paint()
        ..color = const Color(0xff3572e3)
        ..style = PaintingStyle.fill;

      canvas.drawCircle(selectionBounds.corners.bottomRight.bottomRight, 4, selectionDotPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
