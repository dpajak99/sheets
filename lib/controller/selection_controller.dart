import 'package:flutter/material.dart';
import 'package:sheets/controller/sheet_controller.dart';
import 'package:sheets/core/config/sheet_constants.dart';
import 'package:sheets/core/sheet_item_index.dart';
import 'package:sheets/core/sheet_properties.dart';
import 'package:sheets/selection/selection_factory.dart';
import 'package:sheets/selection/selection_status.dart';
import 'package:sheets/selection/types/sheet_multi_selection.dart';
import 'package:sheets/selection/types/sheet_selection.dart';
import 'package:sheets/selection/types/sheet_single_selection.dart';

class SelectionController extends ChangeNotifier {
  SheetSelection _confirmedSelection = SheetSingleSelection.defaultSelection();
  SheetSelection _unconfirmedSelection = SheetSingleSelection.defaultSelection();

  SheetSelection get confirmedSelection => _confirmedSelection;

  SheetSelection get unconfirmedSelection => _unconfirmedSelection;

  SheetSelection get visibleSelection => _unconfirmedSelection;

  set selection(SheetSelection sheetSelection) {
    _unconfirmedSelection = sheetSelection.simplify();
    if (layerSelectionActive == false) {
      _confirmedSelection = sheetSelection.simplify();
    }
    notifyListeners();
  }

  late final SheetProperties properties;

  void applyTo(SheetController controller) {
    properties = controller.sheetProperties;
  }

  bool layerSelectionActive = false;
  bool layerSelectionEnabled = false;

  void openLayer() {
    layerSelectionActive = true;
    layerSelectionEnabled = true;
    notifyListeners();
  }

  void saveLayer() {
    _confirmedSelection = _unconfirmedSelection;
    notifyListeners();
  }

  void closeLayer() {
    layerSelectionActive = false;
    layerSelectionEnabled = false;
    notifyListeners();
  }

  void customSelection(SheetSelection customSelection) {
    selection = customSelection;
  }

  void selectSingle(CellIndex cellIndex, {bool completed = false}) {
    selection = SelectionFactory.getSingleSelection(cellIndex, completed: completed);
  }

  void selectColumn(ColumnIndex columnIndex, {bool completed = false}) {
    selection = SelectionFactory.getColumnSelection(columnIndex, completed: completed);
  }

  void selectRow(RowIndex rowIndex, {bool completed = false}) {
    selection = SelectionFactory.getRowSelection(rowIndex, completed: completed);
  }

  void selectRange({required SheetItemIndex start, required SheetItemIndex end, bool completed = false}) {
    SheetSelection? newSelection = SelectionFactory.getRangeSelection(start: start, end: end, completed: completed);
    if(newSelection != null) {
      selection = newSelection;
    }
  }

  void selectColumnRange({required ColumnIndex start, required ColumnIndex end, bool completed = false}) {
    selection = SelectionFactory.getColumnRangeSelection(start: start, end: end, completed: completed);
  }

  void selectRowRange({required RowIndex start, required RowIndex end, bool completed = false}) {
    selection = SelectionFactory.getRowRangeSelection(start: start, end: end, completed: completed);
  }

  void combine(SheetSelection previousSelection, SheetSelection appendedSelection) {
    Set<CellIndex> cells = {...previousSelection.selectedCells, ...appendedSelection.selectedCells};
    selection = SheetMultiSelection(selectedCells: cells, mainCell: appendedSelection.mainCell);
  }
  
  void selectAll() {
    selection = SelectionFactory.getAllSelection();
  }

  void toggleCellSelection(CellIndex cellIndex) {
    Set<CellIndex> selectedCells = _unconfirmedSelection.selectedCells;
    if (selectedCells.contains(cellIndex) && selectedCells.length > 1) {
      selectedCells.remove(cellIndex);
      selection = SheetMultiSelection(selectedCells: selectedCells);
      layerSelectionEnabled = false;
    } else {
      selectedCells.add(cellIndex);
      selection = SheetMultiSelection(selectedCells: selectedCells);
      layerSelectionEnabled = true;
    }
  }

  bool? toggleColumnSelection(ColumnIndex columnIndex) {
    Set<CellIndex> selectedCells = _unconfirmedSelection.selectedCells;
    List<ColumnIndex> selectedColumns = selectedCells.map((CellIndex cellIndex) => cellIndex.columnIndex).toSet().toList();

    SelectionStatus columnSelectionStatus = _unconfirmedSelection.isColumnSelected(columnIndex);
    if (columnSelectionStatus.isFullySelected == false) {
      selectedCells.addAll(List.generate(defaultRowCount, (int index) => CellIndex(rowIndex: RowIndex(index), columnIndex: columnIndex)));
      selection = SheetMultiSelection(selectedCells: selectedCells, mainCell: CellIndex(rowIndex: RowIndex(0), columnIndex: columnIndex));
      return true;
    } else if (selectedColumns.length == 1 && selectedColumns.first == columnIndex) {
      return null;
    } else {
      selectedCells.removeWhere((CellIndex cellIndex) => cellIndex.columnIndex == columnIndex);
      selection = SheetMultiSelection(selectedCells: selectedCells);
      return false;
    }
  }

  bool? toggleRowSelection(RowIndex rowIndex) {
    Set<CellIndex> selectedCells = _unconfirmedSelection.selectedCells;
    List<RowIndex> selectedRows = selectedCells.map((CellIndex cellIndex) => cellIndex.rowIndex).toSet().toList();

    SelectionStatus rowSelectionStatus = _unconfirmedSelection.isRowSelected(rowIndex);
    if (rowSelectionStatus.isFullySelected == false) {
      selectedCells.addAll(List.generate(defaultColumnCount, (int index) => CellIndex(rowIndex: rowIndex, columnIndex: ColumnIndex(index))));
      selection = SheetMultiSelection(selectedCells: selectedCells, mainCell: CellIndex(rowIndex: rowIndex, columnIndex: ColumnIndex(0)));
      return true;
    } else if (selectedRows.length == 1 && selectedRows.first == rowIndex) {
      return null;
    } else {
      selectedCells.removeWhere((CellIndex cellIndex) => cellIndex.rowIndex == rowIndex);
      selection = SheetMultiSelection(selectedCells: selectedCells);
      return false;
    }
  }

  void completeSelection() {
    selection = _unconfirmedSelection.complete();
  }
}
