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
    canvas.clipRect(Rect.fromLTWH(0, 0, size.width, size.height));

    for (RowConfig row in sheetController.paintConfig.visibleRows) {
      bool rowSelected = sheetController.selection.isRowSelected(row.rowIndex);
      bool allRowSelected = sheetController.selection.isAllRowSelected(row.rowIndex);

      TextStyle textStyle = allRowSelected ? defaultHeaderTextStyleSelectedAll : rowSelected ? defaultHeaderTextStyleSelected : defaultHeaderTextStyle;

      if(allRowSelected) {
        Paint backgroundPaint = Paint()
          ..color = const Color(0xff2456cb)
          ..style = PaintingStyle.fill;

        canvas.drawRect(row.rect, backgroundPaint);
      } else if (rowSelected) {
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
        ..isAntiAlias = false
        ..style = PaintingStyle.stroke;

      canvas.drawRect(row.rect, borderPaint);

      TextPainter textPainter = TextPainter(
        textAlign: TextAlign.center,
        text: TextSpan(text: row.value, style: textStyle),
        textDirection: TextDirection.ltr,
      );

      textPainter.layout(minWidth: rowHeadersWidth, maxWidth: rowHeadersWidth);
      textPainter.paint(canvas, row.rect.centerLeft - Offset(0, textPainter.height / 2));
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
