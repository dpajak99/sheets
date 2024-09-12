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
    canvas.clipRect(Rect.fromLTWH(0, 0, size.width, size.height));

    for (ColumnConfig column in sheetController.paintConfig.visibleColumns) {
      bool columnSelected = sheetController.selection.isColumnSelected(column.columnIndex);
      bool allColumnSelected = sheetController.selection.isAllColumnSelected(column.columnIndex);

      TextStyle textStyle = allColumnSelected ? defaultHeaderTextStyleSelectedAll : columnSelected ? defaultHeaderTextStyleSelected : defaultHeaderTextStyle;

      if(allColumnSelected) {
        Paint backgroundPaint = Paint()
          ..color = const Color(0xff2456cb)
          ..style = PaintingStyle.fill;

        canvas.drawRect(column.rect, backgroundPaint);
      } else if (columnSelected) {
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
        text: TextSpan(text: column.value, style: textStyle),
        textDirection: TextDirection.ltr,
      );

      textPainter.layout(minWidth: column.columnStyle.width, maxWidth: column.columnStyle.width);
      textPainter.paint(canvas, column.rect.center - Offset(textPainter.width / 2, textPainter.height / 2));
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
