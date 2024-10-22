import 'package:sheets/core/sheet_index.dart';
import 'package:sheets/core/viewport/viewport_item.dart';
import 'package:sheets/utils/closest_visible.dart';
import 'package:sheets/utils/direction.dart';

class ClosestVisibleColumnIndexCalculator {
  final List<ViewportColumn> visibleColumns;

  ClosestVisibleColumnIndexCalculator(this.visibleColumns);

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
