import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:sheets/core/gestures/sheet_resize_gestures.dart';
import 'package:sheets/core/keyboard/keyboard_listener.dart';
import 'package:sheets/core/keyboard/keyboard_shortcuts.dart';
import 'package:sheets/core/mouse/mouse_gesture_recognizer.dart';
import 'package:sheets/core/mouse/mouse_listener.dart';
import 'package:sheets/core/scroll/sheet_scroll_controller.dart';
import 'package:sheets/core/selection/selection_state.dart';
import 'package:sheets/core/selection/sheet_selection.dart';
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
    activeCell = ValueNotifier<ViewportCell?>(null);

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
      onChanged: (_) => activeCell.value = null,
    );

    _setupKeyboardShortcuts();
  }

  final SheetProperties properties;
  late final SheetViewport viewport;
  late final SheetScrollController scroll;
  late final KeyboardListener keyboard;
  late final MouseListener mouse;
  late final ValueNotifier<ViewportCell?> activeCell;

  late SelectionState selection;

  Future<void> dispose() async {
    await keyboard.dispose();
  }

  void resizeColumn(ColumnIndex column, double width) {
    SheetResizeColumnGesture(column, width).resolve(this);
  }

  void resizeRow(RowIndex row, double height) {
    SheetResizeRowGesture(row, height).resolve(this);
  }

  void setActiveCellIndex(SheetIndex index) {
    unawaited(() async {
      ViewportCell? cell = await viewport.ensureIndexFullyVisible(index) as ViewportCell?;
      print('Found cell: ${cell?.index.stringifyPosition()}');
      if (cell == null) {
        return;
      }
      setActiveViewportCell(cell);
    }());
  }

  void setActiveViewportCell(ViewportCell cell) {
    print('Setting active cell');
    selection.update(SheetSingleSelection(cell.index, fillHandleVisible: false), notifyAll: false);
    activeCell.value = cell;
  }

  void _setupKeyboardShortcuts() {
    keyboard.pressStream.listen((KeyboardState state) {
      if (activeCell.value != null) {
        return;
      }
      return switch (state) {
        KeyboardShortcuts.selectAll => selection.update(SheetSelectionFactory.all()),
        KeyboardShortcuts.addRows => properties.addRows(10),
        KeyboardShortcuts.addColumns => properties.addColumns(10),
        KeyboardShortcuts.enter => setActiveCellIndex(selection.value.mainCell),
        (_) => null,
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
}
