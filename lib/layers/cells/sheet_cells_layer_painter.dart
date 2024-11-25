import 'dart:math';

import 'package:flutter/material.dart';
import 'package:sheets/core/cell_properties.dart';
import 'package:sheets/core/config/sheet_constants.dart';
import 'package:sheets/core/sheet_style.dart';
import 'package:sheets/core/values/sheet_text_span.dart';
import 'package:sheets/core/viewport/sheet_viewport_content_manager.dart';
import 'package:sheets/core/viewport/viewport_item.dart';
import 'package:sheets/layers/shared_paints.dart';
import 'package:sheets/utils/edge_visibility.dart';
import 'package:sheets/utils/extensions/rect_extensions.dart';
import 'package:sheets/utils/extensions/text_span_extensions.dart';
import 'package:sheets/utils/text_rotation.dart';
import 'package:sheets/utils/text_vertical_align.dart';

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
    required SheetViewportContentManager viewportContent,
    EdgeInsets? padding,
  })  : _viewportContent = viewportContent,
        _padding = padding ?? const EdgeInsets.all(3);

  late SheetViewportContentManager _viewportContent;
  final EdgeInsets _padding;

  void update(SheetViewportContentManager viewportContent) {
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

      if (cell.properties.style.border != null) {
        borderedCells.add(cell);
      }
    }

    _paintMesh(canvas, size);

    for (ViewportCell cell in borderedCells) {
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

    TextAlign textAlign = properties.visibleTextAlign;
    TextRotation textRotation = cellStyle.rotation;
    TextSpan textSpan = richText.toTextSpan();
    if (textRotation == TextRotation.vertical) {
      textSpan = textSpan.applyDivider('\n');
    }

    TextPainter textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
      textAlign: textAlign,
    );

    // Use cell's width minus padding for text layout
    double cellWidth = cell.rect.width - _padding.horizontal;
    double cellHeight = cell.rect.height - _padding.vertical;
    textPainter.layout();

    // Calculate the size of the rotated text's bounding box
    double angle = textRotation.angle;
    double angleRad = angle * pi / 180;
    double cosTheta = cos(angleRad).abs();
    double sinTheta = sin(angleRad).abs();
    double rotatedWidth = textPainter.width * cosTheta + textPainter.height * sinTheta;
    double rotatedHeight = textPainter.width * sinTheta + textPainter.height * cosTheta;

    // Adjust xOffset and yOffset based on alignment
    // Horizontal Alignment
    double xOffset;
    switch (textAlign) {
      case TextAlign.justify:
      case TextAlign.left:
      case TextAlign.start:
        xOffset = _padding.left;
      case TextAlign.center:
        xOffset = _padding.left + (cellWidth - rotatedWidth) / 2;
      case TextAlign.right:
      case TextAlign.end:
        xOffset = _padding.left + (cellWidth - rotatedWidth);
    }

    // Vertical Alignment
    double yOffset;
    TextVerticalAlign verticalAlign = cellStyle.verticalAlign;
    if (verticalAlign == TextVerticalAlign.top) {
      yOffset = _padding.top;
    } else if (verticalAlign == TextVerticalAlign.center) {
      yOffset = _padding.top + (cellHeight - rotatedHeight) / 2;
    } else if (verticalAlign == TextVerticalAlign.bottom) {
      yOffset = _padding.top + (cellHeight - rotatedHeight);
    } else {
      yOffset = _padding.top;
    }

    // Position where the text should be painted
    Offset textPosition = cell.rect.topLeft + Offset(xOffset, yOffset);

    // Save the canvas state
    canvas.save();

    // Clip the canvas to the cell rectangle
    canvas.clipRect(cell.rect);

    if (textRotation == TextRotation.vertical) {
      // Paint the text at the calculated position
      textPainter.paint(canvas, textPosition);
    } else if (angle != 0) {
      // Translate to the center of the rotated bounding box
      canvas.translate(
        textPosition.dx + rotatedWidth / 2,
        textPosition.dy + rotatedHeight / 2,
      );

      // Rotate the canvas
      canvas.rotate(angleRad);

      // Translate back to the top-left of the text
      canvas.translate(-textPainter.width / 2, -textPainter.height / 2);

      // Paint the text at (0,0)
      textPainter.paint(canvas, Offset.zero);
    } else {
      // Paint the text at the calculated position
      textPainter.paint(canvas, textPosition);
    }

    // Restore the canvas state
    canvas.restore();
  }
}
