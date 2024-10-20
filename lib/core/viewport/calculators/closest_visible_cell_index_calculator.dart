import 'package:sheets/core/sheet_index.dart';
import 'package:sheets/core/viewport/calculators/closest_visible_column_index_calculator.dart';
import 'package:sheets/core/viewport/calculators/closest_visible_row_index_calculator.dart';
import 'package:sheets/core/viewport/viewport_item.dart';
import 'package:sheets/utils/closest_visible.dart';

/// [ClosestVisibleCellIndexCalculator] is responsible for determining the
/// closest visible cell index by calculating both the closest visible row
/// and column for a given cell index.
///
/// It uses the [ClosestVisibleRowIndexCalculator] and
/// [ClosestVisibleColumnIndexCalculator] to find the closest visible row and
/// column and then combines them to return the closest visible cell.
class ClosestVisibleCellIndexCalculator {
  /// Calculator to determine the closest visible row for a given cell index.
  final ClosestVisibleRowIndexCalculator rowIndexCalculator;

  /// Calculator to determine the closest visible column for a given cell index.
  final ClosestVisibleColumnIndexCalculator columnIndexCalculator;

  /// Creates a [ClosestVisibleCellIndexCalculator] with the given list of
  /// [visibleRows] and [visibleColumns], initializing row and column calculators.
  ClosestVisibleCellIndexCalculator({
    required List<ViewportRow> visibleRows,
    required List<ViewportColumn> visibleColumns,
  })  : rowIndexCalculator = ClosestVisibleRowIndexCalculator(visibleRows),
        columnIndexCalculator = ClosestVisibleColumnIndexCalculator(visibleColumns);

  /// Finds the closest visible [CellIndex] for the given [cellIndex].
  ///
  /// It calculates the closest visible row and column separately using
  /// [rowIndexCalculator] and [columnIndexCalculator] and then combines the
  /// results to return the closest visible cell.
  ClosestVisible<CellIndex> findFor(CellIndex cellIndex) {
    ClosestVisible<RowIndex> closestVisibleRowIndex = rowIndexCalculator.findFor(cellIndex);
    ClosestVisible<ColumnIndex> closestVisibleColumnIndex = columnIndexCalculator.findFor(cellIndex);

    return ClosestVisible.combineCellIndex(closestVisibleRowIndex, closestVisibleColumnIndex);
  }
}
