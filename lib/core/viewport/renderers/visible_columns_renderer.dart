import 'package:sheets/core/config/sheet_constants.dart';
import 'package:sheets/core/sheet_data.dart';
import 'package:sheets/core/sheet_index.dart';
import 'package:sheets/core/sheet_style.dart';
import 'package:sheets/core/viewport/sheet_viewport_rect.dart';
import 'package:sheets/core/viewport/viewport_item.dart';

class VisibleColumnsRenderer {
  VisibleColumnsRenderer({
    required this.viewportRect,
    required this.data,
    required this.scrollOffset,
  });

  final SheetViewportRect viewportRect;
  final WorksheetData data;
  final double scrollOffset;

  List<ViewportColumn> build() {
    double currentWidth = 0;
    double viewportWidth = viewportRect.width - rowHeadersWidth;
    double pinnedWidth = data.pinnedColumnsFullWidth;
    double offset = data.pinnedColumnCount > 0 ? pinnedBorderWidth : 0;
    List<ViewportColumn> visibleColumns = <ViewportColumn>[];

    for (int i = 0; i < data.columnCount; i++) {
      ColumnIndex columnIndex = ColumnIndex(i);
      ColumnStyle columnStyle = data.columns.get(columnIndex);
      bool pinned = i < data.pinnedColumnCount;

      double adjustedStart = currentWidth - (pinned ? 0 : scrollOffset) + (pinned ? 0 : offset);
      double end = adjustedStart + columnStyle.width + borderWidth;

      bool visible = pinned
          ? end > 0 && adjustedStart < viewportWidth
          : end > pinnedWidth && adjustedStart < viewportWidth;

      if (visible) {
        visibleColumns.add(
          ViewportColumn(
            index: columnIndex,
            style: columnStyle,
            rect: BorderRect.fromLTWH(
              rowHeadersWidth + borderWidth + adjustedStart,
              0,
              columnStyle.width,
              columnHeadersHeight,
            ),
          ),
        );
      }

      currentWidth += columnStyle.width + borderWidth;
    }

    return visibleColumns;
  }
}
