import 'package:flutter/material.dart';
import 'package:sheets/core/selection/renderers/sheet_multi_selection_renderer.dart';
import 'package:sheets/core/selection/sheet_selection.dart';
import 'package:sheets/core/selection/sheet_selection_paint.dart';
import 'package:sheets/core/selection/sheet_selection_renderer.dart';
import 'package:sheets/core/selection/selection_rect.dart';
import 'package:sheets/core/viewport/sheet_viewport.dart';

class SheetMultiSelectionPaint extends SheetSelectionPaint {
  SheetMultiSelectionPaint(
    this.renderer,
    bool? mainCellVisible,
    bool? backgroundVisible,
  ) : super(mainCellVisible: mainCellVisible ?? true, backgroundVisible: backgroundVisible ?? true);

  final SheetMultiSelectionRenderer renderer;

  @override
  void paint(SheetViewport viewport, Canvas canvas, Size size) {
    for (SheetSelection mergedSelection in renderer.selection.selections) {
      SheetSelection completedSelection = mergedSelection.copyWith(completed: true);
      SheetSelectionRenderer<SheetSelection> renderer = completedSelection.createRenderer(viewport);

      renderer.getPaint(mainCellVisible: false, backgroundVisible: true).paint(viewport, canvas, size);
    }

    SelectionRect? selectedRect = renderer.mainCellRect;
    if (selectedRect == null) {
      return;
    }

    paintMainCell(
      canvas,
      selectedRect,
      edgeVisibility: selectedRect.edgeVisibility,
    );
  }
}
