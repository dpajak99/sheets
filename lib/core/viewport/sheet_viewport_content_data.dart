import 'package:flutter/material.dart';
import 'package:sheets/core/config/sheet_constants.dart';
import 'package:sheets/core/data/worksheet.dart';
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

  ClosestVisible<ViewportCell> findCellOrClosest(Worksheet worksheet, CellIndex cellIndex) {
    CellMergeStatus mergeStatus = worksheet.getCell(cellIndex).mergeStatus;
    if(mergeStatus.isMerged && mergeStatus.start != cellIndex) {
      return findCellOrClosest(worksheet, mergeStatus.start!);
    }

    if (containsCell(cellIndex)) {
      return ClosestVisible<ViewportCell>.fullyVisible(findCell(worksheet, cellIndex)!);
    }
    return findClosestCell(worksheet, cellIndex);
  }

  ViewportCell? findCell(Worksheet worksheet, CellIndex cellIndex) {
    CellProperties properties = worksheet.getCell(cellIndex);
    CellMergeStatus mergeStatus = properties.mergeStatus;
    if(mergeStatus.isMerged && mergeStatus.start != cellIndex) {
      return findCell(worksheet, mergeStatus.start!);
    }
    return cells.where((ViewportCell cell) => cell.index == cellIndex).firstOrNull;
  }

  ViewportItem? findAnyByOffset(Offset mousePosition) {
    try {
      return all.firstWhere((ViewportItem element) {
        Rect itemRect = element.rect.expand(borderWidth / 2);
        return itemRect.within(mousePosition);
      });
    } catch (e) {
      return null;
    }
  }

  ClosestVisible<ViewportCell> findClosestCell(Worksheet worksheet, CellIndex cellIndex) {
    ClosestVisibleCellIndexCalculator calculator = ClosestVisibleCellIndexCalculator(visibleRows: rows, visibleColumns: columns);
    ClosestVisible<CellIndex> closestVisibleCellIndex = calculator.findFor(cellIndex);

    return ClosestVisible<ViewportCell>.partiallyVisible(
      value: findCell(worksheet, closestVisibleCellIndex.value)!,
      hiddenBorders: closestVisibleCellIndex.hiddenBorders,
    );
  }
}
