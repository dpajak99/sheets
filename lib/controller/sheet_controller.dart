import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sheets/controller/index.dart';
import 'package:sheets/controller/program_config.dart';
import 'package:sheets/controller/selection/gestures/sheet_drag_gesture.dart';
import 'package:sheets/controller/selection/gestures/sheet_gesture.dart';
import 'package:sheets/controller/selection/gestures/sheet_scroll_gesture.dart';
import 'package:sheets/controller/selection/gestures/sheet_tap_gesture.dart';
import 'package:sheets/controller/selection/sheet_selection_controller.dart';
import 'package:sheets/controller/sheet_cursor_controller.dart';
import 'package:sheets/controller/sheet_keyboard_controller.dart';
import 'package:sheets/controller/sheet_scroll_controller.dart';
import 'package:sheets/controller/sheet_visibility_controller.dart';
import 'package:sheets/controller/style.dart';
import 'package:sheets/utils/extensions/offset_extension.dart';

class SheetControllerOld {
  final SheetProperties sheetProperties;
  final SheetScrollController scrollController;

  late final SheetVisibilityController paintConfig;
  late final SheetKeyboardController keyboardController = SheetKeyboardController();
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

  void edit(CellConfig cellConfig) {
    selectionController.selectSingle(cellConfig.index, editingEnabled: true);
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

  final SheetScrollController scrollController = SheetScrollController();
  late final SheetVisibilityController visibilityController = SheetVisibilityController(
    sheetProperties: sheetProperties,
    scrollController: scrollController,
  );
  late final SheetSelectionController selectionController = SheetSelectionController(visibilityController);
  late final SheetCursorController mouse = SheetCursorController();
  late final SheetKeyboardController keyboard = SheetKeyboardController();

  SheetController() {
    scrollController.customColumnExtents = sheetProperties.customColumnExtents;
    scrollController.customRowExtents = sheetProperties.customRowExtents;

    mouse.stream.listen(_handleGesture);
  }

  void onMouseOffsetChanged(Offset offset) {
    mouse.updateOffset(offset, visibilityController.findHoveredElement(offset));
  }

  void setCursor(SystemMouseCursor cursor) {
    mouse.setCursor(cursor);
  }

  void resizeColumnBy(ColumnConfig column, double delta) {
    ColumnStyle columnStyle = sheetProperties.getColumnStyle(column.columnIndex);
    sheetProperties.setColumnStyle(
      column.columnIndex,
      columnStyle.copyWith(width: max(10, columnStyle.width + delta)),
    );
    scrollController.customColumnExtents = sheetProperties.customColumnExtents;
    visibilityController.refresh();
  }

  void resizeRowBy(RowConfig row, double delta) {
    RowStyle rowStyle = sheetProperties.getRowStyle(row.rowIndex);
    sheetProperties.setRowStyle(
      row.rowIndex,
      rowStyle.copyWith(height: max(10, rowStyle.height + delta)),
    );
    scrollController.customRowExtents = sheetProperties.customRowExtents;
    visibilityController.refresh();
  }

  void _handleGesture(SheetGesture gesture) {
    return switch (gesture) {
      SheetTapGesture tapGesture => _handleTap(tapGesture),
      SheetDoubleTapGesture doubleTapGesture => _handleDoubleTap(doubleTapGesture),
      SheetDragStartGesture dragStartGesture => _handleDragStart(dragStartGesture),
      SheetDragUpdateGesture dragUpdateGesture => _handleDragUpdate(dragUpdateGesture),
      SheetDragEndGesture dragEndGesture => _handleDragEnd(dragEndGesture),
      SheetScrollGesture scrollGesture => _handleScroll(scrollGesture),
      (_) => () {},
    };
  }

  void _handleTap(SheetTapGesture tapGesture) {
    if (keyboard.isKeyPressed(LogicalKeyboardKey.shiftLeft)) {
      CellIndex selectionStart = selectionController.selection.start;
      return switch (tapGesture.details.hoveredItem) {
        CellConfig cell => selectionController.selectRange(start: selectionStart, end: cell.index, completed: true),
        ColumnConfig column => selectionController.selectColumnRange(start: selectionStart.columnIndex, end: column.columnIndex),
        RowConfig row => selectionController.selectRowRange(start: selectionStart.rowIndex, end: row.rowIndex),
        (_) => () {},
      };
    } else {
      return switch (tapGesture.details.hoveredItem) {
        CellConfig cell => selectionController.selectSingle(cell.index),
        ColumnConfig column => selectionController.selectColumn(column.columnIndex),
        RowConfig row => selectionController.selectRow(row.rowIndex),
        (_) => () {},
      };
    }
  }

  void _handleDoubleTap(SheetDoubleTapGesture doubleTapGesture) {}

  void _handleDragStart(SheetDragStartGesture dragStartGesture) {}

  void _handleDragUpdate(SheetDragUpdateGesture dragUpdateGesture) {
    switch (dragUpdateGesture.startDetails.hoveredItem) {
      case CellConfig _:
        return _handleCellDragUpdate(dragUpdateGesture);
      case ColumnConfig _:
        return _handleColumnDragUpdate(dragUpdateGesture);
      case RowConfig _:
        return _handleRowDragUpdate(dragUpdateGesture);
      default:
        return;
    }
  }

  void _handleCellDragUpdate(SheetDragUpdateGesture dragUpdateGesture) {
    CellIndex start = (dragUpdateGesture.startDetails.hoveredItem! as CellConfig).index;
    return switch (dragUpdateGesture.details.hoveredItem) {
      CellConfig endCell => selectionController.selectRange(start: start, end: endCell.index),
      (_) => () {},
    };
  }

  void _handleColumnDragUpdate(SheetDragUpdateGesture dragUpdateGesture) {
    ColumnIndex start = (dragUpdateGesture.startDetails.hoveredItem! as ColumnConfig).columnIndex;
    late ColumnIndex end;

    switch (dragUpdateGesture.details.hoveredItem) {
      case CellConfig cellConfig:
        end = cellConfig.index.columnIndex;
        break;
      case ColumnConfig columnConfig:
        end = columnConfig.columnIndex;
        break;
      default:
        return;
    }

    selectionController.selectColumnRange(start: start, end: end);
  }

  void _handleRowDragUpdate(SheetDragUpdateGesture dragUpdateGesture) {
    RowIndex start = (dragUpdateGesture.startDetails.hoveredItem! as RowConfig).rowIndex;
    late RowIndex end;

    switch (dragUpdateGesture.details.hoveredItem) {
      case CellConfig cellConfig:
        end = cellConfig.index.rowIndex;
        break;
      case RowConfig rowConfig:
        end = rowConfig.rowIndex;
        break;
      default:
        return;
    }

    selectionController.selectRowRange(start: start, end: end);
  }

  void _handleDragEnd(SheetDragEndGesture dragEndGesture) {
    selectionController.completeSelection();
  }

  void _handleScroll(SheetScrollGesture scrollGesture) {
    if (keyboard.isKeyPressed(LogicalKeyboardKey.shiftLeft)) {
      scrollController.scrollBy(scrollGesture.delta.reverse());
    } else {
      scrollController.scrollBy(scrollGesture.delta);
    }
  }
}
