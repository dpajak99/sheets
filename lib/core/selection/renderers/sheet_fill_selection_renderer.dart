import 'package:flutter/material.dart';
import 'package:sheets/core/selection/paints/sheet_fill_selection_paint.dart';
import 'package:sheets/core/selection/renderers/sheet_range_selection_renderer.dart';
import 'package:sheets/core/selection/sheet_selection_paint.dart';
import 'package:sheets/core/selection/types/sheet_fill_selection.dart';
import 'package:sheets/core/sheet_index.dart';

class SheetFillSelectionRenderer<T extends SheetIndex> extends SheetRangeSelectionRenderer<T> {
  SheetFillSelectionRenderer({
    required SheetFillSelection<T> super.selection,
    required super.viewport,
  });

  @override
  SheetFillSelection<T> get selection => super.selection as SheetFillSelection<T>;

  @override
  bool get fillHandleVisible => selection.baseSelection.isCompleted;

  @override
  Offset? get fillHandleOffset => selection.baseSelection.createRenderer(viewport).fillHandleOffset;

  @override
  SheetSelectionPaint getPaint({bool? mainCellVisible, bool? backgroundVisible}) {
    return SheetFillSelectionPaint<T>(this, mainCellVisible, backgroundVisible);
  }
}

