import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:sheets/core/events/sheet_rebuild_config.dart';
import 'package:sheets/core/events/sheet_scroll_events.dart';
import 'package:sheets/core/events/sheet_selection_events.dart';
import 'package:sheets/core/selection/selection_corners.dart';
import 'package:sheets/core/selection/types/sheet_range_selection.dart';
import 'package:sheets/core/selection/types/sheet_single_selection.dart';
import 'package:sheets/core/sheet_index.dart';
import 'package:sheets/core/values/sheet_text_span.dart';
import 'package:sheets/core/viewport/viewport_item.dart';
import 'package:sheets/core/worksheet.dart';

abstract class SheetEvent with EquatableMixin {
  Duration? get lockdownDuration => null;

  SheetAction<SheetEvent>? createAction(Worksheet worksheet);

  SheetRebuildConfig get rebuildConfig;
}

abstract class SheetAction<T extends SheetEvent> {
  SheetAction(this.event, this.worksheet);

  final T event;
  final Worksheet worksheet;

  FutureOr<void> execute();

  void ensureFullyVisible(SheetIndex index) {
    if (!worksheet.isFullyVisible(index)) {
      worksheet.resolve(ScrollToElementEvent(index));
    }
  }

  SheetRangeSelection<CellIndex> ensureMergedCellsVisible(SheetRangeSelection<CellIndex> selection) {
    SelectionCellCorners corners = selection.cellCorners;
    SelectionCellCorners cornersWithMergedCells = selection.cellCorners.includeMergedCells(worksheet.data);
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
  SheetAction<SheetEvent> createAction(Worksheet worksheet) => EnableEditingAction(this, worksheet);

  @override
  SheetRebuildConfig get rebuildConfig {
    return SheetRebuildConfig(rebuildSelection: true);
  }

  @override
  List<Object?> get props => <Object?>[cell, initialValue];
}

class EnableEditingAction extends SheetAction<EnableEditingEvent> {
  EnableEditingAction(super.event, super.worksheet);

  @override
  void execute() {
    worksheet.sheetFocusNode.unfocus();

    CellIndex mainCell = event.cell ?? worksheet.selection.value.mainCell;
    worksheet.selection.update(SheetSingleSelection(mainCell, fillHandleVisible: false));

    ensureFullyVisible(mainCell);

    ViewportCell? cell = worksheet.viewport.visibleContent.findCell(mainCell.toCellIndex());
    if (cell == null) {
      return;
    }

    FocusNode textFieldFocusNode = FocusNode();
    if (event.initialValue != null) {
      ViewportCell updatedCell = cell.withText(event.initialValue!);
      worksheet.editableCellNotifier.setValue(EditableViewportCell(focusNode: textFieldFocusNode, cell: updatedCell));
    } else {
      ViewportCell updatedCell = cell;
      worksheet.editableCellNotifier.setValue(EditableViewportCell(focusNode: textFieldFocusNode, cell: updatedCell));
    }
  }
}

// Disable Editing
class DisableEditingEvent extends SheetEvent {
  DisableEditingEvent({this.save = false, this.move = false});

  final bool save;
  final bool move;

  @override
  SheetAction<SheetEvent> createAction(Worksheet worksheet) => DisableEditingAction(this, worksheet);

  @override
  SheetRebuildConfig get rebuildConfig {
    return SheetRebuildConfig(rebuildData: true);
  }

  @override
  List<Object?> get props => <Object?>[save, move];
}

class DisableEditingAction extends SheetAction<DisableEditingEvent> {
  DisableEditingAction(super.event, super.worksheet);

  @override
  void execute() {
    if (worksheet.editableCellNotifier.value != null && event.save) {
      EditableViewportCell editedCell = worksheet.editableCellNotifier.value!;
      CellIndex index = editedCell.cell.index;

      TextSpan textSpan = editedCell.controller.value.text.toTextSpan();
      worksheet.data.cells.setText(index, SheetRichText.fromTextSpan(textSpan));
      worksheet.data.adjustCellHeight(index);
    }
    worksheet.sheetFocusNode.requestFocus();
    worksheet.editableCellNotifier.setValue(null);

    if (event.move) {
      worksheet.resolve(MoveSelectionEvent(0, 1));
    }
  }
}

// Set Viewport Size
class SetViewportSizeEvent extends SheetEvent {
  SetViewportSizeEvent(this.rect);

  final Rect rect;

  @override
  SheetAction<SheetEvent> createAction(Worksheet worksheet) => SetViewportSizeAction(this, worksheet);

  @override
  SheetRebuildConfig get rebuildConfig {
    return SheetRebuildConfig.all();
  }

  @override
  List<Object?> get props => <Object?>[rect];
}

class SetViewportSizeAction extends SheetAction<SetViewportSizeEvent> {
  SetViewportSizeAction(super.event, super.worksheet);

  @override
  void execute() {
    worksheet.viewport.setViewportRect(event.rect);
    worksheet.scroll.setViewportSize(
      event.rect.size,
      pinnedColumnsWidth: worksheet.data.pinnedColumnsFullWidth,
      pinnedRowsHeight: worksheet.data.pinnedRowsFullHeight,
    );
  }
}

// Set Pinned Columns Count
class SetPinnedColumnsEvent extends SheetEvent {
  SetPinnedColumnsEvent(this.count);

  final int count;

  @override
  SheetAction<SheetEvent> createAction(Worksheet worksheet) =>
      SetPinnedColumnsAction(this, worksheet);

  @override
  SheetRebuildConfig get rebuildConfig {
    return SheetRebuildConfig.all();
  }

  @override
  List<Object?> get props => <Object?>[count];
}

class SetPinnedColumnsAction extends SheetAction<SetPinnedColumnsEvent> {
  SetPinnedColumnsAction(super.event, super.worksheet);

  @override
  void execute() {
    worksheet.data.pinnedColumnCount = event.count;
    worksheet.scroll.setContentSize(worksheet.data.scrollableContentSize);
    worksheet.scroll.setViewportSize(
      worksheet.viewport.rect.size,
      pinnedColumnsWidth: worksheet.data.pinnedColumnsFullWidth,
      pinnedRowsHeight: worksheet.data.pinnedRowsFullHeight,
    );
    worksheet.viewport.rebuild(worksheet.scroll.offset);
  }
}

// Set Pinned Rows Count
class SetPinnedRowsEvent extends SheetEvent {
  SetPinnedRowsEvent(this.count);

  final int count;

  @override
  SheetAction<SheetEvent> createAction(Worksheet worksheet) =>
      SetPinnedRowsAction(this, worksheet);

  @override
  SheetRebuildConfig get rebuildConfig {
    return SheetRebuildConfig.all();
  }

  @override
  List<Object?> get props => <Object?>[count];
}

class SetPinnedRowsAction extends SheetAction<SetPinnedRowsEvent> {
  SetPinnedRowsAction(super.event, super.worksheet);

  @override
  void execute() {
    worksheet.data.pinnedRowCount = event.count;
    worksheet.scroll.setContentSize(worksheet.data.scrollableContentSize);
    worksheet.scroll.setViewportSize(
      worksheet.viewport.rect.size,
      pinnedColumnsWidth: worksheet.data.pinnedColumnsFullWidth,
      pinnedRowsHeight: worksheet.data.pinnedRowsFullHeight,
    );
    worksheet.viewport.rebuild(worksheet.scroll.offset);
  }
}
