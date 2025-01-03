import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:sheets/core/cell_properties.dart';
import 'package:sheets/core/config/sheet_constants.dart';
import 'package:sheets/core/sheet_style.dart';
import 'package:sheets/core/values/sheet_text_span.dart';
import 'package:sheets/core/viewport/sheet_viewport_content_manager.dart';
import 'package:sheets/core/viewport/viewport_item.dart';
import 'package:sheets/utils/extensions/offset_extensions.dart';
import 'package:sheets/utils/extensions/rect_extensions.dart';
import 'package:sheets/utils/extensions/text_span_extensions.dart';
import 'package:sheets/utils/text_rotation.dart';
import 'package:sheets/widgets/material/material_sheet_theme.dart';

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

    visibleCells.sort((ViewportCell a, ViewportCell b) {
      int aZIndex = a.properties.style.borderZIndex ?? 0;
      int bZIndex = b.properties.style.borderZIndex ?? 0;

      return aZIndex.compareTo(bZIndex);
    });

    canvas.clipRect(Rect.fromLTWH(0, 0, size.width, size.height));

    for (ViewportCell cell in visibleCells) {
      _paintCellBackground(canvas, cell);
      _paintCellText(canvas, cell);
    }

    _paintMesh(canvas, size);
  }

  @override
  bool shouldRepaint(covariant SheetCellsLayerPainter oldDelegate) {
    return oldDelegate._visibleContent != _visibleContent || oldDelegate._padding != _padding;
  }

  void _paintMesh(Canvas canvas, Size size) {
    canvas.clipRect(Rect.fromLTWH(0, 0, size.width, size.height));

    Mesh mesh = Mesh();

    List<ViewportCell> visibleCells = _visibleContent.cells;
    if (visibleCells.isEmpty) {
      return;
    }

    for (ViewportCell cell in visibleCells) {
      Rect cellRect = cell.rect;
      Border? border = cell.properties.style.border;

      mesh.addHorizontal(Line(
        cellRect.topLeft.moveY(-borderWidth),
        cellRect.topRight.moveY(-borderWidth).expandEndX(borderWidth),
        border?.top,
      ));

      mesh.addVertical(Line(
        cellRect.topRight.moveX(borderWidth).expandEndY(-1),
        cellRect.bottomRight.moveX(borderWidth),
        border?.right,
      ));

      mesh.addHorizontal(Line(
        cellRect.bottomLeft,
        cellRect.bottomRight.expandEndX(borderWidth),
        border?.bottom,
      ));

      mesh.addVertical(Line(
        cellRect.topLeft.expandEndY(-borderWidth),
        cellRect.bottomLeft,
        border?.left,
      ));
    }

    for (Line line in mesh.lines) {
      Paint paint = Paint()
        ..color = line.side.color
        ..strokeWidth = line.side.width
        ..isAntiAlias = false
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.square;

      canvas.drawLine(line.start, line.end, paint);
    }
  }

  void _paintCellBackground(Canvas canvas, ViewportCell cell) {
    CellStyle cellStyle = cell.properties.style;

    Paint backgroundPaint = Paint()
      ..color = cellStyle.backgroundColor
      ..isAntiAlias = false
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

class Mesh with EquatableMixin {
  Mesh()
      : verticalLines = <double, List<Line>>{},
        horizontalLines = <double, List<Line>>{};

  final Map<double, List<Line>> verticalLines;
  final Map<double, List<Line>> horizontalLines;

  void addHorizontal(Line line) {
    if(horizontalLines[line.start.dy] == null) {
      horizontalLines[line.start.dy] = <Line>[line];
      return;
    }

    List<Line> lines = horizontalLines[line.start.dy]!;
    bool merged = false;

    for (int i = 0; i < lines.length; i++) {
      Line currentLine = lines[i];
      if (currentLine.canMergeHorizontal(line)) {
        lines[i] = currentLine.merge(line);
        merged = true;
        return;
      }
    }

    if(!merged) {
      lines.add(line);
    }
  }

  void addVertical(Line line) {
    if(verticalLines[line.start.dx] == null) {
      verticalLines[line.start.dx] = <Line>[line];
      return;
    }

    List<Line> lines = verticalLines[line.start.dx]!;
    bool merged = false;
    for (int i = 0; i < lines.length; i++) {
      Line currentLine = lines[i];
      if (currentLine.canMergeVertical(line)) {
        lines[i] = currentLine.merge(line);
        merged = true;
        return;
      }
    }

    if(!merged) {
      lines.add(line);
    }
  }

  List<Line> get lines {
    List<Line> allLines = <Line>[];
    allLines.addAll(verticalLines.values.expand((List<Line> lines) => lines));
    allLines.addAll(horizontalLines.values.expand((List<Line> lines) => lines));
    return allLines;
  }

  @override
  List<Object?> get props => <Object?>[verticalLines, horizontalLines];
}

class Line with EquatableMixin {
  Line(this.start, this.end, this._side);

  final Offset start;
  final Offset end;
  final BorderSide? _side;

  BorderSide get side => (_side == null || _side == BorderSide.none) ? MaterialSheetTheme.defaultBorderSide : _side;

  bool canMerge(Line other) {
    return side == other.side && isOverlapping(other);
  }

  bool canMergeVertical(Line other) {
    return side == other.side && isOverlappingVertical(other);
  }

  bool canMergeHorizontal(Line other) {
    return side == other.side && isOverlappingHorizontal(other);
  }

  bool canReplace(Line other) {
    bool sameEdge = start == other.start && end == other.end;
    return sameEdge && other.side != MaterialSheetTheme.defaultBorderSide;
  }

  bool isOverlappingVertical(Line other) {
    return start.dx == end.dx && other.start.dx == other.end.dx && start.dx == other.start.dx && end.dy >= other.start.dy && start.dy <= other.end.dy;
  }

  bool isOverlappingHorizontal(Line other) {
    return start.dy == end.dy && other.start.dy == other.end.dy && start.dy == other.start.dy && end.dx >= other.start.dx && start.dx <= other.end.dx;
  }

  bool isOverlapping(Line other) {
    return isOverlappingVertical(other) || isOverlappingHorizontal(other);
  }

  // Merge two overlapping lines into one
  Line merge(Line other) {
    if (start.dy == end.dy) {
      // Horizontal lines
      return Line(
        Offset(start.dx < other.start.dx ? start.dx : other.start.dx, start.dy),
        Offset(end.dx > other.end.dx ? end.dx : other.end.dx, start.dy),
        _side,
      );
    } else {
      // Vertical lines
      return Line(
        Offset(start.dx, start.dy < other.start.dy ? start.dy : other.start.dy),
        Offset(start.dx, end.dy > other.end.dy ? end.dy : other.end.dy),
        _side,
      );
    }
  }

  @override
  List<Object?> get props => <Object?>[start, end, _side];

  @override
  String toString() {
    return 'Line{start: $start, end: $end}';
  }
}
