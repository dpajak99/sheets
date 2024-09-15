import 'dart:math';

import 'package:flutter/material.dart';
import 'package:sheets/controller/custom_scroll_controller.dart';
import 'package:sheets/controller/program_config.dart';
import 'package:sheets/controller/selection/sheet_selection_controller.dart';
import 'package:sheets/controller/sheet_cursor_controller.dart';
import 'package:sheets/controller/sheet_keyboard_controller.dart';
import 'package:sheets/controller/style.dart';
import 'package:sheets/painters/paint/sheet_paint_config.dart';

class SheetController {
  final SheetProperties sheetProperties;
  final SheetScrollController scrollController;

  late final SheetPaintConfig paintConfig;
  late final SheetCursorController cursorController = SheetCursorController(this);
  late final SheetKeyboardController keyboardController = SheetKeyboardController(this);
  late final SheetSelectionController selectionController = SheetSelectionController(paintConfig);

  ValueNotifier<CellConfig?> editNotifier = ValueNotifier(null);

  SheetController({
    required this.sheetProperties,
    required this.scrollController,
  }) {
    paintConfig = SheetPaintConfig(sheetController: this);
    scrollController.customColumnExtents = sheetProperties.customColumnExtents;
    scrollController.customRowExtents = sheetProperties.customRowExtents;
    selectionController.addListener(cancelEdit);
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


  void edit(CellConfig cellConfig) {
    selectionController.selectSingle(cellConfig.cellIndex, editingEnabled: true);
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
