import 'package:flutter/material.dart';
import 'package:sheets/core/sheet_item_config.dart';
import 'package:sheets/core/sheet_viewport_delegate.dart';
import 'package:sheets/selection/renderers/sheet_single_selection_renderer.dart';
import 'package:sheets/selection/sheet_selection_paint.dart';

class SheetSingleSelectionPaint extends SheetSelectionPaint {
  final SheetSingleSelectionRenderer renderer;

  SheetSingleSelectionPaint(
    this.renderer,
    bool? mainCellVisible,
    bool? backgroundVisible,
  ) : super(mainCellVisible: mainCellVisible ?? true, backgroundVisible: backgroundVisible ?? false);

  @override
  void paint(SheetViewportDelegate paintConfig, Canvas canvas, Size size) {
    CellConfig? selectedCell = renderer.selectedCell;
    if (selectedCell == null) return;

    if (mainCellVisible) {
      paintMainCell(canvas, selectedCell.rect);
    } else {
      paintSelectionBorder(canvas, selectedCell.rect);
    }

    if (backgroundVisible) paintSelectionBackground(canvas, selectedCell.rect);
  }
}
