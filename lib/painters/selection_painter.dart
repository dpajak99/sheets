import 'package:flutter/material.dart';
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
    if (selection is SheetEmptySelection) {
      return;
    }

    ProgramSelectionRectBox? selectionRectBox = sheetController.getProgramSelectionRectBox();
    if (selectionRectBox == null) {
      return;
    }

    if (selectionRectBox.startCellVisible) {
      Paint mainCellPaint = Paint()
        ..color = const Color(0xff3572e3)
        ..strokeWidth = borderWidth * 2
        ..style = PaintingStyle.stroke;

      canvas.drawRect(selectionRectBox.startCellRect, mainCellPaint);
    }

    if (selection is SheetRangeSelection) {
      Paint backgroundPaint = Paint()
        ..color = const Color(0x203572e3)
        ..color = const Color(0x203572e3)
        ..style = PaintingStyle.fill;

      canvas.drawRect(
        Rect.fromPoints(selectionRectBox.topLeft.topLeft, selectionRectBox.bottomRight.bottomRight),
        backgroundPaint,
      );
    }

    if (selection.isCompleted) {
      Rect borderRect = Rect.fromPoints(selectionRectBox.topLeft.topLeft, selectionRectBox.bottomRight.bottomRight);

      Paint selectionPaint = Paint()
        ..color = const Color(0xff3572e3)
        ..strokeWidth = borderWidth
        ..style = PaintingStyle.stroke;

      if (selectionRectBox.hideTopBorder == false) canvas.drawLine(borderRect.topLeft, borderRect.topRight, selectionPaint);
      if (selectionRectBox.hideLeftBorder == false) canvas.drawLine(borderRect.topLeft, borderRect.bottomLeft, selectionPaint);
      if (selectionRectBox.hideBottomBorder == false) canvas.drawLine(borderRect.bottomLeft, borderRect.bottomRight, selectionPaint);
      if (selectionRectBox.hideRightBorder == false) canvas.drawLine(borderRect.topRight, borderRect.bottomRight, selectionPaint);
    }

    if (selection.isCompleted) {
      Paint selectionDotBorderPaint = Paint()
        ..color = const Color(0xffffffff)
        ..style = PaintingStyle.fill;

      canvas.drawCircle(selectionRectBox.bottomRight.bottomRight, 5, selectionDotBorderPaint);

      Paint selectionDotPaint = Paint()
        ..color = const Color(0xff3572e3)
        ..style = PaintingStyle.fill;

      canvas.drawCircle(selectionRectBox.bottomRight.bottomRight, 4, selectionDotPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
