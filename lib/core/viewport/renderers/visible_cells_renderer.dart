import 'package:sheets/core/sheet_data_manager.dart';
import 'package:sheets/core/sheet_index.dart';
import 'package:sheets/core/viewport/viewport_item.dart';

class VisibleCellsRenderer {
  VisibleCellsRenderer({
    required this.visibleRows,
    required this.visibleColumns,
  });

  final List<ViewportRow> visibleRows;

  final List<ViewportColumn> visibleColumns;

  List<ViewportCell> build(SheetDataManager properties) {
    List<ViewportCell> visibleCells = <ViewportCell>[];

    for (ViewportRow row in visibleRows) {
      for (ViewportColumn column in visibleColumns) {
        CellIndex cellIndex = CellIndex(column: column.index, row: row.index);

        ViewportCell viewportCell = ViewportCell(
          index: cellIndex,
          column: column,
          row: row,
          properties: properties.getCellProperties(cellIndex),
        );
        visibleCells.add(viewportCell);
      }
    }

    return visibleCells;
  }
}
