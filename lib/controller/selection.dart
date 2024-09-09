import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:sheets/controller/index.dart';
import 'package:sheets/controller/program_config.dart';
import 'package:sheets/painters/paint/sheet_paint_config.dart';
import 'package:sheets/utils/direction.dart';

abstract class SheetSelection with EquatableMixin {
  final SheetPaintConfig paintConfig;

  SheetSelection({required this.paintConfig});

  SelectionBounds? getSelectionBounds() {
    bool startCellVisible = paintConfig.containsCell(start);
    bool endCellVisible = paintConfig.containsCell(end);

    if ((startCellVisible || endCellVisible) == false) {
      return null;
    }

    CellConfig? startCell = paintConfig.findCell(start);
    CellConfig? endCell = paintConfig.findCell(end);

    if (startCell != null && endCell != null) {
      return SelectionBounds(startCell, endCell, direction);
    } else if (startCell == null && endCell != null) {
      Direction verticalDirection, horizontalDirection;
      CellConfig startClosestCell;

      (verticalDirection, horizontalDirection, startClosestCell) = paintConfig.findClosestVisible(start);

      List<Direction> hiddenBorders = [verticalDirection, horizontalDirection];
      return SelectionBounds(startClosestCell, endCell, direction, hiddenBorders: hiddenBorders, startCellVisible: false);
    } else if (startCell != null && endCell == null) {
      Direction verticalDirection, horizontalDirection;
      CellConfig closestCell;

      (verticalDirection, horizontalDirection, closestCell) = paintConfig.findClosestVisible(end);

      List<Direction> hiddenBorders = [verticalDirection, horizontalDirection];
      return SelectionBounds(startCell, closestCell, direction, hiddenBorders: hiddenBorders, lastCellVisible: false);
    } else {
      return null;
    }
  }

  CellIndex get start;

  CellIndex get end;

  bool get hasBackground => false;

  bool get circleVisible => true;

  bool isColumnSelected(ColumnIndex columnIndex);

  bool isRowSelected(RowIndex rowIndex);

  SelectionDirection get direction;

  bool get isCompleted;
}

class SheetSingleSelection extends SheetSelection {
  final CellIndex cellIndex;
  final bool editingEnabled;

  SheetSingleSelection({
    required super.paintConfig,
    required this.cellIndex,
    this.editingEnabled = false,
  });

  SheetSingleSelection.defaultSelection({required super.paintConfig}) : cellIndex = CellIndex.zero, editingEnabled = false;

  @override
  CellIndex get start => cellIndex;

  @override
  CellIndex get end => cellIndex;

  @override
  bool isColumnSelected(ColumnIndex columnIndex) => cellIndex.columnIndex == columnIndex;

  @override
  bool isRowSelected(RowIndex rowIndex) => cellIndex.rowIndex == rowIndex;

  @override
  SelectionDirection get direction => SelectionDirection.topRight;

  @override
  bool get isCompleted => true;

  @override
  bool get circleVisible => !editingEnabled;

  @override
  List<Object?> get props => [cellIndex];
}

class SheetRangeSelection extends SheetSelection {
  final CellIndex _start;
  final CellIndex _end;
  final bool _completed;

  SheetRangeSelection({
    required super.paintConfig,
    required CellIndex start,
    required CellIndex end,
    required bool completed,
  })  : _end = end,
        _start = start,
        _completed = completed;

  @override
  CellIndex get start => _start;

  @override
  CellIndex get end => _end;

  @override
  bool isColumnSelected(ColumnIndex columnIndex) {
    int startColumnIndex = selectionCorners.topLeft.columnIndex.value;
    int endColumnIndex = selectionCorners.topRight.columnIndex.value;

    return columnIndex.value >= startColumnIndex && columnIndex.value <= endColumnIndex;
  }

  @override
  bool isRowSelected(RowIndex rowIndex) {
    int startRowIndex = selectionCorners.topLeft.rowIndex.value;
    int endRowIndex = selectionCorners.bottomLeft.rowIndex.value;

    return rowIndex.value >= startRowIndex && rowIndex.value <= endRowIndex;
  }

