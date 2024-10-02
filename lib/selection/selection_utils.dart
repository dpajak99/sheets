import 'package:sheets/config/sheet_constants.dart';
import 'package:sheets/core/sheet_item_index.dart';
import 'package:sheets/selection/types/sheet_range_selection.dart';
import 'package:sheets/selection/types/sheet_selection.dart';
import 'package:sheets/selection/types/sheet_single_selection.dart';

class SelectionUtils {
  static SheetSelection getSingleSelection(CellIndex cellIndex) {
    return SheetSingleSelection(cellIndex: cellIndex);
  }

  static SheetSelection getColumnSelection(ColumnIndex columnIndex) {
    return getRangeSelection(
      start: CellIndex(rowIndex: RowIndex(0), columnIndex: columnIndex),
      end: CellIndex(rowIndex: RowIndex(defaultRowCount), columnIndex: columnIndex),
      completed: true,
    );
  }

  static SheetSelection getRowSelection(RowIndex rowIndex) {
    return getRangeSelection(
      start: CellIndex(rowIndex: rowIndex, columnIndex: ColumnIndex(0)),
      end: CellIndex(rowIndex: rowIndex, columnIndex: ColumnIndex(defaultColumnCount)),
      completed: true,
    );
  }

  static SheetSelection getRangeSelection({required CellIndex start, required CellIndex end, bool completed = false}) {
    if (start == end) {
      return getSingleSelection(start);
    } else {
      return SheetRangeSelection(start: start, end: end, completed: completed);
    }
  }

  static SheetSelection getColumnRangeSelection({required ColumnIndex start, required ColumnIndex end}) {
    return getRangeSelection(
      start: CellIndex(rowIndex: RowIndex(0), columnIndex: start),
      end: CellIndex(rowIndex: RowIndex(defaultRowCount), columnIndex: end),
      completed: true,
    );
  }

  static SheetSelection getRowRangeSelection({required RowIndex start, required RowIndex end}) {
    return getRangeSelection(
      start: CellIndex(rowIndex: start, columnIndex: ColumnIndex(0)),
      end: CellIndex(rowIndex: end, columnIndex: ColumnIndex(defaultColumnCount)),
      completed: true,
    );
  }

  static SheetSelection getAllSelection() {
    return getRangeSelection(
      start: CellIndex(rowIndex: RowIndex(0), columnIndex: ColumnIndex(0)),
      end: CellIndex(rowIndex: RowIndex(defaultRowCount), columnIndex: ColumnIndex(defaultColumnCount)),
      completed: true,
    );
  }
}