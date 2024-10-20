import 'package:sheets/core/gestures/sheet_resize_gestures.dart';
import 'package:sheets/core/gestures/sheet_selection_gesture.dart';
import 'package:sheets/core/keyboard/keyboard_listener.dart';
import 'package:sheets/core/keyboard/keyboard_shortcuts.dart';
import 'package:sheets/core/mouse/mouse_gesture_recognizer.dart';
import 'package:sheets/core/mouse/mouse_listener.dart';
import 'package:sheets/core/selection/selection_state.dart';
import 'package:sheets/core/selection/sheet_selection_factory.dart';
import 'package:sheets/core/sheet_index.dart';
import 'package:sheets/core/sheet_properties.dart';
import 'package:sheets/core/scroll/sheet_scroll_controller.dart';
import 'package:sheets/core/viewport/sheet_viewport.dart';

class SheetController {
  SheetController({
    required this.properties,
  }) {
    scroll = SheetScrollController();
    viewport = SheetViewport(properties, scroll);
    keyboard = KeyboardListener();
    mouse = MouseListener(
      mouseActionRecognizers: <MouseGestureRecognizer>[
        MouseSelectionGestureRecognizer(),
      ],
      sheetController: this,
    );
    selection = SelectionState.defaultSelection();

    _setupKeyboardShortcuts();
  }

  final SheetProperties properties;
  late final SheetViewport viewport;
  late final SheetScrollController scroll;
  late final KeyboardListener keyboard;
  late final MouseListener mouse;

  late SelectionState selection;

  void dispose() {
    keyboard.dispose();
  }

  void resizeColumn(ColumnIndex column, double width) {
    SheetResizeColumnGesture(column, width).resolve(this);
  }

  void resizeRow(RowIndex row, double height) {
    SheetResizeRowGesture(row, height).resolve(this);
  }

  void _setupKeyboardShortcuts() {
    keyboard.pressStream.listen((KeyboardState state) {
      return switch (state) {
        KeyboardShortcuts.selectAll => selection.update(SheetSelectionFactory.all()),
        KeyboardShortcuts.addRows => properties.addRows(10),
        KeyboardShortcuts.addColumns => properties.addColumns(10),
        (_) => null,
      };
    });

    keyboard.pressOrHoldStream.listen((KeyboardState state) {
      if (state.containsState(KeyboardShortcuts.moveUp)) SheetSelectionMoveGesture(-1, 0).resolve(this);
      if (state.containsState(KeyboardShortcuts.moveDown)) SheetSelectionMoveGesture(1, 0).resolve(this);
      if (state.containsState(KeyboardShortcuts.moveLeft)) SheetSelectionMoveGesture(0, -1).resolve(this);
      if (state.containsState(KeyboardShortcuts.moveRight)) SheetSelectionMoveGesture(0, 1).resolve(this);
    });
  }
}
