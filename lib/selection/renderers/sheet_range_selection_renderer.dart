import 'package:flutter/material.dart';
import 'package:sheets/core/sheet_item_config.dart';
import 'package:sheets/core/sheet_item_index.dart';
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
    required super.viewportDelegate,
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
    CellConfig? startCell = viewportDelegate.findCell(selection.startCellIndex);
    CellConfig? endCell = viewportDelegate.findCell(selection.endCellIndex);

    if (startCell != null && endCell != null) {
      return SelectionBounds(startCell, endCell, selection.direction);
    }

    if (startCell == null && endCell != null) {
      ClosestVisible<CellIndex> startClosest = viewportDelegate.findClosestVisible(selection.startCellIndex);
      CellConfig updatedStartCell = viewportDelegate.findCell(startClosest.item) as CellConfig;
      return SelectionBounds(updatedStartCell, endCell, selection.direction, hiddenBorders: startClosest.hiddenBorders, startCellVisible: false);
    }

    if (startCell != null && endCell == null) {
      ClosestVisible<CellIndex> endClosest = viewportDelegate.findClosestVisible(selection.endCellIndex);
      CellConfig updatedEndCell = viewportDelegate.findCell(endClosest.item) as CellConfig;

      return SelectionBounds(startCell, updatedEndCell, selection.direction, hiddenBorders: endClosest.hiddenBorders, lastCellVisible: false);
    }

    if (startCell == null && endCell == null && (_selectionPartiallyVisible)) {
      ClosestVisible<CellIndex> startClosest = viewportDelegate.findClosestVisible(selection.startCellIndex);
      ClosestVisible<CellIndex> endClosest = viewportDelegate.findClosestVisible(selection.endCellIndex);

      CellConfig updatedStartCell = viewportDelegate.findCell(startClosest.item) as CellConfig;
      CellConfig updatedEndCell = viewportDelegate.findCell(endClosest.item) as CellConfig;

      List<Direction> hiddenBorders = [...startClosest.hiddenBorders, ...endClosest.hiddenBorders];

      return SelectionBounds(updatedStartCell, updatedEndCell, selection.direction, hiddenBorders: hiddenBorders, startCellVisible: false);
    }

    return null;
  }

  bool get _selectionPartiallyVisible {
    List<RowConfig> visibleRows = viewportDelegate.visibleRows;
    List<ColumnConfig> visibleColumns = viewportDelegate.visibleColumns;

    SelectionCellCorners corners = selection.selectionCellCorners;

    bool rowVisible = visibleRows.any((row) => corners.containsRow(row.index));
    bool columnVisible = visibleColumns.any((column) => corners.containsColumn(column.index));

    return rowVisible && columnVisible;
  }
}