import 'package:flutter/material.dart';
import 'package:sheets/core/selection/sheet_selection.dart';
import 'package:sheets/core/selection/sheet_selection_paint.dart';
import 'package:sheets/core/viewport/sheet_viewport.dart';
import 'package:sheets/core/viewport/viewport_item.dart';
import 'package:sheets/core/config/sheet_constants.dart';

abstract class SheetSelectionRenderer<T extends SheetSelection> {
  SheetSelectionRenderer({
    required this.selection,
    required this.viewport,
  });

  final SheetViewport viewport;
  final T selection;

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

    double left = rowHeadersWidth + (columnPinned ? 0 : data.pinnedColumnsWidth);
    double top = columnHeadersHeight + (rowPinned ? 0 : data.pinnedRowsHeight);
    double width = viewport.rect.width - rowHeadersWidth - (columnPinned ? 0 : data.pinnedColumnsWidth);
    double height = viewport.rect.height - columnHeadersHeight - (rowPinned ? 0 : data.pinnedRowsHeight);

    return Rect.fromLTWH(left, top, width, height);
  }
}
