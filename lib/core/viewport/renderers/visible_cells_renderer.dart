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
        ViewportCell viewportCell = ViewportCell.fromColumnRow(column, row);
        visibleCells.add(viewportCell);
      }
    }

    return visibleCells;
  }
}
