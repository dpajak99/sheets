import 'dart:math';

import 'package:flutter/material.dart';
import 'package:sheets/controller/custom_scroll_controller.dart';
import 'package:sheets/controller/index.dart';
import 'package:sheets/controller/program_config.dart';
import 'package:sheets/controller/selection/sheet_range_selection.dart';
import 'package:sheets/controller/selection/sheet_selection.dart';
import 'package:sheets/controller/selection/sheet_single_selection.dart';
import 'package:sheets/controller/sheet_cursor_controller.dart';
import 'package:sheets/controller/sheet_keyboard_controller.dart';
import 'package:sheets/controller/style.dart';
import 'package:sheets/controller/selection.dart';
import 'package:sheets/painters/paint/sheet_paint_config.dart';
import 'package:sheets/painters/sheet_painter_notifier.dart';
import 'package:sheets/sheet_constants.dart';

class SheetController {
  final SheetProperties sheetProperties;
  final SheetScrollController scrollController;

  late final SheetPaintConfig paintConfig;
  late final SheetCursorController cursorController = SheetCursorController(this);
  late final SheetKeyboardController keyboardController = SheetKeyboardController(this);

  late SheetSelection _selection = SheetSingleSelection.defaultSelection(paintConfig: paintConfig);
  set selection(SheetSelection selection) {
    _selection = selection;
    editNotifier.value = null;
  }

  SheetSelection get selection => _selection;


  SheetPainterNotifier selectionPainterNotifier = SheetPainterNotifier();
  ValueNotifier<CellConfig?> editNotifier = ValueNotifier(null);

  SheetController({
    required this.sheetProperties,
    required this.scrollController,
  }) {
    paintConfig = SheetPaintConfig(sheetController: this);
    scrollController.customColumnExtents = sheetProperties.customColumnExtents;
    scrollController.customRowExtents = sheetProperties.customRowExtents;
  }

  void resize(Size size) {
    scrollController.viewportSize = size;
    paintConfig.resize(size);
  }

  void scrollBy(Offset delta) {
    scrollController.scrollBy(delta);
    paintConfig.refresh();
  }

  void resizeColumnBy(ColumnConfig column, double delta) {
    ColumnStyle columnStyle = sheetProperties.getColumnStyle(column.columnIndex);
    sheetProperties.setColumnStyle(
      column.columnIndex,
      columnStyle.copyWith(width: max(10, columnStyle.width + delta)),
    );
    scrollController.customColumnExtents = sheetProperties.customColumnExtents;
    paintConfig.refresh();
  }

  void resizeRowBy(RowConfig row, double delta) {
    RowStyle rowStyle = sheetProperties.getRowStyle(row.rowIndex);
    sheetProperties.setRowStyle(
      row.rowIndex,
      rowStyle.copyWith(height: max(10, rowStyle.height + delta)),
    );
    scrollController.customRowExtents = sheetProperties.customRowExtents;
    paintConfig.refresh();
  }

  void selectSingle(CellIndex cellIndex, {bool editingEnabled = false}) {
    selection = SheetSingleSelection(paintConfig: paintConfig, cellIndex: cellIndex, editingEnabled: editingEnabled);
    selectionPainterNotifier.repaint();
  }

  void selectRange({CellIndex? start, required CellIndex end, bool completed = true}) {
    CellIndex computedStart = start ?? selection.start;
    if (computedStart == end) {
      selectSingle(computedStart);
    } else {
      selection = SheetRangeSelection(paintConfig: paintConfig, start: computedStart, end: end, completed: completed);
      selectionPainterNotifier.repaint();
    }
  }

  void completeSelection() {
    selection = selection.complete();
    selectionPainterNotifier.repaint();
  }

  void selectAll() {
    selectRange(
      start: CellIndex(rowIndex: RowIndex(0), columnIndex: ColumnIndex(0)),
      end: CellIndex(rowIndex: RowIndex(defaultRowCount), columnIndex: ColumnIndex(defaultColumnCount)),
    );
  }

  void edit(CellConfig cellConfig) {
    selectSingle(cellConfig.cellIndex, editingEnabled: true);
    editNotifier.value = cellConfig;
  }

  void cancelEdit() {
    editNotifier.value = null;
  }

  SheetItemConfig? getHoveredElement(Offset mousePosition) {
    try {
      SheetItemConfig sheetItemConfig = paintConfig.visibleItems.firstWhere(
        (element) => element.rect.contains(mousePosition),
      );
      return sheetItemConfig;
    } catch (e) {
      return null;
    }
  }
}
