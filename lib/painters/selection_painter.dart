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
    SheetSelection selection = sheetController.selection;

    SelectionBounds? selectionBounds = selection.getSelectionBounds();
    if (selectionBounds == null) {
      return;
    }

    if (selectionBounds.isStartCellVisible) {
      Paint mainCellPaint = Paint()
        ..color = const Color(0xff3572e3)
        ..strokeWidth = borderWidth * 2
        ..style = PaintingStyle.stroke;

      canvas.drawRect(selectionBounds.startCellRect, mainCellPaint);
    }

    if (selection.hasBackground) {
      Paint backgroundPaint = Paint()
        ..color = const Color(0x203572e3)
        ..color = const Color(0x203572e3)
        ..style = PaintingStyle.fill;

      canvas.drawRect(selectionBounds.selectionRect.deflate(borderWidth), backgroundPaint);
    }

    if (selection.isCompleted) {
      Paint selectionPaint = Paint()
        ..color = const Color(0xff3572e3)
        ..strokeWidth = borderWidth
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke;

      if (selectionBounds.isTopBorderVisible) canvas.drawLine(selectionBounds.topBorderStart, selectionBounds.topBorderEnd, selectionPaint);
      if (selectionBounds.isRightBorderVisible) canvas.drawLine(selectionBounds.rightBorderStart, selectionBounds.rightBorderEnd, selectionPaint);
      if (selectionBounds.isBottomBorderVisible) canvas.drawLine(selectionBounds.bottomBorderStart, selectionBounds.bottomBorderEnd, selectionPaint);
      if (selectionBounds.isLeftBorderVisible) canvas.drawLine(selectionBounds.leftBorderStart, selectionBounds.leftBorderEnd, selectionPaint);
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
