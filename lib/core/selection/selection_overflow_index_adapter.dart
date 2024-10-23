import 'package:sheets/core/sheet_index.dart';

class SelectionOverflowIndexAdapter {
  static SheetIndex adaptToCellIndex(SheetIndex selectedIndex, RowIndex firstVisibleRow, ColumnIndex firstVisibleColumn) {
    return switch (selectedIndex) {
      CellIndex cellIndex => cellIndex,
      ColumnIndex columnIndex => CellIndex(row: firstVisibleRow, column: columnIndex).move(-1, 0),
      RowIndex rowIndex => CellIndex(row: rowIndex, column: firstVisibleColumn).move(0, -1),
    };
  }
}
