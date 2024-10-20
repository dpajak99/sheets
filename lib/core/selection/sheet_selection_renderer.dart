import 'package:flutter/material.dart';
import 'package:sheets/core/selection/sheet_selection.dart';
import 'package:sheets/core/selection/sheet_selection_paint.dart';
import 'package:sheets/core/viewport/sheet_viewport.dart';
import 'package:sheets/core/viewport/viewport_item.dart';

abstract class SheetSelectionRenderer<T extends SheetSelection> {
  final SheetViewport viewport;
  final T selection;

  SheetSelectionRenderer({
    required this.selection,
    required this.viewport,
  });

  bool get fillHandleVisible;

  Offset? get fillHandleOffset;

  SheetSelectionPaint getPaint({bool? mainCellVisible, bool? backgroundVisible});

  bool get isSelectionVisible {
    bool rowVisible = viewport.visibleContent.rows.any((ViewportRow row) => selection.containsRow(row.index));
    bool columnVisible = viewport.visibleContent.columns.any((ViewportColumn column) => selection.containsColumn(column.index));

    return rowVisible && columnVisible;
  }
}
