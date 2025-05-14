import 'package:flutter/services.dart';
import 'package:sheets/core/events/sheet_event.dart';
import 'package:sheets/core/events/sheet_rebuild_config.dart';
import 'package:sheets/core/selection/selection_overflow_index_adapter.dart';
import 'package:sheets/core/selection/sheet_selection.dart';
import 'package:sheets/core/selection/sheet_selection_factory.dart';
import 'package:sheets/core/selection/strategies/gesture_selection_builder.dart';
import 'package:sheets/core/selection/strategies/gesture_selection_strategy.dart';
import 'package:sheets/core/selection/types/sheet_range_selection.dart';
import 'package:sheets/core/sheet_index.dart';
import 'package:sheets/core/viewport/viewport_item.dart';
import 'package:sheets/core/worksheet.dart';

abstract class SelectionEvent extends SheetEvent {
  @override
  SelectionAction<SelectionEvent> createAction(Worksheet worksheet);
}

abstract class SelectionAction<T extends SelectionEvent> extends SheetAction<T> {
  SelectionAction(super.event, super.worksheet);
}

// Start Selection
class StartSelectionEvent extends SheetEvent {
  StartSelectionEvent(this.selectionStart);

  final ViewportItem selectionStart;

  @override
  SheetAction<SheetEvent>? createAction(Worksheet worksheet) {
    SheetSelection previousSelection = worksheet.selection.value;
    if (previousSelection == SheetSelectionFactory.single(selectionStart.index)) {
      return null;
    } else {
      return StartSelectionAction(this, worksheet);
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
  StartSelectionAction(super.event, super.worksheet);

  @override
  void execute() {
    if (worksheet.isEditingMode) {
      worksheet.resolve(DisableEditingEvent(save: true));
    }

    SheetIndex? selectedIndex = worksheet.data.fillCellIndex(event.selectionStart.index);

    SheetSelection previousSelection = worksheet.selection.value;

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
    worksheet.selection.update(updatedSelection);

    ensureFullyVisible(selectedIndex);
  }
}

// Update Selection
class UpdateSelectionEvent extends SheetEvent {
  UpdateSelectionEvent(this.selectionEnd);

  final ViewportItem selectionEnd;

  @override
  SheetAction<SheetEvent>? createAction(Worksheet worksheet) {
    if (worksheet.isEditingMode) {
      return null;
    } else {
      return UpdateSelectionAction(this, worksheet);
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
  UpdateSelectionAction(super.event, super.worksheet);

  @override
  void execute() {
    SheetIndex selectedIndex = SelectionOverflowIndexAdapter.adaptToCellIndex(
      event.selectionEnd.index,
      worksheet.viewport.firstVisibleRow,
      worksheet.viewport.firstVisibleColumn,
    );
    selectedIndex = worksheet.data.fillCellIndex(selectedIndex);

    SheetSelection previousSelection = worksheet.selection.value;
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

    worksheet.selection.update(updatedSelection);

    ensureFullyVisible(selectedIndex);
  }
}

// Complete Selection
class CompleteSelectionEvent extends SheetEvent {
  CompleteSelectionEvent();

  @override
  SheetAction<SheetEvent>? createAction(Worksheet worksheet) {
    if (worksheet.selection.value.isCompleted) {
      return null;
    } else {
      return CompleteSelectionAction(this, worksheet);
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
  CompleteSelectionAction(super.event, super.worksheet);

  @override
  void execute() {
    worksheet.selection.complete();
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
  SheetAction<SheetEvent> createAction(Worksheet worksheet) => MoveSelectionAction(this, worksheet);

  @override
  SheetRebuildConfig get rebuildConfig {
    return SheetRebuildConfig(rebuildSelection: true);
  }

  @override
  List<Object?> get props => <Object?>[dx, dy];
}

class MoveSelectionAction extends SheetAction<MoveSelectionEvent> {
  MoveSelectionAction(super.event, super.worksheet);

  @override
  void execute() {
    CellIndex selectedIndex;
    SheetSelection previousSelection = worksheet.selection.value;

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
      columnCount: worksheet.data.columnCount,
      rowCount: worksheet.data.rowCount,
    );
    selectedIndex = worksheet.data.fillCellIndex(selectedIndex);
    selectedIndex = selectedIndex.move(dx: event.dx, dy: event.dy).clamp(maxIndex);
    selectedIndex = worksheet.data.fillCellIndex(selectedIndex);

    SheetSelection updatedSelection = selectionBuilder.build(selectedIndex);

    if (updatedSelection is SheetRangeSelection<CellIndex>) {
      updatedSelection = ensureMergedCellsVisible(updatedSelection);
    }

    worksheet.selection.update(updatedSelection);
    worksheet.selection.complete();

    ensureFullyVisible(selectedIndex);
  }
}
