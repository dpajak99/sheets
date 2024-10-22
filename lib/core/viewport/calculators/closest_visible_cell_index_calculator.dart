import 'package:sheets/core/sheet_index.dart';
import 'package:sheets/core/viewport/calculators/closest_visible_column_index_calculator.dart';
import 'package:sheets/core/viewport/calculators/closest_visible_row_index_calculator.dart';
import 'package:sheets/core/viewport/viewport_item.dart';
import 'package:sheets/utils/closest_visible.dart';

class ClosestVisibleCellIndexCalculator {
  final ClosestVisibleRowIndexCalculator rowIndexCalculator;

  final ClosestVisibleColumnIndexCalculator columnIndexCalculator;

  ClosestVisibleCellIndexCalculator({
    required List<ViewportRow> visibleRows,
    required List<ViewportColumn> visibleColumns,
  })  : rowIndexCalculator = ClosestVisibleRowIndexCalculator(visibleRows),
        columnIndexCalculator = ClosestVisibleColumnIndexCalculator(visibleColumns);

  ClosestVisible<CellIndex> findFor(CellIndex cellIndex) {
    ClosestVisible<RowIndex> closestVisibleRowIndex = rowIndexCalculator.findFor(cellIndex);
    ClosestVisible<ColumnIndex> closestVisibleColumnIndex = columnIndexCalculator.findFor(cellIndex);

    return ClosestVisible.combineCellIndex(closestVisibleRowIndex, closestVisibleColumnIndex);
  }
}
