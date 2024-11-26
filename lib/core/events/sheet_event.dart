import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:sheets/core/events/sheet_scroll_events.dart';
import 'package:sheets/core/events/sheet_selection_events.dart';
import 'package:sheets/core/selection/types/sheet_single_selection.dart';
import 'package:sheets/core/sheet_controller.dart';
import 'package:sheets/core/sheet_index.dart';
import 'package:sheets/core/values/sheet_text_span.dart';
import 'package:sheets/core/viewport/viewport_item.dart';

class SheetRebuildProperties {
  SheetRebuildProperties({
    bool rebuildViewport = false,
    bool rebuildData = false,
    bool rebuildSelection = false,
    bool rebuildVerticalScroll = false,
    bool rebuildHorizontalScroll = false,
  }) : _rebuildHorizontalScroll = rebuildHorizontalScroll, _rebuildVerticalScroll = rebuildVerticalScroll, _rebuildSelection = rebuildSelection, _rebuildData = rebuildData, _rebuildViewport = rebuildViewport;

  SheetRebuildProperties.all()
      : _rebuildViewport = true,
        _rebuildData = true,
        _rebuildSelection = true,
        _rebuildVerticalScroll = true,
        _rebuildHorizontalScroll = true;

  final bool _rebuildViewport;
  final bool _rebuildData;
  final bool _rebuildSelection;
  final bool _rebuildVerticalScroll;
  final bool _rebuildHorizontalScroll;

  SheetRebuildProperties combine(SheetRebuildProperties other) {
    return SheetRebuildProperties(
      rebuildViewport: _rebuildViewport || other._rebuildViewport,
      rebuildData: _rebuildData || other._rebuildData,
      rebuildSelection: _rebuildSelection || other._rebuildSelection,
      rebuildVerticalScroll: _rebuildVerticalScroll || other._rebuildVerticalScroll,
      rebuildHorizontalScroll: _rebuildHorizontalScroll || other._rebuildHorizontalScroll,
    );
  }

  bool get rebuildViewport => _rebuildViewport;

  bool get _rebuildScroll => _rebuildVerticalScroll || _rebuildHorizontalScroll;

  bool get rebuildSelection => rebuildViewport || _rebuildSelection || _rebuildScroll;

  bool get rebuildCellsLayer => _rebuildData || _rebuildScroll || _rebuildViewport;

  bool get rebuildFillHandle => rebuildSelection;

  bool get rebuildHorizontalHeaders => _rebuildHorizontalScroll || _rebuildSelection;

  bool get rebuildVerticalHeaders => _rebuildVerticalScroll || _rebuildSelection;

  bool get rebuildHorizontalHeaderResizer => _rebuildHorizontalScroll;

  bool get rebuildVerticalHeaderResizer => _rebuildVerticalScroll;

  @override
  String toString() {
    return 'SheetRebuildProperties(\n\trebuildViewport: $_rebuildViewport,\n\trebuildData: $_rebuildData,\n\trebuildSelection: $_rebuildSelection,\n\trebuildVerticalScroll: $_rebuildVerticalScroll,\n\trebuildHorizontalScroll: $_rebuildHorizontalScroll\n)';
  }
}

abstract class SheetEvent with EquatableMixin {
  Duration? get lockdownDuration => null;

  SheetAction<SheetEvent>? createAction(SheetController controller);

  SheetRebuildProperties get rebuildProperties;
}

abstract class SheetAction<T extends SheetEvent> {
  SheetAction(this.event, this.controller);

  final T event;
  final SheetController controller;

  void execute();

  void ensureFullyVisible(SheetIndex index) {
    if(!controller.isFullyVisible(index)) {
      controller.resolve(ScrollToElementEvent(index));
    }
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
  SheetRebuildProperties get rebuildProperties {
    return SheetRebuildProperties(rebuildSelection: true);
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
  SheetRebuildProperties get rebuildProperties {
    return SheetRebuildProperties(rebuildData: true);
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
  SheetRebuildProperties get rebuildProperties {
    return SheetRebuildProperties.all();
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
