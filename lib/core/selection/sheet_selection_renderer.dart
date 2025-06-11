import 'package:flutter/material.dart';
import 'package:sheets/core/selection/sheet_selection.dart';
import 'package:sheets/core/selection/sheet_selection_paint.dart';
import 'package:sheets/core/viewport/sheet_viewport.dart';
import 'package:sheets/core/config/sheet_constants.dart';
import 'package:sheets/core/sheet_data.dart';
import 'package:sheets/core/sheet_index.dart';
import 'package:sheets/core/cell_properties.dart';

abstract class SheetSelectionRenderer<T extends SheetSelection> {
  SheetSelectionRenderer({
    required this.selection,
    required this.viewport,
  });

  final SheetViewport viewport;
  final T selection;

  WorksheetData get _data => viewport.visibleContent.data;

  double get _horizontalScrollOffset {
    ViewportColumn? unpinned;
    for (ViewportColumn c in viewport.visibleContent.columns) {
      if (c.index.value >= _data.pinnedColumnCount) {
        unpinned = c;
        break;
      }
    }
    if (unpinned == null) {
      return 0;
    }

    double sheetX = 0;
    for (int i = 0; i < unpinned.index.value; i++) {
      sheetX += _data.columns.getWidth(ColumnIndex(i)) + borderWidth;
    }

    double localX = unpinned.rect.left - rowHeadersWidth - borderWidth;
    return sheetX - localX;
  }

  double get _verticalScrollOffset {
    ViewportRow? unpinned;
    for (ViewportRow r in viewport.visibleContent.rows) {
      if (r.index.value >= _data.pinnedRowCount) {
        unpinned = r;
        break;
      }
    }
    if (unpinned == null) {
      return 0;
    }

    double sheetY = 0;
    for (int i = 0; i < unpinned.index.value; i++) {
      sheetY += _data.rows.getHeight(RowIndex(i)) + borderWidth;
    }

    double localY = unpinned.rect.top - columnHeadersHeight - borderWidth;
    return sheetY - localY;
  }

  BorderRect _simpleCellRect(CellIndex index) {
    double x = rowHeadersWidth + borderWidth;
    for (int i = 0; i < index.column.value; i++) {
      x += _data.columns.getWidth(ColumnIndex(i)) + borderWidth;
    }

    double y = columnHeadersHeight + borderWidth;
    for (int i = 0; i < index.row.value; i++) {
      y += _data.rows.getHeight(RowIndex(i)) + borderWidth;
    }

    bool columnPinned = index.column.value < _data.pinnedColumnCount;
    bool rowPinned = index.row.value < _data.pinnedRowCount;

    if (!columnPinned) {
      x -= _horizontalScrollOffset;
    }
    if (!rowPinned) {
      y -= _verticalScrollOffset;
    }

    double width = _data.columns.getWidth(index.column);
    double height = _data.rows.getHeight(index.row);
    return BorderRect.fromLTWH(x, y, width, height);
  }

  BorderRect _mergedCellRect(MergedCell merge) {
    double left = rowHeadersWidth + borderWidth;
    for (int i = 0; i < merge.start.column.value; i++) {
      left += _data.columns.getWidth(ColumnIndex(i)) + borderWidth;
    }

    double right = rowHeadersWidth + borderWidth;
    for (int i = 0; i <= merge.end.column.value; i++) {
      right += _data.columns.getWidth(ColumnIndex(i));
      if (i != merge.end.column.value) {
        right += borderWidth;
      }
    }

    double top = columnHeadersHeight + borderWidth;
    for (int i = 0; i < merge.start.row.value; i++) {
      top += _data.rows.getHeight(RowIndex(i)) + borderWidth;
    }

    double bottom = columnHeadersHeight + borderWidth;
    for (int i = 0; i <= merge.end.row.value; i++) {
      bottom += _data.rows.getHeight(RowIndex(i));
      if (i != merge.end.row.value) {
        bottom += borderWidth;
      }
    }

    bool columnPinned = merge.start.column.value < _data.pinnedColumnCount;
    bool rowPinned = merge.start.row.value < _data.pinnedRowCount;

    if (!columnPinned) {
      left -= _horizontalScrollOffset;
      right -= _horizontalScrollOffset;
    }
    if (!rowPinned) {
      top -= _verticalScrollOffset;
      bottom -= _verticalScrollOffset;
    }

    return BorderRect.fromLTRB(left, top, right, bottom);
  }

  BorderRect cellRectFor(CellIndex index) {
    CellProperties props = _data.cells.get(index);
    CellMergeStatus merge = props.mergeStatus;
    if (merge is MergedCell) {
      return _mergedCellRect(merge);
    }
    return _simpleCellRect(index);
  }

  bool get fillHandleVisible;

  Offset? get fillHandleOffset;

  SheetSelectionPaint getPaint({bool? mainCellVisible, bool? backgroundVisible});

  bool get isSelectionVisible {
    bool rowVisible = viewport.visibleContent.rows.any((ViewportRow row) => selection.containsRow(row.index));
    bool columnVisible = viewport.visibleContent.columns.any((ViewportColumn column) => selection.containsColumn(column.index));

    return rowVisible && columnVisible;
  }

  Rect visibleAreaFor(CellIndex index) {
    final data = viewport.visibleContent.data;

    bool columnPinned = index.column.value < data.pinnedColumnCount;
    bool rowPinned = index.row.value < data.pinnedRowCount;

    double left = rowHeadersWidth +
        (columnPinned ? borderWidth : data.pinnedColumnsWidth);
    double top = columnHeadersHeight +
        (rowPinned ? borderWidth : data.pinnedRowsHeight);
    double right =
        columnPinned ? rowHeadersWidth + data.pinnedColumnsWidth : viewport.rect.width;
    double bottom =
        rowPinned ? columnHeadersHeight + data.pinnedRowsHeight : viewport.rect.height;

    return Rect.fromLTRB(left, top, right, bottom);
  }
}
