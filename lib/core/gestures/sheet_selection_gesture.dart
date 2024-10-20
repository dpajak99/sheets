import 'package:sheets/core/sheet_controller.dart';
import 'package:sheets/core/gestures/sheet_gesture.dart';
import 'package:sheets/core/keyboard/keyboard_shortcuts.dart';
import 'package:sheets/core/selection/selection_index_adapter.dart';
import 'package:sheets/core/selection/sheet_selection.dart';
import 'package:sheets/core/selection/strategies/selection_strategy.dart';
import 'package:sheets/core/selection/strategies/selection_strategy_context.dart';
import 'package:sheets/core/sheet_index.dart';
import 'package:sheets/core/viewport/viewport_item.dart';

class SheetSelectionStartGesture extends SheetGesture {
  final ViewportItem selectionStart;

  SheetSelectionStartGesture(this.selectionStart);

  @override
  void resolve(SheetController controller) {
    SheetIndex? selectedIndex = selectionStart.index;
    SheetSelection previousSelection = controller.selection.value;

    SelectionBuilder selectionBuilder = SelectionBuilder(previousSelection);

    if (controller.keyboard.equals(KeyboardShortcuts.modifyAppendSelection)) {
      selectionBuilder.setStrategy(SelectionStrategyModify());
    } else if (controller.keyboard.equals(KeyboardShortcuts.appendSelection)) {
      selectionBuilder.setStrategy(SelectionStrategyAppend());
    } else if (controller.keyboard.equals(KeyboardShortcuts.modifySelection)) {
      selectionBuilder.setStrategy(SelectionStrategyRange());
    } else {
      selectionBuilder.setStrategy(SelectionStrategySingle());
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
    SheetIndex selectedIndex = SelectionIndexAdapter.adaptToCellIndex(selectionEnd.index, controller.viewport.visibleContent);
    SheetSelection previousSelection = controller.selection.value;

    SelectionBuilder selectionBuilder = SelectionBuilder(previousSelection);

    if (controller.keyboard.equals(KeyboardShortcuts.modifyAppendSelection)) {
      selectionBuilder.setStrategy(SelectionStrategyModify());
    } else if (controller.keyboard.equals(KeyboardShortcuts.appendSelection)) {
      selectionBuilder.setStrategy(SelectionStrategyModify());
    } else if (controller.keyboard.equals(KeyboardShortcuts.modifySelection)) {
      selectionBuilder.setStrategy(SelectionStrategyModify());
    } else {
      selectionBuilder.setStrategy(SelectionStrategyRange());
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

    SelectionBuilder selectionBuilder = SelectionBuilder(previousSelection);

    if (controller.keyboard.state.containsState(KeyboardShortcuts.modifySelection)) {
      selectedIndex = previousSelection.start.cell;
      selectionBuilder.setStrategy(SelectionStrategyRange());
    } else {
      selectedIndex = previousSelection.mainCell;
      selectionBuilder.setStrategy(SelectionStrategySingle());
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
