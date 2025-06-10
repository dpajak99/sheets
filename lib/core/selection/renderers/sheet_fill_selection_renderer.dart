import 'package:flutter/material.dart';
import 'package:sheets/core/selection/paints/sheet_fill_selection_paint.dart';
import 'package:sheets/core/selection/renderers/sheet_range_selection_renderer.dart';
import 'package:sheets/core/selection/sheet_selection.dart';
import 'package:sheets/core/selection/sheet_selection_paint.dart';
import 'package:sheets/core/selection/sheet_selection_renderer.dart';
import 'package:sheets/core/selection/types/sheet_fill_selection.dart';
import 'package:sheets/core/sheet_index.dart';

class SheetFillSelectionRenderer extends SheetRangeSelectionRenderer<CellIndex> {
  SheetFillSelectionRenderer({
    required SheetFillSelection super.selection,
    required super.viewport,
  });

  @override
  SheetFillSelection get selection => super.selection as SheetFillSelection;

  @override
  bool get fillHandleVisible {
    SheetSelectionRenderer<SheetSelection> renderer = selection.baseSelection.createRenderer(viewport);
    return renderer.fillHandleVisible && selection.baseSelection.isCompleted;
  }

  @override
  Offset? get fillHandleOffset {
    SheetSelectionRenderer<SheetSelection> renderer = selection.baseSelection.createRenderer(viewport);
    return renderer.fillHandleVisible ? renderer.fillHandleOffset : null;
  }

  @override
  SheetSelectionPaint getPaint({bool? mainCellVisible, bool? backgroundVisible}) {
    return SheetFillSelectionPaint(this, mainCellVisible, backgroundVisible);
  }
}
