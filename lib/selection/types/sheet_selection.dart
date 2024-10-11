import 'dart:ui';

import 'package:equatable/equatable.dart';
import 'package:sheets/core/sheet_properties.dart';
import 'package:sheets/selection/selection_status.dart';
import 'package:sheets/core/sheet_item_index.dart';
import 'package:sheets/core/sheet_viewport_delegate.dart';
import 'package:sheets/core/config/sheet_constants.dart';
import 'package:sheets/selection/selection_corners.dart';
import 'package:sheets/utils/extensions/rect_extensions.dart';

abstract class SheetSelection with EquatableMixin {
  final bool _completed;
  late SheetProperties sheetProperties;

  void applyProperties(SheetProperties properties) {
    sheetProperties = properties;
  }

  SheetSelection({required bool completed}) : _completed = completed;

  bool get isCompleted => _completed;

  CellIndex get start;

  CellIndex get end;

  CellIndex get trueStart {
    if( start == CellIndex.max) {
      return CellIndex(rowIndex: RowIndex(sheetProperties.rowCount - 1), columnIndex: ColumnIndex(sheetProperties.columnCount - 1));
    } else if (start.columnIndex == ColumnIndex.max) {
      return CellIndex(rowIndex: start.rowIndex, columnIndex: ColumnIndex(sheetProperties.columnCount - 1));
    } else if (start.rowIndex == RowIndex.max) {
      return CellIndex(rowIndex: RowIndex(sheetProperties.rowCount - 1), columnIndex: start.columnIndex);
    } else {
      return start;
    }
  }

  CellIndex get trueEnd {
    if( end == CellIndex.max) {
      return CellIndex(rowIndex: RowIndex(sheetProperties.rowCount - 1), columnIndex: ColumnIndex(sheetProperties.columnCount - 1));
    } else if (end.columnIndex == ColumnIndex.max) {
      return CellIndex(rowIndex: end.rowIndex, columnIndex: ColumnIndex(sheetProperties.columnCount - 1));
    } else if (end.rowIndex == RowIndex.max) {
      return CellIndex(rowIndex: RowIndex(sheetProperties.rowCount - 1), columnIndex: end.columnIndex);
    } else {
      return end;
    }
  }

  CellIndex get mainCell => trueStart;

  Set<CellIndex> get selectedCells;

  SelectionCellCorners? get selectionCellCorners;

  SelectionStatus isColumnSelected(ColumnIndex columnIndex);

  SelectionStatus isRowSelected(RowIndex rowIndex);

  bool containsCell(CellIndex cellIndex);

  SheetSelection complete() => this;

  SheetSelection simplify() => this;

  String stringifySelection();

  SheetSelectionRenderer createRenderer(SheetViewportDelegate viewportDelegate);

  bool contains(CellIndex cellIndex) {
    SelectionCellCorners? corners = selectionCellCorners;
    if(corners == null) return selectedCells.contains(cellIndex);

    return corners.contains(cellIndex);
  }
}

abstract class SheetSelectionRenderer {
  final SheetViewportDelegate viewportDelegate;

  SheetSelectionRenderer({required this.viewportDelegate});

  bool get fillHandleVisible;

  Offset? get fillHandleOffset;

  SheetSelectionPaint get paint;
}

abstract class SheetSelectionPaint {
  void paint(SheetViewportDelegate paintConfig, Canvas canvas, Size size);

  void paintMainCell(Canvas canvas, Rect rect) {
    Paint mainCellPaint = Paint()
      ..color = const Color(0xff3572e3)
      ..strokeWidth = borderWidth * 2
      ..isAntiAlias = false
      ..style = PaintingStyle.stroke;

    canvas.drawRect(rect.subtract(borderWidth / 2), mainCellPaint);
  }

  void paintSelectionBackground(Canvas canvas, Rect rect) {
    Paint backgroundPaint = Paint()
      ..color = const Color(0x203572e3)
      ..color = const Color(0x203572e3)
      ..style = PaintingStyle.fill;

    canvas.drawRect(rect, backgroundPaint);
  }

  void paintSelectionBorder(Canvas canvas, Rect rect, {top = true, right = true, bottom = true, left = true}) {
    Paint selectionPaint = Paint()
      ..color = const Color(0xff3572e3)
      ..strokeWidth = borderWidth
      ..isAntiAlias = false
      ..strokeCap = StrokeCap.square
      ..style = PaintingStyle.stroke;

    if (top) canvas.drawLine(rect.topLeft, rect.topRight, selectionPaint);
    if (right) canvas.drawLine(rect.topRight, rect.bottomRight, selectionPaint);
    if (bottom) canvas.drawLine(rect.bottomLeft, rect.bottomRight, selectionPaint);
    if (left) canvas.drawLine(rect.topLeft, rect.bottomLeft, selectionPaint);
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
