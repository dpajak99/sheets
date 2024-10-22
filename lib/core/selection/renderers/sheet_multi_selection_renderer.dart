import 'package:flutter/material.dart';
import 'package:sheets/core/selection/paints/sheet_multi_selection_paint.dart';
import 'package:sheets/core/selection/sheet_selection_paint.dart';
import 'package:sheets/core/selection/sheet_selection_renderer.dart';
import 'package:sheets/core/selection/types/sheet_multi_selection.dart';
import 'package:sheets/core/viewport/viewport_item.dart';

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

  ViewportCell? get mainCell => viewport.visibleContent.findCell(selection.mainCell);
}
