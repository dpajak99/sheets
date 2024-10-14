import 'package:flutter/material.dart';
import 'package:sheets/viewport/sheet_viewport.dart';
import 'package:sheets/selection/renderers/sheet_fill_selection_renderer.dart';
import 'package:sheets/selection/selection_bounds.dart';
import 'package:sheets/selection/sheet_selection_paint.dart';
import 'package:sheets/selection/sheet_selection_renderer.dart';

class SheetFillSelectionPaint extends SheetSelectionPaint {
  final SheetFillSelectionRenderer renderer;

  SheetFillSelectionPaint(
      this.renderer,
      bool? mainCellVisible,
      bool? backgroundVisible,
      ) : super(mainCellVisible: mainCellVisible ?? true, backgroundVisible: backgroundVisible ?? true);

  @override
  void paint(SheetViewport viewport, Canvas canvas, Size size) {
    SheetSelectionRenderer sheetSelectionRenderer = renderer.selection.baseSelection.createRenderer(viewport);
    sheetSelectionRenderer.getPaint().paint(viewport, canvas, size);

    SelectionBounds? selectionBounds = renderer.selectionBounds;
    if (selectionBounds == null) {
      return;
    }

    Rect selectionRect = selectionBounds.selectionRect;
    paintFillBorder(canvas, selectionRect);
  }
}