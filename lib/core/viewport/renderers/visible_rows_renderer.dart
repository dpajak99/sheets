import 'package:equatable/equatable.dart';
import 'package:sheets/core/config/sheet_constants.dart';
import 'package:sheets/core/data/worksheet.dart';
import 'package:sheets/core/sheet_index.dart';
import 'package:sheets/core/viewport/sheet_viewport_rect.dart';
import 'package:sheets/core/viewport/viewport_item.dart';

class VisibleRowsRenderer {
  VisibleRowsRenderer({
    required this.viewportRect,
    required this.scrollOffset,
  });

  final SheetViewportRect viewportRect;
  final double scrollOffset;

  List<ViewportRow> build(Worksheet worksheet) {
    List<ViewportRow> visibleRows = <ViewportRow>[];
    List<MapEntry<RowIndex, RowConfig>> pinnedRows = worksheet.rowConfigs.entries.map((MapEntry<RowIndex, RowConfig> e) => e).toList();

    double currentContentHeight = 0;
    for(MapEntry<RowIndex, RowConfig> row in pinnedRows) {
      ViewportRow viewportRow = ViewportRow(
        index: row.key,
        config: row.value,
        rect: BorderRect.fromLTWH(0, currentContentHeight + columnHeadersHeight + borderWidth, rowHeadersWidth, row.value.height),
      );
      visibleRows.add(viewportRow);

      currentContentHeight += row.value.height + borderWidth;
    }

    double firstVisibleCoordinate = currentContentHeight + scrollOffset;
    FirstVisibleRowInfo firstVisibleRowInfo = worksheet.findRowByY(firstVisibleCoordinate);

    double maxContentHeight = viewportRect.height - columnHeadersHeight;
    currentContentHeight -= firstVisibleRowInfo.hiddenHeight;

    int index = firstVisibleRowInfo.index.value;

    while (currentContentHeight < maxContentHeight && index < worksheet.rows) {
      RowIndex rowIndex = RowIndex(index);
      RowConfig rowConfig = worksheet.getRow(rowIndex);
      if(rowConfig.pinned) {
        index++;
        continue;
      }

      ViewportRow viewportRow = ViewportRow(
        index: rowIndex,
        config: rowConfig,
        rect: BorderRect.fromLTWH(0, currentContentHeight + columnHeadersHeight + borderWidth, rowHeadersWidth, rowConfig.height),
      );
      visibleRows.add(viewportRow);
      currentContentHeight += viewportRow.config.height + borderWidth;

      index++;
    }

    return visibleRows;
  }
}
