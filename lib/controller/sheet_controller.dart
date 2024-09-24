import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sheets/controller/program_config.dart';
import 'package:sheets/controller/selection/sheet_selection_controller.dart';
import 'package:sheets/controller/sheet_cursor_controller.dart';
import 'package:sheets/controller/sheet_keyboard_controller.dart';
import 'package:sheets/controller/sheet_scroll_controller.dart';
import 'package:sheets/controller/sheet_visibility_controller.dart';
import 'package:sheets/controller/style.dart';

class SheetControllerOld {
  final SheetProperties sheetProperties;
  final SheetScrollController scrollController;

  late final SheetVisibilityController paintConfig;
  late final SheetCursorController cursorController = SheetCursorController(this);
  late final SheetKeyboardController keyboardController = SheetKeyboardController(this);
  late final SheetSelectionController selectionController = SheetSelectionController(paintConfig);

  ValueNotifier<CellConfig?> editNotifier = ValueNotifier(null);

  SheetControllerOld({
    required this.sheetProperties,
    required this.scrollController,
  }) {
    paintConfig = SheetVisibilityController(scrollController: scrollController, sheetProperties: sheetProperties);
    scrollController.customColumnExtents = sheetProperties.customColumnExtents;
    scrollController.customRowExtents = sheetProperties.customRowExtents;
    selectionController.addListener(cancelEdit);
  }

  void resize(Size size) {
    scrollController.viewportSize = size;
  }

  void scrollBy(Offset delta) {
    scrollController.scrollBy(delta);
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
}

class SheetController {
  final SheetProperties sheetProperties = SheetProperties(
    customColumnProperties: {
      // ColumnIndex(3): ColumnStyle(width: 200),
    },
    customRowProperties: {
      // RowIndex(8): RowStyle(height: 100),
    },
  );

  final ValueNotifier<SystemMouseCursor> cursor = ValueNotifier(SystemMouseCursors.basic);
  final ValueNotifier<SheetItemConfig?> hoveredItem = ValueNotifier(null);
  final ValueNotifier<Offset> mousePosition = ValueNotifier(Offset.zero);

  final SheetScrollController scrollController = SheetScrollController();
  late final SheetVisibilityController visibilityController = SheetVisibilityController(
    sheetProperties: sheetProperties,
    scrollController: scrollController,
  );
  late final SheetSelectionController selectionController = SheetSelectionController(visibilityController);

  SheetController() {
    scrollController.customColumnExtents = sheetProperties.customColumnExtents;
    scrollController.customRowExtents = sheetProperties.customRowExtents;
  }
}
