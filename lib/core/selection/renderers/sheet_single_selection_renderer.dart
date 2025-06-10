import 'package:flutter/material.dart';
import 'package:sheets/core/selection/paints/sheet_single_selection_paint.dart';
import 'package:sheets/core/selection/sheet_selection_paint.dart';
import 'package:sheets/core/selection/sheet_selection_renderer.dart';
import 'package:sheets/core/selection/types/sheet_single_selection.dart';
import 'package:sheets/core/viewport/viewport_item.dart';

class SheetSingleSelectionRenderer extends SheetSelectionRenderer<SheetSingleSelection> {
  SheetSingleSelectionRenderer({
    required super.selection,
    required super.viewport,
  });

  @override
  bool get fillHandleVisible => selection.fillHandleVisible && selection.isCompleted;

  @override
  Offset? get fillHandleOffset => selectedCell?.rect.bottomRight;

  @override
  SheetSelectionPaint getPaint({bool? mainCellVisible, bool? backgroundVisible}) {
    return SheetSingleSelectionPaint(this, mainCellVisible, backgroundVisible);
  }

  ViewportCell? get selectedCell =>
      viewport.visibleContent.findCell(selection.start.cell);
}
