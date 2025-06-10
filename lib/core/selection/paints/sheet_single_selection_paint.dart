import 'package:flutter/material.dart';
import 'package:sheets/core/selection/renderers/sheet_single_selection_renderer.dart';
import 'package:sheets/core/selection/selection_rect.dart';
import 'package:sheets/core/selection/sheet_selection_paint.dart';
import 'package:sheets/core/viewport/sheet_viewport.dart';

class SheetSingleSelectionPaint extends SheetSelectionPaint {
  SheetSingleSelectionPaint(
    this.renderer,
    bool? mainCellVisible,
    bool? backgroundVisible,
  ) : super(mainCellVisible: mainCellVisible ?? true, backgroundVisible: backgroundVisible ?? false);

  final SheetSingleSelectionRenderer renderer;

  @override
  void paint(SheetViewport viewport, Canvas canvas, Size size) {
    SelectionRect? selectedRect = renderer.selectedRect;
    if (selectedRect == null) {
      return;
    }

    if (mainCellVisible) {
      paintMainCell(
        canvas,
        selectedRect,
        edgeVisibility: selectedRect.edgeVisibility,
      );
    } else {
      paintSelectionBorder(
        canvas,
        selectedRect,
        selectedRect.edgeVisibility,
      );
    }

    if (backgroundVisible) {
      paintSelectionBackground(canvas, selectedRect);
    }
  }
}
