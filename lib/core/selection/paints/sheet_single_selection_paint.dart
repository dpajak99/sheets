import 'package:flutter/material.dart';
import 'package:sheets/core/selection/renderers/sheet_single_selection_renderer.dart';
import 'package:sheets/core/selection/sheet_selection_paint.dart';
import 'package:sheets/core/viewport/sheet_viewport.dart';
import 'package:sheets/core/viewport/viewport_item.dart';

class SheetSingleSelectionPaint extends SheetSelectionPaint {
  final SheetSingleSelectionRenderer renderer;

  SheetSingleSelectionPaint(
    this.renderer,
    bool? mainCellVisible,
    bool? backgroundVisible,
  ) : super(mainCellVisible: mainCellVisible ?? true, backgroundVisible: backgroundVisible ?? false);

  @override
  void paint(SheetViewport viewport, Canvas canvas, Size size) {
    ViewportCell? selectedCell = renderer.selectedCell;
    if (selectedCell == null) return;

    if (mainCellVisible) {
      paintMainCell(canvas, selectedCell.rect);
    } else {
      paintSelectionBorder(canvas, selectedCell.rect);
    }

    if (backgroundVisible) paintSelectionBackground(canvas, selectedCell.rect);
  }
}