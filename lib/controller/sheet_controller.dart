import 'dart:math';

import 'package:flutter/services.dart';
import 'package:sheets/gestures/sheet_drag_gesture.dart';
import 'package:sheets/gestures/sheet_fill_gesture.dart';
import 'package:sheets/gestures/sheet_gesture.dart';
import 'package:sheets/gestures/sheet_scroll_gesture.dart';
import 'package:sheets/gestures/sheet_tap_gesture.dart';
import 'package:sheets/models/sheet_item_index.dart';
import 'package:sheets/models/sheet_item_config.dart';
import 'package:sheets/controller/selection/sheet_selection_controller.dart';
import 'package:sheets/controller/selection/types/sheet_fill_selection.dart';
import 'package:sheets/controller/selection/types/sheet_selection.dart';
import 'package:sheets/models/sheet_properties.dart';
import 'package:sheets/controller/sheet_scroll_controller.dart';
import 'package:sheets/models/sheet_viewport_delegate.dart';
import 'package:sheets/listeners/keyboard_listener.dart';
import 'package:sheets/listeners/mouse_listener.dart';
import 'package:sheets/recognizers/selection_fill_recognizer.dart';
import 'package:sheets/utils/extensions/offset_extension.dart';

class SheetController {
  final SheetProperties sheetProperties = SheetProperties(
    customColumnStyles: {
      // ColumnIndex(3): ColumnStyle(width: 200),
    },
    customRowStyles: {
      // RowIndex(8): RowStyle(height: 100),
    },
  );

  final SheetScrollController scrollController = SheetScrollController();
  late final SheetViewportDelegate viewport = SheetViewportBaseDelegate(
    sheetProperties: sheetProperties,
    scrollController: scrollController,
  );
  late final SheetSelectionController selectionController = SheetSelectionController(viewport);
  late final SheetMouseListener mouse = SheetMouseListener();
  late final SheetKeyboardListener keyboard = SheetKeyboardListener();

  SheetController() {
    scrollController.customColumnExtents = sheetProperties.customColumnExtents;
    scrollController.customRowExtents = sheetProperties.customRowExtents;

    mouse.stream.listen(_handleGesture);
  }

  void onMouseOffsetChanged(Offset offset) {
    mouse.updateOffset(offset, viewport.findByOffset(offset));
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
  }

  void resizeRowBy(RowConfig row, double delta) {
    RowStyle rowStyle = sheetProperties.getRowStyle(row.rowIndex);
    sheetProperties.setRowStyle(
      row.rowIndex,
      rowStyle.copyWith(height: max(10, rowStyle.height + delta)),
    );
    scrollController.customRowExtents = sheetProperties.customRowExtents;
  }

  void _handleGesture(SheetGesture gesture) {
    return switch (gesture) {
      SheetTapGesture tapGesture => _handleTap(tapGesture),
      SheetDoubleTapGesture doubleTapGesture => _handleDoubleTap(doubleTapGesture),
      SheetDragStartGesture dragStartGesture => _handleDragStart(dragStartGesture),
      SheetDragUpdateGesture dragUpdateGesture => _handleDragUpdate(dragUpdateGesture),
      SheetDragEndGesture dragEndGesture => _handleDragEnd(dragEndGesture),
      SheetFillStartGesture fillStartGesture => _handleFillStart(fillStartGesture),
      SheetFillUpdateGesture fillUpdateGesture => _handleFillUpdate(fillUpdateGesture),
      SheetFillEndGesture fillEndGesture => _handleFillEnd(fillEndGesture),
      SheetScrollGesture scrollGesture => _handleScroll(scrollGesture),
      (_) => print('Unhandled gesture: $gesture'),
    };
  }

  void _handleTap(SheetTapGesture tapGesture) {
    if (keyboard.areKeysPressed([LogicalKeyboardKey.controlLeft, LogicalKeyboardKey.shiftLeft])) {
      CellIndex selectionStart = selectionController.selection.end;
      SheetSelection? sheetSelection = switch (tapGesture.details.hoveredItem) {
        CellConfig cell => selectionController.getRangeSelection(start: selectionStart, end: cell.index, completed: true),
        ColumnConfig column => selectionController.getColumnRangeSelection(start: selectionStart.columnIndex, end: column.columnIndex),
        RowConfig row => selectionController.getRowRangeSelection(start: selectionStart.rowIndex, end: row.rowIndex),
        (_) => null,
      };

      if (sheetSelection != null) {
        selectionController.selectMultiple(
          <CellIndex>[...selectionController.selection.selectedCells, ...sheetSelection.selectedCells],
          endCell: sheetSelection.end,
        );
      }
      return;
    }

    if (keyboard.isKeyPressed(LogicalKeyboardKey.controlLeft)) {
      return switch (tapGesture.details.hoveredItem) {
        CellConfig cell => selectionController.toggleCell(cell.index),
        ColumnConfig column => selectionController.toggleColumn(column.columnIndex),
        RowConfig row => selectionController.toggleRow(row.rowIndex),
        (_) => () {},
      };
    }

    if (keyboard.isKeyPressed(LogicalKeyboardKey.shiftLeft)) {
      CellIndex selectionStart = selectionController.selection.start;
      return switch (tapGesture.details.hoveredItem) {
        CellConfig cell => selectionController.selectRange(start: selectionStart, end: cell.index, completed: true),
        ColumnConfig column => selectionController.selectColumnRange(start: selectionStart.columnIndex, end: column.columnIndex),
        RowConfig row => selectionController.selectRowRange(start: selectionStart.rowIndex, end: row.rowIndex),
        (_) => () {},
      };
    }

    return switch (tapGesture.details.hoveredItem) {
      CellConfig cell => selectionController.selectSingle(cell.index),
      ColumnConfig column => selectionController.selectColumn(column.columnIndex),
      RowConfig row => selectionController.selectRow(row.rowIndex),
      (_) => () {},
    };
  }

