import 'package:flutter/material.dart';
import 'package:sheets/core/selection/renderers/sheet_range_selection_renderer.dart';
import 'package:sheets/core/selection/selection_rect.dart';
import 'package:sheets/core/selection/sheet_selection_paint.dart';
import 'package:sheets/core/sheet_index.dart';
import 'package:sheets/core/viewport/sheet_viewport.dart';

class SheetRangeSelectionPaint<T extends SheetIndex> extends SheetSelectionPaint {
  SheetRangeSelectionPaint(
    this.renderer,
    bool? mainCellVisible,
    bool? backgroundVisible,
  ) : super(mainCellVisible: mainCellVisible ?? true, backgroundVisible: backgroundVisible ?? true);

  final SheetRangeSelectionRenderer<T> renderer;

  @override
  void paint(SheetViewport viewport, Canvas canvas, Size size) {
    SelectionRect? selectionRect = renderer.selectionRect;
    if (selectionRect == null) {
      return;
    }

    if (mainCellVisible && renderer.mainCellRect != null) {
      paintMainCell(
        canvas,
        renderer.mainCellRect!,
        edgeVisibility: renderer.mainCellRect!.edgeVisibility,
      );
    }
    if (backgroundVisible) {
      paintSelectionBackground(canvas, selectionRect);
    }

    if (renderer.selection.isCompleted) {
      paintSelectionBorder(
        canvas,
        selectionRect,
        selectionRect.edgeVisibility,
      );
    }
  }
}
