import 'dart:async';

import 'package:sheets/core/data/worksheet.dart';
import 'package:sheets/core/data/worksheet_event.dart';
import 'package:sheets/core/events/sheet_event.dart';
import 'package:sheets/core/events/sheet_rebuild_config.dart';
import 'package:sheets/core/selection/selection_corners.dart';
import 'package:sheets/core/selection/selection_style.dart';
import 'package:sheets/core/selection/sheet_selection.dart';
import 'package:sheets/core/selection/sheet_selection_factory.dart';
import 'package:sheets/core/selection/types/sheet_range_selection.dart';
import 'package:sheets/core/selection/types/sheet_single_selection.dart';
import 'package:sheets/core/sheet_controller.dart';
import 'package:sheets/core/sheet_index.dart';
import 'package:sheets/utils/formatters/style/cell_style_format.dart';
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
  SheetRebuildConfig get rebuildConfig {
    return SheetRebuildConfig(
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
        controller.selection.value.getSelectedCells(controller.worksheet.cols, controller.worksheet.rows);
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
      // SheetStyleFormatIntent intent => intent.createAction(),
      (_) => throw UnimplementedError(),
    };

    controller.worksheet.dispatchEvent(FormatSelectionWorksheetEvent(selectedCells, formatAction));
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
  SheetRebuildConfig get rebuildConfig {
    return SheetRebuildConfig(
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
    controller.worksheet.dispatchEvent(SetColumnWidthWorksheetEvent(event.column, event.width));
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
  SheetRebuildConfig get rebuildConfig {
    return SheetRebuildConfig(
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
    controller.worksheet.dispatchEvent(SetRowHeightWorksheetEvent(event.row, event.height));
  }
}

// Merge Selection
class MergeSelectionEvent extends SheetFormattingEvent {
  @override
  MergeSelectionAction createAction(SheetController controller) => MergeSelectionAction(this, controller);

  @override
  SheetRebuildConfig get rebuildConfig {
    return SheetRebuildConfig(
      rebuildSelection: true,
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
    SheetSelection selection = controller.selection.value;
    if (selection is SheetRangeSelection) {
      List<CellIndex> selectedCells = selection.getSelectedCells(controller.worksheet.cols, controller.worksheet.rows);
      controller.selection.update(SheetSingleSelection(MergedCellIndex(start: selectedCells.first, end: selectedCells.last)));
      controller.worksheet.dispatchEvent(MergeCellsWorksheetEvent(cells: selectedCells));
    } else if (selection is SheetSingleSelection) {
      CellProperties cellProperties = controller.worksheet.getCell(selection.mainCell);
      CellMergeStatus mergeStatus = cellProperties.mergeStatus;
      if (mergeStatus.isMerged) {
        List<CellIndex> mergedCells = mergeStatus.mergedCells;
        controller.worksheet.dispatchEvent(UnmergeCellsWorksheetEvent(mergedCells));
        controller.selection.update(SheetSelectionFactory.range(
          start: mergeStatus.start!,
          end: mergeStatus.end!,
          completed: true,
        ));
      }
    }
  }
}

// Unmerge Selection
class UnmergeSelectionEvent extends SheetFormattingEvent {
  @override
  UnmergeSelectionAction createAction(SheetController controller) => UnmergeSelectionAction(this, controller);

  @override
  SheetRebuildConfig get rebuildConfig {
    return SheetRebuildConfig(
      rebuildSelection: true,
      rebuildData: true,
    );
  }

  @override
  List<Object?> get props => <Object?>[];
}

class UnmergeSelectionAction extends SheetFormattingAction<UnmergeSelectionEvent> {
  UnmergeSelectionAction(super.event, super.controller);

  @override
  void execute() {
    SheetSelection selection = controller.selection.value;
    SelectionCellCorners? corners = selection.cellCorners?.includeMergedCells(controller.worksheet);

    List<CellIndex> selectedCells = selection.getSelectedCells(controller.worksheet.cols, controller.worksheet.rows);
    for (CellIndex cellIndex in selectedCells) {
      controller.worksheet.dispatchEvent(UnmergeCellsWorksheetEvent.single(cellIndex));
    }

    if (corners != null) {
      controller.selection.update(SheetSelectionFactory.range(start: corners.topLeft, end: corners.bottomRight, completed: true));
    }
  }
}

// Clear Selection
class ClearSelectionEvent extends SheetFormattingEvent {
  @override
  ClearSelectionAction createAction(SheetController controller) => ClearSelectionAction(this, controller);

  @override
  SheetRebuildConfig get rebuildConfig {
    return SheetRebuildConfig(
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
        controller.selection.value.getSelectedCells(controller.worksheet.cols, controller.worksheet.rows);
    controller.worksheet.dispatchEvent(ClearCellsWorksheetEvent(selectedCells));
  }
}
