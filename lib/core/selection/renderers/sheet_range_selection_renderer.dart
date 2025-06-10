import 'package:flutter/material.dart';
import 'package:sheets/core/selection/paints/sheet_range_selection_paint.dart';
import 'package:sheets/core/selection/selection_rect.dart';
import 'package:sheets/core/selection/sheet_selection_paint.dart';
import 'package:sheets/core/selection/sheet_selection_renderer.dart';
import 'package:sheets/core/selection/types/sheet_range_selection.dart';
import 'package:sheets/core/sheet_index.dart';
import 'package:sheets/core/viewport/viewport_item.dart';
import 'package:sheets/utils/cached_value.dart';
import 'package:sheets/utils/closest_visible.dart';
import 'package:sheets/utils/direction.dart';

class SheetRangeSelectionRenderer<T extends SheetIndex> extends SheetSelectionRenderer<SheetRangeSelection<T>> {
  SheetRangeSelectionRenderer({
    required super.selection,
    required super.viewport,
  }) {
    _selectionRect = CachedValue<SelectionRect?>(_calculateSelectionBounds);
  }

  late final CachedValue<SelectionRect?> _selectionRect;

  @override
  bool get fillHandleVisible => selection.isCompleted;

  @override
  Offset? get fillHandleOffset => selectionRect?.bottomRight;

  @override
  SheetSelectionPaint getPaint({bool? mainCellVisible, bool? backgroundVisible}) {
    return SheetRangeSelectionPaint<T>(this, mainCellVisible, backgroundVisible);
  }

  SelectionRect? get selectionRect => _selectionRect.value;

  ViewportCell? get mainCell => viewport.visibleContent.findCell(selection.mainCell);

  SelectionRect? _calculateSelectionBounds() {
    bool rowVisible = viewport.visibleContent.rows
        .any((ViewportRow row) => selection.containsRow(row.index));
    bool columnVisible = viewport.visibleContent.columns
        .any((ViewportColumn column) => selection.containsColumn(column.index));

    if (!rowVisible || !columnVisible) {
      return null;
    }

    ClosestVisible<ViewportCell> startCell =
        viewport.visibleContent.findCellOrClosest(selection.start.cell);
    ClosestVisible<ViewportCell> endCell =
        viewport.visibleContent.findCellOrClosest(selection.end.cell);

    List<Direction> hiddenBorders =
        <Direction>[...startCell.hiddenBorders, ...endCell.hiddenBorders];
    return SelectionRect(
      startCell.value.rect,
      endCell.value.rect,
      selection.direction,
      hiddenBorders: hiddenBorders,
    );
  }
}
