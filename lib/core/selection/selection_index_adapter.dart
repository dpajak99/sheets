import 'package:sheets/core/sheet_index.dart';
import 'package:sheets/core/viewport/sheet_viewport_content.dart';

class SelectionIndexAdapter {
  static SheetIndex adaptToCellIndex(SheetIndex selectedIndex, SheetViewportContent visibleContent) {
    return switch (selectedIndex) {
      CellIndex cellIndex => cellIndex,
      ColumnIndex columnIndex => CellIndex(row: visibleContent.rows.first.index, column: columnIndex).move(-1, 0),
      RowIndex rowIndex => CellIndex(row: rowIndex, column: visibleContent.columns.first.index).move(0, -1),
    };
  }
}
