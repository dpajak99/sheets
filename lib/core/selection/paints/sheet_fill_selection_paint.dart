import 'package:flutter/material.dart';
import 'package:sheets/core/selection/renderers/sheet_fill_selection_renderer.dart';
import 'package:sheets/core/selection/selection_rect.dart';
import 'package:sheets/core/selection/sheet_selection.dart';
import 'package:sheets/core/selection/sheet_selection_paint.dart';
import 'package:sheets/core/selection/sheet_selection_renderer.dart';
import 'package:sheets/core/viewport/sheet_viewport.dart';

class SheetFillSelectionPaint extends SheetSelectionPaint {
  SheetFillSelectionPaint(
    this.renderer,
    bool? mainCellVisible,
    bool? backgroundVisible,
  ) : super(mainCellVisible: mainCellVisible ?? true, backgroundVisible: backgroundVisible ?? true);

  final SheetFillSelectionRenderer renderer;

  @override
  void paint(SheetViewport viewport, Canvas canvas, Size size) {
    SheetSelectionRenderer<SheetSelection> sheetSelectionRenderer = renderer.selection.baseSelection.createRenderer(viewport);
    sheetSelectionRenderer.getPaint().paint(viewport, canvas, size);

    SelectionRect? selectionRect = renderer.selectionRect;
    if (selectionRect == null) {
      return;
    }

    paintFillBorder(canvas, selectionRect);
  }
}
