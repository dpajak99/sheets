import 'package:equatable/equatable.dart';
import 'package:sheets/core/sheet_properties.dart';
import 'package:sheets/selection/selection_status.dart';
import 'package:sheets/core/sheet_item_index.dart';
import 'package:sheets/core/sheet_viewport_delegate.dart';
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
      ColumnIndex columnIndex => SheetRangeSelection(
          start: CellIndex(rowIndex: RowIndex.zero, columnIndex: columnIndex),
          end: CellIndex(rowIndex: RowIndex.max, columnIndex: columnIndex),
          completed: completed,
        ),
      RowIndex rowIndex => SheetRangeSelection(
          start: CellIndex(rowIndex: rowIndex, columnIndex: ColumnIndex.zero),
          end: CellIndex(rowIndex: rowIndex, columnIndex: ColumnIndex.max),
          completed: completed,
        ),
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
          end: CellIndex(rowIndex: endRowIndex, columnIndex: ColumnIndex.max),
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
    return SheetRangeSelection(
      start: CellIndex(rowIndex: RowIndex.zero, columnIndex: startColumnIndex),
      end: CellIndex(rowIndex: RowIndex.max, columnIndex: endColumnIndex),
      completed: completed,
    );
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
    return SheetRangeSelection(
      start: CellIndex(rowIndex: startRowIndex, columnIndex: ColumnIndex.zero),
      end: CellIndex(rowIndex: endRowIndex, columnIndex: ColumnIndex.max),
      completed: completed,
    );
  }

  bool get isCompleted => _completed;

  CellIndex get start;

  CellIndex get end;

  CellIndex get trueStart {
    if (start == CellIndex.max) {
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
    if (end == CellIndex.max) {
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

  String stringifySelection();

  SheetSelectionRenderer createRenderer(SheetViewportDelegate viewportDelegate);

  bool contains(CellIndex cellIndex) {
    SelectionCellCorners? corners = selectionCellCorners;
    if (corners == null) return selectedCells.contains(cellIndex);

    return corners.contains(cellIndex);
  }

  SheetSelection modifyEnd(CellIndex cellIndex, {required bool completed});

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
