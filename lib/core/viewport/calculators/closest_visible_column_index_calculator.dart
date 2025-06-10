import 'package:sheets/core/sheet_index.dart';
import 'package:sheets/core/viewport/viewport_item.dart';
import 'package:sheets/utils/closest_visible.dart';
import 'package:sheets/utils/direction.dart';

class ClosestVisibleColumnIndexCalculator {
  ClosestVisibleColumnIndexCalculator(this.visibleColumns);

  final List<ViewportColumn> visibleColumns;

  ClosestVisible<ColumnIndex> findFor(CellIndex cellIndex) {
    ColumnIndex cellColumn = cellIndex.column;
    List<ColumnIndex> indices =
        visibleColumns.map((ViewportColumn column) => column.index).toList();

    if (indices.contains(cellColumn)) {
      return ClosestVisible<ColumnIndex>.fullyVisible(cellColumn);
    }

    ColumnIndex firstVisibleColumn = indices.first;
    ColumnIndex lastVisibleColumn = indices.last;

    if (cellColumn < firstVisibleColumn) {
      return ClosestVisible<ColumnIndex>.partiallyVisible(
        hiddenBorders: <Direction>[Direction.left],
        value: firstVisibleColumn,
      );
    }

    if (cellColumn > lastVisibleColumn) {
      return ClosestVisible<ColumnIndex>.partiallyVisible(
        hiddenBorders: <Direction>[Direction.right],
        value: lastVisibleColumn,
      );
    }

    // Column lies between first and last but is not visible (gap).
    ColumnIndex lower = indices.first;
    ColumnIndex upper = indices.last;
    for (ColumnIndex index in indices) {
      if (index.value <= cellColumn.value) {
        lower = index;
      }
      if (index.value >= cellColumn.value) {
        upper = index;
        break;
      }
    }

    int distanceLeft = cellColumn.value - lower.value;
    int distanceRight = upper.value - cellColumn.value;
    if (distanceLeft <= distanceRight) {
      return ClosestVisible<ColumnIndex>.partiallyVisible(
        hiddenBorders: <Direction>[Direction.right],
        value: lower,
      );
    } else {
      return ClosestVisible<ColumnIndex>.partiallyVisible(
        hiddenBorders: <Direction>[Direction.left],
        value: upper,
      );
    }
  }
}
