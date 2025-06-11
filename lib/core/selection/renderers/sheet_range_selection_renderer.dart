import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:sheets/core/selection/paints/sheet_range_selection_paint.dart';
import 'package:sheets/core/selection/selection_rect.dart';
import 'package:sheets/core/selection/sheet_selection_paint.dart';
import 'package:sheets/core/selection/sheet_selection_renderer.dart';
import 'package:sheets/core/selection/types/sheet_range_selection.dart';
import 'package:sheets/core/sheet_index.dart';
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
    BorderRect cellRect = cellRectFor(selection.mainCell);
    Rect visibleArea = visibleAreaFor(selection.mainCell);

    if (!cellRect.overlaps(visibleArea)) {
      return null;
    }

    Rect clipped = cellRect.intersect(visibleArea);
    List<Direction> hiddenBorders = <Direction>[];
    if (clipped.left > cellRect.left) {
      hiddenBorders.add(Direction.left);
    }
    if (clipped.top > cellRect.top) {
      hiddenBorders.add(Direction.top);
    }
    if (clipped.right < cellRect.right) {
      hiddenBorders.add(Direction.right);
    }
    if (clipped.bottom < cellRect.bottom) {
      hiddenBorders.add(Direction.bottom);
    }

    return SelectionRect.fromLTRB(
      rect: clipped,
      hiddenBorders: hiddenBorders,
    );
  }

  SelectionRect? _calculateSelectionBounds() {
    BorderRect startRect = cellRectFor(selection.start.cell);
    BorderRect endRect = cellRectFor(selection.end.cell);
    Rect selectionBounds = Rect.fromLTRB(
      math.min(startRect.left, endRect.left),
      math.min(startRect.top, endRect.top),
      math.max(startRect.right, endRect.right),
      math.max(startRect.bottom, endRect.bottom),
    );

    Rect visibleAreaStart = visibleAreaFor(selection.start.cell);
    Rect visibleAreaEnd = visibleAreaFor(selection.end.cell);
    Rect visibleArea = visibleAreaStart.expandToInclude(visibleAreaEnd);

    if (!selectionBounds.overlaps(visibleArea)) {
      return null;
    }

    Rect clipped = selectionBounds.intersect(visibleArea);

    List<Direction> hiddenBorders = <Direction>[];

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
