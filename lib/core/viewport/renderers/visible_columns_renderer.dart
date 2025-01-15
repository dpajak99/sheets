import 'package:sheets/core/config/sheet_constants.dart';
import 'package:sheets/core/data/worksheet.dart';
import 'package:sheets/core/sheet_index.dart';
import 'package:sheets/core/viewport/sheet_viewport_rect.dart';
import 'package:sheets/core/viewport/viewport_item.dart';

class VisibleColumnsRenderer {
  VisibleColumnsRenderer({
    required this.viewportRect,
    required this.scrollOffset,
  });

  final SheetViewportRect viewportRect;
  final double scrollOffset;

  List<ViewportColumn> build(Worksheet worksheet) {
    List<ViewportColumn> visibleColumns = <ViewportColumn>[];
    List<MapEntry<ColumnIndex, ColumnConfig>> pinnedColumns = worksheet.columnConfigs.entries.map((MapEntry<ColumnIndex, ColumnConfig> e) => e).toList();

    double currentContentWidth = 0;
    for(MapEntry<ColumnIndex, ColumnConfig> column in pinnedColumns) {
      ViewportColumn viewportColumn = ViewportColumn(
        index: column.key,
        config: column.value,
        rect: BorderRect.fromLTWH(currentContentWidth + rowHeadersWidth + borderWidth, 0, column.value.width, columnHeadersHeight),
      );
      visibleColumns.add(viewportColumn);

      currentContentWidth += column.value.width + borderWidth;
    }

    double firstVisibleCoordinate = currentContentWidth + scrollOffset;
    FirstVisibleColumnInfo firstVisibleColumnInfo = worksheet.findColumnByX(firstVisibleCoordinate);

    double maxContentWidth = viewportRect.width - rowHeadersWidth;
    currentContentWidth -= firstVisibleColumnInfo.hiddenWidth;

    int index = firstVisibleColumnInfo.index.value;

    while (currentContentWidth < maxContentWidth && index < worksheet.cols) {
      ColumnIndex columnIndex = ColumnIndex(index);
      ColumnConfig columnConfig = worksheet.getColumn(columnIndex);
      if(columnConfig.pinned) {
        index++;
        continue;
      }

      ViewportColumn viewportColumn = ViewportColumn(
        index: columnIndex,
        config: columnConfig,
        rect: BorderRect.fromLTWH(currentContentWidth + rowHeadersWidth + borderWidth, 0, columnConfig.width, columnHeadersHeight),
      );
      visibleColumns.add(viewportColumn);
      currentContentWidth += viewportColumn.style.width + borderWidth;

      index++;
    }

    return visibleColumns;
  }


}