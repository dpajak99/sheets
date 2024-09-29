import 'package:flutter/material.dart';
import 'package:sheets/controller/selection/types/sheet_selection.dart';
import 'package:sheets/sheet_constants.dart';
import 'package:sheets/controller/sheet_controller.dart';

class SelectionPainter extends CustomPainter {
  final SheetController sheetController;

  SelectionPainter({
    required this.sheetController,
  });

  @override
  void paint(Canvas canvas, Size size) {
    canvas.clipRect(Rect.fromLTWH(rowHeadersWidth - borderWidth, columnHeadersHeight - borderWidth, size.width, size.height));

    SheetSelectionPaint selectionPaint = sheetController.selectionController.selection.paint;
    selectionPaint.paint(sheetController.visibilityController, canvas, size);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }

  @override
  bool? hitTest(Offset position) {
    return false;
  }
}
