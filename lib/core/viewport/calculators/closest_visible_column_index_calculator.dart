import 'package:sheets/core/sheet_index.dart';
import 'package:sheets/core/viewport/viewport_item.dart';
import 'package:sheets/utils/closest_visible.dart';
import 'package:sheets/utils/direction.dart';

/// [ClosestVisibleColumnIndexCalculator] is responsible for determining the
/// closest visible column to a given cell's column index. It analyzes the
/// list of visible columns and returns whether the column is fully or
/// partially visible.
class ClosestVisibleColumnIndexCalculator {
  /// The list of visible columns in the current viewport.
  final List<ViewportColumn> visibleColumns;

  /// Creates a [ClosestVisibleColumnIndexCalculator] with the given list of
  /// [visibleColumns].
  ClosestVisibleColumnIndexCalculator(this.visibleColumns);

  /// Finds the closest visible column index for the given [cellIndex].
  ///
  /// If the cell's column is within the visible range, it returns the column
  /// as fully visible. Otherwise, it returns the nearest visible column as
  /// partially visible, indicating which side (left or right) is hidden.
  ///
  /// - If the [cellColumn] is less than the first visible column, it is
  /// considered partially visible from the left.
  /// - If the [cellColumn] is greater than the last visible column, it is
  /// considered partially visible from the right.
  ClosestVisible<ColumnIndex> findFor(CellIndex cellIndex) {
    ColumnIndex firstVisibleColumn = visibleColumns.first.index;
    ColumnIndex lastVisibleColumn = visibleColumns.last.index;
    ColumnIndex cellColumn = cellIndex.column;

    if (cellColumn >= firstVisibleColumn && cellColumn <= lastVisibleColumn) {
      return ClosestVisible<ColumnIndex>.fullyVisible(cellColumn);
    } else if (cellColumn < firstVisibleColumn) {
      return ClosestVisible<ColumnIndex>.partiallyVisible(
        hiddenBorders: <Direction>[Direction.left],
        value: firstVisibleColumn,
      );
    } else {
      return ClosestVisible<ColumnIndex>.partiallyVisible(
        hiddenBorders: <Direction>[Direction.right],
        value: lastVisibleColumn,
      );
    }
  }
}
