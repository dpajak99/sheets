import 'package:flutter/cupertino.dart';
import 'package:sheets/core/sheet_item_index.dart';
import 'package:sheets/core/sheet_viewport_delegate.dart';
import 'package:sheets/config/sheet_constants.dart';
import 'package:sheets/selection/selection_utils.dart';
import 'package:sheets/selection/types/sheet_multi_selection.dart';
import 'package:sheets/selection/types/sheet_range_selection.dart';
import 'package:sheets/selection/types/sheet_selection.dart';
import 'package:sheets/selection/types/sheet_single_selection.dart';

class SheetSelectionController extends ChangeNotifier {
  final SheetViewportDelegate paintConfig;
  late SheetSelection _selection = SheetSingleSelection.defaultSelection();

  set selection(SheetSelection selection) {
    _selection = selection.simplify();
    notifyListeners();
  }

  SheetSelection get selection => _selection;

  SheetSelectionController(this.paintConfig);

  CellIndex get selectionStartIndex => selection.start;


  void custom(SheetSelection selection) {
    this.selection = selection;
  }

  void selectSingle(CellIndex cellIndex, {bool editingEnabled = false}) {
    selection = SelectionUtils.getSingleSelection(cellIndex);
  }

  void selectColumn(ColumnIndex columnIndex) {
    selection = SelectionUtils.getColumnSelection(columnIndex);
  }

  void selectRow(RowIndex rowIndex) {
    selection = SelectionUtils.getRowSelection(rowIndex);
  }

  void selectRange({required CellIndex start, required CellIndex end, bool completed = false}) {
    selection = SelectionUtils.getRangeSelection(start: start, end: end, completed: completed);
  }

  void selectColumnRange({required ColumnIndex start, required ColumnIndex end}) {
    selection = SelectionUtils.getColumnRangeSelection(start: start, end: end);
  }

  void selectRowRange({required RowIndex start, required RowIndex end}) {
    selection = SelectionUtils.getRowRangeSelection(start: start, end: end);
  }

  void selectMultiple(List<CellIndex> selectedCells, {CellIndex? endCell}) {
    List<CellIndex> cells = selectedCells.toSet().toList();
    if (endCell != null && cells.contains(endCell)) {
      cells
        ..remove(endCell)
        ..add(endCell);
    }
    selection = SheetMultiSelection(selectedCells: cells);
  }

  void selectAll() {
    selection = SelectionUtils.getAllSelection();
  }

  void toggleCell(CellIndex cellIndex) {
    List<CellIndex> selectedCells = selection.selectedCells;
    if (selectedCells.contains(cellIndex) && selectedCells.length > 1) {
      selectedCells.remove(cellIndex);
    } else {
      selectedCells.add(cellIndex);
    }
    selection = SheetMultiSelection(selectedCells: selectedCells);
  }

  void toggleColumn(ColumnIndex columnIndex) {
    List<CellIndex> selectedCells = selection.selectedCells;
    if (selectedCells.any((CellIndex cellIndex) => cellIndex.columnIndex == columnIndex)) {
      selectedCells.removeWhere((CellIndex cellIndex) => cellIndex.columnIndex == columnIndex);
    } else {
      selectedCells.addAll(List.generate(defaultRowCount, (int index) => CellIndex(rowIndex: RowIndex(index), columnIndex: columnIndex)));
    }
    selection = SheetMultiSelection(selectedCells: selectedCells);
  }

  void toggleRow(RowIndex rowIndex) {
    List<CellIndex> selectedCells = selection.selectedCells;
    if (selectedCells.any((CellIndex cellIndex) => cellIndex.rowIndex == rowIndex)) {
      selectedCells.removeWhere((CellIndex cellIndex) => cellIndex.rowIndex == rowIndex);
    } else {
      selectedCells.addAll(List.generate(defaultColumnCount, (int index) => CellIndex(rowIndex: rowIndex, columnIndex: ColumnIndex(index))));
    }
    selection = SheetMultiSelection(selectedCells: selectedCells);
  }

  void completeSelection() {
    selection = selection.complete();
    notifyListeners();
  }
}
