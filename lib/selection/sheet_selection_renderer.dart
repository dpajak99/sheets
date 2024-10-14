import 'package:flutter/material.dart';
import 'package:sheets/core/sheet_viewport.dart';
import 'package:sheets/selection/sheet_selection_paint.dart';

abstract class SheetSelectionRenderer {
  final SheetViewport viewportDelegate;

  SheetSelectionRenderer({required this.viewportDelegate});

  bool get fillHandleVisible;

  Offset? get fillHandleOffset;

  SheetSelectionPaint getPaint({bool? mainCellVisible, bool? backgroundVisible});
}