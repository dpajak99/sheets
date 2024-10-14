import 'package:flutter/material.dart';
import 'package:sheets/core/sheet_item_config.dart';
import 'package:sheets/core/sheet_viewport.dart';
import 'package:sheets/selection/renderers/sheet_multi_selection_renderer.dart';
import 'package:sheets/selection/sheet_selection.dart';
import 'package:sheets/selection/sheet_selection_paint.dart';
import 'package:sheets/selection/sheet_selection_renderer.dart';

class SheetMultiSelectionPaint extends SheetSelectionPaint {
  final SheetMultiSelectionRenderer renderer;

  SheetMultiSelectionPaint(
      this.renderer,
      bool? mainCellVisible,
      bool? backgroundVisible,
      ) : super(mainCellVisible: mainCellVisible ?? true, backgroundVisible: backgroundVisible ?? true);

  @override
  void paint(SheetViewport paintConfig, Canvas canvas, Size size) {
    for (SheetSelection mergedSelection in renderer.selection.mergedSelections) {
      SheetSelection completedSelection = mergedSelection.complete();
      SheetSelectionRenderer renderer = completedSelection.createRenderer(paintConfig);

      renderer.getPaint(mainCellVisible: false, backgroundVisible: true).paint(paintConfig, canvas, size);
    }

    CellConfig? selectedCell = renderer.lastSelectedCell;
    if (selectedCell == null) {
      return;
    }

    paintMainCell(canvas, selectedCell.rect);
  }
}
