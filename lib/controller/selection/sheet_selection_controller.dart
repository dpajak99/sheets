import 'package:flutter/cupertino.dart';
import 'package:sheets/controller/index.dart';
import 'package:sheets/controller/selection/types/sheet_range_selection.dart';
import 'package:sheets/controller/selection/types/sheet_selection.dart';
import 'package:sheets/controller/selection/types/sheet_single_selection.dart';
import 'package:sheets/painters/paint/sheet_paint_config.dart';
import 'package:sheets/sheet_constants.dart';

class SheetSelectionController extends ChangeNotifier {
  final SheetPaintConfig paintConfig;
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


  void selectRange({CellIndex? start, required CellIndex end, bool completed = true}) {
    CellIndex computedStart = start ?? selection.start;
    if (computedStart == end) {
      selectSingle(computedStart);
    } else {
      selection = SheetRangeSelection(paintConfig: paintConfig, start: computedStart, end: end, completed: completed);
      notifyListeners();
    }
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
