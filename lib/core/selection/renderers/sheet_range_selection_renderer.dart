import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:sheets/core/selection/paints/sheet_range_selection_paint.dart';
import 'package:sheets/core/selection/selection_rect.dart';
import 'package:sheets/core/selection/sheet_selection_paint.dart';
import 'package:sheets/core/selection/sheet_selection_renderer.dart';
import 'package:sheets/core/selection/types/sheet_range_selection.dart';
import 'package:sheets/core/sheet_index.dart';
import 'package:sheets/utils/direction.dart';

class SheetRangeSelectionRenderer<T extends SheetIndex> extends SheetSelectionRenderer<SheetRangeSelection<T>> {
  SheetRangeSelectionRenderer({
    required super.selection,
    required super.viewport,
  });

  @override
  bool get fillHandleVisible => selection.isCompleted;

  @override
  Offset? get fillHandleOffset => selectionRect?.bottomRight;

  @override
  SheetSelectionPaint getPaint({bool? mainCellVisible, bool? backgroundVisible}) {
    return SheetRangeSelectionPaint<T>(this, mainCellVisible, backgroundVisible);
  }

  SelectionRect? get selectionRect => _calculateSelectionBounds();

  SelectionRect? get mainCellRect {
    BorderRect cellRect = cellRectFor(selection.mainCell);
    Rect visibleArea = visibleAreaFor(selection.mainCell);

    if (!cellRect.overlaps(visibleArea)) {
      return null;
    }

    Rect clipped = cellRect.intersect(visibleArea);
    List<Direction> hiddenBorders = <Direction>[];
    if (clipped.left > cellRect.left) {
      hiddenBorders.add(Direction.left);
    }
    if (clipped.top > cellRect.top) {
      hiddenBorders.add(Direction.top);
    }
    if (clipped.right < cellRect.right) {
      hiddenBorders.add(Direction.right);
    }
    if (clipped.bottom < cellRect.bottom) {
      hiddenBorders.add(Direction.bottom);
    }

    return SelectionRect.fromLTRB(
      rect: clipped,
      hiddenBorders: hiddenBorders,
    );
  }

  SelectionRect? _calculateSelectionBounds() {
    int rowStart = math.min(selection.start.row.value, selection.end.row.value);
    int rowEnd = math.max(selection.start.row.value, selection.end.row.value);
    int columnStart =
        math.min(selection.start.column.value, selection.end.column.value);
    int columnEnd =
        math.max(selection.start.column.value, selection.end.column.value);

    List<ViewportRow> visibleRows = viewport.visibleContent.rows
        .where((ViewportRow row) =>
            row.index.value >= rowStart && row.index.value <= rowEnd)
        .toList();
    List<ViewportColumn> visibleColumns = viewport.visibleContent.columns
        .where((ViewportColumn column) =>
            column.index.value >= columnStart &&
            column.index.value <= columnEnd)
        .toList();

    if (visibleRows.isEmpty || visibleColumns.isEmpty) {
      return null;
    }

    CellIndex firstVisible = CellIndex(
      column: visibleColumns.first.index,
      row: visibleRows.first.index,
    );
    CellIndex lastVisible = CellIndex(
      column: visibleColumns.last.index,
      row: visibleRows.last.index,
    );

    _ClippedCell start = _clipCell(firstVisible)!;
    _ClippedCell end = _clipCell(lastVisible)!;

    Rect bounds = Rect.fromLTRB(
      math.min(start.rect.left, end.rect.left),
      math.min(start.rect.top, end.rect.top),
      math.max(start.rect.right, end.rect.right),
      math.max(start.rect.bottom, end.rect.bottom),
    );

    bool hideLeft =
        visibleColumns.first.index.value > columnStart ||
            start.hiddenBorders.contains(Direction.left);
    bool hideRight =
        visibleColumns.last.index.value < columnEnd ||
            end.hiddenBorders.contains(Direction.right);
    bool hideTop =
        visibleRows.first.index.value > rowStart ||
            start.hiddenBorders.contains(Direction.top);
    bool hideBottom =
        visibleRows.last.index.value < rowEnd ||
            end.hiddenBorders.contains(Direction.bottom);

    Set<Direction> hiddenBorders = <Direction>{
      if (hideTop) Direction.top,
      if (hideBottom) Direction.bottom,
      if (hideLeft) Direction.left,
      if (hideRight) Direction.right,
    };

    return SelectionRect.fromLTRB(
      rect: bounds,
      hiddenBorders: hiddenBorders.toList(),
    );
  }

  _ClippedCell? _clipCell(CellIndex index) {
    BorderRect rect = cellRectFor(index);
    Rect visible = visibleAreaFor(index);

    if (!rect.overlaps(visible)) {
      return null;
    }

    Rect clipped = rect.intersect(visible);
    List<Direction> hiddenBorders = <Direction>[];
    if (clipped.left > rect.left) {
      hiddenBorders.add(Direction.left);
    }
    if (clipped.top > rect.top) {
      hiddenBorders.add(Direction.top);
    }
    if (clipped.right < rect.right) {
      hiddenBorders.add(Direction.right);
    }
    if (clipped.bottom < rect.bottom) {
      hiddenBorders.add(Direction.bottom);
    }

    return _ClippedCell(clipped, hiddenBorders);
  }
}

class _ClippedCell {
  _ClippedCell(this.rect, this.hiddenBorders);

  final Rect rect;
  final List<Direction> hiddenBorders;
}
