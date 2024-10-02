import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:sheets/config/sheet_constants.dart';
import 'package:sheets/core/sheet_item_index.dart';
import 'package:sheets/gestures/sheet_drag_gesture.dart';
import 'package:sheets/gestures/sheet_fill_gesture.dart';
import 'package:sheets/gestures/sheet_gesture.dart';
import 'package:sheets/core/sheet_properties.dart';
import 'package:sheets/controller/sheet_scroll_controller.dart';
import 'package:sheets/core/sheet_viewport_delegate.dart';
import 'package:sheets/gestures/sheet_resize_gestures.dart';
import 'package:sheets/gestures/sheet_selection_gesture.dart';
import 'package:sheets/gestures/sheet_tap_gesture.dart';
import 'package:sheets/listeners/keyboard_listener.dart';
import 'package:sheets/listeners/mouse_listener.dart';
import 'package:sheets/selection/selection_utils.dart';
import 'package:sheets/selection/types/sheet_multi_selection.dart';
import 'package:sheets/selection/types/sheet_selection.dart';
import 'package:sheets/selection/types/sheet_single_selection.dart';

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
  late final SheetMouseListener mouse = SheetMouseListener();
  late final SheetKeyboardListener keyboard = SheetKeyboardListener();

  late ValueNotifier<SheetSelection> selectionNotifier = ValueNotifier<SheetSelection>(SheetSingleSelection.defaultSelection());

  SheetSelection get selection => selectionNotifier.value;

  final StreamController<SheetGesture> _gesturesStream = StreamController<SheetGesture>();

  Stream<SheetGesture> get stream => _gesturesStream.stream;

  SheetController() {
    scrollController.customColumnExtents = sheetProperties.customColumnExtents;
    scrollController.customRowExtents = sheetProperties.customRowExtents;

    mouse.stream.listen(_handleMouseGesture);
    stream.listen(_handleGesture);
  }

  void dispose() {
    _gesturesStream.close();
    mouse.dispose();
    keyboard.dispose();
  }

  void _handleGesture(SheetGesture gesture) {
    gesture.resolve(this);
  }

  SheetSelection? previousSelection;
  bool fillInProgress = false;

  void _handleMouseGesture(SheetGesture gesture) {
    switch (gesture) {
      case SheetTapGesture tapGesture:
        return _gesturesStream.add(SheetSingleSelectionGesture.from(tapGesture));

      case SheetDoubleTapGesture tapGesture:
        return _gesturesStream.add(SheetSingleSelectionGesture.from(tapGesture.single));

      case SheetDragStartGesture dragStartGesture:
        previousSelection = selection;
        return _gesturesStream.add(SheetSelectionStartGesture.from(dragStartGesture));

      case SheetDragUpdateGesture dragUpdateGesture:
        if (previousSelection == null) return;
        return _gesturesStream.add(SheetSelectionUpdateGesture.from(dragUpdateGesture, selection: previousSelection!));

      case SheetDragEndGesture dragEndGesture:
        previousSelection = null;
        return _gesturesStream.add(SheetSelectionEndGesture.from(dragEndGesture));

      case SheetFillStartGesture fillStartGesture:
        fillInProgress = true;
        return _gesturesStream.add(fillStartGesture);

      case SheetFillUpdateGesture fillUpdateGesture:
        if (fillInProgress == false) return;
        return _gesturesStream.add(fillUpdateGesture);

      case SheetFillEndGesture fillEndGesture:
        fillInProgress = false;
        return _gesturesStream.add(fillEndGesture);

      default:
        return _gesturesStream.add(gesture);
    }
  }

  void onMouseOffsetChanged(Offset offset) {
    mouse.updateOffset(offset, viewport.findByOffset(offset));
  }

  void setCursor(SystemMouseCursor cursor) {
    mouse.setCursor(cursor);
  }

  void resizeColumnBy(ColumnIndex column, double delta) {
    _gesturesStream.add(SheetResizeColumnGesture(column, delta));
  }

  void resizeRowBy(RowIndex row, double delta) {
    _gesturesStream.add(SheetResizeRowGesture(row, delta));
  }

  void customSelection(SheetSelection selection) {
    selectionNotifier.value = selection;
  }

  void selectSingle(CellIndex cellIndex, {bool editingEnabled = false}) {
    selectionNotifier.value = SelectionUtils.getSingleSelection(cellIndex);
  }

  void selectColumn(ColumnIndex columnIndex) {
    selectionNotifier.value = SelectionUtils.getColumnSelection(columnIndex);
  }

  void selectRow(RowIndex rowIndex) {
    selectionNotifier.value = SelectionUtils.getRowSelection(rowIndex);
  }

  void selectRange({required CellIndex start, required CellIndex end, bool completed = false}) {
    selectionNotifier.value = SelectionUtils.getRangeSelection(start: start, end: end, completed: completed);
  }

  void selectColumnRange({required ColumnIndex start, required ColumnIndex end}) {
    selectionNotifier.value = SelectionUtils.getColumnRangeSelection(start: start, end: end);
  }

  void selectRowRange({required RowIndex start, required RowIndex end}) {
    selectionNotifier.value = SelectionUtils.getRowRangeSelection(start: start, end: end);
  }

  void selectMultiple(List<CellIndex> selectedCells, {CellIndex? endCell}) {
    List<CellIndex> cells = selectedCells.toSet().toList();
    if (endCell != null && cells.contains(endCell)) {
      cells
        ..remove(endCell)
        ..add(endCell);
    }
    selectionNotifier.value = SheetMultiSelection(selectedCells: cells);
  }

  void selectAll() {
    selectionNotifier.value = SelectionUtils.getAllSelection();
  }

  void toggleCellSelection(CellIndex cellIndex) {
    List<CellIndex> selectedCells = selection.selectedCells;
    if (selectedCells.contains(cellIndex) && selectedCells.length > 1) {
      selectedCells.remove(cellIndex);
    } else {
      selectedCells.add(cellIndex);
    }
    selectionNotifier.value = SheetMultiSelection(selectedCells: selectedCells);
  }

  void toggleColumnSelection(ColumnIndex columnIndex) {
    List<CellIndex> selectedCells = selection.selectedCells;
    if (selectedCells.any((CellIndex cellIndex) => cellIndex.columnIndex == columnIndex)) {
      selectedCells.removeWhere((CellIndex cellIndex) => cellIndex.columnIndex == columnIndex);
    } else {
      selectedCells.addAll(List.generate(defaultRowCount, (int index) => CellIndex(rowIndex: RowIndex(index), columnIndex: columnIndex)));
    }
    selectionNotifier.value = SheetMultiSelection(selectedCells: selectedCells);
  }

  void toggleRowSelection(RowIndex rowIndex) {
    List<CellIndex> selectedCells = selection.selectedCells;
    if (selectedCells.any((CellIndex cellIndex) => cellIndex.rowIndex == rowIndex)) {
      selectedCells.removeWhere((CellIndex cellIndex) => cellIndex.rowIndex == rowIndex);
    } else {
      selectedCells.addAll(List.generate(defaultColumnCount, (int index) => CellIndex(rowIndex: rowIndex, columnIndex: ColumnIndex(index))));
    }
    selectionNotifier.value = SheetMultiSelection(selectedCells: selectedCells);
  }

  void completeSelection() {
    selectionNotifier.value = selection.complete();
  }
}
