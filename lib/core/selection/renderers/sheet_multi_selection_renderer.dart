import 'package:flutter/material.dart';
import 'package:sheets/core/selection/paints/sheet_multi_selection_paint.dart';
import 'package:sheets/core/selection/sheet_selection_paint.dart';
import 'package:sheets/core/selection/sheet_selection_renderer.dart';
import 'package:sheets/core/selection/types/sheet_multi_selection.dart';
import 'package:sheets/core/selection/selection_rect.dart';
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
}
