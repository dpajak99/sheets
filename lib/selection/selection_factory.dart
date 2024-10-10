import 'package:sheets/core/sheet_item_index.dart';
import 'package:sheets/selection/types/sheet_range_selection.dart';
import 'package:sheets/selection/types/sheet_selection.dart';
import 'package:sheets/selection/types/sheet_single_selection.dart';

class SelectionFactory {
  static SheetSelection getSingleSelection(SheetItemIndex cellIndex, {bool completed = true}) {
    return switch (cellIndex) {
      CellIndex index => SheetSingleSelection(cellIndex: index, completed: false),
      ColumnIndex index => _getColumnSelection(index, completed: false),
      RowIndex index => _getRowSelection(index, completed: false),
    };
  }

  static SheetSelection getRangeSelection({required SheetItemIndex start, required SheetItemIndex end, bool completed = false}) {
    SheetSelection? sheetSelection = switch (start) {
      CellIndex start => _getCellDynamicRangeSelection(start, end, completed: completed),
      ColumnIndex start => _getColumnDynamicRangeSelection(start, end, completed:  completed),
      RowIndex start => _getRowRangeDynamicSelection(start, end, completed: completed),
    };

    return sheetSelection;
  }

  static SheetSelection getAllSelection() {
    return SheetRangeSelection(
      start: CellIndex(rowIndex: RowIndex.zero, columnIndex: ColumnIndex.zero),
      end: CellIndex(rowIndex: RowIndex.max, columnIndex: ColumnIndex.max),
      completed: true,
    );
  }

  static SheetSelection _getColumnSelection(ColumnIndex columnIndex, {bool completed = true}) {
    return SheetRangeSelection(
      start: CellIndex(rowIndex: RowIndex.zero, columnIndex: columnIndex),
      end: CellIndex(rowIndex: RowIndex.max, columnIndex: columnIndex),
      completed: completed,
    );
  }

  static SheetSelection _getRowSelection(RowIndex rowIndex, {bool completed = true}) {
    return SheetRangeSelection(
      start: CellIndex(rowIndex: rowIndex, columnIndex: ColumnIndex.zero),
      end: CellIndex(rowIndex: rowIndex, columnIndex: ColumnIndex.max),
      completed: completed,
    );
  }

  static SheetSelection _getCellDynamicRangeSelection(CellIndex start, SheetItemIndex end, {bool completed = false}) {
    return switch (end) {
      CellIndex end => SheetRangeSelection(start: start, end: end, completed: completed),
      ColumnIndex end => _getColumnRangeSelection(start: start.columnIndex, end: end, completed: completed),
      RowIndex end => _getRowRangeSelection(start: start.rowIndex, end: end, completed: completed),
    };
  }

  static SheetSelection _getColumnDynamicRangeSelection(ColumnIndex start, SheetItemIndex end, {bool completed = false}) {
    return switch (end) {
      CellIndex end => _getColumnRangeSelection(start: start, end: end.columnIndex, completed: completed),
      ColumnIndex end => _getColumnRangeSelection(start: start, end: end, completed: completed),
      RowIndex _ => _getColumnRangeSelection(start: start, end: ColumnIndex.zero, completed: completed),
    };
  }

  static SheetSelection _getRowRangeDynamicSelection(RowIndex start, SheetItemIndex end, {bool completed = false}) {
    return switch (end) {
      CellIndex end => _getRowRangeSelection(start: start, end: end.rowIndex, completed: completed),
      RowIndex end => _getRowRangeSelection(start: start, end: end, completed: completed),
      ColumnIndex _ => _getRowRangeSelection(start: start, end: RowIndex.zero, completed: completed),
    };
  }

  static SheetSelection _getColumnRangeSelection({required ColumnIndex start, required ColumnIndex end, bool completed = false}) {
    return SheetRangeSelection(
      start: CellIndex(rowIndex: RowIndex.zero, columnIndex: start),
      end: CellIndex(rowIndex: RowIndex.max, columnIndex: end),
      completed: completed,
    );
  }

  static SheetSelection _getRowRangeSelection({required RowIndex start, required RowIndex end, bool completed = false}) {
    return SheetRangeSelection(
      start: CellIndex(rowIndex: start, columnIndex: ColumnIndex.zero),
      end: CellIndex(rowIndex: end, columnIndex: ColumnIndex.max),
      completed: completed,
    );
  }
}
