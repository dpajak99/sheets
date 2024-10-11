import 'dart:async';

import 'package:flutter/services.dart';
import 'package:sheets/controller/selection_controller.dart';
import 'package:sheets/core/sheet_item_index.dart';
import 'package:sheets/gestures/sheet_drag_gesture.dart';
import 'package:sheets/gestures/sheet_fill_gesture.dart';
import 'package:sheets/gestures/sheet_gesture.dart';
import 'package:sheets/core/sheet_properties.dart';
import 'package:sheets/controller/sheet_scroll_controller.dart';
import 'package:sheets/core/sheet_viewport_delegate.dart';
import 'package:sheets/gestures/sheet_resize_gestures.dart';
import 'package:sheets/gestures/sheet_selection_gesture.dart';
import 'package:sheets/listeners/keyboard_listener.dart';
import 'package:sheets/listeners/mouse_listener.dart';

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
  late final SheetKeyboardListener keyboard = SheetKeyboardListener();
  late final SheetMouseListener mouse = SheetMouseListener();

  SelectionController selectionController = SelectionController();

  final StreamController<SheetGesture> _gesturesStream = StreamController<SheetGesture>();

  Stream<SheetGesture> get stream => _gesturesStream.stream;

  SheetController() {
    scrollController.applyTo(this);
    selectionController.applyTo(this);

    mouse.stream.listen(_handleMouseGesture);
    stream.listen(_handleGesture);

    keyboard.onKeysPressed([LogicalKeyboardKey.controlLeft, LogicalKeyboardKey.keyA], selectionController.selectAll);
    // -------------------
    keyboard.onKeyPressed(LogicalKeyboardKey.keyR, () {
      sheetProperties.addRows(10);
    });
    keyboard.onKeyPressed(LogicalKeyboardKey.keyC, () {
      sheetProperties.addColumns(10);
    });
  }

  void dispose() {
    _gesturesStream.close();
    mouse.dispose();
    keyboard.dispose();
  }

  void _handleGesture(SheetGesture gesture) {
    gesture.resolve(this);
  }

  bool fillInProgress = false;

  void _handleMouseGesture(SheetGesture gesture) {
    switch (gesture) {
      case SheetDragStartGesture sheetDragStartGesture:
        return _gesturesStream.add(SheetSelectionStartGesture.from(sheetDragStartGesture));

      case SheetDragUpdateGesture dragUpdateGesture:
        return _gesturesStream.add(SheetSelectionUpdateGesture.from(dragUpdateGesture));

      case SheetDragEndGesture _:
        return _gesturesStream.add(SheetSelectionEndGesture());

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
}
