import 'package:sheets/core/sheet_index.dart';
import 'package:sheets/core/viewport/viewport_item.dart';

class VisibleCellsRenderer {
  VisibleCellsRenderer({
    required this.visibleRows,
    required this.visibleColumns,
  });

  final List<ViewportRow> visibleRows;

  final List<ViewportColumn> visibleColumns;

  List<ViewportCell> build() {
    List<ViewportCell> visibleCells = <ViewportCell>[];

    for (ViewportRow row in visibleRows) {
      for (ViewportColumn column in visibleColumns) {
        ViewportCell viewportCell = ViewportCell(
          index: CellIndex(column: column.index, row: row.index),
          column: column,
          row: row,
          value: '',
        );
        visibleCells.add(viewportCell);
      }
    }

    return visibleCells;
  }
}
