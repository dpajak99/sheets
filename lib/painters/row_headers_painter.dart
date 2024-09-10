import 'package:flutter/material.dart';
import 'package:sheets/controller/program_config.dart';
import 'package:sheets/sheet_constants.dart';
import 'package:sheets/controller/sheet_controller.dart';

class RowHeadersPainter extends CustomPainter {
  final SheetController sheetController;

  RowHeadersPainter({
    required this.sheetController,
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (RowConfig row in sheetController.paintConfig.visibleRows) {
      bool rowSelected = sheetController.selection.isRowSelected(row.rowIndex);

      if (rowSelected) {
        Paint backgroundPaint = Paint()
          ..color = const Color(0xffd6e2fb)
          ..style = PaintingStyle.fill;

        canvas.drawRect(row.rect, backgroundPaint);
      } else {
        Paint backgroundPaint = Paint()
          ..color = const Color(0xffffffff)
          ..style = PaintingStyle.fill;

        canvas.drawRect(row.rect, backgroundPaint);
      }

      Paint borderPaint = Paint()
        ..color = const Color(0xffc4c7c5)
        ..strokeWidth = borderWidth
        ..style = PaintingStyle.stroke;

      canvas.drawRect(row.rect, borderPaint);

      TextPainter textPainter = TextPainter(
        textAlign: TextAlign.center,
        text: TextSpan(
          text: '${row.rowIndex.value}',
          style: TextStyle(
            color: Colors.black,
            fontWeight: rowSelected ? FontWeight.bold : FontWeight.normal,
            fontSize: 12,
          ),
        ),
        textDirection: TextDirection.ltr,
      );

      textPainter.layout(minWidth: rowHeadersWidth - 10, maxWidth: rowHeadersWidth - 10);
      textPainter.paint(canvas, row.rect.topLeft + const Offset(5, 5));
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}