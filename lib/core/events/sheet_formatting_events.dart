import 'dart:async';

import 'package:sheets/core/events/sheet_event.dart';
import 'package:sheets/core/events/sheet_fill_events.dart';
import 'package:sheets/core/selection/selection_style.dart';
import 'package:sheets/core/selection/types/sheet_range_selection.dart';
import 'package:sheets/core/selection/types/sheet_single_selection.dart';
import 'package:sheets/core/sheet_controller.dart';
import 'package:sheets/core/sheet_index.dart';
import 'package:sheets/utils/formatters/style/cell_style_format.dart';
import 'package:sheets/utils/formatters/style/sheet_style_format.dart';
import 'package:sheets/utils/formatters/style/style_format.dart';
import 'package:sheets/utils/formatters/style/text_style_format.dart';
import 'package:sheets/widgets/text/sheet_text_field.dart';
import 'package:sheets/widgets/text/sheet_text_field_actions.dart';

abstract class SheetFormattingEvent extends SheetEvent {
  @override
  SheetFormattingAction<SheetFormattingEvent> createAction(SheetController controller);
}

abstract class SheetFormattingAction<T extends SheetFormattingEvent> extends SheetAction<T> {
  SheetFormattingAction(super.event, super.controller);
}

// Format Selection
class FormatSelectionEvent extends SheetFormattingEvent {
  FormatSelectionEvent(this.intent);

  final StyleFormatIntent intent;

  @override
  FormatSelectionAction createAction(SheetController controller) => FormatSelectionAction(this, controller);

  @override
  SheetRebuildProperties get rebuildProperties {
    return SheetRebuildProperties(
      rebuildViewport: true,
      rebuildData: true,
    );
  }

  @override
  List<Object?> get props => <Object?>[intent];
}

class FormatSelectionAction extends SheetFormattingAction<FormatSelectionEvent> {
  FormatSelectionAction(super.event, super.controller);

  @override
  void execute() {
    List<CellIndex> selectedCells =
        controller.selection.value.getSelectedCells(controller.data.columnCount, controller.data.rowCount);
    SelectionStyle selectionStyle = controller.getSelectionStyle();

    StyleFormatIntent intent = event.intent;
    if (controller.isEditingMode && intent is TextStyleFormatIntent) {
      SheetTextEditingController editedCellController = controller.editableCellNotifier.value!.controller;
      unawaited(editedCellController.handleAction(SheetTextFieldActions.format(intent)));
      return;
    }

    StyleFormatAction<StyleFormatIntent> formatAction = switch (intent) {
      TextStyleFormatIntent intent => intent.createAction(baseTextStyle: selectionStyle.textStyle),
      CellStyleFormatIntent intent => intent.createAction(cellStyle: selectionStyle.cellStyle),
      SheetStyleFormatIntent intent => intent.createAction(),
      (_) => throw UnimplementedError(),
    };

    controller.data.formatSelection(selectedCells, formatAction);
  }
}

// Resize Column
class ResizeColumnEvent extends SheetFormattingEvent {
  ResizeColumnEvent(this.column, this.width);

  final ColumnIndex column;
  final double width;

  @override
  ResizeColumnAction createAction(SheetController controller) => ResizeColumnAction(this, controller);

  @override
  SheetRebuildProperties get rebuildProperties {
    return SheetRebuildProperties(
      rebuildViewport: true,
      rebuildHorizontalScroll: true,
      rebuildVerticalScroll: true,
      rebuildData: true,
    );
  }

  @override
  List<Object?> get props => <Object?>[column, width];
}

class ResizeColumnAction extends SheetFormattingAction<ResizeColumnEvent> {
  ResizeColumnAction(super.event, super.controller);

  @override
  void execute() {
    controller.data.setColumnWidth(event.column, event.width);
  }
}

// Resize Row
class ResizeRowEvent extends SheetFormattingEvent {
  ResizeRowEvent(this.row, this.height);

  final RowIndex row;
  final double height;

  @override
  ResizeRowAction createAction(SheetController controller) => ResizeRowAction(this, controller);

  @override
  SheetRebuildProperties get rebuildProperties {
    return SheetRebuildProperties(
      rebuildViewport: true,
      rebuildHorizontalScroll: true,
      rebuildVerticalScroll: true,
      rebuildData: true,
    );
  }

  @override
  List<Object?> get props => <Object?>[row, height];
}

class ResizeRowAction extends SheetFormattingAction<ResizeRowEvent> {
  ResizeRowAction(super.event, super.controller);

  @override
  void execute() {
    controller.data.setRowHeight(event.row, event.height);
  }
}

// Merge Selection
class MergeSelectionEvent extends SheetFormattingEvent {
  @override
  MergeSelectionAction createAction(SheetController controller) => MergeSelectionAction(this, controller);

  @override
  SheetRebuildProperties get rebuildProperties {
    return SheetRebuildProperties(
      rebuildViewport: true,
      rebuildData: true,
    );
  }

  @override
  List<Object?> get props => <Object?>[];
}

class MergeSelectionAction extends SheetFormattingAction<MergeSelectionEvent> {
  MergeSelectionAction(super.event, super.controller);

  @override
  void execute() {
    if (controller.selection.value is SheetRangeSelection) {
      List<CellIndex> selectedCells =
          controller.selection.value.getSelectedCells(controller.data.columnCount, controller.data.rowCount);
      controller.selection.update(SheetSingleSelection(controller.selection.value.mainCell));
      controller.data.mergeCells(selectedCells);
    }
  }
}

// Clear Selection
class ClearSelectionEvent extends SheetFormattingEvent {
  @override
  ClearSelectionAction createAction(SheetController controller) => ClearSelectionAction(this, controller);

  @override
  SheetRebuildProperties get rebuildProperties {
    return SheetRebuildProperties(
      rebuildViewport: true,
      rebuildData: true,
    );
  }

  @override
  List<Object?> get props => <Object?>[];
}

class ClearSelectionAction extends SheetFormattingAction<ClearSelectionEvent> {
  ClearSelectionAction(super.event, super.controller);

  @override
  void execute() {
    List<CellIndex> selectedCells =
        controller.selection.value.getSelectedCells(controller.data.columnCount, controller.data.rowCount);
    controller.data.clearCells(selectedCells);
  }
}
