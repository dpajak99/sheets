import 'package:flutter/material.dart';
import 'package:sheets/viewport/sheet_viewport.dart';
import 'package:sheets/selection/sheet_selection_paint.dart';

abstract class SheetSelectionRenderer {
  final SheetViewport viewport;

  SheetSelectionRenderer({required this.viewport});

  bool get fillHandleVisible;

  Offset? get fillHandleOffset;

  SheetSelectionPaint getPaint({bool? mainCellVisible, bool? backgroundVisible});
}