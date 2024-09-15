import 'package:flutter/cupertino.dart';
import 'package:sheets/controller/index.dart';
import 'package:sheets/controller/program_config.dart';
import 'package:sheets/controller/selection/types/sheet_range_selection.dart';
import 'package:sheets/controller/selection/types/sheet_selection.dart';
import 'package:sheets/controller/sheet_controller.dart';
import 'package:sheets/painters/paint/sheet_paint_config.dart';
import 'package:sheets/sheet_constants.dart';

class SelectionDragRecognizer {
  final SheetController sheetController;
  final SheetItemConfig selectionStart;

  SelectionDragRecognizer(this.sheetController, this.selectionStart) {
    if (selectionStart is ColumnConfig || selectionStart is RowConfig) {
      sheetController.cursorController.setCursor(SystemMouseCursors.basic, SystemMouseCursors.grab);
    }
  }

  void handleDragUpdate(SheetItemConfig selectionEnd) {
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

    SheetSelection selection = createSelection(endRowIndex, endColumnIndex);
    sheetController.selectionController.custom(selection);
  }

  void complete() {
    sheetController.cursorController.setCursor(SystemMouseCursors.grab, SystemMouseCursors.basic);
    sheetController.selectionController.completeSelection();
  }

  SheetSelection createSelection(RowIndex endRowIndex, ColumnIndex endColumnIndex) {
    SheetPaintConfig paintConfig = sheetController.paintConfig;

    switch (selectionStart) {
      case CellConfig selectionStart:
        return SheetRangeSelection(
          paintConfig: paintConfig,
          start: selectionStart.cellIndex,
          end: CellIndex(rowIndex: endRowIndex, columnIndex: endColumnIndex),
          completed: false,
        );
      case ColumnConfig selectionStart:
        return SheetRangeSelection(
          paintConfig: paintConfig,
          start: CellIndex(rowIndex: RowIndex(0), columnIndex: selectionStart.columnIndex),
          end: CellIndex(rowIndex: RowIndex(defaultRowCount), columnIndex: endColumnIndex),
          completed: false,
        );
      case RowConfig selectionStart:
        return SheetRangeSelection(
          paintConfig: paintConfig,
          start: CellIndex(rowIndex: selectionStart.rowIndex, columnIndex: ColumnIndex(0)),
          end: CellIndex(rowIndex: endRowIndex, columnIndex: ColumnIndex(defaultColumnCount)),
          completed: false,
        );
      default:
        throw Exception('Invalid selectionStart type: $selectionStart');
    }
  }
}
