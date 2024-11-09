import 'dart:math';

import 'package:flutter/material.dart';
import 'package:sheets/core/config/sheet_constants.dart';
import 'package:sheets/core/viewport/viewport_item.dart';

abstract class SheetCellsLayerPainterBase extends ChangeNotifier implements CustomPainter {
  void paintCellBackground(Canvas canvas, ViewportCell cell) {
    Paint backgroundPaint = Paint()
      ..color = Colors.white
      ..isAntiAlias = false
      ..style = PaintingStyle.fill;

    canvas.drawRect(cell.rect, backgroundPaint);
  }

  void paintCellBorder(Canvas canvas, ViewportCell cell) {
    Paint borderPaint = Paint()
      ..color = const Color(0xffe1e1e1)
      ..strokeWidth = borderWidth
      ..isAntiAlias = false
      ..style = PaintingStyle.stroke;

    canvas.drawRect(cell.rect, borderPaint);
  }

  void paintCellText(Canvas canvas, ViewportCell cell) {
    TextSpan textSpan = cell.properties.value.span.toTextSpan();

    canvas.saveLayer(cell.rect, Paint());
    TextPainter textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
      textAlign: cell.properties.value.span.textAlign,
    );

    double width = cell.rect.width - 10;
    textPainter.layout(minWidth: width, maxWidth: width);
    textPainter.paint(canvas, cell.rect.topLeft + const Offset(5, 5));
    canvas.restore();
  }

  @override
  bool? hitTest(Offset position) => null;

  @override
  SemanticsBuilderCallback? get semanticsBuilder => null;

  @override
  bool shouldRebuildSemantics(covariant CustomPainter oldDelegate) => false;
}

class SheetCellsLayerPainter extends SheetCellsLayerPainterBase {
  SheetCellsLayerPainter({
    required List<ViewportCell> visibleCells,
  }) : _visibleCells = visibleCells;

  late List<ViewportCell> _visibleCells;

  void update(List<ViewportCell> visibleCells) {
    _visibleCells = visibleCells;
    notifyListeners();
  }

  @override
  void paint(Canvas canvas, Size size) {
    canvas.clipRect(Rect.fromLTWH(0, 0, size.width, size.height));

    for (ViewportCell cell in _visibleCells) {
      // paintCellBackground(canvas, cell);
      // paintCellBorder(canvas, cell);
      paintCellText(canvas, cell);
    }
  }

  @override
  bool shouldRepaint(covariant SheetCellsLayerPainter oldDelegate) {
    return oldDelegate._visibleCells != _visibleCells;
  }
}
