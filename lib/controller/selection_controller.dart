import 'package:flutter/material.dart';
import 'package:sheets/controller/sheet_controller.dart';
import 'package:sheets/core/sheet_item_index.dart';
import 'package:sheets/core/sheet_properties.dart';
import 'package:sheets/selection/selection_factory.dart';
import 'package:sheets/selection/selection_status.dart';
import 'package:sheets/selection/types/sheet_multi_selection.dart';
import 'package:sheets/selection/types/sheet_selection.dart';
import 'package:sheets/selection/types/sheet_single_selection.dart';

class SelectionController extends ChangeNotifier {
  SheetSelection get confirmedSelection => _confirmedSelection;

  SheetSelection get unconfirmedSelection => _unconfirmedSelection;

  SheetSelection get visibleSelection => _unconfirmedSelection;

  set selection(SheetSelection sheetSelection) {
    sheetSelection.applyProperties(properties);
    SheetSelection simplifiedSelection = sheetSelection.simplify();

    if(_unconfirmedSelection == simplifiedSelection) return;

    _unconfirmedSelection = simplifiedSelection;

    if (layerSelectionActive == false) {
      _confirmedSelection = simplifiedSelection;
    }
    notifyListeners();
  }

  late final SheetProperties properties;
  late SheetSelection _confirmedSelection;
  late SheetSelection _unconfirmedSelection;

  void applyTo(SheetController controller) {
    properties = controller.sheetProperties;
    _confirmedSelection = SheetSingleSelection.defaultSelection()..applyProperties(properties);
    _unconfirmedSelection = SheetSingleSelection.defaultSelection()..applyProperties(properties);
  }

  bool layerSelectionActive = false;
  bool layerSelectionEnabled = false;

  void openLayer() {
    layerSelectionActive = true;
    layerSelectionEnabled = true;
  }

  void saveLayer() {
    _confirmedSelection = _unconfirmedSelection;
  }

  void closeLayer() {
    layerSelectionActive = false;
    layerSelectionEnabled = false;
  }

  void customSelection(SheetSelection customSelection) {
    selection = customSelection;
  }

  void selectSingle(SheetItemIndex sheetItemIndex, {bool completed = false}) {
    selection = SelectionFactory.getSingleSelection(sheetItemIndex, completed: completed);
  }

  void selectRange({required SheetItemIndex start, required SheetItemIndex end, bool completed = false}) {
    selection = SelectionFactory.getRangeSelection(start: start, end: end, completed: completed);
  }

  void combine(SheetSelection previousSelection, SheetSelection appendedSelection) {
    previousSelection.applyProperties(properties);
    appendedSelection.applyProperties(properties);

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

  void toggleColumnSelection(ColumnIndex columnIndex) {
    Set<CellIndex> selectedCells = _unconfirmedSelection.selectedCells;
    List<ColumnIndex> selectedColumns = selectedCells.map((CellIndex cellIndex) => cellIndex.columnIndex).toSet().toList();

    SelectionStatus columnSelectionStatus = _unconfirmedSelection.isColumnSelected(columnIndex);
    if (columnSelectionStatus.isFullySelected == false) {
      selectedCells.addAll(List.generate(properties.rowCount, (int index) => CellIndex(rowIndex: RowIndex(index), columnIndex: columnIndex)));
      selection = SheetMultiSelection(selectedCells: selectedCells, mainCell: CellIndex(rowIndex: RowIndex(0), columnIndex: columnIndex));
    } else if (selectedColumns.length == 1 && selectedColumns.first == columnIndex) {
      return;
    } else {
      selectedCells.removeWhere((CellIndex cellIndex) => cellIndex.columnIndex == columnIndex);
      selection = SheetMultiSelection(selectedCells: selectedCells);
      return;
    }
  }

  void toggleRowSelection(RowIndex rowIndex) {
    Set<CellIndex> selectedCells = _unconfirmedSelection.selectedCells;
    List<RowIndex> selectedRows = selectedCells.map((CellIndex cellIndex) => cellIndex.rowIndex).toSet().toList();

    SelectionStatus rowSelectionStatus = _unconfirmedSelection.isRowSelected(rowIndex);
    if (rowSelectionStatus.isFullySelected == false) {
      selectedCells.addAll(List.generate(properties.columnCount, (int index) => CellIndex(rowIndex: rowIndex, columnIndex: ColumnIndex(index))));
      selection = SheetMultiSelection(selectedCells: selectedCells, mainCell: CellIndex(rowIndex: rowIndex, columnIndex: ColumnIndex(0)));
    } else if (selectedRows.length == 1 && selectedRows.first == rowIndex) {
      return;
    } else {
      selectedCells.removeWhere((CellIndex cellIndex) => cellIndex.rowIndex == rowIndex);
      selection = SheetMultiSelection(selectedCells: selectedCells);
    }
  }

  void completeSelection() {
    selection = _unconfirmedSelection.complete();
  }
}
