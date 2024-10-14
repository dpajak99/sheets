import 'package:flutter/material.dart';
import 'package:sheets/viewport/sheet_viewport.dart';
import 'package:sheets/selection/renderers/sheet_range_selection_renderer.dart';
import 'package:sheets/selection/selection_bounds.dart';
import 'package:sheets/selection/sheet_selection_paint.dart';

class SheetRangeSelectionPaint extends SheetSelectionPaint {
  final SheetRangeSelectionRenderer renderer;

  SheetRangeSelectionPaint(
      this.renderer,
      bool? mainCellVisible,
      bool? backgroundVisible,
      ) : super(mainCellVisible: mainCellVisible ?? true, backgroundVisible: backgroundVisible ?? true);

  @override
  void paint(SheetViewport viewport, Canvas canvas, Size size) {
    SelectionBounds? selectionBounds = renderer.selectionBounds;
    if (selectionBounds == null) return;

    Rect selectionRect = selectionBounds.selectionRect;

    if (mainCellVisible && selectionBounds.isStartCellVisible) paintMainCell(canvas, selectionBounds.mainCellRect);
    if (backgroundVisible) paintSelectionBackground(canvas, selectionRect);

    if (renderer.selection.isCompleted) {
      paintSelectionBorder(
        canvas,
        selectionRect,
        top: selectionBounds.isTopBorderVisible,
        right: selectionBounds.isRightBorderVisible,
        bottom: selectionBounds.isBottomBorderVisible,
        left: selectionBounds.isLeftBorderVisible,
      );
    }
  }
}
