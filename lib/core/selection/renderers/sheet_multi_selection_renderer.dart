import 'package:flutter/material.dart';
import 'package:sheets/core/selection/paints/sheet_multi_selection_paint.dart';
import 'package:sheets/core/selection/sheet_selection_paint.dart';
import 'package:sheets/core/selection/sheet_selection_renderer.dart';
import 'package:sheets/core/selection/types/sheet_multi_selection.dart';
import 'package:sheets/core/selection/selection_rect.dart';
import 'package:sheets/core/viewport/viewport_item.dart';
import 'package:sheets/utils/direction.dart';

class SheetMultiSelectionRenderer extends SheetSelectionRenderer<SheetMultiSelection> {
  SheetMultiSelectionRenderer({
    required super.selection,
    required super.viewport,
  });

  @override
  bool get fillHandleVisible => false;

  @override
  Offset? get fillHandleOffset => null;

  @override
  SheetSelectionPaint getPaint({bool? mainCellVisible, bool? backgroundVisible}) {
    return SheetMultiSelectionPaint(this, mainCellVisible, backgroundVisible);
  }

  SelectionRect? get mainCellRect {
    ViewportCell? cell = viewport.visibleContent.findCell(selection.mainCell);
    if (cell == null) {
      return null;
    }

    double pinnedColumnsWidth = viewport.visibleContent.data.pinnedColumnsWidth;
    double pinnedRowsHeight = viewport.visibleContent.data.pinnedRowsHeight;

    Rect visibleArea = Rect.fromLTWH(
      rowHeadersWidth + pinnedColumnsWidth,
      columnHeadersHeight + pinnedRowsHeight,
      viewport.rect.width - rowHeadersWidth - pinnedColumnsWidth,
      viewport.rect.height - columnHeadersHeight - pinnedRowsHeight,
    );

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
}
