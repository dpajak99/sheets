import 'dart:math';

import 'package:flutter/material.dart';
import 'package:sheets/core/cell_properties.dart';
import 'package:sheets/core/config/sheet_constants.dart';
import 'package:sheets/core/sheet_style.dart';
import 'package:sheets/core/values/sheet_text_span.dart';
import 'package:sheets/core/viewport/sheet_viewport_content.dart';
import 'package:sheets/core/viewport/viewport_item.dart';
import 'package:sheets/layers/shared_paints.dart';
import 'package:sheets/utils/edge_visibility.dart';
import 'package:sheets/utils/extensions/rect_extensions.dart';
import 'package:sheets/utils/text_vertical_align.dart';
import 'package:sheets/widgets/material/toolbar_items/material_toolbar_text_vertical_align_button.dart';

abstract class SheetCellsLayerPainterBase extends ChangeNotifier implements CustomPainter {
  @override
  bool? hitTest(Offset position) => null;

  @override
  SemanticsBuilderCallback? get semanticsBuilder => null;

  @override
  bool shouldRebuildSemantics(covariant CustomPainter oldDelegate) => false;
}

class SheetCellsLayerPainter extends SheetCellsLayerPainterBase {
  SheetCellsLayerPainter({
    required SheetViewportContent viewportContent,
    EdgeInsets? padding,
  }) : _viewportContent = viewportContent, _padding = padding ?? const EdgeInsets.all(3);

  late SheetViewportContent _viewportContent;
  final EdgeInsets _padding;

  void update(SheetViewportContent viewportContent) {
    _viewportContent = viewportContent;
    notifyListeners();
  }

  @override
  void paint(Canvas canvas, Size size) {
    List<ViewportCell> visibleCells = _viewportContent.cells;

    visibleCells.sort((ViewportCell a, ViewportCell b) {
      int aZIndex = a.properties.style.borderZIndex ?? 0;
      int bZIndex = b.properties.style.borderZIndex ?? 0;

      return aZIndex.compareTo(bZIndex);
    });

    canvas.clipRect(Rect.fromLTWH(0, 0, size.width, size.height));

    List<ViewportCell> borderedCells = <ViewportCell>[];

    for (ViewportCell cell in visibleCells) {
      _paintCellBackground(canvas, cell);
      _paintCellText(canvas, cell);

      if(cell.properties.style.border != null) {
        borderedCells.add(cell);
      }
    }

    _paintMesh(canvas, size);

    for(ViewportCell cell in borderedCells) {
      _paintCellBorder(canvas, cell);
    }
  }

  @override
  bool shouldRepaint(covariant SheetCellsLayerPainter oldDelegate) {
    return oldDelegate._viewportContent != _viewportContent || oldDelegate._padding != _padding;
  }
  
  void _paintMesh(Canvas canvas, Size size) {
    canvas.clipRect(Rect.fromLTWH(0, 0, size.width, size.height));
    List<ViewportColumn> visibleColumns = _viewportContent.columns;
    List<ViewportRow> visibleRows = _viewportContent.rows;

    if (visibleColumns.isEmpty || visibleRows.isEmpty) {
      return;
    }

    ViewportColumn lastColumn = visibleColumns.last;
    ViewportRow lastRow = visibleRows.last;

    double maxOffsetRight = min(size.width, lastColumn.rect.right);
    double maxOffsetBottom = min(size.height, lastRow.rect.bottom);

    for (ViewportColumn column in visibleColumns) {
      Rect columnRect = column.rect;
      _paintMeshLine(canvas, Offset(columnRect.right + borderWidth, 0), Offset(columnRect.right + borderWidth, maxOffsetBottom));
    }

    for (ViewportRow row in visibleRows) {
      Rect rowRect = row.rect;
      _paintMeshLine(canvas, Offset(0, rowRect.bottom), Offset(maxOffsetRight, rowRect.bottom));
    }
  }

  void _paintMeshLine(Canvas canvas, Offset startOffset, Offset endOffset) {
    Paint borderPaint = Paint()
      ..color = const Color(0x1F040404)
      ..strokeWidth = borderWidth
      ..isAntiAlias = false
      ..style = PaintingStyle.stroke;

    canvas.drawLine(startOffset, endOffset, borderPaint);
  }

  void _paintCellBackground(Canvas canvas, ViewportCell cell) {
    CellStyle cellStyle = cell.properties.style;

    Paint backgroundPaint = Paint()
      ..color = cellStyle.backgroundColor
      ..isAntiAlias = false
      ..style = PaintingStyle.fill;

    canvas.drawRect(cell.rect.expand(borderWidth), backgroundPaint);
  }

  void _paintCellBorder(Canvas canvas, ViewportCell cell) {
    Border border = Border(
      top: cell.properties.style.border?.top ?? BorderSide.none,
      right: cell.properties.style.border?.right ?? BorderSide.none,
      bottom: cell.properties.style.border?.bottom ?? BorderSide.none,
      left: cell.properties.style.border?.left ?? BorderSide.none,
    );

    SharedPaints.paintBorder(
      canvas: canvas,
      rect: cell.rect,
      border: border,
      edgeVisibility: EdgeVisibility.allVisible(),
    );
  }

  void _paintCellText(Canvas canvas, ViewportCell cell) {
    CellProperties properties = cell.properties;
    CellStyle cellStyle = properties.style;

    SheetRichText richText = properties.visibleRichText;
    if (richText.isEmpty) {
      return;
    }

    TextSpan textSpan = richText.toTextSpan();
    TextAlign textAlign = properties.visibleTextAlign;

    TextPainter textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
      textAlign: textAlign,
    );

    double width = cell.rect.width - _padding.horizontal;
    textPainter.layout(minWidth: width, maxWidth: width);

    // Get vertical alignment (default to top if not set)
    TextVerticalAlign verticalAlign = cellStyle.verticalAlign;

    // Calculate the y-offset based on vertical alignment
    double yOffset;
    double availableHeight = cell.rect.height - _padding.vertical;

    if (verticalAlign == TextVerticalAlign.top || textPainter.height >= availableHeight) {
      yOffset = _padding.top;
    } else if (verticalAlign == TextVerticalAlign.center) {
      yOffset = _padding.top + (availableHeight - textPainter.height) / 2;
    } else if (verticalAlign == TextVerticalAlign.bottom) {
      yOffset = cell.rect.height - _padding.bottom - textPainter.height;
    } else {
      yOffset = _padding.top;
    }

    if (cellStyle.rotationAngleDegrees != 0) {
      Offset position = cell.rect.topLeft + Offset(_padding.left, yOffset);

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
      textPainter.paint(canvas, cell.rect.topLeft + Offset(_padding.left, yOffset));
    }
  }
}
