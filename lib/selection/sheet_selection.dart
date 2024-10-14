import 'package:equatable/equatable.dart';
import 'package:sheets/core/sheet_properties.dart';
import 'package:sheets/selection/selection_status.dart';
import 'package:sheets/core/sheet_item_index.dart';
import 'package:sheets/viewport/sheet_viewport.dart';
import 'package:sheets/selection/selection_corners.dart';
import 'package:sheets/selection/sheet_selection_renderer.dart';
import 'package:sheets/selection/types/sheet_fill_selection.dart';
import 'package:sheets/selection/types/sheet_multi_selection.dart';
import 'package:sheets/selection/types/sheet_range_selection.dart';
import 'package:sheets/selection/types/sheet_single_selection.dart';
import 'package:sheets/utils/direction.dart';

abstract class SheetSelection with EquatableMixin {
  final bool _completed;
  late SheetProperties sheetProperties;

  void applyProperties(SheetProperties properties) {
    sheetProperties = properties;
  }

  SheetSelection({required bool completed}) : _completed = completed;

  factory SheetSelection.single(
    SheetItemIndex selectedIndex, {
    required bool completed,
  }) {
    return switch (selectedIndex) {
      CellIndex cellIndex => SheetSingleSelection(selectedIndex: cellIndex, completed: false),
      ColumnIndex columnIndex => SheetRangeSelection(start: columnIndex, end: columnIndex, completed: completed),
      RowIndex rowIndex => SheetRangeSelection(start: rowIndex, end: rowIndex, completed: completed),
    };
  }

  factory SheetSelection.range({
    required SheetItemIndex start,
    required SheetItemIndex end,
    required bool completed,
  }) {
    if (start is CellIndex && start == end) {
      return SheetSingleSelection(selectedIndex: start, completed: completed);
    }

    return switch (start) {
      CellIndex startCellIndex => SheetSelection._cellRangeDynamic(startCellIndex, end, completed),
      ColumnIndex startColumnndex => SheetSelection._columnRangeDynamic(startColumnndex, end, completed),
      RowIndex startRowIndex => SheetSelection._rowRangeDynamic(startRowIndex, end, completed),
    };
  }

  factory SheetSelection.multi({
    required List<SheetSelection> selections,
    required CellIndex mainCell,
  }) {
    return SheetMultiSelection(mergedSelections: selections, mainCell: mainCell);
  }

  factory SheetSelection.fill({
    required SheetSelection baseSelection,
    required Direction fillDirection,
    required CellIndex start,
    required CellIndex end,
    required bool completed,
  }) {
    return SheetFillSelection(baseSelection: baseSelection, fillDirection: fillDirection, start: start, end: end, completed: completed);
  }

  factory SheetSelection.all() {
    return SheetRangeSelection(
      start: CellIndex(rowIndex: RowIndex.zero, columnIndex: ColumnIndex.zero),
      end: CellIndex(rowIndex: RowIndex.max, columnIndex: ColumnIndex.max),
      completed: true,
    );
  }

  factory SheetSelection._cellRangeDynamic(
    CellIndex startCellIndex,
    SheetItemIndex endIndex,
    bool completed,
  ) {
    switch (endIndex) {
      case CellIndex endCellIndex:
        return SheetRangeSelection(
          start: startCellIndex,
          end: endCellIndex,
          completed: completed,
        );
      case ColumnIndex endColumnIndex:
        return SheetRangeSelection(
          start: startCellIndex,
          end: CellIndex(rowIndex: RowIndex.zero, columnIndex: endColumnIndex),
          completed: completed,
        );
      case RowIndex endRowIndex:
        return SheetRangeSelection(
          start: startCellIndex,
          end: CellIndex(rowIndex: endRowIndex, columnIndex: ColumnIndex.zero),
          completed: completed,
        );
    }
  }

  factory SheetSelection._columnRangeDynamic(
    ColumnIndex startColumnIndex,
    SheetItemIndex endIndex,
    bool completed,
  ) {
    switch (endIndex) {
      case CellIndex endCellIndex:
        return SheetSelection._columnRange(startColumnIndex, endCellIndex.columnIndex, completed);
      case ColumnIndex endColumnIndex:
        return SheetSelection._columnRange(startColumnIndex, endColumnIndex, completed);
      case RowIndex _:
        return SheetSelection._columnRange(startColumnIndex, ColumnIndex.zero, completed);
    }
  }

