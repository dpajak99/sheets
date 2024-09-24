import 'package:flutter/material.dart';
import 'package:sheets/controller/program_config.dart';
import 'package:sheets/sheet_constants.dart';
import 'package:sheets/controller/sheet_controller.dart';

class SheetPainter extends CustomPainter {
  final SheetController sheetController;

  SheetPainter({
    required this.sheetController,
  });

  @override
  void paint(Canvas canvas, Size size) {
    canvas.clipRect(Rect.fromLTWH(0, 0, size.width, size.height));

    for (CellConfig cell in sheetController.visibilityController.visibleCells) {
      Paint backgroundPaint = Paint()
        ..color = Colors.white
        ..style = PaintingStyle.fill;

      canvas.drawRect(cell.rect, backgroundPaint);

      Paint borderPaint = Paint()
        ..color = const Color(0xffe1e1e1)
        ..strokeWidth = borderWidth
        ..isAntiAlias = false
        ..style = PaintingStyle.stroke;

      canvas.drawRect(cell.rect, borderPaint);

      // Fill cell with text
      // TextPainter textPainter = TextPainter(
      //   text: TextSpan(text: cell.value, style: defaultTextStyle),
      //   textDirection: TextDirection.ltr,
      //   maxLines: 3,
      // );
      //
      // textPainter.layout();
      // textPainter.paint(canvas, cell.rect.topLeft + const Offset(5, 5));
    }
  }

  @override
  bool shouldRepaint(covariant SheetPainter oldDelegate) {
    return true;
  }
}
