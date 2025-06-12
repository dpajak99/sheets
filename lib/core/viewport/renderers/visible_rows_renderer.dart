import 'package:equatable/equatable.dart';
import 'package:sheets/core/config/sheet_constants.dart';
import 'package:sheets/core/sheet_data.dart';
import 'package:sheets/core/sheet_index.dart';
import 'package:sheets/core/sheet_style.dart';
import 'package:sheets/core/viewport/sheet_viewport_rect.dart';
import 'package:sheets/core/viewport/viewport_item.dart';

class VisibleRowsRenderer {
  VisibleRowsRenderer({
    required this.viewportRect,
    required this.data,
    required this.scrollOffset,
  });

  final SheetViewportRect viewportRect;

  final WorksheetData data;

  final double scrollOffset;

  List<ViewportRow> build() {
    double currentHeight = 0;
    double viewportHeight = viewportRect.height - columnHeadersHeight;
    double pinnedHeight = data.pinnedRowsFullHeight;
    double offset = data.pinnedRowCount > 0 ? pinnedBorderWidth : 0;
    List<ViewportRow> visibleRows = <ViewportRow>[];

    for (int i = 0; i < data.rowCount; i++) {
      RowIndex rowIndex = RowIndex(i);
      RowStyle rowStyle = data.rows.get(rowIndex);
      bool pinned = i < data.pinnedRowCount;

      double adjustedStart = currentHeight - (pinned ? 0 : scrollOffset) + (pinned ? 0 : offset);
      double end = adjustedStart + rowStyle.height + borderWidth;

      bool visible = pinned
          ? end > 0 && adjustedStart < viewportHeight
          : end > pinnedHeight && adjustedStart < viewportHeight;

      if (visible) {
        visibleRows.add(
          ViewportRow(
            index: rowIndex,
            style: rowStyle,
            rect: BorderRect.fromLTWH(
              0,
              columnHeadersHeight + borderWidth + adjustedStart,
              rowHeadersWidth,
              rowStyle.height,
            ),
          ),
        );
      }

      currentHeight += rowStyle.height + borderWidth;
    }

    return visibleRows;
  }
}
