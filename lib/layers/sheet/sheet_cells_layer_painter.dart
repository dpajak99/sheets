import 'dart:math';
import 'dart:ui';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:sheets/core/cell_properties.dart';
import 'package:sheets/core/config/sheet_constants.dart';
import 'package:sheets/core/sheet_style.dart';
import 'package:sheets/core/values/sheet_text_span.dart';
import 'package:sheets/core/viewport/sheet_viewport_content_manager.dart';
import 'package:sheets/core/viewport/viewport_item.dart';
import 'package:sheets/core/worksheet.dart';
import 'package:sheets/utils/extensions/offset_extensions.dart';
import 'package:sheets/utils/extensions/text_span_extensions.dart';
import 'package:sheets/utils/text_rotation.dart';
import 'package:sheets/widgets/material/material_sheet_theme.dart';

class CellsDrawingController extends ChangeNotifier {
  void rebuild() {
    notifyListeners();
  }
}

class SheetCellsLayerPainter extends CustomPainter {
  SheetCellsLayerPainter({
    required this.worksheet,
    required CellsDrawingController drawingController,
    EdgeInsets? padding,
  })  : _padding = padding ?? const EdgeInsets.symmetric(horizontal: 3, vertical: 2),
        super(repaint: drawingController);

  final Worksheet worksheet;
  final EdgeInsets _padding;

  SheetViewportContentManager get _visibleContent => worksheet.viewport.visibleContent;

  @override
  void paint(Canvas canvas, Size size) {
    _clipCellsLayerBox(canvas, size);

    double pinnedColumnsWidth = worksheet.data.pinnedColumnsWidth;
    double pinnedRowsHeight = worksheet.data.pinnedRowsHeight;

    List<ViewportCell> pinnedBoth = <ViewportCell>[];
    List<ViewportCell> pinnedRows = <ViewportCell>[];
    List<ViewportCell> pinnedColumns = <ViewportCell>[];
    List<ViewportCell> normal = <ViewportCell>[];

    for (ViewportCell cell in _visibleContent.cells) {
      bool rowPinned = cell.index.row.value < worksheet.data.pinnedRowCount;
      bool columnPinned = cell.index.column.value < worksheet.data.pinnedColumnCount;

      if (rowPinned && columnPinned) {
        pinnedBoth.add(cell);
      } else if (rowPinned) {
        pinnedRows.add(cell);
      } else if (columnPinned) {
        pinnedColumns.add(cell);
      } else {
        normal.add(cell);
      }
    }

    canvas.save();
    canvas.clipRect(Rect.fromLTWH(
      rowHeadersWidth + pinnedColumnsWidth + borderWidth,
      columnHeadersHeight + pinnedRowsHeight + borderWidth,
      size.width - pinnedColumnsWidth,
      size.height - pinnedRowsHeight,
    ));
    _paintCells(canvas, normal);
    canvas.restore();

    canvas.save();
    canvas.clipRect(Rect.fromLTWH(
      rowHeadersWidth + pinnedColumnsWidth + borderWidth,
      columnHeadersHeight + borderWidth,
      size.width - pinnedColumnsWidth,
      pinnedRowsHeight,
    ));
    _paintCells(canvas, pinnedRows);
    canvas.restore();

    canvas.save();
    canvas.clipRect(Rect.fromLTWH(
      rowHeadersWidth + borderWidth,
      columnHeadersHeight + pinnedRowsHeight + borderWidth,
      pinnedColumnsWidth,
      size.height - pinnedRowsHeight,
    ));
    _paintCells(canvas, pinnedColumns);
    canvas.restore();

    canvas.save();
    canvas.clipRect(Rect.fromLTWH(
      rowHeadersWidth + borderWidth,
      columnHeadersHeight + borderWidth,
      pinnedColumnsWidth,
      pinnedRowsHeight,
    ));
    _paintCells(canvas, pinnedBoth);
    canvas.restore();

    _paintMesh(canvas, size);
  }

  @override
  bool shouldRepaint(covariant SheetCellsLayerPainter oldDelegate) {
    return oldDelegate._visibleContent != _visibleContent || oldDelegate._padding != _padding;
  }

  void _clipCellsLayerBox(Canvas canvas, Size size) {
    canvas.clipRect(Rect.fromLTWH(rowHeadersWidth + borderWidth, columnHeadersHeight + borderWidth, size.width, size.height));
  }

  void _paintCells(Canvas canvas, List<ViewportCell> cells) {
    if (cells.isEmpty) {
      return;
    }

    _StyleBasedPainterBuilder(
      cells: cells,
      builder: (CellStyle style, List<ViewportCell> cells) {
        _BackgroundColorPainter(
          color: style.backgroundColor,
          shapes: cells.map((ViewportCell cell) => cell.rect),
        ).layout(canvas);
      },
    ).build();

    for (ViewportCell cell in cells) {
      _paintCellText(canvas, cell);
    }
  }

