import 'package:flutter/material.dart';
import 'package:sheets/selection/paints/sheet_fill_selection_paint.dart';
import 'package:sheets/selection/renderers/sheet_range_selection_renderer.dart';
import 'package:sheets/selection/sheet_selection_paint.dart';
import 'package:sheets/selection/types/sheet_fill_selection.dart';

class SheetFillSelectionRenderer extends SheetRangeSelectionRenderer {
  SheetFillSelectionRenderer({
    required super.viewport,
    required super.selection,
  });

  @override
  SheetFillSelection get selection => super.selection as SheetFillSelection;

  @override
  bool get fillHandleVisible => selection.baseSelection.isCompleted;

  @override
  Offset? get fillHandleOffset => selection.baseSelection.createRenderer(viewport).fillHandleOffset;

  @override
  SheetSelectionPaint getPaint({bool? mainCellVisible, bool? backgroundVisible}) {
    return SheetFillSelectionPaint(this, mainCellVisible, backgroundVisible);
  }
}

