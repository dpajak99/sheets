import 'dart:async';
import 'dart:math';

import 'package:flutter/services.dart';
import 'package:sheets/gestures/sheet_drag_gesture.dart';
import 'package:sheets/gestures/sheet_gesture.dart';
import 'package:sheets/core/sheet_item_config.dart';
import 'package:sheets/controller/sheet_selection_controller.dart';
import 'package:sheets/core/sheet_properties.dart';
import 'package:sheets/controller/sheet_scroll_controller.dart';
import 'package:sheets/core/sheet_viewport_delegate.dart';
import 'package:sheets/gestures/sheet_selection_gesture.dart';
import 'package:sheets/gestures/sheet_tap_gesture.dart';
import 'package:sheets/listeners/keyboard_listener.dart';
import 'package:sheets/listeners/mouse_listener.dart';
import 'package:sheets/selection/types/sheet_selection.dart';

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
    selectionController.dispose();
    mouse.dispose();
    keyboard.dispose();
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

  SheetSelection? previousSelection;

  void _handleGesture(SheetGesture gesture) {
    gesture.resolve(this);
  }

  void _handleMouseGesture(SheetGesture gesture) {
    switch (gesture) {
      case SheetTapGesture tapGesture:
        return _gesturesStream.add(SheetSingleSelectionGesture.from(tapGesture));
      case SheetDoubleTapGesture tapGesture:
        return _gesturesStream.add(SheetSingleSelectionGesture.from(tapGesture.single));
      case SheetDragStartGesture dragStartGesture:
        previousSelection = selectionController.selection;
        return _gesturesStream.add(SheetSelectionStartGesture.from(dragStartGesture));
      case SheetDragUpdateGesture dragUpdateGesture:
        if (previousSelection == null) return;
        return _gesturesStream.add(SheetSelectionUpdateGesture.from(dragUpdateGesture, selection: previousSelection!));
      case SheetDragEndGesture dragEndGesture:
        previousSelection = null;
        return _gesturesStream.add(SheetSelectionEndGesture.from(dragEndGesture));
      default:
        return _gesturesStream.add(gesture);
    }
  }
}
