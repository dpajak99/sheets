import 'package:flutter/material.dart';
import 'package:sheets/core/selection/paints/sheet_single_selection_paint.dart';
import 'package:sheets/core/selection/selection_rect.dart';
import 'package:sheets/core/selection/sheet_selection_paint.dart';
import 'package:sheets/core/selection/sheet_selection_renderer.dart';
import 'package:sheets/core/selection/types/sheet_single_selection.dart';
import 'package:sheets/core/viewport/viewport_item.dart';
import 'package:sheets/utils/direction.dart';

class SheetSingleSelectionRenderer extends SheetSelectionRenderer<SheetSingleSelection> {
  SheetSingleSelectionRenderer({
    required super.selection,
    required super.viewport,
  });

  @override
  bool get fillHandleVisible {
    SelectionRect? rect = selectedRect;
    return selection.fillHandleVisible &&
        selection.isCompleted &&
        rect != null &&
        rect.isBottomBorderVisible &&
        rect.isRightBorderVisible;
  }

  @override
  Offset? get fillHandleOffset =>
      fillHandleVisible ? selectedRect!.bottomRight : null;

  @override
  SheetSelectionPaint getPaint({bool? mainCellVisible, bool? backgroundVisible}) {
    return SheetSingleSelectionPaint(this, mainCellVisible, backgroundVisible);
  }

  SelectionRect? get selectedRect {
    BorderRect cellRect = cellRectFor(selection.start.cell);
    Rect visibleArea = visibleAreaFor(selection.start.cell);

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
