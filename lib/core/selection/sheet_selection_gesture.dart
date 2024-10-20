import 'package:sheets/core/selection/selection_overflow_index_adapter.dart';
import 'package:sheets/core/selection/strategies/gesture_selection_builder.dart';
import 'package:sheets/core/selection/strategies/gesture_selection_strategy.dart';
import 'package:sheets/core/sheet_controller.dart';
import 'package:sheets/core/gestures/sheet_gesture.dart';
import 'package:sheets/core/keyboard/keyboard_shortcuts.dart';
import 'package:sheets/core/selection/sheet_selection.dart';
import 'package:sheets/core/sheet_index.dart';
import 'package:sheets/core/viewport/viewport_item.dart';

class SheetSelectionStartGesture extends SheetGesture {
  final ViewportItem selectionStart;

  SheetSelectionStartGesture(this.selectionStart);

  @override
  void resolve(SheetController controller) {
    SheetIndex? selectedIndex = selectionStart.index;
    SheetSelection previousSelection = controller.selection.value;

    GestureSelectionBuilder selectionBuilder = GestureSelectionBuilder(previousSelection);

    if (controller.keyboard.equals(KeyboardShortcuts.modifyAppendSelection)) {
      selectionBuilder.setStrategy(GestureSelectionStrategyModify());
    } else if (controller.keyboard.equals(KeyboardShortcuts.appendSelection)) {
      selectionBuilder.setStrategy(GestureSelectionStrategyAppend());
    } else if (controller.keyboard.equals(KeyboardShortcuts.modifySelection)) {
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
  final ViewportItem selectionStart;
  final ViewportItem selectionEnd;

  SheetSelectionUpdateGesture(this.selectionStart, this.selectionEnd);

  @override
  void resolve(SheetController controller) {
    SheetIndex selectedIndex = SelectionOverflowIndexAdapter.adaptToCellIndex(
      selectionEnd.index,
      controller.viewport.firstVisibleRow,
      controller.viewport.firstVisibleColumn,
    );
    
    SheetSelection previousSelection = controller.selection.value;
    GestureSelectionBuilder selectionBuilder = GestureSelectionBuilder(previousSelection);

    if (controller.keyboard.equals(KeyboardShortcuts.modifyAppendSelection)) {
      selectionBuilder.setStrategy(GestureSelectionStrategyModify());
    } else if (controller.keyboard.equals(KeyboardShortcuts.appendSelection)) {
      selectionBuilder.setStrategy(GestureSelectionStrategyModify());
    } else if (controller.keyboard.equals(KeyboardShortcuts.modifySelection)) {
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
  final int dx;
  final int dy;

  SheetSelectionMoveGesture(this.dx, this.dy);

  @override
  void resolve(SheetController controller) {
    CellIndex selectedIndex;
    SheetSelection previousSelection = controller.selection.value;

    GestureSelectionBuilder selectionBuilder = GestureSelectionBuilder(previousSelection);

    if (controller.keyboard.state.containsState(KeyboardShortcuts.modifySelection)) {
      selectedIndex = previousSelection.start.cell;
      selectionBuilder.setStrategy(GestureSelectionStrategyRange());
    } else {
      selectedIndex = previousSelection.mainCell;
      selectionBuilder.setStrategy(GestureSelectionStrategySingle());
    }

    CellIndex maxIndex = CellIndex.max.toRealIndex(controller.properties);
    selectedIndex = selectedIndex.move(dx, dy).clamp(maxIndex);

    SheetSelection updatedSelection = selectionBuilder.build(selectedIndex);
    controller.selection.update(updatedSelection);
    controller.selection.complete();

    controller.viewport.ensureIndexFullyVisible(selectedIndex);
  }

  @override
  List<Object?> get props => <Object?>[dx, dy];
}
