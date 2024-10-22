import 'package:sheets/core/sheet_index.dart';
import 'package:sheets/core/viewport/viewport_item.dart';
import 'package:sheets/utils/closest_visible.dart';
import 'package:sheets/utils/direction.dart';

class ClosestVisibleRowIndexCalculator {
  final List<ViewportRow> visibleRows;

  ClosestVisibleRowIndexCalculator(this.visibleRows);

  ClosestVisible<RowIndex> findFor(CellIndex cellIndex) {
    RowIndex firstVisibleRow = visibleRows.first.index;
    RowIndex lastVisibleRow = visibleRows.last.index;
    RowIndex cellRow = cellIndex.row;

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
