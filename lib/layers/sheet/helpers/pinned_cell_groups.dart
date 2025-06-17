import 'package:sheets/core/sheet_data.dart';
import 'package:sheets/core/viewport/viewport_item.dart';

class PinnedCellGroups {
  PinnedCellGroups({
    required this.normal,
    required this.rows,
    required this.columns,
    required this.both,
  });

  final List<ViewportCell> normal;
  final List<ViewportCell> rows;
  final List<ViewportCell> columns;
  final List<ViewportCell> both;
}

PinnedCellGroups groupPinnedCells(
  Iterable<ViewportCell> cells,
  WorksheetData data,
) {
  final List<ViewportCell> both = <ViewportCell>[];
  final List<ViewportCell> rows = <ViewportCell>[];
  final List<ViewportCell> columns = <ViewportCell>[];
  final List<ViewportCell> normal = <ViewportCell>[];

  for (final ViewportCell cell in cells) {
    final bool rowPinned = cell.index.row.value < data.pinnedRowCount;
    final bool columnPinned = cell.index.column.value < data.pinnedColumnCount;

    if (rowPinned && columnPinned) {
      both.add(cell);
    } else if (rowPinned) {
      rows.add(cell);
    } else if (columnPinned) {
      columns.add(cell);
    } else {
      normal.add(cell);
    }
  }

  return PinnedCellGroups(
    normal: normal,
    rows: rows,
    columns: columns,
    both: both,
  );
}
