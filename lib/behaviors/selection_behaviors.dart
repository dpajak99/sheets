import 'package:sheets/controller/sheet_controller.dart';
import 'package:sheets/core/sheet_item_index.dart';
import 'package:sheets/selection/selection_corners.dart';
import 'package:sheets/selection/selection_factory.dart';
import 'package:sheets/selection/types/sheet_fill_selection.dart';
import 'package:sheets/selection/types/sheet_range_selection.dart';
import 'package:sheets/selection/types/sheet_selection.dart';
import 'package:sheets/utils/direction.dart';

abstract class SelectionBehavior {
  void invoke(SheetController controller);
}

class SingleSelectionBehavior extends SelectionBehavior {
  final SheetItemIndex hoveredIndex;

  SingleSelectionBehavior(this.hoveredIndex);

  @override
  void invoke(SheetController controller) {
    controller.selectionController.selectSingle(hoveredIndex, completed: false);
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
  final SheetItemIndex? startIndex;

  BasicSelectionRangeBehavior(this.hoveredIndex, {this.startIndex});

  @override
  void invoke(SheetController controller) {
    SheetItemIndex? startIndex = this.startIndex;
    SheetItemIndex? hoveredIndex = this.hoveredIndex;

    if (startIndex != null && startIndex.runtimeType != hoveredIndex.runtimeType) {
      hoveredIndex = SheetItemIndex.matchType(startIndex, hoveredIndex);
    }

    SheetSelection previousSelection = controller.selectionController.confirmedSelection;
    CellIndex previousStart = previousSelection.mainCell;

    SheetSelection? newSelection = SelectionFactory.getRangeSelection(start: startIndex ?? previousStart, end: hoveredIndex);

    controller.selectionController.customSelection(newSelection);
    controller.selectionController.saveLayer();
  }
}

class AppendSelectionRangeBehavior extends SelectionBehavior {
  final SheetItemIndex hoveredIndex;
  final SheetItemIndex? startIndex;

  AppendSelectionRangeBehavior(this.hoveredIndex, {this.startIndex});

  @override
  void invoke(SheetController controller) {
    SheetItemIndex? hoveredIndex = this.hoveredIndex;

    if (startIndex != null && startIndex.runtimeType != hoveredIndex.runtimeType) {
      hoveredIndex = SheetItemIndex.matchType(startIndex!, hoveredIndex);
    }

    if (controller.selectionController.layerSelectionEnabled == false) {
      return;
    }

    SheetSelection previousSelection = controller.selectionController.confirmedSelection;
    CellIndex previousEnd = previousSelection.end;

    SheetSelection? appendedSelection = SelectionFactory.getRangeSelection(start: previousEnd, end: hoveredIndex);

    controller.selectionController.combine(previousSelection, appendedSelection);
  }
}

class ModifySelectionRangeBehavior extends SelectionBehavior {
  final SheetItemIndex hoveredIndex;
  final SheetItemIndex? startIndex;

  ModifySelectionRangeBehavior(this.hoveredIndex, {this.startIndex});

  @override
  void invoke(SheetController controller) {
    SheetItemIndex? hoveredIndex = this.hoveredIndex;

    if (startIndex != null && startIndex.runtimeType != hoveredIndex.runtimeType) {
      hoveredIndex = SheetItemIndex.matchType(startIndex!, hoveredIndex);
    }

    if (controller.selectionController.layerSelectionEnabled == false) {
      return;
    }

    SheetSelection previousSelection = controller.selectionController.confirmedSelection;
    CellIndex previousStart = previousSelection.mainCell;

    SheetSelection? newSelection = SelectionFactory.getRangeSelection(start: previousStart, end: hoveredIndex);

    controller.selectionController.selectRange(start: previousStart, end: newSelection.end, completed: true);
  }
}

class ModifyAppendedSelectionBehavior extends SelectionBehavior {
  final SheetItemIndex hoveredIndex;
  final SheetItemIndex? startIndex;

  ModifyAppendedSelectionBehavior(this.hoveredIndex, {this.startIndex});

  @override
  void invoke(SheetController controller) {
    SheetItemIndex? hoveredIndex = this.hoveredIndex;

    if (startIndex != null && startIndex.runtimeType != hoveredIndex.runtimeType) {
      hoveredIndex = SheetItemIndex.matchType(startIndex!, hoveredIndex);
    }

    if (controller.selectionController.layerSelectionEnabled == false) {
      return;
    }

    SheetSelection previousSelection = controller.selectionController.confirmedSelection;
    CellIndex previousStart = previousSelection.mainCell;

    SheetSelection? newSelection = SelectionFactory.getRangeSelection(start: previousStart, end: hoveredIndex);
    SheetSelection? appendedSelection = SheetRangeSelection(start: previousSelection.mainCell, end: newSelection.end, completed: true);

    controller.selectionController.combine(previousSelection, appendedSelection);
  }
}

class SelectionFillBehavior extends SelectionBehavior {
  final SheetItemIndex hoveredIndex;

  SelectionFillBehavior(this.hoveredIndex);

  @override
  void invoke(SheetController controller) {
    if (this.hoveredIndex is! CellIndex) return;
    CellIndex hoveredIndex = this.hoveredIndex as CellIndex;

    SheetSelection baseSelection = (controller.selectionController.visibleSelection is SheetFillSelection)
        ? (controller.selectionController.visibleSelection as SheetFillSelection).baseSelection
        : controller.selectionController.visibleSelection;

    SelectionCellCorners? corners = baseSelection.selectionCellCorners;
    if (corners == null) return;

    Direction direction = corners.getRelativePosition(hoveredIndex);

    if (baseSelection.contains(hoveredIndex)) {
      return controller.selectionController.customSelection(baseSelection);
    }

    late CellIndex start;
    late CellIndex end;

    switch (direction) {
      case Direction.top:
        start = corners.topLeft.move(-1, 0);
        end = CellIndex(rowIndex: hoveredIndex.rowIndex, columnIndex: corners.topRight.columnIndex);
        break;
      case Direction.bottom:
        start = CellIndex(rowIndex: hoveredIndex.rowIndex, columnIndex: corners.bottomLeft.columnIndex);
        end = corners.bottomRight.move(1, 0);
        break;
      case Direction.left:
        start = corners.topLeft.move(0, -1);
        end = CellIndex(rowIndex: corners.bottomLeft.rowIndex, columnIndex: hoveredIndex.columnIndex);
        break;
      case Direction.right:
        start = CellIndex(rowIndex: corners.topRight.rowIndex, columnIndex: hoveredIndex.columnIndex);
        end = corners.bottomRight.move(0, 1);
        break;
    }

    SheetFillSelection sheetFillSelection = SheetFillSelection(
      fillDirection: direction,
      baseSelection: baseSelection,
      start: start,
      end: end,
      completed: false,
    );

    controller.selectionController.customSelection(sheetFillSelection);
  }
}
