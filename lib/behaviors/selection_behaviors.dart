import 'package:sheets/controller/sheet_controller.dart';
import 'package:sheets/core/sheet_item_index.dart';
import 'package:sheets/selection/selection_utils.dart';
import 'package:sheets/selection/types/sheet_selection.dart';

abstract class SelectionBehavior {
  void invoke(SheetController controller);

  SheetSelection? getBaseRangeSelection({required SheetItemIndex start, required SheetItemIndex end}) {
    return switch (start) {
      CellIndex start => _getCellRangeSelection(start, end),
      ColumnIndex start => _getColumnRangeSelection(start, end),
      RowIndex start => _getRowRangeSelection(start, end),
      _ => null,
    };
  }

  SheetSelection? _getCellRangeSelection(CellIndex start, SheetItemIndex end) {
    return switch (end) {
      CellIndex end => SelectionUtils.getRangeSelection(start: start, end: end),
      (_) => null,
    };
  }

  SheetSelection? _getColumnRangeSelection(ColumnIndex start, SheetItemIndex end) {
    return switch (end) {
      CellIndex end => SelectionUtils.getColumnRangeSelection(start: start, end: end.columnIndex, completed: false),
      ColumnIndex end => SelectionUtils.getColumnRangeSelection(start: start, end: end, completed: false),
      (_) => null,
    };
  }

  SheetSelection? _getRowRangeSelection(RowIndex start, SheetItemIndex end) {
    return switch (end) {
      CellIndex end => SelectionUtils.getRowRangeSelection(start: start, end: end.rowIndex, completed: false),
      RowIndex end => SelectionUtils.getRowRangeSelection(start: start, end: end, completed: false),
      (_) => null,
    };
  }
}

class SingleSelectionBehavior extends SelectionBehavior {
  final SheetItemIndex hoveredIndex;

  SingleSelectionBehavior(this.hoveredIndex);

  @override
  void invoke(SheetController controller) {
    return switch (hoveredIndex) {
      CellIndex index => controller.selectionController.selectSingle(index, completed: false),
      ColumnIndex index => controller.selectionController.selectColumn(index, completed: false),
      RowIndex index => controller.selectionController.selectRow(index, completed: false),
      (_) => () {},
    };
  }
}

class ToggleSingleSelectionBehavior extends SelectionBehavior {
  final SheetItemIndex hoveredIndex;

  ToggleSingleSelectionBehavior(this.hoveredIndex);

  @override
  void invoke(SheetController controller) {
    switch (hoveredIndex) {
      case CellIndex index:
        controller.selectionController.toggleCellSelection(index);
        break;
      case ColumnIndex index:
        controller.selectionController.toggleColumnSelection(index);
        break;
      case RowIndex index:
        controller.selectionController.toggleRowSelection(index);
        break;
    }

    controller.selectionController.saveLayer();
  }
}

class BasicSelectionRangeBehavior extends SelectionBehavior {
  final SheetItemIndex hoveredIndex;

  BasicSelectionRangeBehavior(this.hoveredIndex);

  @override
  void invoke(SheetController controller) {
    SheetSelection savedSelection = controller.selectionController.confirmedSelection;
    CellIndex start = savedSelection.mainCell;

    SheetSelection? baseSelection = getBaseRangeSelection(start: start, end: hoveredIndex);
    if (baseSelection == null) return;

    controller.selectionController.customSelection(baseSelection);
  }
}

class AppendSelectionRangeBehavior extends SelectionBehavior {
  final SheetItemIndex hoveredIndex;

  AppendSelectionRangeBehavior(this.hoveredIndex);

  @override
  void invoke(SheetController controller) {
    if (controller.selectionController.layerSelectionEnabled == false) {
      return;
    }

    SheetSelection previousSelection = controller.selectionController.confirmedSelection;
    SheetSelection? appendedSelection = getBaseRangeSelection(start: previousSelection.end, end: hoveredIndex);
    if (appendedSelection == null) return;

    controller.selectionController.selectMultiple(
      <CellIndex>[...previousSelection.selectedCells, ...appendedSelection.selectedCells],
      mainCell: previousSelection.end,
    );
  }
}

class ModifySelectionRangeBehavior extends SelectionBehavior {
  final SheetItemIndex hoveredIndex;

  ModifySelectionRangeBehavior(this.hoveredIndex);

  @override
  void invoke(SheetController controller) {
    SheetSelection savedSelection = controller.selectionController.confirmedSelection;
    CellIndex start = savedSelection.mainCell;

    if (controller.selectionController.layerSelectionEnabled == false) {
      return;
    }

    SheetSelection? newSelection = getBaseRangeSelection(start: start, end: hoveredIndex);
    if (newSelection == null) return;

    SheetSelection previousSelection = controller.selectionController.confirmedSelection;
    controller.selectionController.selectRange(start: previousSelection.mainCell, end: newSelection.end, completed: true);
  }
}

class ModifyAppendedSelectionBehavior extends SelectionBehavior {
  final SheetItemIndex end;

  ModifyAppendedSelectionBehavior(this.end);

  @override
  void invoke(SheetController controller) {
    SheetSelection savedSelection = controller.selectionController.confirmedSelection;
    CellIndex start = savedSelection.mainCell;

    if (controller.selectionController.layerSelectionEnabled == false) {
      return;
    }

    SheetSelection? newSelection = getBaseRangeSelection(start: start, end: end);
    if (newSelection == null) return;

    SheetSelection previousSelection = controller.selectionController.confirmedSelection;
    SheetSelection appendedSelection = SelectionUtils.getRangeSelection(start: previousSelection.mainCell, end: newSelection.end, completed: true);

    controller.selectionController.selectMultiple(
      <CellIndex>[...previousSelection.selectedCells, ...appendedSelection.selectedCells],
      mainCell: previousSelection.mainCell,
    );
  }
}
