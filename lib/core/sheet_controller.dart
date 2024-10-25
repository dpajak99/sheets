import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:sheets/core/gestures/sheet_resize_gestures.dart';
import 'package:sheets/core/keyboard/keyboard_listener.dart';
import 'package:sheets/core/keyboard/keyboard_shortcuts.dart';
import 'package:sheets/core/mouse/mouse_gesture_recognizer.dart';
import 'package:sheets/core/mouse/mouse_listener.dart';
import 'package:sheets/core/scroll/sheet_scroll_controller.dart';
import 'package:sheets/core/selection/selection_state.dart';
import 'package:sheets/core/selection/sheet_selection_factory.dart';
import 'package:sheets/core/selection/sheet_selection_gesture.dart';
import 'package:sheets/core/selection/types/sheet_single_selection.dart';
import 'package:sheets/core/sheet_index.dart';
import 'package:sheets/core/sheet_properties.dart';
import 'package:sheets/core/viewport/sheet_viewport.dart';
import 'package:sheets/core/viewport/viewport_item.dart';

class SheetController {
  SheetController({
    required this.properties,
  }) {
    _activeCellNotifier = ValueNotifier<ViewportCell?>(null);

    scroll = SheetScrollController();
    viewport = SheetViewport(properties, scroll);
    keyboard = KeyboardListener();
    mouse = MouseListener(
      mouseActionRecognizers: <MouseGestureRecognizer>[
        MouseDoubleTapRecognizer(),
        MouseSelectionGestureRecognizer(),
      ],
      sheetController: this,
    );
    selection = SelectionState.defaultSelection(
      onChanged: (_) => resetActiveCell(),
    );

    _setupKeyboardShortcuts();
  }

  final SheetProperties properties;
  late final SheetViewport viewport;
  late final SheetScrollController scroll;
  late final KeyboardListener keyboard;
  late final MouseListener mouse;
  late final ValueNotifier<ViewportCell?> _activeCellNotifier;

  late SelectionState selection;

  Future<void> dispose() async {
    await keyboard.dispose();
  }

  ValueNotifier<ViewportCell?> get activeCellNotifier => _activeCellNotifier;

  void resizeColumn(ColumnIndex column, double width) {
    SheetResizeColumnGesture(column, width).resolve(this);
  }

  void resizeRow(RowIndex row, double height) {
    SheetResizeRowGesture(row, height).resolve(this);
  }

  String getCellValue(CellIndex index) {
    return properties.getCellValue(index);
  }

  void setCellValue(CellIndex index, String value, {Size? size}) {
    properties.setCellValue(index, value);
    if(size != null ) {
      SheetResizeCellGesture(index, size).resolve(this);
    }
    resetActiveCell();
  }

  void resetActiveCell() {
    _activeCellNotifier.value = null;
    keyboard.enableListener();
  }

  void setActiveCellIndex(SheetIndex index, {String? value}) {
    ViewportCell? cell = viewport.ensureIndexFullyVisible(index) as ViewportCell?;
    if (cell == null) {
      return;
    }
    setActiveViewportCell(cell, value: value);
  }

  void setActiveViewportCell(ViewportCell cell, {String? value}) {
    selection.update(SheetSingleSelection(cell.index, fillHandleVisible: false), notifyAll: false);
    _activeCellNotifier.value = cell.copyWith(value: value);
    keyboard.disableListener();
  }

  void _setupKeyboardShortcuts() {
    keyboard.pressStream.listen((KeyboardState state) {
      return switch (state) {
        KeyboardShortcuts.selectAll => selection.update(SheetSelectionFactory.all()),
        KeyboardShortcuts.addRows => properties.addRows(10),
        KeyboardShortcuts.addColumns => properties.addColumns(10),
        KeyboardShortcuts.enter => setActiveCellIndex(selection.value.mainCell),
        (_) => _handleKeyboardKey(state.keys),
      };
    });

    keyboard.pressOrHoldStream.listen((KeyboardState state) {
      if (state.containsState(KeyboardShortcuts.moveUp)) {
        SheetSelectionMoveGesture(-1, 0).resolve(this);
      }
      if (state.containsState(KeyboardShortcuts.moveDown)) {
        SheetSelectionMoveGesture(1, 0).resolve(this);
      }
      if (state.containsState(KeyboardShortcuts.moveLeft)) {
        SheetSelectionMoveGesture(0, -1).resolve(this);
      }
      if (state.containsState(KeyboardShortcuts.moveRight)) {
        SheetSelectionMoveGesture(0, 1).resolve(this);
      }
    });
  }

  void _handleKeyboardKey(List<LogicalKeyboardKey> key) {
    List<String> keyLabels = key
        .map((LogicalKeyboardKey logicalKeyboardKey) => logicalKeyboardKey.keyLabel)
        .toList()
        .where((String label) => label.length == 1)
        .toList();

    if(keyLabels.isNotEmpty) {
      bool uppercase = key.contains(LogicalKeyboardKey.shiftLeft) || key.contains(LogicalKeyboardKey.shiftRight);
      String value = keyLabels.first;

      if (uppercase) {
        value = value.toUpperCase();
      } else {
        value = value.toLowerCase();
      }

      setActiveCellIndex(selection.value.mainCell, value: value);
    }

    bool clearCell = key.contains(LogicalKeyboardKey.delete) || key.contains(LogicalKeyboardKey.backspace);
    if (clearCell) {
      setCellValue(selection.value.mainCell, '');
    }
  }
}
