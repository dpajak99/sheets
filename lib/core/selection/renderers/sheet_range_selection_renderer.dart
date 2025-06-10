import 'package:flutter/material.dart';
import 'package:sheets/core/selection/paints/sheet_range_selection_paint.dart';
import 'package:sheets/core/selection/selection_rect.dart';
import 'package:sheets/core/selection/sheet_selection_paint.dart';
import 'package:sheets/core/selection/sheet_selection_renderer.dart';
import 'package:sheets/core/selection/types/sheet_range_selection.dart';
import 'package:sheets/core/sheet_index.dart';
import 'package:sheets/core/viewport/viewport_item.dart';
import 'package:sheets/utils/closest_visible.dart';
import 'package:sheets/utils/direction.dart';

class SheetRangeSelectionRenderer<T extends SheetIndex> extends SheetSelectionRenderer<SheetRangeSelection<T>> {
  SheetRangeSelectionRenderer({
    required super.selection,
    required super.viewport,
  });

  @override
  bool get fillHandleVisible => selection.isCompleted;

  @override
  Offset? get fillHandleOffset => selectionRect?.bottomRight;

  @override
  SheetSelectionPaint getPaint({bool? mainCellVisible, bool? backgroundVisible}) {
    return SheetRangeSelectionPaint<T>(this, mainCellVisible, backgroundVisible);
  }

  SelectionRect? get selectionRect => _calculateSelectionBounds();

  ViewportCell? get mainCell => viewport.visibleContent.findCell(selection.mainCell);

  SelectionRect? _calculateSelectionBounds() {
    bool rowVisible = viewport.visibleContent.rows
        .any((ViewportRow row) => selection.containsRow(row.index));
    bool columnVisible = viewport.visibleContent.columns
        .any((ViewportColumn column) => selection.containsColumn(column.index));

    if (!rowVisible || !columnVisible) {
      return null;
    }

    ClosestVisible<ViewportCell> startCell =
        viewport.visibleContent.findCellOrClosest(selection.start.cell);
    ClosestVisible<ViewportCell> endCell =
        viewport.visibleContent.findCellOrClosest(selection.end.cell);

    Rect selectionBounds = Rect.fromPoints(
      startCell.value.rect.topLeft,
      endCell.value.rect.bottomRight,
    );

    double pinnedColumnsWidth = viewport.visibleContent.data.pinnedColumnsWidth;
    double pinnedRowsHeight = viewport.visibleContent.data.pinnedRowsHeight;

    Rect visibleArea = Rect.fromLTWH(
      rowHeadersWidth + pinnedColumnsWidth,
      columnHeadersHeight + pinnedRowsHeight,
      viewport.rect.width - rowHeadersWidth - pinnedColumnsWidth,
      viewport.rect.height - columnHeadersHeight - pinnedRowsHeight,
    );

    if (!selectionBounds.overlaps(visibleArea)) {
      return null;
    }

    Rect clipped = selectionBounds.intersect(visibleArea);

    List<Direction> hiddenBorders =
        <Direction>[...startCell.hiddenBorders, ...endCell.hiddenBorders];

    if (clipped.left > selectionBounds.left) {
      hiddenBorders.add(Direction.left);
    }
    if (clipped.top > selectionBounds.top) {
      hiddenBorders.add(Direction.top);
    }
    if (clipped.right < selectionBounds.right) {
      hiddenBorders.add(Direction.right);
    }
    if (clipped.bottom < selectionBounds.bottom) {
      hiddenBorders.add(Direction.bottom);
    }

    return SelectionRect.fromLTRB(
      rect: clipped,
      hiddenBorders: hiddenBorders,
    );
  }
}
