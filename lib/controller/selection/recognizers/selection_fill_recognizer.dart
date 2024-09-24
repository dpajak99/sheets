import 'package:sheets/controller/index.dart';
import 'package:sheets/controller/program_config.dart';
import 'package:sheets/controller/selection/recognizers/selection_recognizer.dart';
import 'package:sheets/controller/selection/types/sheet_fill_selection.dart';
import 'package:sheets/controller/selection/types/sheet_selection.dart';
import 'package:sheets/controller/sheet_controller.dart';
import 'package:sheets/sheet_constants.dart';

class SelectionFillRecognizer extends SelectionRecognizer {
  final SheetControllerOld sheetController;
  final SheetItemConfig selectionStart;

  SelectionFillRecognizer(this.sheetController, this.selectionStart);

  @override
  void handle(SheetItemConfig selectionEnd) {
    if (selectionStart.runtimeType != selectionEnd.runtimeType) {
      return;
    }

    SheetSelection fillSelection = getFillSelection(selectionEnd);
    sheetController.selectionController.custom(fillSelection);
  }

  SheetSelection getFillSelection(SheetItemConfig selectionEnd) {
    SheetSelection realPreviousSelection = sheetController.selectionController.selection;
    SheetSelection firstPreviousSelection = realPreviousSelection is SheetFillSelection ? realPreviousSelection.baseSelection : realPreviousSelection;

    late RowIndex endRowIndex;
    late ColumnIndex endColumnIndex;

    switch (selectionEnd) {
      case CellConfig selectionEnd:
        endRowIndex = selectionEnd.cellIndex.rowIndex;
        endColumnIndex = selectionEnd.cellIndex.columnIndex;
        break;
      case ColumnConfig selectionEnd:
        endRowIndex = RowIndex(defaultRowCount);
        endColumnIndex = selectionEnd.columnIndex;
        break;
      case RowConfig selectionEnd:
        endRowIndex = selectionEnd.rowIndex;
        endColumnIndex = ColumnIndex(defaultColumnCount);
        break;
    }

    return SheetFillSelection(
      baseSelection: firstPreviousSelection,
      paintConfig: sheetController.paintConfig,
      start: firstPreviousSelection.end,
      end: CellIndex(rowIndex: endRowIndex, columnIndex: endColumnIndex),
      completed: false,
    );
  }

  @override
  void complete() {}
}
