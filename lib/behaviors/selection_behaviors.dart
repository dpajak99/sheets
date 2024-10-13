import 'package:sheets/controller/sheet_controller.dart';
import 'package:sheets/core/sheet_item_index.dart';
import 'package:sheets/selection/selection_corners.dart';
import 'package:sheets/selection/types/sheet_fill_selection.dart';
import 'package:sheets/selection/sheet_selection.dart';
import 'package:sheets/selection/types/sheet_multi_selection.dart';
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

    SheetSelection updatedSelection = selection.append(SheetSelection.single(pressedIndex, completed: false));
    controller.selectionController.customSelection(updatedSelection);
  }
}

class SelectionRangeBehavior extends SelectionBehavior {
  final SheetItemIndex hoveredIndex;

  SelectionRangeBehavior(this.hoveredIndex);

  @override
  void invoke(SheetController controller) {
    SheetSelection selection = controller.selectionController.visibleSelection;
    if(selection is SheetMultiSelection) {
      selection = selection.mergedSelections.last;
    }

    SheetSelection updatedSelection = selection.modifyEnd(hoveredIndex, completed: false);
    controller.selectionController.customSelection(updatedSelection);
  }
}

class ModifySelectionRangeBehavior extends SelectionBehavior {
  final SheetItemIndex hoveredIndex;

  ModifySelectionRangeBehavior(this.hoveredIndex);

  @override
  void invoke(SheetController controller) {
    SheetSelection selection = controller.selectionController.visibleSelection;

    SheetSelection updatedSelection = selection.modifyEnd(hoveredIndex, completed: false);
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

    SheetSelection selection = SheetSelection.fill(
      fillDirection: direction,
      baseSelection: baseSelection,
      start: start,
      end: end,
      completed: false,
    );

    controller.selectionController.customSelection(selection);
  }
}