import 'package:flutter/services.dart';
import 'package:sheets/controller/index.dart';
import 'package:sheets/controller/program_config.dart';
import 'package:sheets/controller/selection/sheet_selection_controller.dart';
import 'package:sheets/controller/selection/types/sheet_selection.dart';
import 'package:sheets/controller/sheet_controller.dart';
import 'package:sheets/controller/sheet_keyboard_controller.dart';
import 'package:sheets/sheet_constants.dart';

class SelectionTapRecognizer {
  final SheetController sheetController;

  SelectionTapRecognizer(this.sheetController);

  void handleItemTap(SheetItemConfig sheetItem) {
    List<_SelectionTapAction> actions = [
      _ContinueRangeSelectionTapAction(sheetController),
      _StartSingleSelectionTapAction(sheetController),
    ];

    _SelectionTapAction? activeAction = actions.firstWhere((action) => action.isActive, orElse: () => actions.last);
    activeAction.execute(sheetItem);
  }
}

abstract class _SelectionTapAction {
  final SheetController sheetController;

  _SelectionTapAction(this.sheetController);

  bool get isActive;

  void execute(SheetItemConfig sheetItem);

  SheetSelectionController get selectionController => sheetController.selectionController;

  SheetKeyboardController get keyboardController => sheetController.keyboardController;

  SheetSelection get previousSelection => selectionController.selection;
}

class _ContinueRangeSelectionTapAction extends _SelectionTapAction {
  _ContinueRangeSelectionTapAction(super.sheetController);

  @override
  bool get isActive {
    return keyboardController.isKeyPressed(LogicalKeyboardKey.shiftLeft);
  }

  @override
  void execute(SheetItemConfig selectionEnd) {
    switch (selectionEnd) {
      case CellConfig cellConfig:
        selectionController.selectRange(start: previousSelection.start, end: cellConfig.cellIndex);
      case ColumnConfig columnConfig:
        selectionController.selectRange(
          start: CellIndex(rowIndex: RowIndex(0), columnIndex: previousSelection.start.columnIndex),
          end: CellIndex(rowIndex: RowIndex(defaultRowCount), columnIndex: columnConfig.columnIndex),
        );
      case RowConfig rowConfig:
        selectionController.selectRange(
          start: CellIndex(rowIndex: previousSelection.start.rowIndex, columnIndex: ColumnIndex(0)),
          end: CellIndex(rowIndex: rowConfig.rowIndex, columnIndex: ColumnIndex(defaultColumnCount)),
        );
    }
  }
}

class _StartSingleSelectionTapAction extends _SelectionTapAction {
  _StartSingleSelectionTapAction(super.sheetController);

  @override
  bool get isActive {
    return keyboardController.anyKeyActive == false;
  }

  @override
  void execute(SheetItemConfig sheetItem) {
    switch (sheetItem) {
      case CellConfig cellConfig:
        selectionController.selectSingle(cellConfig.cellIndex);
      case ColumnConfig columnConfig:
        selectionController.selectRange(
          start: CellIndex(rowIndex: RowIndex(0), columnIndex: columnConfig.columnIndex),
          end: CellIndex(rowIndex: RowIndex(defaultRowCount), columnIndex: columnConfig.columnIndex),
          completed: true,
        );
      case RowConfig rowConfig:
        selectionController.selectRange(
          start: CellIndex(rowIndex: rowConfig.rowIndex, columnIndex: ColumnIndex(0)),
          end: CellIndex(rowIndex: rowConfig.rowIndex, columnIndex: ColumnIndex(defaultColumnCount)),
          completed: true,
        );
    }
  }
}
