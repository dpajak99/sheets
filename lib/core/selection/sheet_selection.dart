import 'package:equatable/equatable.dart';
import 'package:sheets/core/selection/selection_corners.dart';
import 'package:sheets/core/selection/selection_status.dart';
import 'package:sheets/core/selection/sheet_selection_renderer.dart';
import 'package:sheets/core/selection/types/sheet_fill_selection.dart';
import 'package:sheets/core/selection/types/sheet_multi_selection.dart';
import 'package:sheets/core/selection/types/sheet_range_selection.dart';
import 'package:sheets/core/selection/types/sheet_single_selection.dart';
import 'package:sheets/core/sheet_index.dart';
import 'package:sheets/core/viewport/sheet_viewport.dart';
import 'package:sheets/utils/direction.dart';

abstract class SheetSelection with EquatableMixin {
  final bool _completed;

  SheetSelection({required bool completed}) : _completed = completed;

  SheetSelection copyWith({bool? completed});

  factory SheetSelection.single(
    SheetIndex index, {
    bool completed = false,
  }) {
    return switch (index) {
      CellIndex cellIndex => SheetSingleSelection(cellIndex, completed: completed),
      ColumnIndex columnIndex => SheetRangeSelection<ColumnIndex>.single(columnIndex, completed: completed),
      RowIndex rowIndex => SheetRangeSelection<RowIndex>.single(rowIndex, completed: completed),
    };
  }

  factory SheetSelection.range({
    required SheetIndex start,
    required SheetIndex end,
    bool completed = false,
  }) {
    if (start is CellIndex && start == end) {
      return SheetSingleSelection(start, completed: completed);
    }

    return switch (start) {
      CellIndex start => SheetSelection.cellRange(start, end, completed),
      ColumnIndex start => SheetSelection.columnRange(start, end, completed),
      RowIndex start => SheetSelection.rowRange(start, end, completed),
    };
  }

  factory SheetSelection.multi({
    required List<SheetSelection> selections,
  }) {
    return SheetMultiSelection(selections: selections);
  }

  factory SheetSelection.fill(
    SheetIndex start,
    SheetIndex end, {
    required SheetSelection baseSelection,
    required Direction fillDirection,
    bool completed = false,
  }) {
    return SheetFillSelection<SheetIndex>(start, end, completed: completed, baseSelection: baseSelection, fillDirection: fillDirection);
  }

  factory SheetSelection.all() {
    return SheetRangeSelection<CellIndex>(CellIndex.zero, CellIndex.max, completed: true);
  }

  factory SheetSelection.cellRange(
    CellIndex startCellIndex,
    SheetIndex endIndex,
    bool completed,
  ) {
    switch (endIndex) {
      case CellIndex endCellIndex:
        return SheetRangeSelection<CellIndex>(startCellIndex, endCellIndex, completed: completed);
      case ColumnIndex endColumnIndex:
        return SheetRangeSelection<CellIndex>(startCellIndex, CellIndex.fromColumnMin(endColumnIndex), completed: completed);
      case RowIndex endRowIndex:
        return SheetRangeSelection<CellIndex>(startCellIndex, CellIndex.fromRowMin(endRowIndex), completed: completed);
    }
  }

  factory SheetSelection.columnRange(
    ColumnIndex startColumnIndex,
    SheetIndex endIndex,
    bool completed,
  ) {
    switch (endIndex) {
      case CellIndex endCellIndex:
        return SheetRangeSelection<ColumnIndex>(startColumnIndex, endCellIndex.column, completed: completed);
      case ColumnIndex endColumnIndex:
        return SheetRangeSelection<ColumnIndex>(startColumnIndex, endColumnIndex, completed: completed);
      case RowIndex _:
        return SheetRangeSelection<ColumnIndex>(startColumnIndex, ColumnIndex.zero, completed: completed);
    }
  }

