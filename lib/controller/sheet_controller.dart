import 'dart:async';

import 'package:flutter/services.dart';
import 'package:sheets/gestures/sheet_selection_gesture.dart';
import 'package:sheets/selection/selection_state.dart';
import 'package:sheets/core/sheet_item_index.dart';
import 'package:sheets/gestures/sheet_gesture.dart';
import 'package:sheets/core/sheet_properties.dart';
import 'package:sheets/controller/sheet_scroll_controller.dart';
import 'package:sheets/gestures/sheet_gesture_mapper.dart';
import 'package:sheets/selection/sheet_selection.dart';
import 'package:sheets/utils/streamable.dart';
import 'package:sheets/viewport/sheet_viewport.dart';
import 'package:sheets/gestures/sheet_resize_gestures.dart';
import 'package:sheets/listeners/keyboard_listener.dart';
import 'package:sheets/listeners/mouse_listener.dart';

class SheetController {
  SheetController({
    required this.properties,
  }) {
    gestures = Streamable<SheetGesture>();

    scroll = SheetScrollController();
    viewport = SheetViewport(properties, scroll);
    keyboard = SheetKeyboardListener();
    mouse = SheetMouseListener(viewport);
    selection = SelectionState.defaultSelection();

    gestures.listen(_handleGesture);
    mouse.stream.listen((SheetGesture gesture) => _handleGesture(gesture, SheetMouseGestureMapper()));

    _setupKeyboardShortcuts();
  }

  final SheetProperties properties;
  late final Streamable<SheetGesture> gestures;
  late final SheetViewport viewport;
  late final SheetScrollController scroll;
  late final SheetKeyboardListener keyboard;
  late final SheetMouseListener mouse;
  late SelectionState selection;

  final List<Type> _lockedGestures = <Type>[];

  void dispose() {
    mouse.dispose();
    keyboard.dispose();
    gestures.dispose();
  }

  void select(SheetSelection customSelection) {
    selection.update(customSelection);
  }

  void setCursor(SystemMouseCursor cursor) {
    mouse.setCursor(cursor);
  }

  void resizeColumnBy(ColumnIndex column, double delta) {
    gestures.add(SheetResizeColumnGesture(column, delta));
  }

  void resizeRowBy(RowIndex row, double delta) {
    gestures.add(SheetResizeRowGesture(row, delta));
  }

  void _setupKeyboardShortcuts() {
    keyboard.onKeysPressed(
      <LogicalKeyboardKey>[LogicalKeyboardKey.controlLeft, LogicalKeyboardKey.keyA],
      () => select(SheetSelection.all()),
    );
    // -------------------
    keyboard.onKeyPressed(LogicalKeyboardKey.keyR, () {
      properties.addRows(10);
    });
    keyboard.onKeyPressed(LogicalKeyboardKey.keyC, () {
      properties.addColumns(10);
    });
    // -------------------
    keyboard.onKeyHold(LogicalKeyboardKey.arrowUp, () {
      gestures.add(SheetSelectionMoveGesture(-1, 0));
    });
    keyboard.onKeyHold(LogicalKeyboardKey.arrowDown, () {
      gestures.add(SheetSelectionMoveGesture(1, 0));
    });
    keyboard.onKeyHold(LogicalKeyboardKey.arrowLeft, () {
      gestures.add(SheetSelectionMoveGesture(0, -1));
    });
    keyboard.onKeyHold(LogicalKeyboardKey.arrowRight, () {
      gestures.add(SheetSelectionMoveGesture(0, 1));
    });
  }

  void _handleGesture(SheetGesture gesture, [SheetGestureMapper? mapper]) {
    SheetGesture convertedGesture = mapper?.convert(gesture) ?? gesture;
    if (_lockedGestures.contains(convertedGesture.runtimeType)) return;

    convertedGesture.resolve(this);
    Duration? lockdownDuration = convertedGesture.lockdownDuration;
    if (lockdownDuration != null) {
      _lockedGestures.add(convertedGesture.runtimeType);
      Future<void>.delayed(lockdownDuration, () {
        _lockedGestures.remove(convertedGesture.runtimeType);
      });
    }
  }
}
