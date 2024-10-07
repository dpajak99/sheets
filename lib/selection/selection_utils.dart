import 'package:sheets/core/config/sheet_constants.dart';
import 'package:sheets/core/sheet_item_index.dart';
import 'package:sheets/selection/types/sheet_range_selection.dart';
import 'package:sheets/selection/types/sheet_selection.dart';
import 'package:sheets/selection/types/sheet_single_selection.dart';

class SelectionUtils {
  static SheetSelection getSingleSelection(CellIndex cellIndex, {bool completed = true}) {
    return SheetSingleSelection(cellIndex: cellIndex, completed: completed);
  }

  static SheetSelection getColumnSelection(ColumnIndex columnIndex, {bool completed = true}) {
    return getRangeSelection(
      start: CellIndex(rowIndex: RowIndex(0), columnIndex: columnIndex),
      end: CellIndex(rowIndex: RowIndex(defaultRowCount - 1), columnIndex: columnIndex),
      completed: completed,
    );
  }

  static SheetSelection getRowSelection(RowIndex rowIndex, {bool completed = true}) {
    return getRangeSelection(
      start: CellIndex(rowIndex: rowIndex, columnIndex: ColumnIndex(0)),
      end: CellIndex(rowIndex: rowIndex, columnIndex: ColumnIndex(defaultColumnCount - 1)),
      completed: completed,
    );
  }

  static SheetSelection getRangeSelection({required CellIndex start, required CellIndex end, bool completed = false}) {
    return SheetRangeSelection(start: start, end: end, completed: completed);
  }

  static SheetSelection getColumnRangeSelection({required ColumnIndex start, required ColumnIndex end, bool completed = false}) {
    return getRangeSelection(
      start: CellIndex(rowIndex: RowIndex(0), columnIndex: start),
      end: CellIndex(rowIndex: RowIndex(defaultRowCount - 1), columnIndex: end),
      completed: completed,
    );
  }

  static SheetSelection getRowRangeSelection({required RowIndex start, required RowIndex end, bool completed = false}) {
    return getRangeSelection(
      start: CellIndex(rowIndex: start, columnIndex: ColumnIndex(0)),
      end: CellIndex(rowIndex: end, columnIndex: ColumnIndex(defaultColumnCount - 1)),
      completed: completed,
    );
  }

  static SheetSelection getAllSelection() {
    return getRangeSelection(
      start: CellIndex(rowIndex: RowIndex(0), columnIndex: ColumnIndex(0)),
      end: CellIndex(rowIndex: RowIndex(defaultRowCount - 1), columnIndex: ColumnIndex(defaultColumnCount - 1)),
      completed: true,
    );
  }
}
