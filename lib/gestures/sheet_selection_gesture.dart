import 'package:flutter/services.dart';
import 'package:sheets/behaviors/selection_behaviors.dart';
import 'package:sheets/controller/sheet_controller.dart';
import 'package:sheets/core/sheet_item_index.dart';
import 'package:sheets/gestures/sheet_drag_gesture.dart';

class SheetSelectionStartGesture extends SheetDragGesture {
  final SheetDragDetails startDetails;

  SheetSelectionStartGesture(this.startDetails);

  factory SheetSelectionStartGesture.from(SheetDragStartGesture dragGesture) {
    return SheetSelectionStartGesture(dragGesture.startDetails);
  }

  @override
  void resolve(SheetController controller) {
    SheetItemIndex? hoveredIndex = startDetails.hoveredItem?.index;
    if (hoveredIndex == null) return;

    if (controller.keyboard.areKeysPressed([LogicalKeyboardKey.controlLeft, LogicalKeyboardKey.shiftLeft])) {
      return ModifySelectionRangeBehavior(hoveredIndex).invoke(controller);
    } else if (controller.keyboard.isKeyPressed(LogicalKeyboardKey.controlLeft)) {
      return ToggleSelectionBehavior(hoveredIndex).invoke(controller);
    } else if (controller.keyboard.isKeyPressed(LogicalKeyboardKey.shiftLeft)) {
      return SelectionRangeBehavior(hoveredIndex).invoke(controller);
    } else {
      return SingleSelectionBehavior(hoveredIndex).invoke(controller);
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
    SheetItemIndex? hoveredIndex = endDetails.hoveredItem?.index;
    if (hoveredIndex == null) return;

    if (controller.keyboard.areKeysPressed([LogicalKeyboardKey.controlLeft, LogicalKeyboardKey.shiftLeft])) {
      ModifySelectionRangeBehavior(hoveredIndex).invoke(controller);
    } else if (controller.keyboard.isKeyPressed(LogicalKeyboardKey.controlLeft)) {
      AppendSelectionRangeBehavior(hoveredIndex, startIndex: startDetails.hoveredItemIndex).invoke(controller);
    } else if (controller.keyboard.isKeyPressed(LogicalKeyboardKey.shiftLeft)) {
      ModifySelectionRangeBehavior(hoveredIndex, startIndex: startDetails.hoveredItemIndex).invoke(controller);
    } else {
      SelectionRangeBehavior(hoveredIndex, startIndex: startDetails.hoveredItemIndex).invoke(controller);
    }
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
