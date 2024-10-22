import 'package:sheets/core/viewport/viewport_item.dart';

class VisibleCellsRenderer {
  final List<ViewportRow> visibleRows;

  final List<ViewportColumn> visibleColumns;

  VisibleCellsRenderer({
    required this.visibleRows,
    required this.visibleColumns,
  });

  List<ViewportCell> build() {
    List<ViewportCell> visibleCells = <ViewportCell>[];

    for (ViewportRow row in visibleRows) {
      for (ViewportColumn column in visibleColumns) {
        ViewportCell viewportCell = ViewportCell.fromColumnRow(column, row, value: '');
        visibleCells.add(viewportCell);
      }
    }

    return visibleCells;
  }
}
