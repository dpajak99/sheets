import 'package:flutter/services.dart';
import 'package:sheets/controller/index.dart';
import 'package:sheets/controller/program_config.dart';
import 'package:sheets/controller/selection/recognizers/selection_recognizer.dart';
import 'package:sheets/controller/selection/sheet_selection_controller.dart';
import 'package:sheets/controller/selection/types/sheet_multi_selection.dart';
import 'package:sheets/controller/selection/types/sheet_range_selection.dart';
import 'package:sheets/controller/selection/types/sheet_selection.dart';
import 'package:sheets/controller/selection/types/sheet_single_selection.dart';
import 'package:sheets/controller/sheet_controller.dart';
import 'package:sheets/controller/sheet_keyboard_controller.dart';
import 'package:sheets/controller/sheet_visibility_controller.dart';
import 'package:sheets/sheet_constants.dart';

class SelectionTapRecognizer extends SelectionRecognizer {
  final SheetControllerOld sheetController;

  SelectionTapRecognizer(this.sheetController);

  @override
  void handle(SheetItemConfig selectionEnd) {
    List<_SelectionTapAction> actions = [
      _MultiSelectionTapAction(sheetController),
      _ContinueRangeSelectionTapAction(sheetController),
      _StartSingleSelectionTapAction(sheetController),
    ];

    _SelectionTapAction? activeAction = actions.firstWhere((action) => action.isActive, orElse: () => actions.last);
    SheetSelection sheetSelection = activeAction.execute(selectionEnd);
    sheetController.selectionController.custom(sheetSelection);
  }

  @override
  void complete() {}
}

abstract class _SelectionTapAction {
  final SheetControllerOld sheetController;

  _SelectionTapAction(this.sheetController);

  bool get isActive;

  SheetSelection execute(SheetItemConfig sheetItem);

  SheetSelectionController get selectionController => sheetController.selectionController;

  SheetKeyboardController get keyboardController => sheetController.keyboardController;

  SheetVisibilityController get paintConfig => sheetController.paintConfig;

  SheetSelection get previousSelection => selectionController.selection;
}

class _MultiSelectionTapAction extends _SelectionTapAction {
  _MultiSelectionTapAction(super.sheetController);

  @override
  bool get isActive {
    return keyboardController.isKeyPressed(LogicalKeyboardKey.controlLeft);
  }

  @override
  SheetSelection execute(SheetItemConfig sheetItem) {
    print('Execute: Multi selection');
    late SheetMultiSelection sheetMultiSelection;
    if (previousSelection is SheetMultiSelection) {
      sheetMultiSelection = previousSelection as SheetMultiSelection;
    } else {
      sheetMultiSelection = SheetMultiSelection(selectedCells: previousSelection.selectedCells, paintConfig: sheetController.paintConfig);
    }

    List<_SelectionTapAction> actions = [
      _ContinueRangeSelectionTapAction(sheetController),
      _StartSingleSelectionTapAction(sheetController),
    ];

    _SelectionTapAction? activeAction = actions.firstWhere((action) => action.isActive, orElse: () => actions.last);
    SheetSelection sheetSelection = activeAction.execute(sheetItem);
    if (sheetSelection is SheetSingleSelection) {
      sheetMultiSelection.addSingle(sheetSelection.cellIndex);
    } else if (sheetSelection is SheetRangeSelection) {
      sheetMultiSelection.addAll(sheetSelection.selectedCells);
    }
    return sheetMultiSelection;
  }
}

class _ContinueRangeSelectionTapAction extends _SelectionTapAction {
  _ContinueRangeSelectionTapAction(super.sheetController);

  @override
  bool get isActive {
    return keyboardController.isKeyPressed(LogicalKeyboardKey.shiftLeft);
  }

  @override
  SheetSelection execute(SheetItemConfig selectionEnd) {
    switch (selectionEnd) {
      case CellConfig cellConfig:
        return SheetRangeSelection(
          paintConfig: paintConfig,
          start: previousSelection.end,
          end: cellConfig.index,
          completed: true,
        );
      case ColumnConfig columnConfig:
        return SheetRangeSelection(
          paintConfig: paintConfig,
          start: CellIndex(rowIndex: RowIndex(0), columnIndex: previousSelection.start.columnIndex),
          end: CellIndex(rowIndex: RowIndex(defaultRowCount), columnIndex: columnConfig.columnIndex),
          completed: true,
        );
      case RowConfig rowConfig:
        return SheetRangeSelection(
          paintConfig: paintConfig,
          start: CellIndex(rowIndex: previousSelection.start.rowIndex, columnIndex: ColumnIndex(0)),
          end: CellIndex(rowIndex: rowConfig.rowIndex, columnIndex: ColumnIndex(defaultColumnCount)),
          completed: true,
        );
      default:
        throw Exception('Invalid selectionEnd type: $selectionEnd');
    }
  }
}

class _StartSingleSelectionTapAction extends _SelectionTapAction {
  _StartSingleSelectionTapAction(super.sheetController);

  @override
  bool get isActive {
    return true;
  }

  @override
  SheetSelection execute(SheetItemConfig sheetItem) {
    switch (sheetItem) {
      case CellConfig cellConfig:
        return SheetSingleSelection(paintConfig: paintConfig, cellIndex: cellConfig.index);
      case ColumnConfig columnConfig:
        return SheetRangeSelection(
          paintConfig: paintConfig,
          start: CellIndex(rowIndex: RowIndex(0), columnIndex: columnConfig.columnIndex),
          end: CellIndex(rowIndex: RowIndex(defaultRowCount), columnIndex: columnConfig.columnIndex),
          completed: true,
        );
      case RowConfig rowConfig:
        return SheetRangeSelection(
          paintConfig: paintConfig,
          start: CellIndex(rowIndex: rowConfig.rowIndex, columnIndex: ColumnIndex(0)),
          end: CellIndex(rowIndex: rowConfig.rowIndex, columnIndex: ColumnIndex(defaultColumnCount)),
          completed: true,
        );
      default:
        throw Exception('Invalid sheetItem type: $sheetItem');
    }
  }
}
