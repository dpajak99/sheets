import 'dart:async';

import 'package:sheets/core/cell_properties.dart';
import 'package:sheets/core/events/sheet_event.dart';
import 'package:sheets/core/events/sheet_rebuild_config.dart';
import 'package:sheets/core/selection/selection_corners.dart';
import 'package:sheets/core/selection/selection_style.dart';
import 'package:sheets/core/selection/sheet_selection.dart';
import 'package:sheets/core/selection/sheet_selection_factory.dart';
import 'package:sheets/core/selection/types/sheet_range_selection.dart';
import 'package:sheets/core/selection/types/sheet_single_selection.dart';
import 'package:sheets/core/sheet_index.dart';
import 'package:sheets/core/worksheet.dart';
import 'package:sheets/utils/formatters/style/cell_style_format.dart';
import 'package:sheets/utils/formatters/style/sheet_style_format.dart';
import 'package:sheets/utils/formatters/style/style_format.dart';
import 'package:sheets/utils/formatters/style/text_style_format.dart';
import 'package:sheets/widgets/text/sheet_text_field.dart';
import 'package:sheets/widgets/text/sheet_text_field_actions.dart';

abstract class SheetFormattingEvent extends SheetEvent {
  @override
  SheetFormattingAction<SheetFormattingEvent> createAction(Worksheet worksheet);
}

abstract class SheetFormattingAction<T extends SheetFormattingEvent> extends SheetAction<T> {
  SheetFormattingAction(super.event, super.worksheet);
}

// Format Selection
class FormatSelectionEvent extends SheetFormattingEvent {
  FormatSelectionEvent(this.intent);

  final StyleFormatIntent intent;

  @override
  FormatSelectionAction createAction(Worksheet worksheet) => FormatSelectionAction(this, worksheet);

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
  FormatSelectionAction(super.event, super.worksheet);

  @override
  void execute() {
    List<CellIndex> selectedCells = worksheet.selection.value.getSelectedCells(worksheet.data.columnCount, worksheet.data.rowCount);
    SelectionStyle selectionStyle = worksheet.getSelectionStyle();

    StyleFormatIntent intent = event.intent;
    if (worksheet.isEditingMode && intent is TextStyleFormatIntent) {
      SheetTextEditingController editedCellController = worksheet.editableCellNotifier.value!.controller;
      unawaited(editedCellController.handleAction(SheetTextFieldActions.format(intent)));
      return;
    }

    StyleFormatAction<StyleFormatIntent> formatAction = switch (intent) {
      TextStyleFormatIntent intent => intent.createAction(baseTextStyle: selectionStyle.textStyle),
      CellStyleFormatIntent intent => intent.createAction(cellStyle: selectionStyle.cellStyle),
      SheetStyleFormatIntent intent => intent.createAction(),
      (_) => throw UnimplementedError(),
    };

    worksheet.data.formatSelection(selectedCells, formatAction);
  }
}

// Resize Column
class ResizeColumnEvent extends SheetFormattingEvent {
  ResizeColumnEvent(this.column, this.width);

  final ColumnIndex column;
  final double width;

  @override
  ResizeColumnAction createAction(Worksheet worksheet) => ResizeColumnAction(this, worksheet);

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
  ResizeColumnAction(super.event, super.worksheet);

  @override
  void execute() {
    worksheet.data.columns.setWidth(event.column, event.width);
  }
}

// Resize Row
class ResizeRowEvent extends SheetFormattingEvent {
  ResizeRowEvent(this.row, this.height);

  final RowIndex row;
  final double height;

  @override
  ResizeRowAction createAction(Worksheet worksheet) => ResizeRowAction(this, worksheet);

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
  ResizeRowAction(super.event, super.worksheet);

  @override
  void execute() {
    worksheet.data.rows.setHeight(event.row, event.height);
  }
}

// Merge Selection
class MergeSelectionEvent extends SheetFormattingEvent {
  @override
  MergeSelectionAction createAction(Worksheet worksheet) => MergeSelectionAction(this, worksheet);

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
  MergeSelectionAction(super.event, super.worksheet);

  @override
  void execute() {
    SheetSelection selection = worksheet.selection.value;
    if (selection is SheetRangeSelection) {
      List<CellIndex> selectedCells = selection.getSelectedCells(worksheet.data.columnCount, worksheet.data.rowCount);
      worksheet.selection.update(SheetSingleSelection(MergedCellIndex(start: selectedCells.first, end: selectedCells.last)));
      worksheet.data.cells.merge(selectedCells);
    } else if (selection is SheetSingleSelection) {
      CellProperties cellProperties = worksheet.data.cells.get(selection.mainCell);
      CellMergeStatus mergeStatus = cellProperties.mergeStatus;
      if (mergeStatus is MergedCell) {
        List<CellIndex> mergedCells = mergeStatus.mergedCells;
        worksheet.data.cells.unmergeAll(mergedCells);
        worksheet.selection.update(SheetSelectionFactory.range(start: mergeStatus.start, end: mergeStatus.end, completed: true));
      }
    }
  }
}

// Unmerge Selection
class UnmergeSelectionEvent extends SheetFormattingEvent {
  @override
  UnmergeSelectionAction createAction(Worksheet worksheet) => UnmergeSelectionAction(this, worksheet);

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
  UnmergeSelectionAction(super.event, super.worksheet);

  @override
  void execute() {
    SheetSelection selection = worksheet.selection.value;
    SelectionCellCorners? corners = selection.cellCorners?.includeMergedCells(worksheet.data);

    List<CellIndex> selectedCells = selection.getSelectedCells(worksheet.data.columnCount, worksheet.data.rowCount);
    selectedCells.forEach(worksheet.data.cells.unmerge);

    if (corners != null) {
      worksheet.selection.update(SheetSelectionFactory.range(start: corners.topLeft, end: corners.bottomRight, completed: true));
    }
  }
}

// Clear Selection
class ClearSelectionEvent extends SheetFormattingEvent {
  @override
  ClearSelectionAction createAction(Worksheet worksheet) => ClearSelectionAction(this, worksheet);

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
  ClearSelectionAction(super.event, super.worksheet);

  @override
  void execute() {
    List<CellIndex> selectedCells = worksheet.selection.value.getSelectedCells(worksheet.data.columnCount, worksheet.data.rowCount);
    worksheet.data.cells.clearAll(selectedCells);
  }
}
