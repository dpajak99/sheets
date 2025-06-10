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

  SelectionRect? get mainCellRect {
    ViewportCell? cell = viewport.visibleContent.findCell(selection.mainCell);
    if (cell == null) {
      return null;
    }

    Rect visibleArea = visibleAreaFor(cell.index);

    if (!cell.rect.overlaps(visibleArea)) {
      return null;
    }

    Rect clipped = cell.rect.intersect(visibleArea);
    List<Direction> hiddenBorders = <Direction>[];
    if (clipped.left > cell.rect.left) {
      hiddenBorders.add(Direction.left);
    }
    if (clipped.top > cell.rect.top) {
      hiddenBorders.add(Direction.top);
    }
    if (clipped.right < cell.rect.right) {
      hiddenBorders.add(Direction.right);
    }
    if (clipped.bottom < cell.rect.bottom) {
      hiddenBorders.add(Direction.bottom);
    }

    return SelectionRect.fromLTRB(
      rect: clipped,
      hiddenBorders: hiddenBorders,
    );
  }

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

    Rect startRect = startCell.value.rect;
    Rect endRect = endCell.value.rect;
    Rect selectionBounds;
    switch (selection.direction) {
      case SelectionDirection.bottomRight:
        selectionBounds =
            Rect.fromPoints(startRect.topLeft, endRect.bottomRight);
        break;
      case SelectionDirection.bottomLeft:
        selectionBounds =
            Rect.fromPoints(startRect.topRight, endRect.bottomLeft);
        break;
      case SelectionDirection.topRight:
        selectionBounds =
            Rect.fromPoints(startRect.bottomLeft, endRect.topRight);
        break;
      case SelectionDirection.topLeft:
        selectionBounds =
            Rect.fromPoints(startRect.bottomRight, endRect.topLeft);
        break;
    }

    Rect visibleAreaStart = visibleAreaFor(startCell.value.index);
    Rect visibleAreaEnd = visibleAreaFor(endCell.value.index);
    Rect visibleArea = visibleAreaStart.expandToInclude(visibleAreaEnd);

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
