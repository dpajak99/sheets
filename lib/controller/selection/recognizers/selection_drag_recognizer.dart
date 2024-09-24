import 'package:flutter/services.dart';
import 'package:sheets/controller/index.dart';
import 'package:sheets/controller/program_config.dart';
import 'package:sheets/controller/selection/recognizers/selection_recognizer.dart';
import 'package:sheets/controller/selection/sheet_selection_controller.dart';
import 'package:sheets/controller/selection/types/sheet_multi_selection.dart';
import 'package:sheets/controller/selection/types/sheet_range_selection.dart';
import 'package:sheets/controller/selection/types/sheet_selection.dart';
import 'package:sheets/controller/sheet_controller.dart';
import 'package:sheets/controller/sheet_cursor_controller.dart';
import 'package:sheets/controller/sheet_keyboard_controller.dart';
import 'package:sheets/controller/sheet_visibility_controller.dart';
import 'package:sheets/sheet_constants.dart';

class SelectionDragRecognizer extends SelectionRecognizer {
  final SheetControllerOld sheetController;
  final SheetItemConfig selectionStart;

  SelectionDragRecognizer(this.sheetController, this.selectionStart) {
    if (selectionStart is ColumnConfig || selectionStart is RowConfig) {
      // sheetController.cursorController.setCursor(SystemMouseCursors.basic, SystemMouseCursors.grab);
    }
  }

  @override
  void handle(SheetItemConfig selectionEnd) {
    late RowIndex endRowIndex;
    late ColumnIndex endColumnIndex;

    if (selectionStart.runtimeType != selectionEnd.runtimeType) {
      return;
    }

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

    List<_SelectionDragAction> actions = [
      _MultiSelectionDragAction(sheetController, selectionStart, selectionEnd),
      _SimpleSelectionDragAction(sheetController, selectionStart, selectionEnd),
    ];

    _SelectionDragAction? activeAction = actions.firstWhere((action) => action.isActive, orElse: () => actions.last);
    print('Found $activeAction. Paint it');
    SheetSelection sheetSelection = activeAction.execute(endRowIndex, endColumnIndex);
    sheetController.selectionController.custom(sheetSelection);
  }

  @override
  void complete() {
    // sheetController.cursorController.setCursor(SystemMouseCursors.grab, SystemMouseCursors.basic);
    sheetController.selectionController.completeSelection();
  }
}

abstract class _SelectionDragAction {
  final SheetControllerOld sheetController;
  final SheetItemConfig selectionStart;
  final SheetItemConfig selectionEnd;

  _SelectionDragAction(this.sheetController, this.selectionStart, this.selectionEnd);

  bool get isActive;

  SheetSelection execute(RowIndex endRowIndex, ColumnIndex endColumnIndex);

  SheetSelectionController get selectionController => sheetController.selectionController;

  SheetKeyboardController get keyboardController => sheetController.keyboardController;

  // SheetCursorController get cursorController => sheetController.cursorController;

  SheetVisibilityController get paintConfig => sheetController.paintConfig;

  SheetSelection get previousSelection => selectionController.selection;
}

class _SimpleSelectionDragAction extends _SelectionDragAction {
  _SimpleSelectionDragAction(super.sheetController, super.selectioNStart, super.selectionEnd);

  @override
  bool get isActive {
    return true;
  }

  @override
  SheetSelection execute(RowIndex endRowIndex, ColumnIndex endColumnIndex) {
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

class _MultiSelectionDragAction extends _SelectionDragAction {
  _MultiSelectionDragAction(super.sheetController, super.selectioNStart, super.selectionEnd);

  @override
  bool get isActive {
    return keyboardController.isKeyPressed(LogicalKeyboardKey.controlLeft);
  }

  @override
  SheetSelection execute(RowIndex endRowIndex, ColumnIndex endColumnIndex) {
    late SheetMultiSelection sheetMultiSelection;
    if (previousSelection is SheetMultiSelection) {
      sheetMultiSelection = previousSelection as SheetMultiSelection;
    } else {
      sheetMultiSelection = SheetMultiSelection(selectedCells: previousSelection.selectedCells, paintConfig: sheetController.paintConfig);
    }

    List<_SelectionDragAction> actions = [
      _SimpleSelectionDragAction(sheetController, selectionStart, selectionEnd),
    ];

    _SelectionDragAction? activeAction = actions.firstWhere((action) => action.isActive, orElse: () => actions.last);
    SheetSelection sheetSelection = activeAction.execute(endRowIndex, endColumnIndex);
    sheetMultiSelection.addAll(sheetSelection.selectedCells);
    return sheetMultiSelection;
  }
}
