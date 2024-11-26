import 'package:flutter/material.dart';
import 'package:sheets/core/config/sheet_constants.dart';
import 'package:sheets/core/viewport/sheet_viewport.dart';
import 'package:sheets/core/viewport/sheet_viewport_content_data.dart';
import 'package:sheets/core/viewport/viewport_item.dart';
import 'package:sheets/layers/shared_paints.dart';
import 'package:sheets/utils/edge_visibility.dart';
import 'package:sheets/utils/extensions/rect_extensions.dart';

abstract class SheetSelectionPaint {
  SheetSelectionPaint({
    this.mainCellVisible = true,
    this.backgroundVisible = true,
  });

  bool mainCellVisible = true;
  bool backgroundVisible = true;

  void paint(SheetViewport viewport, Canvas canvas, Size size);

  void paintMainCell(Canvas canvas, BorderRect rect) {
    SharedPaints.paintBorder(
      canvas: canvas,
      rect: rect,
      edgeVisibility: EdgeVisibility.allVisible(),
      border: Border.all(
        color: const Color(0xff3572e3),
        width: 2,
      ),
    );
  }

  void paintSelectionBackground(Canvas canvas, BorderRect backgroundRect) {
    Paint backgroundPaint = Paint()
      ..color = const Color(0x203572e3)
      ..color = const Color(0x203572e3)
      ..style = PaintingStyle.fill;

    canvas.drawRect(backgroundRect.expand(borderWidth), backgroundPaint);
  }

  void paintSelectionBorder(Canvas canvas, BorderRect rect, EdgeVisibility edgeVisibility) {
    SharedPaints.paintBorder(
      canvas: canvas,
      rect: rect,
      edgeVisibility: edgeVisibility,
      border: Border.all(
        color: const Color(0xff3572e3),
      ),
    );
  }

  void paintFillBorder(Canvas canvas, Rect rect) {
    Paint selectionPaint = Paint()
      ..color = const Color(0xff818181)
      ..strokeWidth = borderWidth
      ..isAntiAlias = false
      ..strokeCap = StrokeCap.square
      ..style = PaintingStyle.stroke;

    double dashWidth = 4;
    double dashSpace = 4;

    // Draw top dashes
    for (double x = rect.left; x < rect.right; x += dashWidth + dashSpace) {
      canvas.drawLine(Offset(x, rect.top), Offset(x + dashWidth, rect.top), selectionPaint);
    }

    // Draw right dashes
    for (double y = rect.top; y < rect.bottom; y += dashWidth + dashSpace) {
      canvas.drawLine(Offset(rect.right, y), Offset(rect.right, y + dashWidth), selectionPaint);
    }

    // Draw bottom dashes
    for (double x = rect.right; x > rect.left; x -= dashWidth + dashSpace) {
      canvas.drawLine(Offset(x, rect.bottom), Offset(x - dashWidth, rect.bottom), selectionPaint);
    }

    // Draw left dashes
    for (double y = rect.bottom; y > rect.top; y -= dashWidth + dashSpace) {
      canvas.drawLine(Offset(rect.left, y), Offset(rect.left, y - dashWidth), selectionPaint);
    }
  }
}