  void _paintMesh(Canvas canvas, Size size) {
    canvas.clipRect(Rect.fromLTWH(0, 0, size.width, size.height));
    List<ViewportColumn> visibleColumns = _visibleContent.columns;
    List<ViewportRow> visibleRows = _visibleContent.rows;
    List<ViewportCell> visibleCells = _visibleContent.cells;

    if (visibleColumns.isEmpty || visibleRows.isEmpty) {
      return;
    }

    Mesh mesh = Mesh(
      verticalPoints: visibleColumns.map((ViewportColumn column) => column.rect.left).toList(),
      horizontalPoints: visibleRows.map((ViewportRow row) => row.rect.top).toList(),
      maxHorizontal: visibleColumns.last.rect.right,
      maxVertical: visibleRows.last.rect.bottom,
    );

    for (ViewportCell cell in visibleCells) {
      Rect cellRect = cell.rect;
      BorderSide defaultBorder = MaterialSheetTheme.defaultBorderSide;

      Line topBorderLine = Line(
        cellRect.topLeft.moveY(-borderWidth),
        cellRect.topRight.moveY(-borderWidth).expandEndX(borderWidth),
      );

      Line rightBorderLine = Line(
        cellRect.topRight.moveX(borderWidth).expandEndY(-1),
        cellRect.bottomRight.moveX(borderWidth),
      );

      Line bottomBorderLine = Line(
        cellRect.bottomLeft,
        cellRect.bottomRight.expandEndX(borderWidth),
      );

      Line leftBorderLine = Line(
        cellRect.topLeft.expandEndY(-borderWidth),
        cellRect.bottomLeft,
      );

      mesh.addHorizontal(cellRect.top, topBorderLine, defaultBorder);
      mesh.addHorizontal(cellRect.bottom, bottomBorderLine, defaultBorder);
      mesh.addVertical(cellRect.right, rightBorderLine, defaultBorder);
      mesh.addVertical(cellRect.left, leftBorderLine, defaultBorder);
    }

    for (ViewportCell cell in visibleCells) {
      Rect cellRect = cell.rect;
      Border? border = cell.properties.style.border;

      BorderSide defaultBorder = MaterialSheetTheme.defaultBorderSide;

      BorderSide topBorderSide = border?.top ?? defaultBorder;
      Line topBorderLine = Line(
        cellRect.topLeft.moveY(-borderWidth),
        cellRect.topRight.moveY(-borderWidth).expandEndX(borderWidth),
      );

      BorderSide rightBorderSide = border?.right ?? defaultBorder;
      Line rightBorderLine = Line(
        cellRect.topRight.moveX(borderWidth).expandEndY(-1),
        cellRect.bottomRight.moveX(borderWidth),
      );

      BorderSide bottomBorderSide = border?.bottom ?? defaultBorder;
      Line bottomBorderLine = Line(
        cellRect.bottomLeft,
        cellRect.bottomRight.expandEndX(borderWidth),
      );

      BorderSide leftBorderSide = border?.left ?? defaultBorder;
      Line leftBorderLine = Line(
        cellRect.topLeft.expandEndY(-borderWidth),
        cellRect.bottomLeft,
      );

      if (topBorderSide != defaultBorder) {
        mesh.addHorizontal(cellRect.top, topBorderLine, topBorderSide);
      }
      if (rightBorderSide != defaultBorder) {
        mesh.addVertical(cellRect.right, rightBorderLine, rightBorderSide);
      }
      if (bottomBorderSide != defaultBorder) {
        mesh.addHorizontal(cellRect.bottom, bottomBorderLine, bottomBorderSide);
      }
      if (leftBorderSide != defaultBorder) {
        mesh.addVertical(cellRect.left, leftBorderLine, leftBorderSide);
      }
    }

    Map<BorderSide, List<Line>> linesByStyle = mesh.lines;

    for (MapEntry<BorderSide, List<Line>> entry in linesByStyle.entries) {
      BorderSide side = entry.key;
      List<Line> lines = entry.value;
      Paint paint = Paint()
        ..color = side.color
        ..strokeWidth = side.width
        ..isAntiAlias = false
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.square;

      canvas.drawPoints(
        PointMode.lines,
        lines.expand((Line line) => <Offset>[line.start, line.end]).toList(),
        paint,
      );
    }
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

    Offset textPosition = cell.rect.topLeft + Offset(xOffset, yOffset);
    textPainter.paint(canvas, textPosition);

    // // Position where the text should be painted
    // Offset textPosition = cell.rect.topLeft + Offset(xOffset, yOffset);
    //
    // // Save the canvas state
    // canvas.save();
    //
    // // Clip the canvas to the cell rectangle
    // canvas.clipRect(cell.rect);
    //
    // if (textRotation == TextRotation.vertical) {
    //   // Paint the text at the calculated position
    //   textPainter.paint(canvas, textPosition);
    // } else if (angle != 0) {
    //   // Translate to the center of the rotated bounding box
    //   canvas.translate(
    //     textPosition.dx + rotatedWidth / 2,
    //     textPosition.dy + rotatedHeight / 2,
    //   );
    //
    //   // Rotate the canvas
    //   canvas.rotate(angleRad);
    //
    //   // Translate back to the top-left of the text
    //   canvas.translate(-textPainter.width / 2, -textPainter.height / 2);
    //
    //   // Paint the text at (0,0)
    //   textPainter.paint(canvas, Offset.zero);
    // } else {
    //   // Paint the text at the calculated position
    //   textPainter.paint(canvas, textPosition);
    // }
    //
    // // Restore the canvas state
    // canvas.restore();
  }
}

