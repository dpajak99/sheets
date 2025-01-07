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
    canvas.clipRect(Rect.fromLTWH(rowHeadersWidth + borderWidth, columnHeadersHeight + borderWidth, size.width, size.height));

    List<ViewportCell> visibleCells = _visibleContent.cells;

    canvas.clipRect(Rect.fromLTWH(0, 0, size.width, size.height));

    for (ViewportCell cell in visibleCells) {
      _paintCellBackground(canvas, cell);
      _paintCellText(canvas, cell);
    }

    SheetMeshLayerPainter(visibleCells).paint(canvas, size);
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
