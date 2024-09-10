import 'package:flutter/material.dart';
import 'package:sheets/controller/program_config.dart';
import 'package:sheets/sheet_constants.dart';
import 'package:sheets/controller/sheet_controller.dart';

class ColumnHeadersPainter extends CustomPainter {
  final SheetController sheetController;

  ColumnHeadersPainter({
    required this.sheetController,
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (ColumnConfig column in sheetController.paintConfig.visibleColumns) {
      bool columnSelected = sheetController.selection.isColumnSelected(column.columnIndex);

      if (columnSelected) {
        Paint backgroundPaint = Paint()
          ..color = const Color(0xffd6e2fb)
          ..style = PaintingStyle.fill;

        canvas.drawRect(column.rect, backgroundPaint);
      } else {
        Paint backgroundPaint = Paint()
          ..color = const Color(0xffffffff)
          ..style = PaintingStyle.fill;

        canvas.drawRect(column.rect, backgroundPaint);
      }

      Paint borderPaint = Paint()
        ..color = const Color(0xffc4c7c5)
        ..strokeWidth = borderWidth
        ..isAntiAlias = false
        ..style = PaintingStyle.stroke;

      canvas.drawRect(column.rect, borderPaint);

      TextPainter textPainter = TextPainter(
        textAlign: TextAlign.center,
        text: TextSpan(
          text: column.value,
          style: TextStyle(
            color: Colors.black,
            fontWeight: columnSelected ? FontWeight.bold : FontWeight.normal,
            fontSize: 12,
          ),
        ),
        textDirection: TextDirection.ltr,
      );

      textPainter.layout(minWidth: column.columnStyle.width - 10, maxWidth: column.columnStyle.width - 10);
      textPainter.paint(canvas, column.rect.topLeft + const Offset(5, 5));
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}