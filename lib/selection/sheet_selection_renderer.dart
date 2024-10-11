import 'package:flutter/material.dart';
import 'package:sheets/core/sheet_viewport_delegate.dart';
import 'package:sheets/selection/sheet_selection_paint.dart';

abstract class SheetSelectionRenderer {
  final SheetViewportDelegate viewportDelegate;

  SheetSelectionRenderer({required this.viewportDelegate});

  bool get fillHandleVisible;

  Offset? get fillHandleOffset;

  SheetSelectionPaint getPaint({bool? mainCellVisible, bool? backgroundVisible});
}