import 'package:flutter/services.dart';
import 'package:sheets/core/events/sheet_event.dart';
import 'package:sheets/core/events/sheet_rebuild_config.dart';
import 'package:sheets/core/selection/selection_overflow_index_adapter.dart';
import 'package:sheets/core/selection/sheet_selection.dart';
import 'package:sheets/core/selection/sheet_selection_factory.dart';
import 'package:sheets/core/selection/strategies/gesture_selection_builder.dart';
import 'package:sheets/core/selection/strategies/gesture_selection_strategy.dart';
import 'package:sheets/core/selection/types/sheet_range_selection.dart';
import 'package:sheets/core/sheet_controller.dart';
import 'package:sheets/core/sheet_index.dart';
import 'package:sheets/core/viewport/viewport_item.dart';

abstract class SelectionEvent extends SheetEvent {
  @override
  SelectionAction<SelectionEvent> createAction(SheetController controller);
}

abstract class SelectionAction<T extends SelectionEvent> extends SheetAction<T> {
  SelectionAction(super.event, super.controller);
}

// Start Selection
class StartSelectionEvent extends SheetEvent {
  StartSelectionEvent(this.selectionStart);

  final ViewportItem selectionStart;

  @override
  SheetAction<SheetEvent>? createAction(SheetController controller) {
    SheetSelection previousSelection = controller.selection.value;
    if (previousSelection == SheetSelectionFactory.single(selectionStart.index)) {
      return null;
    } else {
      return StartSelectionAction(this, controller);
    }
  }

  @override
  SheetRebuildConfig get rebuildConfig {
    return SheetRebuildConfig(rebuildSelection: true);
  }

  @override
  List<Object?> get props => <Object?>[selectionStart];
}

class StartSelectionAction extends SheetAction<StartSelectionEvent> {
  StartSelectionAction(super.event, super.controller);

  @override
  void execute() {
    if (controller.isEditingMode) {
      controller.resolve(DisableEditingEvent(save: true));
    }

    SheetIndex? selectedIndex = controller.data.fillCellIndex(event.selectionStart.index);

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

    ensureFullyVisible(selectedIndex);
  }
}

// Update Selection
class UpdateSelectionEvent extends SheetEvent {
  UpdateSelectionEvent(this.selectionEnd);

  final ViewportItem selectionEnd;

  @override
  SheetAction<SheetEvent>? createAction(SheetController controller) {
    if (controller.isEditingMode) {
      return null;
    } else {
      return UpdateSelectionAction(this, controller);
    }
  }

  @override
  SheetRebuildConfig get rebuildConfig {
    return SheetRebuildConfig(rebuildSelection: true);
  }

  @override
  List<Object?> get props => <Object?>[selectionEnd];
}

class UpdateSelectionAction extends SheetAction<UpdateSelectionEvent> {
  UpdateSelectionAction(super.event, super.controller);

  @override
  void execute() {
    SheetIndex selectedIndex = SelectionOverflowIndexAdapter.adaptToCellIndex(
      event.selectionEnd.index,
      controller.viewport.firstVisibleRow,
      controller.viewport.firstVisibleColumn,
    );
    selectedIndex = controller.data.fillCellIndex(selectedIndex);

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

    if (updatedSelection is SheetRangeSelection<CellIndex>) {
      updatedSelection = ensureMergedCellsVisible(updatedSelection);
    }

    controller.selection.update(updatedSelection);

    ensureFullyVisible(selectedIndex);
  }
}

// Complete Selection
class CompleteSelectionEvent extends SheetEvent {
  CompleteSelectionEvent();

  @override
  SheetAction<SheetEvent>? createAction(SheetController controller) {
    if (controller.selection.value.isCompleted) {
      return null;
    } else {
      return CompleteSelectionAction(this, controller);
    }
  }

  @override
  SheetRebuildConfig get rebuildConfig {
    return SheetRebuildConfig(rebuildSelection: true);
  }

  @override
  List<Object?> get props => <Object?>[];
}

class CompleteSelectionAction extends SheetAction<CompleteSelectionEvent> {
  CompleteSelectionAction(super.event, super.controller);

  @override
  void execute() {
    controller.selection.complete();
  }
}

// Move Selection
class MoveSelectionEvent extends SheetEvent {
  MoveSelectionEvent(this.dx, this.dy);

  MoveSelectionEvent.fromOffset(Offset offset)
      : dx = offset.dx.toInt(),
        dy = offset.dy.toInt();

  final int dx;
  final int dy;

  @override
  SheetAction<SheetEvent> createAction(SheetController controller) => MoveSelectionAction(this, controller);

  @override
  SheetRebuildConfig get rebuildConfig {
    return SheetRebuildConfig(rebuildSelection: true);
  }

  @override
  List<Object?> get props => <Object?>[dx, dy];
}

class MoveSelectionAction extends SheetAction<MoveSelectionEvent> {
  MoveSelectionAction(super.event, super.controller);

  @override
  void execute() {
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

    CellIndex maxIndex = CellIndex.max.toRealIndex(
      columnCount: controller.data.columnCount,
      rowCount: controller.data.rowCount,
    );
    selectedIndex = controller.data.fillCellIndex(selectedIndex);
    selectedIndex = selectedIndex.move(dx: event.dx, dy: event.dy).clamp(maxIndex);
    selectedIndex = controller.data.fillCellIndex(selectedIndex);

    SheetSelection updatedSelection = selectionBuilder.build(selectedIndex);

    if (updatedSelection is SheetRangeSelection<CellIndex>) {
      updatedSelection = ensureMergedCellsVisible(updatedSelection);
    }

    controller.selection.update(updatedSelection);
    controller.selection.complete();

    ensureFullyVisible(selectedIndex);
  }
}
