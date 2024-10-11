import 'package:flutter/material.dart';
import 'package:sheets/core/sheet_item_config.dart';
import 'package:sheets/core/sheet_item_index.dart';
import 'package:sheets/selection/paints/sheet_range_selection_paint.dart';
import 'package:sheets/selection/selection_bounds.dart';
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
    CellConfig? startCell = viewportDelegate.findCell(selection.trueStart);
    CellConfig? endCell = viewportDelegate.findCell(selection.trueEnd);

    if (startCell != null && endCell != null) {
      return SelectionBounds(startCell, endCell, selection.direction);
    }

    if (startCell == null && endCell != null) {
      ClosestVisible<CellIndex> startClosest = viewportDelegate.findClosestVisible(selection.trueStart);
      CellConfig updatedStartCell = viewportDelegate.findCell(startClosest.item) as CellConfig;
      return SelectionBounds(updatedStartCell, endCell, selection.direction, hiddenBorders: startClosest.hiddenBorders, startCellVisible: false);
    }

    if (startCell != null && endCell == null) {
      ClosestVisible<CellIndex> endClosest = viewportDelegate.findClosestVisible(selection.trueEnd);
      CellConfig updatedEndCell = viewportDelegate.findCell(endClosest.item) as CellConfig;

      return SelectionBounds(startCell, updatedEndCell, selection.direction, hiddenBorders: endClosest.hiddenBorders, lastCellVisible: false);
    }

    if (startCell == null && endCell == null && (_isFullHeightSelection || _isFullWidthSelection)) {
      ClosestVisible<CellIndex> startClosest = viewportDelegate.findClosestVisible(selection.trueStart);
      ClosestVisible<CellIndex> endClosest = viewportDelegate.findClosestVisible(selection.trueEnd);

      CellConfig updatedStartCell = viewportDelegate.findCell(startClosest.item) as CellConfig;
      CellConfig updatedEndCell = viewportDelegate.findCell(endClosest.item) as CellConfig;

      List<Direction> hiddenBorders = [...startClosest.hiddenBorders, ...endClosest.hiddenBorders];

      return SelectionBounds(updatedStartCell, updatedEndCell, selection.direction, hiddenBorders: hiddenBorders, startCellVisible: false);
    }

    return null;
  }

  bool get _isFullHeightSelection {
    List<RowConfig> visibleRows = viewportDelegate.visibleRows;
    bool vertical1 = selection.trueStart.rowIndex < visibleRows.first.rowIndex && selection.trueEnd.rowIndex > visibleRows.last.rowIndex;
    bool vertical2 = selection.trueEnd.rowIndex < visibleRows.first.rowIndex && selection.trueStart.rowIndex > visibleRows.last.rowIndex;

    return vertical1 || vertical2;
  }

  bool get _isFullWidthSelection {
    List<ColumnConfig> visibleColumns = viewportDelegate.visibleColumns;
    bool horizontal1 =
        selection.trueStart.columnIndex < visibleColumns.first.columnIndex && selection.trueEnd.columnIndex > visibleColumns.last.columnIndex;
    bool horizontal2 =
        selection.trueEnd.columnIndex < visibleColumns.first.columnIndex && selection.trueStart.columnIndex > visibleColumns.last.columnIndex;

    return horizontal1 || horizontal2;
  }
}