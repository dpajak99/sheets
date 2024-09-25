import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sheets/controller/program_config.dart';
import 'package:sheets/controller/selection/gestures/sheet_drag_gesture.dart';
import 'package:sheets/controller/selection/gestures/sheet_gesture.dart';
import 'package:sheets/controller/selection/gestures/sheet_scroll_gesture.dart';
import 'package:sheets/controller/selection/gestures/sheet_tap_gesture.dart';
import 'package:sheets/controller/selection/recognizers/sheet_tap_recognizer.dart';

class SheetCursorController {
  final StreamController<SheetGesture> _gesturesStream = StreamController<SheetGesture>();

  Stream<SheetGesture> get stream => _gesturesStream.stream;

  final ValueNotifier<Offset> mousePosition = ValueNotifier(Offset.zero);
  final ValueNotifier<SheetItemConfig?> hoveredItem = ValueNotifier(null);
  final ValueNotifier<SystemMouseCursor> cursor = ValueNotifier(SystemMouseCursors.basic);

  final SheetTapRecognizer tapRecognizer = SheetTapRecognizer();

  void updateOffset(Offset offset, SheetItemConfig? element) {
    mousePosition.value = offset;
    hoveredItem.value = element;
  }

  void setCursor(SystemMouseCursor cursor) {
    this.cursor.value = cursor;
  }

  void tap() {
    SheetGesture tapGesture = tapRecognizer.onTap(SheetTapDetails.create(mousePosition.value, hoveredItem.value));
    _gesturesStream.add(tapGesture);
  }

  SheetDragDetails? _activeStartDragDetails;

  void dragStart() {
    SheetDragDetails sheetDragDetails = SheetDragDetails.create(mousePosition.value, hoveredItem.value);
    _activeStartDragDetails = sheetDragDetails;
    _gesturesStream.add(SheetDragStartGesture(sheetDragDetails));
  }

  void dragUpdate() {
    if (_activeStartDragDetails == null) return;

    SheetGesture dragUpdateGesture = SheetDragUpdateGesture(
      SheetDragDetails.create(mousePosition.value, hoveredItem.value),
      startDetails: _activeStartDragDetails!,
    );
    _gesturesStream.add(dragUpdateGesture);
  }

  void dragEnd() {
    if (_activeStartDragDetails == null) return;

    SheetGesture dragEndGesture = SheetDragEndGesture(
      SheetDragDetails.create(mousePosition.value, hoveredItem.value),
      startDetails: _activeStartDragDetails!,
    );
    _gesturesStream.add(dragEndGesture);
  }

  void scroll(Offset delta) {
    _gesturesStream.add(SheetScrollGesture(delta));
  }

  // void dragStart(DragStartDetails details, {Offset subtract = Offset.zero}) {
  //   // print('Drag start');
  //   // position = details.globalPosition;
  //   // SheetItemConfig? dragHoveredElement = sheetController.getHoveredElement(position - subtract);
  //   // hoveredElement = dragHoveredElement;
  //   // if (isResizing) {
  //   // } else if (dragHoveredElement != null) {
  //   //   if (sheetController.cursorController.isFilling) {
  //   //     selectionDragRecognizer = SelectionFillRecognizer(sheetController, dragHoveredElement);
  //   //   } else {
  //   //     selectionDragRecognizer = SelectionDragRecognizer(sheetController, dragHoveredElement);
  //   //   }
  //   // }
  //   //
  //   // notifyListeners();
  // }
  //
  // void dragUpdate(DragUpdateDetails details, {Offset subtract = Offset.zero}) {
  //   // position = details.globalPosition;
  //   // SheetItemConfig? dragHoveredElement = sheetController.getHoveredElement(position - subtract);
  //   // hoveredElement = dragHoveredElement;
  //   //
  //   // if (isResizing) {
  //   // } else if (dragHoveredElement != null) {
  //   //   selectionDragRecognizer?.handle(dragHoveredElement);
  //   // }
  //   //
  //   // notifyListeners();
  // }
  //
  // void dragEnd(DragEndDetails details) {
  //   position = details.globalPosition;
  //
  //   if (isResizing) {
  //   } else {
  //     selectionDragRecognizer?.complete();
  //     selectionDragRecognizer = null;
  //   }
  //   notifyListeners();
  // }
}
