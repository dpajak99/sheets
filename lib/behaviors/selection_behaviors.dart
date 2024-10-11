import 'package:sheets/controller/sheet_controller.dart';
import 'package:sheets/core/sheet_item_index.dart';
import 'package:sheets/selection/selection_corners.dart';
import 'package:sheets/selection/selection_factory.dart';
import 'package:sheets/selection/types/sheet_fill_selection.dart';
import 'package:sheets/selection/types/sheet_multi_selection.dart';
import 'package:sheets/selection/sheet_selection.dart';
import 'package:sheets/selection/types/sheet_single_selection.dart';
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

class ToggleSelectionBehavior extends SelectionBehavior {
  final SheetItemIndex pressedIndex;

  ToggleSelectionBehavior(this.pressedIndex);

  @override
  void invoke(SheetController controller) {
    SheetSelection selection = controller.selectionController.visibleSelection;
    if(pressedIndex is! CellIndex) return;

    SheetSelection updatedSelection = selection.append(SheetSingleSelection(cellIndex: pressedIndex as CellIndex, completed: false));
    controller.selectionController.customSelection(updatedSelection);
  }
}

class SelectionRangeBehavior extends SelectionBehavior {
  final SheetItemIndex hoveredIndex;
  final SheetItemIndex? startIndex;

  SelectionRangeBehavior(this.hoveredIndex, {this.startIndex});

  @override
  void invoke(SheetController controller) {
    SheetSelection selection = controller.selectionController.visibleSelection;
    if(hoveredIndex is! CellIndex) return;

    // TODO: Handle rows and columns
    SheetSelection updatedSelection = selection.modifyEnd(hoveredIndex as CellIndex, completed: false);

    controller.selectionController.customSelection(updatedSelection);
  }
}

class AppendSelectionRangeBehavior extends SelectionBehavior {
  final SheetItemIndex hoveredIndex;
  final SheetItemIndex? startIndex;

  AppendSelectionRangeBehavior(this.hoveredIndex, {this.startIndex});

  @override
  void invoke(SheetController controller) {
    SheetSelection selection = controller.selectionController.visibleSelection;
    if(hoveredIndex is! CellIndex || startIndex is! CellIndex?) return;

    CellIndex previousEnd = (startIndex as CellIndex?)  ?? selection.end;

    SheetSelection appendedSelection = SelectionFactory.getRangeSelection(start: previousEnd, end: hoveredIndex);


    if( selection is SheetMultiSelection ) {
      SheetMultiSelection updatedSelection = selection.replaceLast(appendedSelection);
      controller.selectionController.customSelection(updatedSelection);
    } else {
      SheetSelection updatedSelection = selection.append(appendedSelection);
      controller.selectionController.customSelection(updatedSelection);
    }
  }
}

class ModifySelectionRangeBehavior extends SelectionBehavior {
  final SheetItemIndex hoveredIndex;
  final SheetItemIndex? startIndex;

  ModifySelectionRangeBehavior(this.hoveredIndex, {this.startIndex});

  @override
  void invoke(SheetController controller) {
    SheetSelection selection = controller.selectionController.visibleSelection;
    if(hoveredIndex is! CellIndex) return;

    // TODO: Handle rows and columns
    SheetSelection updatedSelection = selection.modifyEnd(hoveredIndex as CellIndex, completed: false);
    controller.selectionController.customSelection(updatedSelection);
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