import 'package:equatable/equatable.dart';
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
    double firstVisibleCoordinate = scrollOffset;
    FirstVisibleColumnInfo firstVisibleColumnInfo = worksheet.findColumnByX(firstVisibleCoordinate);

    double maxContentWidth = viewportRect.width - rowHeadersWidth;
    double currentContentWidth = -firstVisibleColumnInfo.hiddenWidth;

    List<ViewportColumn> visibleColumns = <ViewportColumn>[];
    int index = firstVisibleColumnInfo.index.value;

    while (currentContentWidth < maxContentWidth && index < worksheet.cols) {
      ColumnIndex columnIndex = ColumnIndex(index);
      ColumnConfig columnConfig = worksheet.getColumn(columnIndex);

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