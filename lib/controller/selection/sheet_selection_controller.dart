import 'package:flutter/cupertino.dart';
import 'package:sheets/controller/selection/types/sheet_multi_selection.dart';
import 'package:sheets/models/sheet_item_index.dart';
import 'package:sheets/controller/selection/types/sheet_range_selection.dart';
import 'package:sheets/controller/selection/types/sheet_selection.dart';
import 'package:sheets/controller/selection/types/sheet_single_selection.dart';
import 'package:sheets/models/sheet_viewport_delegate.dart';
import 'package:sheets/config/sheet_constants.dart';

class SheetSelectionController extends ChangeNotifier {
  final SheetViewportDelegate paintConfig;
  late SheetSelection _selection = SheetSingleSelection.defaultSelection(paintConfig: paintConfig);

  set selection(SheetSelection selection) {
    _selection = selection.simplify();
    notifyListeners();
  }

  SheetSelection get selection => _selection;

  SheetSelectionController(this.paintConfig);

  void custom(SheetSelection selection) {
    this.selection = selection;
  }

  void selectSingle(CellIndex cellIndex, {bool editingEnabled = false}) {
    selection = getSingleSelection(cellIndex);
  }

  void selectColumn(ColumnIndex columnIndex) {
    selection = getColumnSelection(columnIndex);
  }

  void selectRow(RowIndex rowIndex) {
    selection = getRowSelection(rowIndex);
  }

  void selectRange({required CellIndex start, required CellIndex end, bool completed = false}) {
    selection = getRangeSelection(start: start, end: end, completed: completed);
  }

  void selectColumnRange({required ColumnIndex start, required ColumnIndex end}) {
    selection = getColumnRangeSelection(start: start, end: end);
  }

  void selectRowRange({required RowIndex start, required RowIndex end}) {
    selection = getRowRangeSelection(start: start, end: end);
  }

  void selectMultiple(List<CellIndex> selectedCells, {CellIndex? endCell}) {
    List<CellIndex> cells = selectedCells.toSet().toList();
    if(endCell != null && cells.contains(endCell)) {
      cells..remove(endCell)..add(endCell);
    }
    selection = SheetMultiSelection(paintConfig: paintConfig, selectedCells: cells);
  }

  void selectAll() {
    selection = getAllSelection();
  }

  SheetSelection getSingleSelection(CellIndex cellIndex) {
    return SheetSingleSelection(paintConfig: paintConfig, cellIndex: cellIndex);
  }

  SheetSelection getColumnSelection(ColumnIndex columnIndex) {
    return getRangeSelection(
      start: CellIndex(rowIndex: RowIndex(0), columnIndex: columnIndex),
      end: CellIndex(rowIndex: RowIndex(defaultRowCount), columnIndex: columnIndex),
      completed: true,
    );
  }

  SheetSelection getRowSelection(RowIndex rowIndex) {
    return getRangeSelection(
      start: CellIndex(rowIndex: rowIndex, columnIndex: ColumnIndex(0)),
      end: CellIndex(rowIndex: rowIndex, columnIndex: ColumnIndex(defaultColumnCount)),
      completed: true,
    );
  }

  SheetSelection getRangeSelection({required CellIndex start, required CellIndex end, bool completed = false}) {
    if (start == end) {
      return getSingleSelection(start);
    } else {
      return SheetRangeSelection(paintConfig: paintConfig, start: start, end: end, completed: completed);
    }
  }

  SheetSelection getColumnRangeSelection({required ColumnIndex start, required ColumnIndex end}) {
    return getRangeSelection(
      start: CellIndex(rowIndex: RowIndex(0), columnIndex: start),
      end: CellIndex(rowIndex: RowIndex(defaultRowCount), columnIndex: end),
      completed: true,
    );
  }

  SheetSelection getRowRangeSelection({required RowIndex start, required RowIndex end}) {
    return getRangeSelection(
      start: CellIndex(rowIndex: start, columnIndex: ColumnIndex(0)),
      end: CellIndex(rowIndex: end, columnIndex: ColumnIndex(defaultColumnCount)),
      completed: true,
    );
  }

  SheetSelection getAllSelection() {
    return getRangeSelection(
      start: CellIndex(rowIndex: RowIndex(0), columnIndex: ColumnIndex(0)),
      end: CellIndex(rowIndex: RowIndex(defaultRowCount), columnIndex: ColumnIndex(defaultColumnCount)),
      completed: true,
    );
  }

  void toggleCell(CellIndex cellIndex) {
    List<CellIndex> selectedCells = selection.selectedCells;
    if (selectedCells.contains(cellIndex) && selectedCells.length > 1) {
      selectedCells.remove(cellIndex);
    } else {
      selectedCells.add(cellIndex);
    }
    selection = SheetMultiSelection(paintConfig: paintConfig, selectedCells: selectedCells);
  }

  void toggleColumn(ColumnIndex columnIndex) {
    List<CellIndex> selectedCells = selection.selectedCells;
    if (selectedCells.any((CellIndex cellIndex) => cellIndex.columnIndex == columnIndex)) {
      selectedCells.removeWhere((CellIndex cellIndex) => cellIndex.columnIndex == columnIndex);
    } else {
      selectedCells.addAll(List.generate(defaultRowCount, (int index) => CellIndex(rowIndex: RowIndex(index), columnIndex: columnIndex)));
    }
    selection = SheetMultiSelection(paintConfig: paintConfig, selectedCells: selectedCells);
  }

  void toggleRow(RowIndex rowIndex) {
    List<CellIndex> selectedCells = selection.selectedCells;
    if (selectedCells.any((CellIndex cellIndex) => cellIndex.rowIndex == rowIndex)) {
      selectedCells.removeWhere((CellIndex cellIndex) => cellIndex.rowIndex == rowIndex);
    } else {
      selectedCells.addAll(List.generate(defaultColumnCount, (int index) => CellIndex(rowIndex: rowIndex, columnIndex: ColumnIndex(index))));
    }
    selection = SheetMultiSelection(paintConfig: paintConfig, selectedCells: selectedCells);
  }

  void completeSelection() {
    selection = selection.complete();
    notifyListeners();
  }
}
