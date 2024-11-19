import 'package:flutter/services.dart';
import 'package:sheets/core/gestures/sheet_gesture.dart';
import 'package:sheets/core/keyboard/keyboard_shortcuts.dart';
import 'package:sheets/core/selection/selection_overflow_index_adapter.dart';
import 'package:sheets/core/selection/sheet_selection.dart';
import 'package:sheets/core/selection/strategies/gesture_selection_builder.dart';
import 'package:sheets/core/selection/strategies/gesture_selection_strategy.dart';
import 'package:sheets/core/sheet_controller.dart';
import 'package:sheets/core/sheet_index.dart';
import 'package:sheets/core/viewport/viewport_item.dart';

class SheetSelectionStartGesture extends SheetGesture {
  SheetSelectionStartGesture(this.selectionStart);

  final ViewportItem selectionStart;

  @override
  void resolve(SheetController controller) {
    SheetIndex? selectedIndex = selectionStart.index;
    SheetSelection previousSelection = controller.selection.value;

    GestureSelectionBuilder selectionBuilder = GestureSelectionBuilder(previousSelection);

    HardwareKeyboard keyboard = HardwareKeyboard.instance;

    if (keyboard.isControlPressed && keyboard.isShiftPressed) {
      selectionBuilder.setStrategy(GestureSelectionStrategyModify());
    } else if (keyboard.isControlPressed) {
      selectionBuilder.setStrategy(GestureSelectionStrategyAppend());
    } else if (keyboard.isShiftPressed) {
      selectionBuilder.setStrategy(GestureSelectionStrategyRange());
    } else {
      selectionBuilder.setStrategy(GestureSelectionStrategySingle());
    }

    SheetSelection updatedSelection = selectionBuilder.build(selectedIndex);
    controller.selection.update(updatedSelection);

    controller.viewport.ensureIndexFullyVisible(selectedIndex);
  }

  @override
  List<Object?> get props => <Object?>[selectionStart];
}

class SheetSelectionUpdateGesture extends SheetGesture {
  SheetSelectionUpdateGesture(this.selectionStart, this.selectionEnd);

  final ViewportItem selectionStart;
  final ViewportItem selectionEnd;

  @override
  void resolve(SheetController controller) {
    SheetIndex selectedIndex = SelectionOverflowIndexAdapter.adaptToCellIndex(
      selectionEnd.index,
      controller.viewport.firstVisibleRow,
      controller.viewport.firstVisibleColumn,
    );

    SheetSelection previousSelection = controller.selection.value;
    GestureSelectionBuilder selectionBuilder = GestureSelectionBuilder(previousSelection);

    HardwareKeyboard keyboard = HardwareKeyboard.instance;
    if (keyboard.isControlPressed && keyboard.isShiftPressed) {
      selectionBuilder.setStrategy(GestureSelectionStrategyModify());
    } else if (keyboard.isControlPressed) {
      selectionBuilder.setStrategy(GestureSelectionStrategyModify());
    } else if (keyboard.isShiftPressed) {
      selectionBuilder.setStrategy(GestureSelectionStrategyModify());
    } else {
      selectionBuilder.setStrategy(GestureSelectionStrategyRange());
    }

    SheetSelection updatedSelection = selectionBuilder.build(selectedIndex);
    controller.selection.update(updatedSelection);

    controller.viewport.ensureIndexFullyVisible(selectedIndex);
  }

  @override
  List<Object?> get props => <Object?>[selectionStart, selectionEnd];
}

class SheetSelectionEndGesture extends SheetGesture {
  SheetSelectionEndGesture();

  @override
  void resolve(SheetController controller) {
    controller.selection.complete();
  }

  @override
  List<Object?> get props => <Object?>[];
}

class SheetSelectionMoveGesture extends SheetGesture {
  SheetSelectionMoveGesture(this.dx, this.dy);

  final int dx;
  final int dy;

  @override
  void resolve(SheetController controller) {
    CellIndex selectedIndex;
    SheetSelection previousSelection = controller.selection.value;

    GestureSelectionBuilder selectionBuilder = GestureSelectionBuilder(previousSelection);

    HardwareKeyboard keyboard = HardwareKeyboard.instance;
    if (keyboard.isShiftPressed) {
      selectedIndex = previousSelection.end.cell;
      selectionBuilder.setStrategy(GestureSelectionStrategyRange());
    } else {
      selectedIndex = previousSelection.mainCell;
      selectionBuilder.setStrategy(GestureSelectionStrategySingle());
    }

    CellIndex maxIndex = CellIndex.max.toRealIndex(controller.properties);
    selectedIndex = selectedIndex.move(dx: dx, dy: dy).clamp(maxIndex);

    SheetSelection updatedSelection = selectionBuilder.build(selectedIndex);
    controller.selection.update(updatedSelection);
    controller.selection.complete();

    controller.viewport.ensureIndexFullyVisible(selectedIndex);
  }

  @override
  List<Object?> get props => <Object?>[dx, dy];
}
