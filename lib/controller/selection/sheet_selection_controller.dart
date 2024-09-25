import 'package:flutter/cupertino.dart';
import 'package:sheets/controller/index.dart';
import 'package:sheets/controller/selection/types/sheet_range_selection.dart';
import 'package:sheets/controller/selection/types/sheet_selection.dart';
import 'package:sheets/controller/selection/types/sheet_single_selection.dart';
import 'package:sheets/controller/sheet_visibility_controller.dart';
import 'package:sheets/sheet_constants.dart';

class SheetSelectionController extends ChangeNotifier {
  final SheetVisibilityController paintConfig;
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
    selection = SheetSingleSelection(paintConfig: paintConfig, cellIndex: cellIndex, fillHandleVisible: editingEnabled);
  }

  void selectColumn(ColumnIndex columnIndex) {
    selectRange(
      start: CellIndex(rowIndex: RowIndex(0), columnIndex: columnIndex),
      end: CellIndex(rowIndex: RowIndex(defaultRowCount), columnIndex: columnIndex),
    );
  }

  void selectRow(RowIndex rowIndex) {
    selectRange(
      start: CellIndex(rowIndex: rowIndex, columnIndex: ColumnIndex(0)),
      end: CellIndex(rowIndex: rowIndex, columnIndex: ColumnIndex(defaultColumnCount)),
    );
  }

  void selectRange({required CellIndex start, required CellIndex end, bool completed = false}) {
    if (start == end) {
      selectSingle(start);
    } else {
      selection = SheetRangeSelection(paintConfig: paintConfig, start: start, end: end, completed: completed);
      notifyListeners();
    }
  }

  void selectColumnRange({required ColumnIndex start, required ColumnIndex end}) {
    selectRange(
      start: CellIndex(rowIndex: RowIndex(0), columnIndex: start),
      end: CellIndex(rowIndex: RowIndex(defaultRowCount), columnIndex: end),
    );
  }

  void selectRowRange({required RowIndex start, required RowIndex end}) {
    selectRange(
      start: CellIndex(rowIndex: start, columnIndex: ColumnIndex(0)),
      end: CellIndex(rowIndex: end, columnIndex: ColumnIndex(defaultColumnCount)),
    );
  }

  void selectAll() {
    selectRange(
      start: CellIndex(rowIndex: RowIndex(0), columnIndex: ColumnIndex(0)),
      end: CellIndex(rowIndex: RowIndex(defaultRowCount), columnIndex: ColumnIndex(defaultColumnCount)),
    );
  }

  void completeSelection() {
    selection = selection.complete();
    notifyListeners();
  }
}
