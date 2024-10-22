import 'package:flutter/material.dart';
import 'package:sheets/core/selection/renderers/sheet_multi_selection_renderer.dart';
import 'package:sheets/core/selection/sheet_selection.dart';
import 'package:sheets/core/selection/sheet_selection_paint.dart';
import 'package:sheets/core/selection/sheet_selection_renderer.dart';
import 'package:sheets/core/viewport/sheet_viewport.dart';
import 'package:sheets/core/viewport/viewport_item.dart';

class SheetMultiSelectionPaint extends SheetSelectionPaint {
  final SheetMultiSelectionRenderer renderer;

  SheetMultiSelectionPaint(
    this.renderer,
    bool? mainCellVisible,
    bool? backgroundVisible,
  ) : super(mainCellVisible: mainCellVisible ?? true, backgroundVisible: backgroundVisible ?? true);

  @override
  void paint(SheetViewport viewport, Canvas canvas, Size size) {
    for (SheetSelection mergedSelection in renderer.selection.selections) {
      SheetSelection completedSelection = mergedSelection.copyWith(completed: true);
      SheetSelectionRenderer<SheetSelection> renderer = completedSelection.createRenderer(viewport);

      renderer.getPaint(mainCellVisible: false, backgroundVisible: true).paint(viewport, canvas, size);
    }

    ViewportCell? selectedCell = renderer.mainCell;
    if (selectedCell == null) {
      return;
    }

    paintMainCell(canvas, selectedCell.rect);
  }
}
