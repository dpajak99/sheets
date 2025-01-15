import 'dart:math';

import 'package:flutter/material.dart';
import 'package:sheets/core/config/sheet_constants.dart';
import 'package:sheets/core/data/worksheet.dart';
import 'package:sheets/core/values/sheet_text_span.dart';
import 'package:sheets/core/viewport/sheet_viewport_content_manager.dart';
import 'package:sheets/core/viewport/viewport_item.dart';
import 'package:sheets/layers/sheet/sheet_mesh_layer_painter.dart';
import 'package:sheets/utils/extensions/rect_extensions.dart';
import 'package:sheets/utils/extensions/text_span_extensions.dart';
import 'package:sheets/utils/text_rotation.dart';

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
    EdgeInsets? padding,
  }) : _padding = padding ?? const EdgeInsets.symmetric(horizontal: 3, vertical: 2);

  final EdgeInsets _padding;
  late SheetViewportContentManager _visibleContent;

  void rebuild({
    required SheetViewportContentManager visibleContent,
  }) {
    _visibleContent = visibleContent;
    notifyListeners();
  }

  @override
  void paint(Canvas canvas, Size size) {
    // 1) Partition the visible cells into four groups:
    final List<ViewportCell> allCells = _visibleContent.cells;

    // A) Cells for which BOTH row and column are pinned
    final List<ViewportCell> pinnedCornerCells = allCells.where(
          (cell) => cell.row.isPinned && cell.column.isPinned,
    ).toList();

    // B) Cells where ONLY the row is pinned
    final List<ViewportCell> pinnedRowCells = allCells.where(
          (cell) => cell.row.isPinned && !cell.column.isPinned,
    ).toList();

    // C) Cells where ONLY the column is pinned
    final List<ViewportCell> pinnedColumnCells = allCells.where(
          (cell) => !cell.row.isPinned && cell.column.isPinned,
    ).toList();

    // D) Fully scrollable cells (neither row nor column pinned)
    final List<ViewportCell> scrollableCells = allCells.where(
          (cell) => !cell.row.isPinned && !cell.column.isPinned,
    ).toList();

    // 2) Compute how far pinned columns extend (the right edge)
    final double pinnedColumnsRight = _computePinnedColumnsRight(
      pinnedCornerCells,
      pinnedColumnCells,
    );

    // 3) Compute how far pinned rows extend (the bottom edge)
    final double pinnedRowsBottom = _computePinnedRowsBottom(
      pinnedCornerCells,
      pinnedRowCells,
    );

    // 4) Build four clipping rects:

    // A) The "corner" rect (both pinned row + column),
    //    if pinnedColumnsRight > rowHeadersWidth + borderWidth
    //    AND pinnedRowsBottom > columnHeadersHeight + borderWidth
    final double pinnedCornerWidth =
        pinnedColumnsRight - (rowHeadersWidth + borderWidth);
    final double pinnedCornerHeight =
        pinnedRowsBottom - (columnHeadersHeight + borderWidth);

    final Rect pinnedCornerRect = Rect.fromLTWH(
      rowHeadersWidth + borderWidth,
      columnHeadersHeight + borderWidth,
      max(0, pinnedCornerWidth),
      max(0, pinnedCornerHeight),
    );

    // B) The rect for pinned rows (only row pinned, no pinned column).
    //    We let it span the entire available width unless columns are also pinned.
    //    But we skip the corner area already covered above.
    final Rect pinnedRowsRect = Rect.fromLTWH(
      0,  // We start from x=0 so that pinned rows can cover row headers as well,
      // or you might choose rowHeadersWidth + borderWidth if needed.
      pinnedCornerRect.top + pinnedCornerRect.height, // below the corner
      size.width,
      max(0, size.height - pinnedCornerRect.bottom),
    );

    // C) The rect for pinned columns (only column pinned, no pinned row).
    //    We skip the corner region on top.
    final Rect pinnedColumnsRect = Rect.fromLTWH(
      pinnedCornerRect.left + pinnedCornerRect.width, // to the right of corner
      0,
      max(0, size.width - pinnedCornerRect.right),
      size.height,
    );

    // D) The fully scrollable rect for everything else
    final Rect scrollableRect = Rect.fromLTWH(
      pinnedCornerRect.right,        // to the right of pinned columns
      pinnedCornerRect.bottom,       // below pinned rows
      max(0, size.width - pinnedCornerRect.right),
      max(0, size.height - pinnedCornerRect.bottom),
    );

    // 5) Paint each group in its own clipped region.

    // A) Pinned corner cells (both row + column pinned)
    if (pinnedCornerRect.width > 0 && pinnedCornerRect.height > 0) {
      canvas.save();
      canvas.clipRect(pinnedCornerRect);
      for (final cell in pinnedCornerCells) {
        _paintCellBackground(canvas, cell);
        _paintCellText(canvas, cell);
      }
      SheetMeshLayerPainter(pinnedCornerCells).paint(canvas, size);
      canvas.restore();
    }

    // B) Pinned row cells (row pinned, column scrollable)
    if (pinnedRowsRect.height > 0) {
      canvas.save();
      canvas.clipRect(pinnedColumnsRect);
      for (final cell in pinnedRowCells) {
        print('Paint: ${cell.index}');

        _paintCellBackground(canvas, cell);
        _paintCellText(canvas, cell);
      }
      SheetMeshLayerPainter(pinnedRowCells).paint(canvas, size);
      canvas.restore();
    }

    // C) Pinned column cells (column pinned, row scrollable)
    if (pinnedColumnsRect.width > 0) {
      canvas.save();
      canvas.clipRect(pinnedRowsRect);

      for (final cell in pinnedColumnCells) {
        _paintCellBackground(canvas, cell);
        _paintCellText(canvas, cell);
      }
      SheetMeshLayerPainter(pinnedColumnCells).paint(canvas, size);
      canvas.restore();
    }

    // D) Fully scrollable cells
    canvas.save();
    canvas.clipRect(scrollableRect);
    for (final cell in scrollableCells) {
      _paintCellBackground(canvas, cell);
      _paintCellText(canvas, cell);
    }
    SheetMeshLayerPainter(scrollableCells).paint(canvas, size);
    canvas.restore();
  }


  /// Computes how far pinned columns extend (the right edge).
  /// Includes the corner cells that are pinned by both row and column.
  double _computePinnedColumnsRight(
      List<ViewportCell> pinnedCornerCells,
      List<ViewportCell> pinnedColumnCells,
      ) {
    // Combine corner + pinned-column cells to find the maximum 'rect.right'.
    List<ViewportCell> pinnedCells = [
      ...pinnedCornerCells,
      ...pinnedColumnCells,
    ];
    if (pinnedCells.isEmpty) {
      // If no pinned columns, fallback to the normal left offset
      return rowHeadersWidth + borderWidth;
    }
    return pinnedCells.map((c) => c.rect.right).reduce(max);
  }

  /// Computes how far pinned rows extend (the bottom edge).
  /// Includes the corner cells that are pinned by both row and column.
  double _computePinnedRowsBottom(
      List<ViewportCell> pinnedCornerCells,
      List<ViewportCell> pinnedRowCells,
      ) {
    // Combine corner + pinned-row cells to find the maximum 'rect.bottom'.
    List<ViewportCell> pinnedCells = [
      ...pinnedCornerCells,
      ...pinnedRowCells,
    ];
    if (pinnedCells.isEmpty) {
      // If no pinned rows, fallback to the normal top offset
      return columnHeadersHeight + borderWidth;
    }
    return pinnedCells.map((c) => c.rect.bottom).reduce(max);
  }


  @override
  bool shouldRepaint(covariant SheetCellsLayerPainter oldDelegate) {
    return oldDelegate._visibleContent != _visibleContent || oldDelegate._padding != _padding;
  }

  void _paintCellBackground(Canvas canvas, ViewportCell cell) {
    CellStyle cellStyle = cell.properties.style;

    Paint backgroundPaint = Paint()
      ..color = cellStyle.backgroundColor
      ..style = PaintingStyle.fill;

    canvas.drawRect(cell.rect.expand(borderWidth), backgroundPaint);
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
    TextAlignVertical verticalAlign = cellStyle.verticalAlign;
    if (verticalAlign == TextAlignVertical.top) {
      yOffset = _padding.top;
    } else if (verticalAlign == TextAlignVertical.center) {
      yOffset = _padding.top + (cellHeight - rotatedHeight) / 2;
    } else if (verticalAlign == TextAlignVertical.bottom) {
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
