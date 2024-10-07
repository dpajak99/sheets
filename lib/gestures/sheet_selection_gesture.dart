import 'package:flutter/services.dart';
import 'package:sheets/actions/selection_actions.dart';
import 'package:sheets/controller/sheet_controller.dart';
import 'package:sheets/core/sheet_item_index.dart';
import 'package:sheets/gestures/sheet_drag_gesture.dart';
import 'package:sheets/core/sheet_item_config.dart';
import 'package:sheets/selection/selection_utils.dart';
import 'package:sheets/selection/types/sheet_selection.dart';

class SheetSelectionStartGesture extends SheetDragGesture {
  final SheetDragDetails startDetails;

  SheetSelectionStartGesture(this.startDetails);

  factory SheetSelectionStartGesture.from(SheetDragStartGesture dragGesture) {
    return SheetSelectionStartGesture(dragGesture.startDetails);
  }

  @override
  void resolve(SheetController controller) {
    SheetItemIndex? hoveredItemIndex = startDetails.hoveredItem?.index;
    if (hoveredItemIndex == null) return;

    if (controller.keyboard.areKeysPressed([LogicalKeyboardKey.controlLeft, LogicalKeyboardKey.shiftLeft])) {
      return StartSelectRangeOverlapAction(hoveredItemIndex).resolve(controller);
    } else if (controller.keyboard.isKeyPressed(LogicalKeyboardKey.controlLeft)) {
      return StartSelectToggleAction(hoveredItemIndex).resolve(controller);
    } else if (controller.keyboard.isKeyPressed(LogicalKeyboardKey.shiftLeft)) {
      return StartSelectRangeAction(hoveredItemIndex).resolve(controller);
    } else {
      return StartSelectSingleAction(hoveredItemIndex).resolve(controller);
    }
  }
}

class SheetSelectionUpdateGesture extends SheetDragUpdateGesture {
  SheetSelectionUpdateGesture(super.endDetails, {required super.startDetails});

  factory SheetSelectionUpdateGesture.from(SheetDragUpdateGesture dragGesture) {
    return SheetSelectionUpdateGesture(dragGesture.endDetails, startDetails: dragGesture.startDetails);
  }

  @override
  List<Object?> get props => [endDetails, startDetails];

  @override
  void resolve(SheetController controller) {


    SheetItemIndex? hoveredItemIndex = endDetails.hoveredItem?.index;
    if (hoveredItemIndex == null) return;

    SheetSelection? sheetSelection = switch (startDetails.hoveredItem?.index) {
      CellIndex index => _handleCellDragUpdate(index),
      ColumnIndex index => _handleColumnDragUpdate(index),
      RowIndex index => _handleRowDragUpdate(index),
      _ => null,
    };
    if (sheetSelection == null) return;

    if (controller.keyboard.areKeysPressed([LogicalKeyboardKey.controlLeft, LogicalKeyboardKey.shiftLeft])) {
      if( controller.selectionController.layerSelectionEnabled == false) {
        return;
      }

      SheetSelection savedSelection = controller.selectionController.confirmedSelection;

      SheetSelection layerSelection = SelectionUtils.getRangeSelection(start: savedSelection.mainCell, end: sheetSelection.end, completed: true);
      controller.selectionController.selectMultiple(<CellIndex>[...savedSelection.selectedCells, ...layerSelection.selectedCells], mainCell: savedSelection.mainCell);

    } else if (controller.keyboard.isKeyPressed(LogicalKeyboardKey.controlLeft)) {
      if( controller.selectionController.layerSelectionEnabled == false) {
        return;
      }

      SheetSelection savedSelection = controller.selectionController.confirmedSelection;
      SheetSelection? sheetSelection = switch (savedSelection.end) {
        CellIndex index => _handleCellDragUpdate(index),
      };

      controller.selectionController.selectMultiple(<CellIndex>[...savedSelection.selectedCells, ...?sheetSelection?.selectedCells], mainCell: savedSelection.mainCell);
    } else if (controller.keyboard.isKeyPressed(LogicalKeyboardKey.shiftLeft)) {
      if( controller.selectionController.layerSelectionEnabled == false) {
        return;
      }

      controller.selectionController.selectRange(start: controller.selectionController.confirmedSelection.mainCell, end: sheetSelection.end, completed: true);
    } else {
      controller.selectionController.customSelection(sheetSelection);
    }
  }

  SheetSelection? _handleCellDragUpdate(CellIndex start) {
    return switch (endDetails.hoveredItem?.index) {
      CellIndex index => SelectionUtils.getRangeSelection(start: start, end: index),
      (_) => null,
    };
  }

  SheetSelection? _handleColumnDragUpdate(ColumnIndex start) {
    late ColumnIndex end;

    switch (endDetails.hoveredItem) {
      case CellConfig cellConfig:
        end = cellConfig.cellIndex.columnIndex;
        break;
      case ColumnConfig columnConfig:
        end = columnConfig.columnIndex;
        break;
      default:
        return null;
    }

    return SelectionUtils.getColumnRangeSelection(start: start, end: end, completed: false);
  }

  SheetSelection? _handleRowDragUpdate(RowIndex start) {
    late RowIndex end;

    switch (endDetails.hoveredItem) {
      case CellConfig cellConfig:
        end = cellConfig.cellIndex.rowIndex;
        break;
      case RowConfig rowConfig:
        end = rowConfig.rowIndex;
        break;
      default:
        return null;
    }

    return SelectionUtils.getRowRangeSelection(start: start, end: end, completed: false);
  }
}

class SheetSelectionEndGesture extends SheetDragGesture {
  SheetSelectionEndGesture();

  @override
  void resolve(SheetController controller) {
    controller.selectionController.completeSelection();
  }

  @override
  List<Object?> get props => [];
}
