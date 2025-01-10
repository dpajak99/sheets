import 'dart:collection';

import 'package:sheets/core/data/worksheet.dart';
import 'package:sheets/core/sheet_index.dart';

extension CellPropertiesExtensions on Iterable<CellProperties> {
  Map<ColumnIndex, List<CellProperties>> groupByColumns() {
    Map<ColumnIndex, List<CellProperties>> groupedCells = <ColumnIndex, List<CellProperties>>{};
    for (CellProperties cell in this) {
      CellMergeStatus mergeStatus = cell.mergeStatus;
      if (mergeStatus.isMerged && mergeStatus.start == cell.index) {
        groupedCells.putIfAbsent(cell.index.column, () => <CellProperties>[]).add(cell);
      } else if(!mergeStatus.isMerged) {
        groupedCells.putIfAbsent(cell.index.column, () => <CellProperties>[]).add(cell);
      }
    }
    return SplayTreeMap<ColumnIndex, List<CellProperties>>.from(groupedCells);
  }

  List<CellProperties> whereColumn(ColumnIndex index) {
    return where((CellProperties cell) => cell.index.column == index).toList();
  }

  Map<RowIndex, List<CellProperties>> groupByRows() {
    Map<RowIndex, List<CellProperties>> groupedCells = <RowIndex, List<CellProperties>>{};
    for (CellProperties cell in this) {
      CellMergeStatus mergeStatus = cell.mergeStatus;
      if (mergeStatus.isMerged && mergeStatus.start == cell.index) {
        groupedCells.putIfAbsent(cell.index.row, () => <CellProperties>[]).add(cell);
      } else if (!mergeStatus.isMerged) {
        groupedCells.putIfAbsent(cell.index.row, () => <CellProperties>[]).add(cell);
      }
    }
    return SplayTreeMap<RowIndex, List<CellProperties>>.from(groupedCells);
  }

  List<CellProperties> whereRow(RowIndex index) {
    return where((CellProperties cell) => cell.index.row == index).toList();
  }

  List<CellProperties> maybeReverse(bool value) {
    return value ? toList().reversed.toList() : toList();
  }
}
