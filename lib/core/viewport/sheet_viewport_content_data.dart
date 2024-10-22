import 'package:flutter/material.dart';
import 'package:sheets/core/sheet_index.dart';
import 'package:sheets/core/viewport/calculators/closest_visible_cell_index_calculator.dart';
import 'package:sheets/core/viewport/viewport_item.dart';
import 'package:sheets/utils/closest_visible.dart';
import 'package:sheets/utils/extensions/rect_extensions.dart';

class SheetViewportContentData {
  List<ViewportRow> rows = <ViewportRow>[];
  List<ViewportColumn> columns = <ViewportColumn>[];
  List<ViewportCell> cells = <ViewportCell>[];

  List<ViewportItem> get all {
    return <ViewportItem>[...rows, ...columns, ...cells];
  }

  void update(List<ViewportRow> newRows, List<ViewportColumn> newColumns, List<ViewportCell> newCells) {
    rows = newRows;
    columns = newColumns;
    cells = newCells;
  }

  bool containsCell(CellIndex cellIndex) {
    return cells.any((ViewportCell cell) => cell.index == cellIndex);
  }

  ClosestVisible<ViewportCell> findCellOrClosest(CellIndex cellIndex) {
    if (containsCell(cellIndex)) {
      return ClosestVisible<ViewportCell>.fullyVisible(findCell(cellIndex)!);
    }
    return findClosestCell(cellIndex);
  }

  ViewportCell? findCell(CellIndex cellIndex) {
    return cells.where((ViewportCell cell) => cell.index == cellIndex).firstOrNull;
  }

  ViewportItem? findAnyByOffset(Offset mousePosition) {
    try {
      return all.firstWhere((ViewportItem element) => element.rect.within(mousePosition));
    } catch (e) {
      return null;
    }
  }

  ClosestVisible<ViewportCell> findClosestCell(CellIndex cellIndex) {
    ClosestVisibleCellIndexCalculator calculator = ClosestVisibleCellIndexCalculator(visibleRows: rows, visibleColumns: columns);
    ClosestVisible<CellIndex> closestVisibleCellIndex = calculator.findFor(cellIndex);

    return ClosestVisible<ViewportCell>.partiallyVisible(
      value: findCell(closestVisibleCellIndex.value)!,
      hiddenBorders: closestVisibleCellIndex.hiddenBorders,
    );
  }
}
