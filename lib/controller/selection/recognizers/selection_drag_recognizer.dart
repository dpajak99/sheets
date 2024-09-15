import 'package:sheets/controller/index.dart';
import 'package:sheets/controller/program_config.dart';
import 'package:sheets/controller/sheet_controller.dart';
import 'package:sheets/sheet_constants.dart';

class SelectionDragRecognizer {
  final SheetController sheetController;
  final SheetItemConfig selectionStart;

  SelectionDragRecognizer(this.sheetController, this.selectionStart);

  void handleDragUpdate(SheetItemConfig selectionEnd) {
    late RowIndex endRowIndex;
    late ColumnIndex endColumnIndex;

    switch(selectionEnd) {
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

    switch(selectionStart) {
      case CellConfig selectionStart:
        sheetController.selectionController.selectRange(start: selectionStart.cellIndex, end: CellIndex(rowIndex: endRowIndex, columnIndex: endColumnIndex));
      case ColumnConfig selectionStart:
        sheetController.selectionController.selectRange(
          start: CellIndex(rowIndex: RowIndex(0), columnIndex: selectionStart.columnIndex),
          end: CellIndex(rowIndex: RowIndex(defaultRowCount), columnIndex: endColumnIndex),
        );
      case RowConfig selectionStart:
        sheetController.selectionController.selectRange(
          start: CellIndex(rowIndex: selectionStart.rowIndex, columnIndex: ColumnIndex(0)),
          end: CellIndex(rowIndex: endRowIndex, columnIndex: ColumnIndex(defaultColumnCount)),
        );
    }
  }
}