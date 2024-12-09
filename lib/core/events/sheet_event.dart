import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:sheets/core/events/sheet_rebuild_config.dart';
import 'package:sheets/core/events/sheet_scroll_events.dart';
import 'package:sheets/core/events/sheet_selection_events.dart';
import 'package:sheets/core/selection/selection_corners.dart';
import 'package:sheets/core/selection/types/sheet_range_selection.dart';
import 'package:sheets/core/selection/types/sheet_single_selection.dart';
import 'package:sheets/core/sheet_controller.dart';
import 'package:sheets/core/sheet_index.dart';
import 'package:sheets/core/values/sheet_text_span.dart';
import 'package:sheets/core/viewport/viewport_item.dart';

abstract class SheetEvent with EquatableMixin {
  Duration? get lockdownDuration => null;

  SheetAction<SheetEvent>? createAction(SheetController controller);

  SheetRebuildConfig get rebuildConfig;
}

abstract class SheetAction<T extends SheetEvent> {
  SheetAction(this.event, this.controller);

  final T event;
  final SheetController controller;

  FutureOr<void> execute();

  void ensureFullyVisible(SheetIndex index) {
    if (!controller.isFullyVisible(index)) {
      controller.resolve(ScrollToElementEvent(index));
    }
  }

  SheetRangeSelection<CellIndex> ensureMergedCellsVisible(SheetRangeSelection<CellIndex> selection) {
    SelectionCellCorners corners = selection.cellCorners;
    SelectionCellCorners cornersWithMergedCells = selection.cellCorners.includeMergedCells(controller.data);
    if (corners == cornersWithMergedCells) {
      return selection;
    }

    return SheetRangeSelection<CellIndex>(
      cornersWithMergedCells.topLeft,
      cornersWithMergedCells.bottomRight,
      completed: selection.isCompleted,
      customMainCell: selection.mainCell,
    );
  }
}

// Enable Editing
class EnableEditingEvent extends SheetEvent {
  EnableEditingEvent({this.cell, this.initialValue});

  final CellIndex? cell;
  final String? initialValue;

  @override
  SheetAction<SheetEvent> createAction(SheetController controller) => EnableEditingAction(this, controller);

  @override
  SheetRebuildConfig get rebuildConfig {
    return SheetRebuildConfig(rebuildSelection: true);
  }

  @override
  List<Object?> get props => <Object?>[cell, initialValue];
}

class EnableEditingAction extends SheetAction<EnableEditingEvent> {
  EnableEditingAction(super.event, super.controller);

  @override
  void execute() {
    controller.sheetFocusNode.unfocus();

    CellIndex mainCell = event.cell ?? controller.selection.value.mainCell;
    controller.selection.update(SheetSingleSelection(mainCell, fillHandleVisible: false));

    ensureFullyVisible(mainCell);

    ViewportCell? cell = controller.viewport.visibleContent.findCell(mainCell.toCellIndex());
    if (cell == null) {
      return;
    }

    FocusNode textFieldFocusNode = FocusNode();
    if (event.initialValue != null) {
      ViewportCell updatedCell = cell.withText(event.initialValue!);
      controller.editableCellNotifier.setValue(EditableViewportCell(focusNode: textFieldFocusNode, cell: updatedCell));
    } else {
      ViewportCell updatedCell = cell;
      controller.editableCellNotifier.setValue(EditableViewportCell(focusNode: textFieldFocusNode, cell: updatedCell));
    }
  }
}

// Disable Editing
class DisableEditingEvent extends SheetEvent {
  DisableEditingEvent({this.save = false, this.move = false});

  final bool save;
  final bool move;

  @override
  SheetAction<SheetEvent> createAction(SheetController controller) => DisableEditingAction(this, controller);

  @override
  SheetRebuildConfig get rebuildConfig {
    return SheetRebuildConfig(rebuildData: true);
  }

  @override
  List<Object?> get props => <Object?>[save, move];
}

class DisableEditingAction extends SheetAction<DisableEditingEvent> {
  DisableEditingAction(super.event, super.controller);

  @override
  void execute() {
    if (controller.editableCellNotifier.value != null && event.save) {
      EditableViewportCell editedCell = controller.editableCellNotifier.value!;
      CellIndex index = editedCell.cell.index;

      TextSpan textSpan = editedCell.controller.value.text.toTextSpan();
      controller.data.setText(index, SheetRichText.fromTextSpan(textSpan));
      controller.data.adjustCellHeight(index);
    }
    controller.sheetFocusNode.requestFocus();
    controller.editableCellNotifier.setValue(null);

    if (event.move) {
      controller.resolve(MoveSelectionEvent(0, 1));
    }
  }
}

// Set Viewport Size
class SetViewportSizeEvent extends SheetEvent {
  SetViewportSizeEvent(this.rect);

  final Rect rect;

  @override
  SheetAction<SheetEvent> createAction(SheetController controller) => SetViewportSizeAction(this, controller);

  @override
  SheetRebuildConfig get rebuildConfig {
    return SheetRebuildConfig.all();
  }

  @override
  List<Object?> get props => <Object?>[rect];
}

class SetViewportSizeAction extends SheetAction<SetViewportSizeEvent> {
  SetViewportSizeAction(super.event, super.controller);

  @override
  void execute() {
    controller.viewport.setViewportRect(event.rect);
  }
}
