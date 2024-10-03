import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sheets/gestures/sheet_drag_gesture.dart';
import 'package:sheets/gestures/sheet_fill_gesture.dart';
import 'package:sheets/gestures/sheet_gesture.dart';
import 'package:sheets/gestures/sheet_scroll_gesture.dart';
import 'package:sheets/gestures/sheet_tap_gesture.dart';
import 'package:sheets/core/sheet_item_config.dart';
import 'package:sheets/recognizers/sheet_tap_recognizer.dart';

class SheetMouseListener {
  final StreamController<SheetGesture> _gesturesStream = StreamController<SheetGesture>();

  Stream<SheetGesture> get stream => _gesturesStream.stream;

  final ValueNotifier<Offset> mousePosition = ValueNotifier(Offset.zero);
  final ValueNotifier<SheetItemConfig?> hoveredItem = ValueNotifier(null);
  final ValueNotifier<SystemMouseCursor> cursor = ValueNotifier(SystemMouseCursors.basic);

  final SheetTapRecognizer tapRecognizer = SheetTapRecognizer();

  bool _enabled = true;

  void disable() => _enabled = false;

  void enable() => _enabled = true;

  bool get enabled => _enabled;

  bool nativeDragging = false;
  bool customTapHovered = false;

  void dispose() {
    _gesturesStream.close();
  }

  void updateOffset(Offset offset, SheetItemConfig? element) {
    mousePosition.value = offset;
    hoveredItem.value = element;
  }

  void setCursor(SystemMouseCursor cursor) {
    this.cursor.value = cursor;
  }

  void tap() {
    if (customTapHovered) return;
    if (nativeDragging) return;
    SheetGesture tapGesture = tapRecognizer.onTap(SheetTapDetails.create(mousePosition.value, hoveredItem.value));
    _addGesture(tapGesture);
  }

  SheetDragDetails? _activeStartDragDetails;

  void dragStart(SheetItemConfig draggedItem) {
    if(_previousGesture is SheetTapGesture && (_previousGesture as SheetTapGesture).details.hoveredItem == hoveredItem.value) return;
    if(_previousGesture is SheetDoubleTapGesture && (_previousGesture as SheetDoubleTapGesture).details.hoveredItem == hoveredItem.value) return;

    nativeDragging = true;
    SheetDragDetails sheetDragDetails = SheetDragDetails.create(mousePosition.value, draggedItem);
    _activeStartDragDetails = sheetDragDetails;
    _addGesture(SheetDragStartGesture());
  }

  void dragUpdate() {
    if (_activeStartDragDetails == null) return;

    SheetGesture dragUpdateGesture = SheetDragUpdateGesture(
      SheetDragDetails.create(mousePosition.value, hoveredItem.value),
      startDetails: _activeStartDragDetails!,
    );
    _addGesture(dragUpdateGesture);
  }

  void dragEnd() {
    nativeDragging = false;
    if (_activeStartDragDetails == null) return;

    SheetGesture dragEndGesture = SheetDragEndGesture();
    _addGesture(dragEndGesture);
  }

  void fillStart() {
    SheetFillStartGesture fillStartGesture = SheetFillStartGesture();
    _gesturesStream.add(fillStartGesture);
  }

  void fillUpdate() {
    SheetGesture fillUpdateGesture = SheetFillUpdateGesture(endDetails: SheetDragDetails.create(mousePosition.value, hoveredItem.value));
    _gesturesStream.add(fillUpdateGesture);
  }

  void fillEnd() {
    SheetFillEndGesture fillEndGesture = SheetFillEndGesture();
    _gesturesStream.add(fillEndGesture);
  }


  void scroll(Offset delta) {
    _addGesture(SheetScrollGesture(delta));
  }

  SheetGesture? _previousGesture;
  void _addGesture(SheetGesture gesture) {
    if (!_enabled) return;
    _gesturesStream.add(gesture);
    _previousGesture = gesture;
  }
}
