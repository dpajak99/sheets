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
    for (CellConfig cell in sheetController.paintConfig.visibleCells) {
      Paint backgroundPaint = Paint()
        ..color = Colors.white
        ..style = PaintingStyle.fill;

      canvas.drawRect(cell.rect, backgroundPaint);

      Paint borderPaint = Paint()
        ..color = const Color(0xffe1e1e1)
        ..strokeWidth = borderWidth
        ..style = PaintingStyle.stroke;

      canvas.drawRect(cell.rect, borderPaint);

      // Fill cell with text
      TextPainter textPainter = TextPainter(
        text: TextSpan(
          text: '${cell.rowConfig.rowIndex.value}-${cell.columnConfig.columnIndex.value}',
          // text: '',
          style: const TextStyle(
            color: Colors.black,
            fontSize: 12,
          ),
        ),
        textDirection: TextDirection.ltr,
      );

      textPainter.layout();
      textPainter.paint(canvas, cell.rect.topLeft + const Offset(5, 5));
    }
  }

  @override
  bool shouldRepaint(covariant SheetPainter oldDelegate) {
    return true;
  }
}