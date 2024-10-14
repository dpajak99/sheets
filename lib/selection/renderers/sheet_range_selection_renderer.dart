import 'package:flutter/material.dart';
import 'package:sheets/viewport/viewport_item.dart';
import 'package:sheets/selection/paints/sheet_range_selection_paint.dart';
import 'package:sheets/selection/selection_bounds.dart';
import 'package:sheets/selection/selection_corners.dart';
import 'package:sheets/selection/sheet_selection_paint.dart';
import 'package:sheets/selection/sheet_selection_renderer.dart';
import 'package:sheets/selection/types/sheet_range_selection.dart';
import 'package:sheets/utils/cached_value.dart';
import 'package:sheets/utils/closest_visible.dart';
import 'package:sheets/utils/direction.dart';

class SheetRangeSelectionRenderer extends SheetSelectionRenderer {
  final SheetRangeSelection selection;
  late final CachedValue<SelectionBounds?> _selectionBounds;

  SheetRangeSelectionRenderer({
    required super.viewport,
    required this.selection,
  }) {
    _selectionBounds = CachedValue<SelectionBounds?>(_calculateSelectionBounds);
  }

  @override
  bool get fillHandleVisible => selection.isCompleted;

  @override
  Offset? get fillHandleOffset => selectionBounds?.selectionRect.bottomRight;

  @override
  SheetSelectionPaint getPaint({bool? mainCellVisible, bool? backgroundVisible}) {
    return SheetRangeSelectionPaint(this, mainCellVisible, backgroundVisible);
  }

  SelectionBounds? get selectionBounds => _selectionBounds.value;

  SelectionBounds? _calculateSelectionBounds() {
    ViewportCell? startCell = viewport.visibleContent.findCell(selection.startCellIndex);
    ViewportCell? endCell = viewport.visibleContent.findCell(selection.endCellIndex);

    if (startCell != null && endCell != null) {
      return SelectionBounds(startCell, endCell, selection.direction);
    }

    if (startCell == null && endCell != null) {
      ClosestVisible<ViewportCell> startCell = viewport.visibleContent.findClosestCell(selection.startCellIndex);
      
      return SelectionBounds(startCell.value, endCell, selection.direction, hiddenBorders: startCell.hiddenBorders, startCellVisible: false);
    }

    if (startCell != null && endCell == null) {
      ClosestVisible<ViewportCell> endCell = viewport.visibleContent.findClosestCell(selection.endCellIndex);

      return SelectionBounds(startCell, endCell.value, selection.direction, hiddenBorders: endCell.hiddenBorders, lastCellVisible: false);
    }

    if (startCell == null && endCell == null && (_selectionPartiallyVisible)) {
      ClosestVisible<ViewportCell> startCell = viewport.visibleContent.findClosestCell(selection.startCellIndex);
      ClosestVisible<ViewportCell> endCell = viewport.visibleContent.findClosestCell(selection.endCellIndex);
      
      List<Direction> hiddenBorders = [...startCell.hiddenBorders, ...endCell.hiddenBorders];

      return SelectionBounds(startCell.value, endCell.value, selection.direction, hiddenBorders: hiddenBorders, startCellVisible: false);
    }

    return null;
  }

  bool get _selectionPartiallyVisible {
    SelectionCellCorners corners = selection.selectionCellCorners;

    bool rowVisible = viewport.visibleContent.rows.any((row) => corners.containsRow(row.index));
    bool columnVisible = viewport.visibleContent.columns.any((column) => corners.containsColumn(column.index));

    return rowVisible && columnVisible;
  }
}