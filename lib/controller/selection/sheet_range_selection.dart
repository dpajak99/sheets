import 'package:flutter/material.dart';
import 'package:sheets/controller/index.dart';
import 'package:sheets/controller/program_config.dart';
import 'package:sheets/controller/selection.dart';
import 'package:sheets/controller/selection/sheet_selection.dart';
import 'package:sheets/painters/paint/sheet_paint_config.dart';
import 'package:sheets/sheet_constants.dart';
import 'package:sheets/utils/direction.dart';

class SheetRangeSelection extends SheetSelection {
  final CellIndex _start;
  final CellIndex _end;

  SheetRangeSelection({
    required super.paintConfig,
    required CellIndex start,
    required CellIndex end,
    required super.completed,
  })  : _end = end,
        _start = start;

  SheetRangeSelection copyWith({
    CellIndex? start,
    CellIndex? end,
    bool? completed,
  }) {
    return SheetRangeSelection(
      paintConfig: paintConfig,
      start: start ?? _start,
      end: end ?? _end,
      completed: completed ?? isCompleted,
    );
  }

  @override
  CellIndex get start => _start;

  @override
  CellIndex get end => _end;

  @override
  SelectionStatus isColumnSelected(ColumnIndex columnIndex) {
    return SelectionStatus(
      horizontalRange.contains(columnIndex),
      verticalRange.containsRange(Range<RowIndex>(RowIndex.zero, RowIndex(defaultRowCount))),
    );
  }

  @override
  SelectionStatus isRowSelected(RowIndex rowIndex) {
    return SelectionStatus(
      verticalRange.contains(rowIndex),
      horizontalRange.containsRange(Range<ColumnIndex>(ColumnIndex.zero, ColumnIndex(defaultColumnCount))),
    );
  }

  Range<ColumnIndex> get horizontalRange => Range(_start.columnIndex, _end.columnIndex);

  Range<RowIndex> get verticalRange => Range(_start.rowIndex, _end.rowIndex);

  SelectionCorners<CellIndex> get selectionCorners {
    return SelectionCorners.fromDirection(
      topLeft: start,
      topRight: CellIndex(rowIndex: start.rowIndex, columnIndex: end.columnIndex),
      bottomLeft: CellIndex(rowIndex: end.rowIndex, columnIndex: start.columnIndex),
      bottomRight: end,
      direction: direction,
    );
  }

  @override
  SheetSelection complete() => copyWith(completed: true);

  @override
  SheetSelectionPaint get paint => SheetRangeSelectionPaint(this);

  SelectionBounds? getSelectionBounds() {
    CellConfig? startCell = paintConfig.findCell(start);
    CellConfig? endCell = paintConfig.findCell(end);

    if (startCell != null && endCell != null) {
      return SelectionBounds(startCell, endCell, direction);
    }

    if (startCell == null && endCell != null) {
      ClosestVisible<CellIndex> startClosest = paintConfig.findClosestVisible(start);
      CellConfig updatedStartCell = paintConfig.findCell(startClosest.item) as CellConfig;
      return SelectionBounds(updatedStartCell, endCell, direction, hiddenBorders: startClosest.hiddenBorders, startCellVisible: false);
    }

    if (startCell != null && endCell == null) {
      ClosestVisible<CellIndex> endClosest = paintConfig.findClosestVisible(end);
      CellConfig updatedEndCell = paintConfig.findCell(endClosest.item) as CellConfig;

      return SelectionBounds(startCell, updatedEndCell, direction, hiddenBorders: endClosest.hiddenBorders, lastCellVisible: false);
    }

    if (startCell == null && endCell == null && (_isFullHeightSelection || _isFullWidthSelection)) {
      ClosestVisible<CellIndex> startClosest = paintConfig.findClosestVisible(start);
      ClosestVisible<CellIndex> endClosest = paintConfig.findClosestVisible(end);

      CellConfig updatedStartCell = paintConfig.findCell(startClosest.item) as CellConfig;
      CellConfig updatedEndCell = paintConfig.findCell(endClosest.item) as CellConfig;

      List<Direction> hiddenBorders = [...startClosest.hiddenBorders, ...endClosest.hiddenBorders];

      return SelectionBounds(updatedStartCell, updatedEndCell, direction, hiddenBorders: hiddenBorders, startCellVisible: false);
    }

    return null;
  }

  bool get _isFullHeightSelection {
    List<RowConfig> visibleRows = paintConfig.visibleRows;
    bool vertical1 = start.rowIndex < visibleRows.first.rowIndex && end.rowIndex > visibleRows.last.rowIndex;
    bool vertical2 = end.rowIndex < visibleRows.first.rowIndex && start.rowIndex > visibleRows.last.rowIndex;

    return vertical1 || vertical2;
  }

  bool get _isFullWidthSelection {
    List<ColumnConfig> visibleColumns = paintConfig.visibleColumns;
    bool horizontal1 = start.columnIndex < visibleColumns.first.columnIndex && end.columnIndex > visibleColumns.last.columnIndex;
    bool horizontal2 = end.columnIndex < visibleColumns.first.columnIndex && start.columnIndex > visibleColumns.last.columnIndex;

    return horizontal1 || horizontal2;
  }

  SelectionDirection get direction {
    bool startBeforeEndRow = _start.rowIndex.value < _end.rowIndex.value;
    bool startBeforeEndColumn = _start.columnIndex.value < _end.columnIndex.value;

    if (startBeforeEndRow) {
      return startBeforeEndColumn ? SelectionDirection.bottomRight : SelectionDirection.bottomLeft;
    } else {
      return startBeforeEndColumn ? SelectionDirection.topRight : SelectionDirection.topLeft;
    }
  }

  @override
  List<Object?> get props => [_start, _end];
}

class SheetRangeSelectionPaint extends SheetSelectionPaint {
  final SheetRangeSelection selection;

  SheetRangeSelectionPaint(this.selection);

  @override
  void paint(SheetPaintConfig paintConfig, Canvas canvas, Size size) {
    SelectionBounds? selectionBounds = selection.getSelectionBounds();
    if (selectionBounds == null) {
      return;
    }

    Rect selectionRect = selectionBounds.selectionRect;

    if (selectionBounds.isStartCellVisible) {
      paintMainCell(canvas, selectionBounds.mainCellRect);
    }

    paintSelectionBackground(canvas, selectionRect);

    if (selection.isCompleted) {
      paintSelectionBorder(
        canvas,
        selectionRect,
        top: selectionBounds.isTopBorderVisible,
        right: selectionBounds.isRightBorderVisible,
        bottom: selectionBounds.isBottomBorderVisible,
        left: selectionBounds.isLeftBorderVisible,
      );

      paintFillHandle(canvas, selectionBounds.selectionRect.bottomRight);
    }
  }
}