  factory SheetSelection._columnRange(
    ColumnIndex startColumnIndex,
    ColumnIndex endColumnIndex,
    bool completed,
  ) {
    return SheetRangeSelection(start: startColumnIndex, end: endColumnIndex, completed: completed);
  }

  factory SheetSelection._rowRangeDynamic(
    RowIndex startRowIndex,
    SheetItemIndex endIndex,
    bool completed,
  ) {
    switch (endIndex) {
      case CellIndex endCellIndex:
        return SheetSelection._rowRange(startRowIndex, endCellIndex.rowIndex, completed);
      case ColumnIndex _:
        return SheetSelection._rowRange(startRowIndex, RowIndex.zero, completed);
      case RowIndex endRowIndex:
        return SheetSelection._rowRange(startRowIndex, endRowIndex, completed);
    }
  }

  factory SheetSelection._rowRange(
    RowIndex startRowIndex,
    RowIndex endRowIndex,
    bool completed,
  ) {
    return SheetRangeSelection(start: startRowIndex, end: endRowIndex, completed: completed);
  }

  bool get isCompleted => _completed;

  SheetItemIndex get start;

  SheetItemIndex get end;

  CellIndex get startCellIndex {
    switch (start) {
      case ColumnIndex columnIndex:
        return CellIndex(rowIndex: RowIndex.zero, columnIndex: columnIndex);
      case RowIndex rowIndex:
        return CellIndex(rowIndex: rowIndex, columnIndex: ColumnIndex.zero);
      case CellIndex cellIndex:
        if (cellIndex == CellIndex.max) {
          return CellIndex(rowIndex: RowIndex(sheetProperties.rowCount - 1), columnIndex: ColumnIndex(sheetProperties.columnCount - 1));
        } else if (cellIndex.columnIndex == ColumnIndex.max) {
          return CellIndex(rowIndex: cellIndex.rowIndex, columnIndex: ColumnIndex(sheetProperties.columnCount - 1));
        } else if (cellIndex.rowIndex == RowIndex.max) {
          return CellIndex(rowIndex: RowIndex(sheetProperties.rowCount - 1), columnIndex: cellIndex.columnIndex);
        } else {
          return cellIndex;
        }
    }
  }

  CellIndex get endCellIndex {
    switch (end) {
      case ColumnIndex columnIndex:
        return CellIndex(rowIndex: RowIndex(sheetProperties.rowCount - 1), columnIndex: columnIndex);
      case RowIndex rowIndex:
        return CellIndex(rowIndex: rowIndex, columnIndex: ColumnIndex(sheetProperties.columnCount - 1));
      case CellIndex cellIndex:
        if (cellIndex == CellIndex.max) {
          return CellIndex(rowIndex: RowIndex(sheetProperties.rowCount - 1), columnIndex: ColumnIndex(sheetProperties.columnCount - 1));
        } else if (cellIndex.columnIndex == ColumnIndex.max) {
          return CellIndex(rowIndex: cellIndex.rowIndex, columnIndex: ColumnIndex(sheetProperties.columnCount - 1));
        } else if (cellIndex.rowIndex == RowIndex.max) {
          return CellIndex(rowIndex: RowIndex(sheetProperties.rowCount - 1), columnIndex: cellIndex.columnIndex);
        } else {
          return cellIndex;
        }
    }
  }

  CellIndex get mainCell => startCellIndex;

  Set<CellIndex> get selectedCells;

  SelectionCellCorners? get selectionCellCorners;

  SelectionStatus isColumnSelected(ColumnIndex columnIndex);

  SelectionStatus isRowSelected(RowIndex rowIndex);

  bool containsCell(CellIndex cellIndex);

  SheetSelection complete() => this;

  String stringifySelection();

  SheetSelectionRenderer createRenderer(SheetViewport viewport);

  bool contains(CellIndex cellIndex) {
    SelectionCellCorners? corners = selectionCellCorners;
    if (corners == null) return selectedCells.contains(cellIndex);

    return corners.contains(cellIndex);
  }

  SheetSelection modifyEnd(SheetItemIndex itemIndex, {required bool completed});

  SheetSelection append(SheetSelection appendedSelection) {
    return SheetMultiSelection(
      mergedSelections: [this, appendedSelection],
      mainCell: appendedSelection.mainCell,
    );
  }

  bool containsSelection(SheetSelection nestedSelection);

  List<SheetSelection> subtract(SheetSelection subtractedSelection);

  SheetSelection simplify() => this;
}
