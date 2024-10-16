import 'package:sheets/gestures/sheet_selection_gesture.dart';
import 'package:sheets/listeners/keyboard/keyboard_listener.dart';
import 'package:sheets/listeners/keyboard/keyboard_shortcuts.dart';
import 'package:sheets/listeners/mouse_listener.dart';
import 'package:sheets/recognizers/mouse_action_recognizer.dart';
import 'package:sheets/selection/selection_state.dart';
import 'package:sheets/core/sheet_item_index.dart';
import 'package:sheets/core/sheet_properties.dart';
import 'package:sheets/controller/sheet_scroll_controller.dart';
import 'package:sheets/selection/sheet_selection.dart';
import 'package:sheets/viewport/sheet_viewport.dart';
import 'package:sheets/gestures/sheet_resize_gestures.dart';

class SheetController {
  SheetController({
    required this.properties,
  }) {
    scroll = SheetScrollController();
    viewport = SheetViewport(properties, scroll);
    keyboard = KeyboardListener();
    mouse = MouseListener(
      mouseActionRecognizers: <MouseActionRecognizer>[MouseSelectionRecognizer()],
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

  void select(SheetSelection customSelection) {
    selection.update(customSelection);
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
        KeyboardShortcuts.selectAll => select(SheetSelection.all()),
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