class _StyleBasedPainterBuilder {
  _StyleBasedPainterBuilder({required this.cells, required this.builder});

  final List<ViewportCell> cells;
  final void Function(CellStyle style, List<ViewportCell> cells) builder;


  void build() {
    Map<CellStyle, List<ViewportCell>> cellsByStyle = <CellStyle, List<ViewportCell>>{};

    for (ViewportCell cell in cells) {
      CellStyle style = cell.properties.style;
      cellsByStyle.putIfAbsent(style, () => <ViewportCell>[]).add(cell);
    }

    for (MapEntry<CellStyle, List<ViewportCell>> entry in cellsByStyle.entries) {
      builder(entry.key, entry.value);
    }
  }
}

class _BackgroundColorPainter {
  _BackgroundColorPainter({
    required this.color,
    required Iterable<BorderRect> shapes,
  })  : _corners = <Offset>[],
        _colors = <Color>[],
        _indices = <int>[] {
    shapes.forEach(_fillRect);
  }

  static const int _cornersCount = 4;

  final Color color;
  final List<Offset> _corners;
  final List<Color> _colors;
  final List<int> _indices;

  void layout(Canvas canvas) {
    canvas.drawVertices(
      Vertices(VertexMode.triangles, _corners, colors: _colors, indices: _indices),
      BlendMode.srcOver,
      Paint(),
    );
  }

  void _fillRect(BorderRect rect) {
    int offset = _corners.length ~/ _cornersCount;
    List<Offset> cornerPoints = rect.asOffsets;

    _corners.addAll(cornerPoints);
    _colors.addAll(List<Color>.filled(cornerPoints.length, color));
    _indices.addAll(<int>[0, 1, 2, 1, 2, 3].map((int index) => index + offset * _cornersCount));
  }
}

class StyledLine {
  StyledLine(this.line, this.style);

  final Line line;
  final BorderSide style;
}

class Mesh {
  Mesh({
    required this.verticalPoints,
    required this.horizontalPoints,
    this.maxVertical = 0,
    this.maxHorizontal = 0,
  });

  final List<double> verticalPoints;
  final List<double> horizontalPoints;
  final double maxVertical;
  final double maxHorizontal;

  Map<double, List<StyledLine>> customVertical = <double, List<StyledLine>>{};
  Map<double, List<StyledLine>> customHorizontal = <double, List<StyledLine>>{};

  void addVertical(double x, Line line, BorderSide style) {
    customVertical.putIfAbsent(x, () => <StyledLine>[]).add(StyledLine(line, style));
  }

  void addHorizontal(double y, Line line, BorderSide style) {
    customHorizontal.putIfAbsent(y, () => <StyledLine>[]).add(StyledLine(line, style));
  }

  Map<BorderSide, List<Line>> get lines {
    Map<BorderSide, List<Line>> result = <BorderSide, List<Line>>{};

    for (MapEntry<double, List<StyledLine>> entry in customVertical.entries) {
      List<StyledLine> lines = entry.value;

      for (StyledLine styledLine in lines) {
        BorderSide style = styledLine.style;
        Line line = styledLine.line;

        result.putIfAbsent(style, () => <Line>[]).add(line);
      }
    }

    for (MapEntry<double, List<StyledLine>> entry in customHorizontal.entries) {
      List<StyledLine> lines = entry.value;

      for (StyledLine styledLine in lines) {
        BorderSide style = styledLine.style;
        Line line = styledLine.line;

        result.putIfAbsent(style, () => <Line>[]).add(line);
      }
    }

    return result;
  }
}

class Line with EquatableMixin {
  Line(this.start, this.end);

  final Offset start;
  final Offset end;

  @override
  List<Object?> get props => <Object?>[start, end];

  @override
  String toString() {
    return 'Line{start: $start, end: $end}';
  }
}