  factory SheetSelection.rowRange(
    RowIndex startRowIndex,
    SheetIndex endIndex,
    bool completed,
  ) {
    switch (endIndex) {
      case CellIndex endCellIndex:
        return SheetRangeSelection<RowIndex>(startRowIndex, endCellIndex.row, completed: completed);
      case ColumnIndex _:
        return SheetRangeSelection<RowIndex>(startRowIndex, RowIndex.zero, completed: completed);
      case RowIndex endRowIndex:
        return SheetRangeSelection<RowIndex>(startRowIndex, endRowIndex, completed: completed);
    }
  }

  bool get isCompleted => _completed;

  CellIndex get mainCell;

  SheetIndex get selectionStart;

  SheetIndex get selectionEnd;

  CellIndex get cellStart {
    return switch (selectionStart) {
      CellIndex cellIndex => cellIndex,
      ColumnIndex columnIndex => CellIndex.fromColumnMin(columnIndex),
      RowIndex rowIndex => CellIndex.fromRowMin(rowIndex),
    };
  }

  CellIndex get cellEnd {
    return switch (selectionEnd) {
      CellIndex cellIndex => cellIndex,
      ColumnIndex columnIndex => CellIndex.fromColumnMax(columnIndex),
      RowIndex rowIndex => CellIndex.fromRowMax(rowIndex),
    };
  }

  ColumnIndex get columnStart {
    return switch (selectionStart) {
      CellIndex cellIndex => cellIndex.column,
      ColumnIndex columnIndex => columnIndex,
      RowIndex _ => ColumnIndex.zero,
    };
  }

  ColumnIndex get columnEnd {
    return switch (selectionEnd) {
      CellIndex cellIndex => cellIndex.column,
      ColumnIndex columnIndex => columnIndex,
      RowIndex _ => ColumnIndex.zero,
    };
  }

  RowIndex get rowStart {
    return switch (selectionStart) {
      CellIndex cellIndex => cellIndex.row,
      ColumnIndex _ => RowIndex.zero,
      RowIndex rowIndex => rowIndex,
    };
  }

  RowIndex get rowEnd {
    return switch (selectionEnd) {
      CellIndex cellIndex => cellIndex.row,
      ColumnIndex _ => RowIndex.zero,
      RowIndex rowIndex => rowIndex,
    };
  }

  SelectionCellCorners? get cellCorners;

  SelectionStatus isColumnSelected(ColumnIndex columnIndex);

  SelectionStatus isRowSelected(RowIndex rowIndex);

  bool contains(SheetIndex index) {
    return switch (index) {
      CellIndex cellIndex => containsCell(cellIndex),
      ColumnIndex columnIndex => containsColumn(columnIndex),
      RowIndex rowIndex => containsRow(rowIndex),
    };
  }

  bool containsCell(CellIndex index) {
    bool rowSelected = containsRow(index.row);
    bool columnSelected = containsColumn(index.column);

    return rowSelected && columnSelected;
  }

  bool containsRow(RowIndex index) {
    if (isFullWidthSelection) return true;

    RowIndex leftRow = rowStart < rowEnd ? rowStart : rowEnd;
    RowIndex rightRow = rowStart < rowEnd ? rowEnd : rowStart;

    return index.value >= leftRow.value && index.value <= rightRow.value;
  }

  bool containsColumn(ColumnIndex index) {
    if (isFullHeightSelection) return true;

    ColumnIndex leftColumn = columnStart < columnEnd ? columnStart : columnEnd;
    ColumnIndex rightColumn = columnStart < columnEnd ? columnEnd : columnStart;

    return index.value >= leftColumn.value && index.value <= rightColumn.value;
  }

  bool get isFullHeightSelection => selectionStart is RowIndex && selectionEnd is RowIndex;

  bool get isFullWidthSelection => selectionStart is ColumnIndex && selectionEnd is ColumnIndex;

  SheetSelection complete() => this;

  String stringifySelection();

  SheetSelectionRenderer<SheetSelection> createRenderer(SheetViewport viewport);

  SheetSelection modifyEnd(SheetIndex itemIndex);

  SheetSelection append(SheetSelection appendedSelection) {
    return SheetMultiSelection(selections: <SheetSelection>[this, appendedSelection]);
  }

  bool containsSelection(SheetSelection nestedSelection);

  List<SheetSelection> subtract(SheetSelection subtractedSelection);
}
