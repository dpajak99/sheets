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
    double firstVisibleCoordinate = scrollOffset;
    FirstVisibleRowInfo firstVisibleRowInfo = worksheet.findRowByY(firstVisibleCoordinate);

    double maxContentHeight = viewportRect.height - columnHeadersHeight;
    double currentContentHeight = -firstVisibleRowInfo.hiddenHeight;

    List<ViewportRow> visibleRows = <ViewportRow>[];
    int index = firstVisibleRowInfo.index.value;

    while (currentContentHeight < maxContentHeight && index < worksheet.rows) {
      RowIndex rowIndex = RowIndex(index);
      RowConfig rowConfig = worksheet.getRow(rowIndex);

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
