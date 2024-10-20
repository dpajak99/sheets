import 'package:sheets/core/selection/sheet_selection.dart';
import 'package:sheets/core/selection/types/sheet_fill_selection.dart';
import 'package:sheets/core/selection/types/sheet_multi_selection.dart';
import 'package:sheets/core/selection/types/sheet_range_selection.dart';
import 'package:sheets/core/selection/types/sheet_single_selection.dart';
import 'package:sheets/core/sheet_index.dart';
import 'package:sheets/utils/direction.dart';

class SheetSelectionFactory {
  static SheetSelection single(SheetIndex index, {bool completed = false}) {
    return switch (index) {
      CellIndex cellIndex => SheetSingleSelection(cellIndex, completed: completed),
      ColumnIndex columnIndex => SheetRangeSelection<ColumnIndex>.single(columnIndex, completed: completed),
      RowIndex rowIndex => SheetRangeSelection<RowIndex>.single(rowIndex, completed: completed),
    };
  }

  static SheetSelection range({
    required SheetIndex start,
    required SheetIndex end,
    bool completed = false,
  }) {
    if (start is CellIndex && start == end) {
      return SheetSingleSelection(start, completed: completed);
    }

    return switch (start) {
      CellIndex start => _cellRange(start, end, completed),
      ColumnIndex start => _columnRange(start, end, completed),
      RowIndex start => _rowRange(start, end, completed),
    };
  }

  static SheetSelection multi({
    required List<SheetSelection> selections,
  }) {
    return SheetMultiSelection(selections: selections);
  }

  static SheetSelection fill(
    CellIndex start,
    CellIndex end, {
    required SheetSelection baseSelection,
    required Direction fillDirection,
    bool completed = false,
  }) {
    return SheetFillSelection(
      start,
      end,
      baseSelection: baseSelection,
      fillDirection: fillDirection,
    );
  }

  static SheetSelection all() {
    return SheetRangeSelection<CellIndex>(CellIndex.zero, CellIndex.max, completed: true);
  }

  static SheetSelection _cellRange(
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

  static SheetSelection _columnRange(
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

  static SheetSelection _rowRange(
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
}