  void _handleDoubleTap(SheetDoubleTapGesture doubleTapGesture) {
    if (keyboard.isKeyPressed(LogicalKeyboardKey.controlLeft)) {
      _handleTap(doubleTapGesture.toSingleTap());
    }
  }

  SheetSelection? previousSelection;

  void _handleDragStart(SheetDragStartGesture dragStartGesture) {
    previousSelection = selectionController.selection;
  }

  void _handleDragUpdate(SheetDragUpdateGesture dragUpdateGesture) {
    if (previousSelection == null) return;

    SheetSelection? sheetSelection = switch (dragUpdateGesture.startDetails.hoveredItem) {
      CellConfig _ => _handleCellDragUpdate(dragUpdateGesture),
      ColumnConfig _ => _handleColumnDragUpdate(dragUpdateGesture),
      RowConfig _ => _handleRowDragUpdate(dragUpdateGesture),
      _ => null,
    };

    if (sheetSelection != null) {
      if (keyboard.isKeyPressed(LogicalKeyboardKey.controlLeft)) {
        selectionController.selectMultiple(<CellIndex>[...previousSelection!.selectedCells, ...sheetSelection.selectedCells]);
      } else {
        selectionController.custom(sheetSelection);
      }
    }
  }

  SheetSelection? _handleCellDragUpdate(SheetDragUpdateGesture dragUpdateGesture) {
    CellIndex start = (dragUpdateGesture.startDetails.hoveredItem! as CellConfig).index;

    return switch (dragUpdateGesture.endDetails.hoveredItem) {
      CellConfig endCell => selectionController.getRangeSelection(start: start, end: endCell.index),
      (_) => null,
    };
  }

  SheetSelection? _handleColumnDragUpdate(SheetDragUpdateGesture dragUpdateGesture) {
    ColumnIndex start = (dragUpdateGesture.startDetails.hoveredItem! as ColumnConfig).columnIndex;
    late ColumnIndex end;

    switch (dragUpdateGesture.endDetails.hoveredItem) {
      case CellConfig cellConfig:
        end = cellConfig.index.columnIndex;
        break;
      case ColumnConfig columnConfig:
        end = columnConfig.columnIndex;
        break;
      default:
        return null;
    }

    return selectionController.getColumnRangeSelection(start: start, end: end);
  }

  SheetSelection? _handleRowDragUpdate(SheetDragUpdateGesture dragUpdateGesture) {
    RowIndex start = (dragUpdateGesture.startDetails.hoveredItem! as RowConfig).rowIndex;
    late RowIndex end;

    switch (dragUpdateGesture.endDetails.hoveredItem) {
      case CellConfig cellConfig:
        end = cellConfig.index.rowIndex;
        break;
      case RowConfig rowConfig:
        end = rowConfig.rowIndex;
        break;
      default:
        return null;
    }

    return selectionController.getRowRangeSelection(start: start, end: end);
  }

  void _handleDragEnd(SheetDragEndGesture dragEndGesture) {
    selectionController.completeSelection();
    previousSelection = null;
  }

  bool _fillingInProgress = false;

  void _handleFillStart(SheetFillStartGesture fillStartGesture) {
    _fillingInProgress = true;
  }

  void _handleFillUpdate(SheetFillUpdateGesture fillUpdateGesture) {
    if (_fillingInProgress == false) return;
    if (mouse.hoveredItem.value == null) return;
    SheetSelection sheetSelection = (selectionController.selection is SheetFillSelection)
        ? (selectionController.selection as SheetFillSelection).baseSelection
        : selectionController.selection;
    SelectionFillRecognizer.from(sheetSelection, this).handle(mouse.hoveredItem.value!);
  }

  void _handleFillEnd(SheetFillEndGesture fillEndGesture) {
    _fillingInProgress = false;
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