  @override
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
  bool get hasBackground => true;

  @override
  bool get isCompleted => _completed;

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
  List<Object?> get props => [_start, _end];
}

enum SelectionDirection { topRight, topLeft, bottomRight, bottomLeft }

class SelectionCorners<T> with EquatableMixin {
  final T topLeft;
  final T topRight;
  final T bottomLeft;
  final T bottomRight;

  SelectionCorners(this.topLeft, this.topRight, this.bottomLeft, this.bottomRight);

  factory SelectionCorners.fromDirection({
    required T topLeft,
    required T topRight,
    required T bottomLeft,
    required T bottomRight,
    required SelectionDirection direction,
  }) {
    switch (direction) {
      case SelectionDirection.bottomRight:
        return SelectionCorners(topLeft, topRight, bottomLeft, bottomRight);
      case SelectionDirection.bottomLeft:
        return SelectionCorners(topRight, topLeft, bottomRight, bottomLeft);
      case SelectionDirection.topRight:
        return SelectionCorners(bottomLeft, bottomRight, topLeft, topRight);
      case SelectionDirection.topLeft:
        return SelectionCorners(bottomRight, bottomLeft, topRight, topLeft);
    }
  }

  @override
  List<Object?> get props => <Object?>[topLeft, topRight, bottomLeft, bottomRight];
}

class SelectionBounds {
  final SelectionCorners<Rect> _corners;
  final CellConfig _startCell;
  final bool _startCellVisible;
  final List<Direction> _hiddenBorders;

  SelectionBounds._({
    required SelectionCorners<Rect> corners,
    required CellConfig startCell,
    required bool startCellVisible,
    required List<Direction> hiddenBorders,
  })  : _corners = corners,
        _startCell = startCell,
        _startCellVisible = startCellVisible,
        _hiddenBorders = hiddenBorders;

  factory SelectionBounds(
    CellConfig startCell,
    CellConfig endCell,
    SelectionDirection direction, {
    List<Direction>? hiddenBorders,
    bool startCellVisible = true,
    bool lastCellVisible = true,
  }) {
    SelectionCorners<Rect> corners = SelectionCorners<Rect>.fromDirection(
      topLeft: startCell.rect,
      bottomRight: endCell.rect,
      topRight: Rect.fromPoints(
        Offset(endCell.rect.left, startCell.rect.top),
        Offset(endCell.rect.right, startCell.rect.bottom),
      ),
      bottomLeft: Rect.fromPoints(
        Offset(startCell.rect.left, endCell.rect.top),
        Offset(startCell.rect.right, endCell.rect.bottom),
      ),
      direction: direction,
    );

    return SelectionBounds._(
      corners: corners,
      startCell: startCell,
      startCellVisible: startCellVisible,
      hiddenBorders: hiddenBorders ?? [],
    );
  }

  bool get isStartCellVisible => _startCellVisible;

  Rect get startCellRect => _startCell.rect;

  Rect get selectionRect {
    return Rect.fromPoints(_corners.topLeft.topLeft, _corners.bottomRight.bottomRight);
  }

  bool get isLeftBorderVisible => !_hiddenBorders.contains(Direction.left);

  Offset get leftBorderStart => _corners.topLeft.topLeft;

  Offset get leftBorderEnd => _corners.bottomLeft.bottomLeft;

  bool get isTopBorderVisible => !_hiddenBorders.contains(Direction.top);

  Offset get topBorderStart => _corners.topLeft.topLeft;

  Offset get topBorderEnd => _corners.topRight.topRight;

  bool get isRightBorderVisible => !_hiddenBorders.contains(Direction.right);

  Offset get rightBorderStart => _corners.topRight.topRight;

  Offset get rightBorderEnd => _corners.bottomRight.bottomRight;

  bool get isBottomBorderVisible => !_hiddenBorders.contains(Direction.bottom);

  Offset get bottomBorderStart => _corners.bottomLeft.bottomLeft;

  Offset get bottomBorderEnd => _corners.bottomRight.bottomRight;

  SelectionCorners<Rect> get corners => _corners;
}
