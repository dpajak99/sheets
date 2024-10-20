import 'package:sheets/behaviors/selection_strategy.dart';
import 'package:sheets/controller/sheet_controller.dart';
import 'package:sheets/core/sheet_item_index.dart';
import 'package:sheets/gestures/sheet_gesture.dart';
import 'package:sheets/listeners/keyboard/keyboard_shortcuts.dart';
import 'package:sheets/selection/sheet_selection.dart';
import 'package:sheets/viewport/viewport_item.dart';

class SheetSelectionStartGesture extends SheetGesture {
  final ViewportItem selectionStart;

  SheetSelectionStartGesture(this.selectionStart);

  @override
  void resolve(SheetController controller) {
    SheetIndex? hoveredIndex = selectionStart.index;

    SheetSelection previousSelection = controller.selection.value;
    SheetSelection updatedSelection;

    if (controller.keyboard.equals(KeyboardShortcuts.modifyAppendSelection)) {
      updatedSelection = ModifySelectionRangeStrategy(hoveredIndex).execute(previousSelection);
    } else if (controller.keyboard.equals(KeyboardShortcuts.appendSelection)) {
      updatedSelection = AppendSelectionStrategy(hoveredIndex).execute(previousSelection);
    } else if (controller.keyboard.equals(KeyboardShortcuts.modifySelection)) {
      updatedSelection = RangeSelectionStrategy(hoveredIndex).execute(previousSelection);
    } else {
      updatedSelection = SingleSelectionStrategy(hoveredIndex).execute(previousSelection);
    }

    controller.select(updatedSelection);
    controller.viewport.ensureIndexFullyVisible(hoveredIndex);
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
    SheetIndex selectionEndIndex = selectionEnd.index;

    SheetSelection previousSelection = controller.selection.value;
    if (previousSelection.selectionStart is CellIndex) {
      if (selectionEndIndex is ColumnIndex) {
        selectionEndIndex = CellIndex(row: controller.viewport.visibleContent.rows.first.index, column: selectionEndIndex).move(-1, 0);
      } else if (selectionEndIndex is RowIndex) {
        selectionEndIndex = CellIndex(row: selectionEndIndex, column: controller.viewport.visibleContent.columns.first.index).move(0, -1);
      }
    }

    SheetSelection updatedSelection;

    if (controller.keyboard.equals(KeyboardShortcuts.modifyAppendSelection)) {
      updatedSelection = ModifySelectionRangeStrategy(selectionEndIndex).execute(previousSelection);
    } else if (controller.keyboard.equals(KeyboardShortcuts.appendSelection)) {
      updatedSelection= ModifySelectionRangeStrategy(selectionEndIndex).execute(previousSelection);
    } else if (controller.keyboard.equals(KeyboardShortcuts.modifySelection)) {
      updatedSelection = ModifySelectionRangeStrategy(selectionEndIndex).execute(previousSelection);
    } else {
      updatedSelection = RangeSelectionStrategy(selectionEndIndex).execute(previousSelection);
    }

    controller.select(updatedSelection);
    controller.viewport.ensureIndexFullyVisible(selectionEndIndex);
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
    SheetSelection previousSelection = controller.selection.value;
    SheetSelection updatedSelection;

    CellIndex maxIndex = CellIndex.max.toRealIndex(controller.properties);
    CellIndex newIndex;

    if (controller.keyboard.state.containsState(KeyboardShortcuts.modifySelection)) {
      newIndex = previousSelection.cellEnd.move(dx, dy).clamp(maxIndex);
      updatedSelection = RangeSelectionStrategy(newIndex).execute(previousSelection);
    } else {
      newIndex = previousSelection.mainCell.move(dx, dy).clamp(maxIndex);
      updatedSelection = SingleSelectionStrategy(newIndex).execute(previousSelection);
    }

    controller.viewport.ensureIndexFullyVisible(newIndex);

    controller.select(updatedSelection);
    controller.selection.complete();
  }

  @override
  List<Object?> get props => <Object?>[dx, dy];
}
