import 'package:flutter/material.dart';
import 'package:sheets/viewport/viewport_item.dart';
import 'package:sheets/selection/paints/sheet_multi_selection_paint.dart';
import 'package:sheets/selection/sheet_selection_paint.dart';
import 'package:sheets/selection/sheet_selection_renderer.dart';
import 'package:sheets/selection/types/sheet_multi_selection.dart';

class SheetMultiSelectionRenderer extends SheetSelectionRenderer<SheetMultiSelection> {
  SheetMultiSelectionRenderer({
    required super.selection,
    required super.viewport,
  });

  @override
  bool get fillHandleVisible => false;

  @override
  Offset? get fillHandleOffset => null;

  @override
  SheetSelectionPaint getPaint({bool? mainCellVisible, bool? backgroundVisible}) {
    return SheetMultiSelectionPaint(this, mainCellVisible, backgroundVisible);
  }

  ViewportCell? get lastSelectedCell => viewport.visibleContent.findCell(selection.mainCell);
}
