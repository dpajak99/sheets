import 'package:sheets/viewport/viewport_item.dart';
import 'package:sheets/core/sheet_item_index.dart';
import 'package:sheets/utils/closest_visible.dart';
import 'package:sheets/utils/direction.dart';

/// [ClosestVisibleRowIndexCalculator] is responsible for determining the
/// closest visible row to a given cell's row index. It analyzes the list of
/// visible rows and returns whether the row is fully or partially visible.
class ClosestVisibleRowIndexCalculator {
  /// The list of visible rows in the current viewport.
  final List<ViewportRow> visibleRows;

  /// Creates a [ClosestVisibleRowIndexCalculator] with the given list of
  /// [visibleRows].
  ClosestVisibleRowIndexCalculator(this.visibleRows);

  /// Finds the closest visible row index for the given [cellIndex].
  ///
  /// If the cell's row is within the visible range, it returns the row
  /// as fully visible. Otherwise, it returns the nearest visible row as
  /// partially visible, indicating which side (top or bottom) is hidden.
  ///
  /// - If the [cellRow] is less than the first visible row, it is considered
  /// partially visible from the top.
  /// - If the [cellRow] is greater than the last visible row, it is considered
  /// partially visible from the bottom.
  ClosestVisible<RowIndex> findFor(CellIndex cellIndex) {
    RowIndex firstVisibleRow = visibleRows.first.index;
    RowIndex lastVisibleRow = visibleRows.last.index;
    RowIndex cellRow = cellIndex.rowIndex;

    bool visible = cellRow >= firstVisibleRow && cellRow <= lastVisibleRow;
    bool missingTop = cellRow < firstVisibleRow;

    if (visible) {
      return ClosestVisible<RowIndex>.fullyVisible(cellRow);
    } else if (missingTop) {
      return ClosestVisible<RowIndex>.partiallyVisible(
        hiddenBorders: <Direction>[Direction.top],
        value: firstVisibleRow,
      );
    } else {
      return ClosestVisible<RowIndex>.partiallyVisible(
        hiddenBorders: <Direction>[Direction.bottom],
        value: lastVisibleRow,
      );
    }
  }
}
