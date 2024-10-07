import 'package:sheets/controller/sheet_controller.dart';
import 'package:sheets/core/sheet_item_index.dart';
import 'package:sheets/selection/selection_utils.dart';
import 'package:sheets/selection/types/sheet_selection.dart';

class StartSelectSingleAction {
  final SheetItemIndex sheetItemIndex;

  StartSelectSingleAction(this.sheetItemIndex);

  void resolve(SheetController controller) {
    return switch (sheetItemIndex) {
      CellIndex index => controller.selectionController.selectSingle(index, completed: false),
      ColumnIndex index => controller.selectionController.selectColumn(index, completed: false),
      RowIndex index => controller.selectionController.selectRow(index, completed: false),
      (_) => () {},
    };
  }
}

class StartSelectRangeAction {
  final SheetItemIndex sheetItemIndex;

  StartSelectRangeAction(this.sheetItemIndex);

  void resolve(SheetController controller) {
    SheetSelection savedSelection = controller.selectionController.confirmedSelection;
    CellIndex startIndex = savedSelection.mainCell;

    return switch (sheetItemIndex) {
      CellIndex index => controller.selectionController.selectRange(start: startIndex, end: index, completed: false),
      ColumnIndex index => controller.selectionController.selectColumnRange(start: startIndex.columnIndex, end: index, completed: false),
      RowIndex index => controller.selectionController.selectRowRange(start: startIndex.rowIndex, end: index, completed: false),
      (_) => () {},
    };
  }
}

class StartSelectToggleAction {
  final SheetItemIndex sheetItemIndex;

  StartSelectToggleAction(this.sheetItemIndex);

  void resolve(SheetController controller) {
    bool selected = true;

    switch (sheetItemIndex) {
      case CellIndex index:
        selected = controller.selectionController.toggleCellSelection(index);
        break;
      case ColumnIndex index:
        controller.selectionController.toggleColumnSelection(index);
        break;
      case RowIndex index:
        controller.selectionController.toggleRowSelection(index);
        break;
    }

    controller.selectionController.saveLayer();
    if (selected == false) {
      controller.selectionController.layerSelectionEnabled = false;
    } else {
      controller.selectionController.layerSelectionEnabled = true;
    }
  }
}

class StartSelectRangeOverlapAction {
  final SheetItemIndex sheetItemIndex;

  StartSelectRangeOverlapAction(this.sheetItemIndex);

  void resolve(SheetController controller) {
    SheetSelection savedSelection = controller.selectionController.confirmedSelection;
    CellIndex selectionStart = savedSelection.end;
    SheetSelection? sheetSelection = switch (sheetItemIndex) {
      CellIndex index => SelectionUtils.getRangeSelection(start: index, end: selectionStart, completed: true),
      ColumnIndex index => SelectionUtils.getColumnRangeSelection(start: selectionStart.columnIndex, end: index),
      RowIndex index => SelectionUtils.getRowRangeSelection(start: selectionStart.rowIndex, end: index),
      (_) => null,
    };

    if (sheetSelection != null) {
      controller.selectionController.selectMultiple(
        <CellIndex>[...savedSelection.selectedCells, ...sheetSelection.selectedCells],
        mainCell: sheetSelection.end,
      );
    }
  }
}
