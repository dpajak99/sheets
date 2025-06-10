import 'package:sheets/core/sheet_index.dart';
import 'package:sheets/core/viewport/viewport_item.dart';
import 'package:sheets/utils/closest_visible.dart';
import 'package:sheets/utils/direction.dart';

class ClosestVisibleRowIndexCalculator {
  ClosestVisibleRowIndexCalculator(this.visibleRows);

  final List<ViewportRow> visibleRows;

  ClosestVisible<RowIndex> findFor(CellIndex cellIndex) {
    RowIndex cellRow = cellIndex.row;
    List<RowIndex> indices =
        visibleRows.map((ViewportRow row) => row.index).toList();

    if (indices.contains(cellRow)) {
      return ClosestVisible<RowIndex>.fullyVisible(cellRow);
    }

    RowIndex firstVisibleRow = indices.first;
    RowIndex lastVisibleRow = indices.last;

    if (cellRow < firstVisibleRow) {
      return ClosestVisible<RowIndex>.partiallyVisible(
        hiddenBorders: <Direction>[Direction.top],
        value: firstVisibleRow,
      );
    }

    if (cellRow > lastVisibleRow) {
      return ClosestVisible<RowIndex>.partiallyVisible(
        hiddenBorders: <Direction>[Direction.bottom],
        value: lastVisibleRow,
      );
    }

    // The row lies between first and last but is not visible (gap caused by
    // pinned regions). Find the closest visible row.
    RowIndex lower = indices.first;
    RowIndex upper = indices.last;
    for (RowIndex index in indices) {
      if (index.value <= cellRow.value) {
        lower = index;
      }
      if (index.value >= cellRow.value) {
        upper = index;
        break;
      }
    }

    int distanceTop = cellRow.value - lower.value;
    int distanceBottom = upper.value - cellRow.value;
    if (distanceTop <= distanceBottom) {
      return ClosestVisible<RowIndex>.partiallyVisible(
        hiddenBorders: <Direction>[Direction.bottom],
        value: lower,
      );
    } else {
      return ClosestVisible<RowIndex>.partiallyVisible(
        hiddenBorders: <Direction>[Direction.top],
        value: upper,
      );
    }
  }
}
