import 'dart:math';

import 'package:flutter/material.dart';
import 'package:sheets/core/cell_properties.dart';
import 'package:sheets/core/config/sheet_constants.dart';
import 'package:sheets/core/values/sheet_text_span.dart';
import 'package:sheets/core/viewport/viewport_item.dart';
import 'package:sheets/layers/shared_paints.dart';
import 'package:sheets/utils/edge_visibility.dart';
import 'package:sheets/utils/extensions/rect_extensions.dart';
import 'package:sheets/widgets/material/toolbar_items/material_toolbar_text_vertical_align_button.dart';

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

  @override
  bool? hitTest(Offset position) => null;

  @override
  SemanticsBuilderCallback? get semanticsBuilder => null;

  @override
  bool shouldRebuildSemantics(covariant CustomPainter oldDelegate) => false;
}

class CellPainter {
  CellPainter({
    required this.cell,
    this.padding = const EdgeInsets.all(3),
  });

  final ViewportCell cell;
  final EdgeInsets padding;

  void paint(Canvas canvas) {
    _paintBackground(canvas);
    _paintBorder(canvas);
    _paintText(canvas);
  }

  void _paintText(Canvas canvas) {
    CellProperties properties = cell.properties;
    CellStyle cellStyle = properties.style;

    SheetRichText richText = properties.visibleRichText;
    if(richText.isEmpty) {
      return;
    }

    TextSpan textSpan = richText.toTextSpan();
    TextAlign textAlign = properties.visibleTextAlign;

    TextPainter textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
      textAlign: textAlign,
    );

    double width = cell.rect.width - padding.horizontal;
    textPainter.layout(minWidth: width, maxWidth: width);

    // Get vertical alignment (default to top if not set)
    TextVerticalAlign verticalAlign = cellStyle.textVerticalAlign;

    // Calculate the y-offset based on vertical alignment
    double yOffset;
    double availableHeight = cell.rect.height - padding.vertical;

    if (verticalAlign == TextVerticalAlign.top || textPainter.height >= availableHeight) {
      yOffset = padding.top;
    } else if (verticalAlign == TextVerticalAlign.center) {
      yOffset = padding.top + (availableHeight - textPainter.height) / 2;
    } else if (verticalAlign == TextVerticalAlign.bottom) {
      yOffset = cell.rect.height - padding.bottom - textPainter.height;
    } else {
      yOffset = padding.top;
    }

    if (cellStyle.rotationAngleDegrees != 0) {
      Offset position = cell.rect.topLeft + Offset(padding.left, yOffset);

      double textWidth = textPainter.width;
      double textHeight = textPainter.height;
      Offset textCenter = position + Offset(textWidth / 2, textHeight / 2);

      canvas.save();
      canvas.translate(textCenter.dx, textCenter.dy);
      canvas.rotate(cellStyle.rotationAngleDegrees * pi / 180);
      canvas.translate(-textWidth / 2, -textHeight / 2);
      textPainter.paint(canvas, Offset.zero);
      canvas.restore();
    } else {
      textPainter.paint(canvas, cell.rect.topLeft + Offset(padding.left, yOffset));
    }
  }

  void _paintBackground(Canvas canvas) {
    CellStyle cellStyle = cell.properties.style;

    Paint backgroundPaint = Paint()
      ..color = cellStyle.backgroundColor
      ..isAntiAlias = false
      ..style = PaintingStyle.fill;

    canvas.drawRect(cell.rect.expand(borderWidth), backgroundPaint);
  }

  void _paintBorder(Canvas canvas) {
    SharedPaints.paintBorder(
      canvas: canvas,
      rect: cell.rect,
      border: cell.properties.style.border ??
          Border.all(
            color: const Color(0x1F040404),
            width: borderWidth,
          ),
      edgeVisibility: EdgeVisibility.allVisible(),
    );
  }
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
    _visibleCells.sort((ViewportCell a, ViewportCell b) {
      int aZIndex = a.properties.style.borderZIndex ?? 0;
      int bZIndex = b.properties.style.borderZIndex ?? 0;

      return aZIndex.compareTo(bZIndex);
    });

    canvas.clipRect(Rect.fromLTWH(0, 0, size.width, size.height));

    for (ViewportCell cell in _visibleCells) {
      CellPainter cellPainter = CellPainter(cell: cell);
      cellPainter.paint(canvas);
    }
  }

  @override
  bool shouldRepaint(covariant SheetCellsLayerPainter oldDelegate) {
    return oldDelegate._visibleCells != _visibleCells;
  }
}
