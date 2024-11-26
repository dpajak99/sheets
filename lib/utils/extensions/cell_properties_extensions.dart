import 'package:sheets/core/cell_properties.dart';
import 'package:sheets/core/sheet_index.dart';

extension IndexedCellPropertiesExtensions on Iterable<IndexedCellProperties> {
  Map<ColumnIndex, List<IndexedCellProperties>> groupByColumns() {
    Map<ColumnIndex, List<IndexedCellProperties>> groupedCells = <ColumnIndex, List<IndexedCellProperties>>{};
    for (IndexedCellProperties cell in this) {
      groupedCells.putIfAbsent(cell.index.column, () => <IndexedCellProperties>[]).add(cell);
    }
    return groupedCells;
  }

  List<IndexedCellProperties> whereColumn(ColumnIndex index) {
    return where((IndexedCellProperties cell) => cell.index.column == index).toList();
  }

  Map<RowIndex, List<IndexedCellProperties>> groupByRows() {
    Map<RowIndex, List<IndexedCellProperties>> groupedCells = <RowIndex, List<IndexedCellProperties>>{};
    for (IndexedCellProperties cell in this) {
      groupedCells.putIfAbsent(cell.index.row, () => <IndexedCellProperties>[]).add(cell);
    }
    return groupedCells;
  }

  List<IndexedCellProperties> whereRow(RowIndex index) {
    return where((IndexedCellProperties cell) => cell.index.row == index).toList();
  }

  List<IndexedCellProperties> maybeReverse(bool value) {
    return value ? toList().reversed.toList() : toList();
  }
}
